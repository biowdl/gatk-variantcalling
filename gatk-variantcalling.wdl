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

import "tasks/biopet/biopet.wdl" as biopet
import "tasks/bedtools.wdl" as bedtools
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard
import "haplotypecaller.wdl" as haplotype_wf
import "tasks/vt.wdl" as vt
import "tasks/samtools.wdl" as samtools

workflow GatkVariantCalling {
    input {
        Array[BamAndGender] bamFilesAndGenders
        String outputDir = "."
        String vcfBasename = "multisample"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File? dbsnpVCF
        File? dbsnpVCFIndex
        File? XNonParRegions
        File? YNonParRegions
        File? regions
        Boolean jointgenotyping = true
        Boolean singleSampleGvcf = true
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

    Boolean knownParRegions = defined(XNonParRegions) && defined(YNonParRegions)

    if (knownParRegions) {
        # We define the 'normal' regions by creating a regions file that covers
        # everything except the XNonParRegions and the YNonParRegions.
        call bedtools.MergeBedFiles as mergeBeds {
            input:
                bedFiles = select_all([XNonParRegions, YNonParRegions]),
                dockerImage = dockerImages["bedtools"]
        }
        call bedtools.Complement as inverseBed {
            input:
                inputBed = mergeBeds.mergedBed,
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
        File Xregions = select_first([intersectX.intersectedBed, XNonParRegions])
        File Yregions = select_first([intersectY.intersectedBed, YNonParRegions])
        File autosomalRegions = select_first([intersectAutosomalRegions.intersectedBed, inverseBed.complementBed])
    }

    call biopet.ScatterRegions as scatterAutosomalRegions {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            # When there are non-PAR regions and there are regions of interest, use the intersect of the autosomal regions and the regions of interest.
            # When there are non-PAR regions and there are no specified regions of interest, use the autosomal regions.
            # When there are no non-PAR regions, use the optional regions parameter.
            regions = if knownParRegions
                      then select_first([autosomalRegions])
                      else regions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    scatter (bamGender in bamFilesAndGenders) {
        String gender = select_first([bamGender.gender, "unknown"])
        String sampleName = basename(bamGender.file, ".bam")
        Boolean male = (gender == "male" || gender == "m" || gender == "M")
        Boolean female = (gender == "female" || gender == "f" || gender == "F")
        Boolean unknownGender = !(male || female)
        String scatterDir = outputDir + "/samples/" + sampleName + "/scatters/"
        # Call separate pipeline to allow scatter in scatter.
        # Also this is needed. If there are 50 bam files, we need more scattering than
        # when we have 1 bam file.
        call haplotype_wf.Caller as callAutosomal {
            input:
                bam = bamGender.file,
                bamIndex = bamGender.index,
                scatterList = scatterAutosomalRegions.scatters,
                referenceFasta = referenceFasta,
                referenceFastaDict = referenceFastaDict,
                referenceFastaFai = referenceFastaFai,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                outputDir = scatterDir,
                gvcf = jointgenotyping,
                dockerImages = dockerImages
        }

        # If the PAR regions are known we call X and Y separately. If not the
        # autosomalRegions BED file will simply have contained all regions.
        if (knownParRegions) {
            # Males have ploidy 1 for X. Call females and unknowns with ploidy 2
            call gatk.HaplotypeCaller as callX {
                input:
                    outputPath = scatterDir + "/X.g.vcf.gz",
                    intervalList = select_all([Xregions]),
                    # Females are default.
                    ploidy = if male then 1 else 2,
                    referenceFasta = referenceFasta,
                    referenceFastaIndex = referenceFastaFai,
                    referenceFastaDict = referenceFastaDict,
                    inputBams = [bamGender.file],
                    inputBamsIndex = [bamGender.index],
                    dbsnpVCF = dbsnpVCF,
                    dbsnpVCFIndex = dbsnpVCFIndex,
                    gvcf = jointgenotyping,
                    dockerImage = dockerImages["gatk4"]
            }

            # Only call y on males. Call on unknowns to be sure.
            if (male || unknownGender) {
                call gatk.HaplotypeCaller as callY {
                    input:
                        outputPath = scatterDir + "/Y.g.vcf.gz",
                        intervalList = select_all([Yregions]),
                        ploidy = 1,
                        referenceFasta = referenceFasta,
                        referenceFastaIndex = referenceFastaFai,
                        referenceFastaDict = referenceFastaDict,
                        inputBams = [bamGender.file],
                        inputBamsIndex = [bamGender.index],
                        dbsnpVCF = dbsnpVCF,
                        dbsnpVCFIndex = dbsnpVCFIndex,
                        gvcf = jointgenotyping,
                        dockerImage = dockerImages["gatk4"]
                }
            }
        }

        Array[File] VCFs = flatten([callAutosomal.outputVcfs, select_all([callY.outputVCF, callX.outputVCF])])
        Array[File] VCFIndexes = flatten([callAutosomal.outputVcfsIndex, select_all([callX.outputVCFIndex, callY.outputVCFIndex])])

        if (singleSampleGvcf && jointgenotyping) {
            call gatk.CombineGVCFs as mergeSingleSample {
                input:
                    gvcfFiles = VCFs,
                    gvcfFilesIndex = VCFIndexes,
                    outputPath = outputDir + "/samples/" + sampleName + ".g.vcf.gz",
                    referenceFasta = referenceFasta,
                    referenceFastaFai = referenceFastaFai,
                    referenceFastaDict = referenceFastaDict,
                    dockerImage = dockerImages["gatk4"]
            }
        }
    }

    if (jointgenotyping) {
        call gatk.CombineGVCFs as gatherGvcfs {
                input:
                    gvcfFiles = flatten(VCFs),
                    gvcfFilesIndex = flatten(VCFIndexes),
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

        scatter (bed in scatterAllRegions.scatters) {

            call gatk.GenotypeGVCFs as genotypeGvcfs {
                input:
                    gvcfFile = gatherGvcfs.outputVcf,
                    gvcfFileIndex = gatherGvcfs.outputVcfIndex,
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
    }

    call picard.MergeVCFs as gatherVcfs {
        input:
            inputVCFs = if jointgenotyping then select_first([genotypeGvcfs.outputVCF]) else flatten(VCFs),
            inputVCFsIndexes = if jointgenotyping then select_first([genotypeGvcfs.outputVCFIndex]) else flatten(VCFIndexes),
            outputVcfPath = outputDir + "/" + vcfBasename + ".vcf.gz",
            dockerImage = dockerImages["picard"]
    }

    call vt.Normalize as normalize {
        input:
            inputVCF = gatherVcfs.outputVcf,
            inputVCFIndex = gatherVcfs.outputVcfIndex,
            referenceFasta = referenceFasta,
            referenceFastaFai = referenceFastaFai,
            outputPath = outputDir + "/" + vcfBasename + ".normalized_decomposed.vcf.gz",
    }

    call samtools.Tabix as tabix {
        input:
            inputFile = normalize.outputVcf,
            outputFilePath = outputDir + "/" + vcfBasename + ".normalized_decomposed.indexed.vcf.gz"
    }

    output {
        File outputVcf = tabix.indexedFile
        File outputVcfIndex = tabix.index
        Array[File] singleSampleGvcfs = select_all(mergeSingleSample.outputVcf)
        Array[File] singleSampleGvcfsIndex = select_all(mergeSingleSample.outputVcfIndex)
        File? autosomalRegionsBed = autosomalRegions
        File? xRegionBed = Xregions
        File? yRegionBed = Yregions
        File? outputGVcf = gatherGvcfs.outputVcf
        File? outputGVcfIndex = gatherGvcfs.outputVcfIndex
    }

    parameter_meta {
        bamFilesAndGenders: { description: "List of structs containing,BAM file, BAM index and gender. The BAM should be recalibrated beforehand if required. The gender string is optional. Actionable values are 'female','f','F','male','m' and 'M'.",
                            category: "required" }
        vcfBasename: { description: "The basename of the VCF and GVCF files that are outputted by the workflow",
                       category: "common"}
        referenceFasta: { description: "The reference fasta file", category: "required" }
        referenceFastaFai: { description: "Fasta index (.fai) file of the reference", category: "required" }
        referenceFastaDict: { description: "Sequence dictionary (.dict) file of the reference", category: "required" }
        dbsnpVCF: { description: "dbsnp VCF file used for checking known sites", category: "common"}
        dbsnpVCFIndex: { description: "Index (.tbi) file for the dbsnp VCF", category: "common"}
        outputDir: { description: "The directory where the output files should be located", category: "common" }
        scatterSize: {description: "The size of the scattered regions in bases. Scattering is used to speed up certain processes. The genome will be sseperated into multiple chunks (scatters) which will be processed in their own job, allowing for parallel processing. Higher values will result in a lower number of jobs. The optimal value here will depend on the available resources.",
              category: "advanced"}
        regions: {description: "A bed file describing the regions to operate on.", category: "common"}
        XNonParRegions: {description: "Bed file with the non-PAR regions of X", category: "common"}
        YNonParRegions: {description: "Bed file with the non-PAR regions of Y", category: "common"}
        dockerImages: { description: "specify which docker images should be used for running this pipeline",
                        category: "advanced" }
        jointgenotyping: {description: "Whether to perform jointgenotyping (using HaplotypeCaller to call GVCFs and merge them with GenotypeGVCFs) or not",
                          category: "common"}
        singleSampleGvcf: {description: "Whether to output single-sample gvcfs", category: "common"}
    }
}

struct BamAndGender {
    File file
    File index
    String? gender
}