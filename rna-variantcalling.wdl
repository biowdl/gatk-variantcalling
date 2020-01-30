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
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard

workflow GatkRnaVariantCalling {
    input {
        File bam
        File bamIndex
        String outputDir = "."
        String vcfBasename = "sample"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File? dbsnpVCF
        File? dbsnpVCFIndex
        File? regions
        # scatterSize is on number of bases. The human genome has 3 000 000 000 bases.
        # 1 billion gives approximately 3 scatters per sample.
        Int scatterSize = 1000000000
        Map[String, String] dockerImages = {
          "picard":"quay.io/biocontainers/picard:2.20.5--0",
          "gatk4":"quay.io/biocontainers/gatk4:4.1.0.0--0",
          "biopet-scatterregions":"quay.io/biocontainers/biopet-scatterregions:0.2--0",
        }
    }

    call biopet.ScatterRegions as scatterRegions {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            regions = regions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    # Glob messes with order of scatters (10 comes before 1), which causes problems at gatherGvcfs
    call biopet.ReorderGlobbedScatters as orderedScatters {
        input:
            scatters = scatterRegions.scatters
            # Dockertag not relevant here. Python script always runs in the same
            # python container.
    }

    scatter (bed in orderedScatters.reorderedScatters) {
        call gatk.HaplotypeCaller as HaplotypeCaller {
            input:
                inputBams = [bam],
                inputBamsIndex = [bamIndex],
                intervalList = [bed],
                outputPath = outputDir + "/scatters/" + basename(bed) + ".vcf.gz",
                referenceFasta = referenceFasta,
                referenceFastaIndex = referenceFastaFai,
                referenceFastaDict = referenceFastaDict,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                gvcf = false,
                dockerImage = dockerImages["gatk4"]
        }
    }

    call picard.MergeVCFs as gatherVcfs {
        input:
            inputVCFs = HaplotypeCaller.outputVCF,
            inputVCFsIndexes =  HaplotypeCaller.outputVCFIndex,
            outputVcfPath = outputDir + "/" + vcfBasename + ".vcf.gz",
            dockerImage = dockerImages["picard"]
    }

    output {
        File outputVcf = gatherVcfs.outputVcf
        File outputVcfIndex = gatherVcfs.outputVcfIndex
    }

    parameter_meta {
        bam: {description: "Bam file to be genotyped.", category: "required"}
        bamIndex: {description: "Index (.bai) file of the bam file.", category: "required"}
        vcfBasename: { description: "The basename of the VCF files that are outputted by the workflow",
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
    }
}