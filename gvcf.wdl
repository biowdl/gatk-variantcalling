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

import "tasks/gatk.wdl" as gatk

workflow Gvcf {
    input {
        File bam
        File bamIndex
        Array[File] scatterList
        String outputDir = "."
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File dbsnpVCF
        File dbsnpVCFIndex
        Map[String, String] dockerImages
    }

    String scatterDir = outputDir + "/scatters/"

    scatter (bed in scatterList) {
        call gatk.HaplotypeCallerGvcf as haplotypeCallerGvcf {
            input:
                gvcfPath = scatterDir + "/" + basename(bed) + ".g.vcf.gz",
                intervalList = [bed],
                referenceFasta = referenceFasta,
                referenceFastaIndex = referenceFastaFai,
                referenceFastaDict = referenceFastaDict,
                inputBams = [bam],
                inputBamsIndex = [bamIndex],
                dbsnpVCF = dbsnpVCF,
                dbsnpVCFIndex = dbsnpVCFIndex,
                dockerImage = dockerImages["gatk4"]
        }
    }

    output {
        Array[File] outputGvcfs = haplotypeCallerGvcf.outputGVCF
        Array[File] outputGvcfsIndex = haplotypeCallerGvcf.outputGVCFIndex
    }

    parameter_meta {
        bam: {description: "Bam file to be genotyped.", category: "required"}
        bamIndex: {description: "Index (.bai) file of the bam file.", category: "required"}
        scatterList: {description: "A list of bed files to define the scatter regions.", category:"required"}
        referenceFasta: {description: "The reference fasta file.", category: "required"}
        referenceFastaFai: {description: "Fasta index (.fai) file of the reference.", category: "required"}
        referenceFastaDict: {description: "Sequence dictionary (.dict) file of the reference.", category: "required"}
        dbsnpVCF: {description: "A dbSNP VCF file used for checking known sites.", category: "required"}
        dbsnpVCFIndex: {description: "The index (.tbi) file for the dbSNP VCF.", category: "required"}
        outputDir: {description: "The directory where the output files should be located.", category: "common"}
        dockerImages: {description: "A map with docker images to use.", category: "required"}
    }
}