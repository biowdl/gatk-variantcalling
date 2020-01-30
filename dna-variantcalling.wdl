version 1.0

# Copyright (c) 2018 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import "tasks/common.wdl" as common
import "tasks/biopet/biopet.wdl" as biopet
import "tasks/bedtools.wdl" as bedtools
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard
import "gvcf.wdl" as gvcf

workflow GatkVariantCalling {
    input {
        Array[Pair[IndexedBamFile, String?]] bamFilesAndGenders
        String outputDir = "."
        String vcfBasename = "multisample"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File dbsnpVCF
        File dbsnpVCFIndex
        File? XNonParRegions
        File? YNonParRegions
        File? regions
        # scatterSize is on number of bases. The human genome has 3 000 000 000 bases.
        # 1 billion gives approximately 3 scatters per sample.
        Int scatterSize = 1000000000
        Map[String, String] dockerImages = {
          "bedtools": "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3",
          "picard":"quay.io/biocontainers/picard:2.20.5--0",
          "gatk4":"quay.io/biocontainers/gatk4:4.1.0.0--0",
          "biopet-scatterregions":"quay.io/biocontainers/biopet-scatterregions:0.2--0",
        }
    }

    String scatterDir = outputDir + "/scatters/"

    Boolean knownParRegions = defined(XNonParRegions) && defined(YNonParRegions)

    if (knownParRegions) {
        # We define the 'normal' regions by creating a regions file that covers
        # everything except the XNonParRegions and the YNonParRegions.
        call bedtools.MergeBedFiles as mergeBeds {
            input:
                bedFiles = select_all([XNonParRegions, YNonParRegions]),
                dockerImage = dockerImages["bedtools"]
        }
    }

    if (!knownParRegions) {
        # If we do not know the non-PAR regions we create an empty bed.
        # Complementing this will simply return all regions.
        call common.TextToFile as emptyBed {
            input:
                text = "",
                outputFile = "empty.bed"
        }
    }

    # Note: When complementing an empty bed autosomalRegions == allRegions
    call bedtools.Complement as inverseBed {
        input:
            inputBed = select_first([mergeBeds.mergedBed, emptyBed.out]),
            faidx = referenceFastaFai,
            outputBed = "autosomal_regions.bed",
            dockerImage = dockerImages["bedtools"]
    }

    if (defined(regions)) {
        call bedtools.Intersect as intersectAutosomalRegions {
            input:
                regionsA = inverseBed.complementBed,
                regionsB = select_first([regions]),
                faidx = referenceFastaFai,
                outputBed = "intersected_autosomal_regions.bed",
                dockerImage = dockerImages["bedtools"]
        }

        if (knownParRegions) {
            call bedtools.Intersect as intersectX {
                input:
                    regionsA = select_first([XNonParRegions]),
                    regionsB = select_first([regions]),
                    faidx = referenceFastaFai,
                    outputBed = "intersected_x_non_par_regions.bed",
                    dockerImage = dockerImages["bedtools"]
            }

            call bedtools.Intersect as intersectY {
                input:
                    regionsA = select_first([YNonParRegions]),
                    regionsB = select_first([regions]),
                    faidx = referenceFastaFai,
                    outputBed = "intersected_y_non_par_regions.bed",
                    dockerImage = dockerImages["bedtools"]
            }
        }
    }

    File autosomalRegions = select_first([intersectAutosomalRegions.intersectedBed, inverseBed.complementBed])
    File Xregions = select_first([intersectX.intersectedBed, XNonParRegions, emptyBed.out])
    File Yregions = select_first([intersectY.intersectedBed, YNonParRegions, emptyBed.out])

    call biopet.ScatterRegions as scatterAutosomalRegions {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            regions = autosomalRegions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    # Glob messes with order of scatters (10 comes before 1), which causes problems at gatherGvcfs
    call biopet.ReorderGlobbedScatters as orderedAutosomalScatters {
        input:
            scatters = scatterAutosomalRegions.scatters
            # Dockertag not relevant here. Python script always runs in the same
            # python container.
    }

    scatter (bamGender in bamFilesAndGenders) {
        IndexedBamFile bam = bamGender.left
        String gender = select_first([bamGender.right, "unknown"])
        Boolean male = (gender == "male" || gender == "m" || gender == "M")
        Boolean female = (gender == "female" || gender == "f" || gender == "F")
        Boolean unknownGender = !(male || female)
        # Call separate pipeline to allow scatter in scatter.
        # Also this is needed. If there are 50 bam files, we need more scattering than
        # when we have 1 bam file.
        call gvcf.Gvcf as Gvcf {
            input:
                bam = bam.file,
                bamIndex = bam.index,
                scatterList = orderedAutosomalScatters.reorderedScatters,
                referenceFasta = referenceFasta,
                referenceFastaDict = referenceFastaDict,
                referenceFastaFai = referenceFastaFai,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                outputDir = outputDir + "/samples/" + basename(bam.file, ".bam"),
                dockerImages = dockerImages
        }

        # If the PAR regions are known we call X and Y separately. If not the
        # autosomalRegions BED file will simply have contained all regions.
        if (knownParRegions) {
            # Males have ploidy 1 for X. Call females and unknowns with ploidy 2
            call gatk.HaplotypeCaller as callX {
                input:
                    outputPath = scatterDir + "/" + ".g.vcf.gz",
                    intervalList = [Xregions],
                    # Females are default.
                    ploidy = if male then 1 else 2,
                    referenceFasta = referenceFasta,
                    referenceFastaIndex = referenceFastaFai,
                    referenceFastaDict = referenceFastaDict,
                    inputBams = [bam.file],
                    inputBamsIndex = [bam.index],
                    dbsnpVCF = dbsnpVCF,
                    dbsnpVCFIndex = dbsnpVCFIndex,
                    gvcf = true,
                    dockerImage = dockerImages["gatk4"]
            }

            # Only call y on males. Call on unknowns to be sure.
            if (male || unknownGender) {
                call gatk.HaplotypeCaller as callY {
                    input:
                        outputPath = scatterDir + "/" + ".g.vcf.gz",
                        intervalList = [Yregions],
                        ploidy = 1,
                        referenceFasta = referenceFasta,
                        referenceFastaIndex = referenceFastaFai,
                        referenceFastaDict = referenceFastaDict,
                        inputBams = [bam.file],
                        inputBamsIndex = [bam.index],
                        dbsnpVCF = dbsnpVCF,
                        dbsnpVCFIndex = dbsnpVCFIndex,
                        gvcf = true,
                        dockerImage = dockerImages["gatk4"]
                }
            }
        }

        Array[File] GVCFs = flatten([Gvcf.outputGvcfs, select_all([callY.outputVCF, callX.outputVCF])])
        Array[File] GVCFIndexes = flatten([Gvcf.outputGvcfsIndex, select_all([callX.outputVCFIndex, callY.outputVCFIndex])])
    }

    call gatk.CombineGVCFs as gatherGvcfs {
            input:
                gvcfFiles = flatten(GVCFs),
                gvcfFilesIndex = flatten(GVCFIndexes),
                outputPath = outputDir + "/" + vcfBasename + ".g.vcf.gz",
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                referenceFastaDict = referenceFastaDict,
                dockerImage = dockerImages["gatk4"]

    }

    call biopet.ScatterRegions as scatterAllRegions {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            regions = regions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    # Glob messes with order of scatters (10 comes before 1), which causes problems at gatherGvcfs
    call biopet.ReorderGlobbedScatters as orderedAllScatters {
        input:
            scatters = scatterAllRegions.scatters
            # Dockertag not relevant here. Python script always runs in the same
            # python container.
    }

    scatter (bed in orderedAllScatters.reorderedScatters) {

        call gatk.GenotypeGVCFs as genotypeGvcfs {
            input:
                gvcfFiles = [gatherGvcfs.outputVcf],
                gvcfFilesIndex = [gatherGvcfs.outputVcfIndex],
                intervals = [bed],
                referenceFasta = referenceFasta,
                referenceFastaDict = referenceFastaDict,
                referenceFastaFai = referenceFastaFai,
                outputPath = outputDir + "/scatters/" + basename(bed) + ".genotyped.vcf.gz",
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                dockerImage = dockerImages["gatk4"]
        }
    }

    call picard.MergeVCFs as gatherVcfs {
        input:
            inputVCFs = genotypeGvcfs.outputVCF,
            inputVCFsIndexes = genotypeGvcfs.outputVCFIndex,
            outputVcfPath = outputDir + "/" + vcfBasename + ".vcf.gz",
            dockerImage = dockerImages["picard"]
    }

    output {
        File outputVcf = gatherVcfs.outputVcf
        File outputVcfIndex = gatherVcfs.outputVcfIndex
        File autosomalRegionsBed = autosomalRegions
        File xRegionBed = Xregions
        File yRegionBed = Yregions
        File? outputGVcf = gatherGvcfs.outputVcf
        File? outputGVcfIndex = gatherGvcfs.outputVcfIndex
    }

    parameter_meta {
        bamFilesAndGenders: { description: "List of tuples of BAM files and gender. BAM file to be analysed by GATK. The should be recalibrated beforehand if required. The gender string is optional. Actionable values are 'female','f','F','male','m' and 'M'.",
                            category: "required" }
        vcfBasename: { description: "The basename of the VCF and GVCF files that are outputted by the workflow",
                       category: "common"}
        referenceFasta: { description: "The reference fasta file", category: "required" }
        referenceFastaFai: { description: "Fasta index (.fai) file of the reference", category: "required" }
        referenceFastaDict: { description: "Sequence dictionary (.dict) file of the reference", category: "required" }
        dbsnpVCF: { description: "dbsnp VCF file used for checking known sites", category: "required"}
        dbsnpVCFIndex: { description: "Index (.tbi) file for the dbsnp VCF", category: "required"}
        outputDir: { description: "The directory where the output files should be located", category: "common" }
        scatterSize: {description: "The size of the scattered regions in bases. Scattering is used to speed up certain processes. The genome will be sseperated into multiple chunks (scatters) which will be processed in their own job, allowing for parallel processing. Higher values will result in a lower number of jobs. The optimal value here will depend on the available resources.",
              category: "advanced"}
        regions: {description: "A bed file describing the regions to operate on.", category: "common"}
        XNonParRegions: {description: "Bed file with the non-PAR regions of X", category: "common"}
        YNonParRegions: {description: "Bed file with the non-PAR regions of Y", category: "common"}
        dockerImages: { description: "specify which docker images should be used for running this pipeline",
                        category: "advanced" }
    }
}
