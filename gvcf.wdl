version 1.0

import "tasks/biopet/biopet.wdl" as biopet
import "tasks/common.wdl" as common
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard
import "tasks/samtools.wdl" as samtools

workflow Gvcf {
    input {
        Array[IndexedBamFile] bamFiles
        String outputDir = "."
        String gvcfName = "gvcf.g.vcf.gz"
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File dbsnpVCF
        File dbsnpVCFIndex

        File? regions
        Int scatterSize = 10000000
        Map[String, String] dockerImages = {
          "samtools":"quay.io/biocontainers/samtools:1.8--h46bd0b3_5",
          "picard":"quay.io/biocontainers/picard:2.20.5--0",
          "gatk4":"quay.io/biocontainers/gatk4:4.1.0.0--0",
          "biopet-scatterregions":"quay.io/biocontainers/biopet-scatterregions:0.2--0",
          "tabix": "quay.io/biocontainers/tabix:0.2.6--ha92aebf_0"
        }
    }

    call biopet.ScatterRegions as scatterList {
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
            scatters = scatterList.scatters,
            # Dockertag not relevant here. Python script always runs in the same
            # python container.
    }

    scatter (f in bamFiles) {
        File files = f.file
        File indexes = f.index
    }

    String scatterDir = outputDir + "/scatters/"

    scatter (bed in orderedScatters.reorderedScatters) {
        call gatk.HaplotypeCallerGvcf as haplotypeCallerGvcf {
            input:
                gvcfPath = scatterDir + "/" + basename(bed) + ".vcf.gz",
                intervalList = [bed],
                referenceFasta = referenceFasta,
                referenceFastaIndex = referenceFastaFai,
                referenceFastaDict = referenceFastaDict,
                inputBams = files,
                inputBamsIndex = indexes,
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                dockerImage = dockerImages["gatk4"]
        }

    }

    call picard.GatherVcfs as gatherGvcfs {
        input:
            inputVcfs = haplotypeCallerGvcf.outputGVCF,
            inputVcfIndexes = haplotypeCallerGvcf.outputGVCFIndex,
            outputVcfPath = outputDir + "/"+ gvcfName,
            dockerImage = dockerImages["picard"]
    }

    call samtools.Tabix as indexGatheredGvcfs {
        input:
            inputFile = gatherGvcfs.outputVcf,
            outputFilePath = outputDir + "/"+ gvcfName,
            dockerImage = dockerImages["tabix"]
    }

    output {
        File outputGVcf = indexGatheredGvcfs.indexedFile
        File outputGVcfIndex = indexGatheredGvcfs.index
    }
}