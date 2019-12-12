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
import "gvcf.wdl" as gvcf

workflow GatkVariantCalling {
    input {
        Array[Pair[IndexedBamFile, String]] bamFilesAndGenders
        String outputDir = "."
        String vcfBasename = "multisample"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File dbsnpVCF
        File dbsnpVCFIndex
        File XNonParRegions
        File YNonParRegions
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

    # We define the 'normal' regions by creating a regions file that covers
    # everything except the XNonParRegions and the YNonParRegions.
    call bedtools.MergeBedFiles as mergeBeds {
        input:
            bedFiles = [XNonParRegions, YNonParRegions],
            dockerImage = dockerImages["bedtools"]
    }

    call bedtools.Complement as inverseBed {
        input:
            inputBed = mergeBeds.mergedBed,
            faidx = referenceFastaFai,
            dockerImage = dockerImages["bedtools"]
    }
    File autosomalRegions = inverseBed.complementBed

    call biopet.ScatterRegions as scatterList {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            regions = autosomalRegions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    # Glob messes with order of scatters (10 comes before 1), which causes problems at gatherGvcfs
    call biopet.ReorderGlobbedScatters as orderedScatters {
        input:
            scatters = scatterList.scatters
            # Dockertag not relevant here. Python script always runs in the same
            # python container.
    }

    scatter (bamGender in bamFilesAndGenders) {
        IndexedBamFile bam = bamGender.left
        String gender = bamGender.right
        # Call separate pipeline to allow scatter in scatter.
        # Also this is needed. If there are 50 bam files, we need more scattering than
        # when we have 1 bam file.
        call gvcf.Gvcf as Gvcf {
            input:
                bam = bam.file,
                bamIndex = bam.index,
                scatterList = orderedScatters.reorderedScatters,
                referenceFasta = referenceFasta,
                referenceFastaDict = referenceFastaDict,
                referenceFastaFai = referenceFastaFai,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                outputDir = outputDir + "/samples/" + basename(bam.file, ".bam"),
                dockerImages = dockerImages
        }

        if (gender == "male" || gender =="m") {
            call gatk.HaplotypeCallerGVCF as callMalePloidy {
                input:
                    gvcfPath = scatterDir + "/" + ".g.vcf.gz",
                    intervalList = [XNonParRegions, YNonParRegions],
                    ploidy = 1,
                    referenceFasta = referenceFasta,
                    referenceFastaIndex = referenceFastaFai,
                    referenceFastaDict = referenceFastaDict,
                    inputBam = [bam.file],
                    inputBamsIndex = [bam.index],
                    dbsnpVCF = dbsnpVCF,
                    dbsnpVCFIndex = dbsnpVCFIndex,
                    dockerImage = dockerImages["gatk4"]
            }
        }
    }

    call gatk.CombineGVCFs as gatherGvcfs {
            input:
                gvcfFiles = flatten(Gvcf.outputGvcfs),
                gvcfFilesIndex = flatten(Gvcf.outputGvcfsIndex),
                outputPath = outputDir + "/" + vcfBasename + ".g.vcf.gz",
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                referenceFastaDict = referenceFastaDict,
                dockerImage = dockerImages["gatk4"]

    }

    String scatterDir = outputDir + "/scatters/"

    scatter (bed in orderedScatters.reorderedScatters) {

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
        File? outputGVcf = gatherGvcfs.outputVcf
        File? outputGVcfIndex = gatherGvcfs.outputVcfIndex
    }

    parameter_meta {
        bamFiles: { description: "BAM files to be analysed by GATK. The should be recalibrated beforehand if required.",
                    category: "required" }
        vcfBasename: { description: "The basename of the VCF and GVCF files that are outputted by the workflow",
                       category: "common"}
        referenceFasta: { description: "The reference fasta file", category: "required" }
        referenceFastaFai: { description: "Fasta index (.fai) file of the reference", category: "required" }
        referenceFastaDict: { description: "Sequence dictionary (.dict) file of the reference", category: "required" }
        dbsnpVCF: { description: "dbsnp VCF file used for checking known sites", category: "required"}
        dbsnpVCFIndex: { description: "index (.tbi) file for the dbsnp VCF", category: "required"}
        outputDir: { description: "The directory where the output files should be located", category: "common" }
        dockerImages: { description: "specify which docker images should be used for running this pipeline",
                        category: "advanced" }
    }
}
