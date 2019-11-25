version 1.0

import "tasks/biopet/biopet.wdl" as biopet
import "tasks/common.wdl" as common
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard
import "tasks/samtools.wdl" as samtools

workflow GatkVariantCalling {
    input {
        Array[IndexedBamFile] bamFiles
        String outputDir = "."
        String vcfBasename = "multisample"
        Boolean mergeGvcfFiles = true
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File dbsnpVCF
        File dbsnpVCFIndex

        File? regions
        # scatterSize is on number of bases. The human genome has 3 000 000 000 bases.
        # 1 billion gives approximately 3 scatters per sample.
        Int scatterSize = 1000000000
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

        call gatk.GenotypeGVCFs as genotypeGvcfs {
            input:
                gvcfFiles = [haplotypeCallerGvcf.outputGVCF],
                gvcfFilesIndex = [haplotypeCallerGvcf.outputGVCFIndex],
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

    if (mergeGvcfFiles) {
        call picard.MergeVCFs as gatherGvcfs {
            input:
                inputVCFs = haplotypeCallerGvcf.outputGVCF,
                inputVCFsIndexes = haplotypeCallerGvcf.outputGVCFIndex,
                outputVcfPath = outputDir + "/" + vcfBasename + ".g.vcf.gz",
                dockerImage = dockerImages["picard"]

        }
    }
    output {
        File outputVcf = gatherVcfs.outputVcf
        File outputVcfIndex = gatherVcfs.outputVcfIndex
        File? outputGVcf = gatherGvcfs.outputVcf
        File? outputGVcfIndex = gatherGvcfs.outputVcfIndex
    }
}