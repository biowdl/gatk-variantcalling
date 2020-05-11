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


workflow JointGenotyping {
    input {
        Array[File] gvcfFiles
        Array[File] gvcfFilesIndex
        String outputDir = "."
        String vcfBasename = "multisample"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File? dbsnpVCF
        File? dbsnpVCFIndex
        File? regions
        # Added scatterSizeMillions to overcome Json max int limit
        Int scatterSizeMillions = 1000
        # scatterSize is on number of bases. The human genome has 3 000 000 000 bases.
        # 1 billion gives approximately 3 scatters per sample.
        Int scatterSize = scatterSizeMillions * 1000000
        Map[String, String] dockerImages = {
          "picard":"quay.io/biocontainers/picard:2.20.5--0",
          "gatk4":"quay.io/biocontainers/gatk4:4.1.0.0--0",
          "biopet-scatterregions":"quay.io/biocontainers/biopet-scatterregions:0.2--0",
        }
    }
    
    call gatk.CombineGVCFs as gatherGvcfs {
        input:
            gvcfFiles = gvcfFiles,
            gvcfFilesIndex = gvcfFilesIndex,
            outputPath = outputDir + "/" + vcfBasename + ".g.vcf.gz",
            referenceFasta = referenceFasta,
            referenceFastaFai = referenceFastaFai,
            referenceFastaDict = referenceFastaDict,
            dockerImage = dockerImages["gatk4"]
    }

    call biopet.ScatterRegions as scatterRegions {
        input:
            referenceFasta = referenceFasta,
            referenceFastaDict = referenceFastaDict,
            scatterSize = scatterSize,
            regions = regions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }
    
    Boolean noScatter = length(scatterRegions.scatters) == 1
    String vcfName = outputDir + "/" + vcfBasename + ".vcf.gz"

    scatter (bed in scatterRegions.scatters) {
        String scatterVcfName = outputDir + "/scatters/" + basename(bed) + ".genotyped.vcf.gz"
        call gatk.GenotypeGVCFs as genotypeGvcfs {
            input:
                gvcfFile = gatherGvcfs.outputVcf,
                gvcfFileIndex = gatherGvcfs.outputVcfIndex,
                intervals = [bed],
                referenceFasta = referenceFasta,
                referenceFastaDict = referenceFastaDict,
                referenceFastaFai = referenceFastaFai,
                outputPath = if noScatter then vcfName else scatterVcfName,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                dockerImage = dockerImages["gatk4"]
        }
    }

    if (noScatter) {
        File noScatterVcf = genotypeGvcfs.outputVCF[0]
        File noScatterVcfIndex = genotypeGvcfs.outputVCFIndex[0]
    }

    if (!noScatter) {
        call picard.MergeVCFs as gatherVcfs {
            input:
                inputVCFs = genotypeGvcfs.outputVCF,
                inputVCFsIndexes = genotypeGvcfs.outputVCFIndex,
                outputVcfPath = vcfName,
                dockerImage = dockerImages["picard"]
        }
    }

    output {
        File multisampleGVcf = gatherGvcfs.outputVcf
        File multisampleGVcfIndex = gatherGvcfs.outputVcfIndex
        File multisampleVcf = select_first([noScatterVcf, gatherVcfs.outputVcf])
        File multisampleVcfIndex = select_first([noScatterVcfIndex, gatherVcfs.outputVcfIndex])
    }
}