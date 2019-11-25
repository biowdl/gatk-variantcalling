version 1.0

import "tasks/biopet/biopet.wdl" as biopet
import "tasks/common.wdl" as common
import "tasks/gatk.wdl" as gatk
import "tasks/picard.wdl" as picard
import "tasks/samtools.wdl" as samtools

workflow JointGenotyping {
    input{
        Array[IndexedVcfFile]+ gvcfFiles
        String outputDir = "."
        String vcfBasename = "multisample"
        Reference reference
        Boolean mergeGvcfFiles = true
        IndexedVcfFile dbsnpVCF

        File? regions
        # scatterSize is on number of bases. The human genome has 3 000 000 000 bases.
        # 1 billion gives approximately 3 scatters per sample.
        Int scatterSize = 1000000000

        Map[String, String] dockerImages = {
          "picard": "quay.io/biocontainers/picard:2.20.5--0",
          "gatk4":"quay.io/biocontainers/gatk4:4.1.0.0--0",
          "biopet-scatterregions": "quay.io/biocontainers/biopet-scatterregions:0.2--0",
        }
    }

    call biopet.ScatterRegions as scatterList {
        input:
            referenceFasta = reference.fasta,
            referenceFastaDict = reference.dict,
            scatterSize = scatterSize,
            regions = regions,
            dockerImage = dockerImages["biopet-scatterregions"]
    }

    # Glob messes with order of scatters (10 comes before 1), which causes problems at vcf gathering
    call biopet.ReorderGlobbedScatters as orderedScatters {
        input:
            scatters = scatterList.scatters
    }

    scatter (gvcf in gvcfFiles) {
        File files = gvcf.file
        File indexes = gvcf.index
    }

    scatter (bed in orderedScatters.reorderedScatters) {

        call gatk.CombineGVCFs as combineGVCFs {
            input:
                gvcfFiles = files,
                gvcfFilesIndex = indexes,
                referenceFasta = reference.fasta,
                referenceFastaFai = reference.fai,
                referenceFastaDict = reference.dict,
                outputPath = outputDir + "/scatters/" + basename(bed) + ".g.vcf.gz",
                intervals = [bed],
                dockerImage = dockerImages["gatk4"]
        }

        call gatk.GenotypeGVCFs as genotypeGvcfs {
            input:
                gvcfFiles = [combineGVCFs.outputVcf],
                gvcfFilesIndex = [combineGVCFs.outputVcfIndex],
                intervals = [bed],
                referenceFasta = reference.fasta,
                referenceFastaDict = reference.dict,
                referenceFastaFai = reference.fai,
                outputPath = outputDir + "/scatters/" + basename(bed) + ".genotyped.vcf.gz",
                dbsnpVCF = dbsnpVCF.file,
                dbsnpVCFIndex = dbsnpVCF.index,
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
                inputVCFs = combineGVCFs.outputVcf,
                inputVCFsIndexes = combineGVCFs.outputVcfIndex,
                outputVcfPath = outputDir + "/" + vcfBasename + ".g.vcf.gz",
                dockerImage = dockerImages["picard"]
        }
        IndexedVcfFile mergedGVCF = object {
            file: gatherGvcfs.outputVcf,
            index: gatherGvcfs.outputVcfIndex
        }
    }

    output {
        IndexedVcfFile vcfFile = object {
            file: gatherVcfs.outputVcf,
            index: gatherVcfs.outputVcfIndex
        }
        IndexedVcfFile? gvcfFile = mergedGVCF
    }
}