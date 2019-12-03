---
layout: default
title: Inputs
---

# Inputs for GatkVariantCalling

The following is an overview of all available inputs in
GatkVariantCalling.


## Required inputs
<dl>
<dt id="GatkVariantCalling.bamFiles"><a href="#GatkVariantCalling.bamFiles">GatkVariantCalling.bamFiles</a></dt>
<dd>
    <i>Array[struct(file : File, index : File, md5sum : String?)] </i><i>&mdash; Default:</i> <code>None</code><br />
    BAM files to be analysed by GATK. The should be recalibrated beforehand if required.
</dd>
<dt id="GatkVariantCalling.dbsnpVCF"><a href="#GatkVariantCalling.dbsnpVCF">GatkVariantCalling.dbsnpVCF</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    dbsnp VCF file used for checking known sites
</dd>
<dt id="GatkVariantCalling.dbsnpVCFIndex"><a href="#GatkVariantCalling.dbsnpVCFIndex">GatkVariantCalling.dbsnpVCFIndex</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    index (.tbi) file for the dbsnp VCF
</dd>
<dt id="GatkVariantCalling.referenceFasta"><a href="#GatkVariantCalling.referenceFasta">GatkVariantCalling.referenceFasta</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    The reference fasta file
</dd>
<dt id="GatkVariantCalling.referenceFastaDict"><a href="#GatkVariantCalling.referenceFastaDict">GatkVariantCalling.referenceFastaDict</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    Sequence dictionary (.dict) file of the reference
</dd>
<dt id="GatkVariantCalling.referenceFastaFai"><a href="#GatkVariantCalling.referenceFastaFai">GatkVariantCalling.referenceFastaFai</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    Fasta index (.fai) file of the reference
</dd>
</dl>

## Other common inputs
<dl>
<dt id="GatkVariantCalling.outputDir"><a href="#GatkVariantCalling.outputDir">GatkVariantCalling.outputDir</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory where the output files should be located
</dd>
<dt id="GatkVariantCalling.vcfBasename"><a href="#GatkVariantCalling.vcfBasename">GatkVariantCalling.vcfBasename</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"multisample"</code><br />
    The basename of the VCF and GVCF files that are outputted by the workflow
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="GatkVariantCalling.dockerImages"><a href="#GatkVariantCalling.dockerImages">GatkVariantCalling.dockerImages</a></dt>
<dd>
    <i>Map[String,String] </i><i>&mdash; Default:</i> <code>{"picard": "quay.io/biocontainers/picard:2.20.5--0", "gatk4": "quay.io/biocontainers/gatk4:4.1.0.0--0", "biopet-scatterregions": "quay.io/biocontainers/biopet-scatterregions:0.2--0"}</code><br />
    specify which docker images should be used for running this pipeline
</dd>
</dl>
</details>



## Other inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="GatkVariantCalling.gatherGvcfs.intervals"><a href="#GatkVariantCalling.gatherGvcfs.intervals">GatkVariantCalling.gatherGvcfs.intervals</a></dt>
<dd>
    <i>Array[File] </i><i>&mdash; Default:</i> <code>[]</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.gatherGvcfs.javaXmx"><a href="#GatkVariantCalling.gatherGvcfs.javaXmx">GatkVariantCalling.gatherGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.gatherGvcfs.memory"><a href="#GatkVariantCalling.gatherGvcfs.memory">GatkVariantCalling.gatherGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.gatherVcfs.javaXmx"><a href="#GatkVariantCalling.gatherVcfs.javaXmx">GatkVariantCalling.gatherVcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.gatherVcfs.memory"><a href="#GatkVariantCalling.gatherVcfs.memory">GatkVariantCalling.gatherVcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.javaXmx"><a href="#GatkVariantCalling.genotypeGvcfs.javaXmx">GatkVariantCalling.genotypeGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"6G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.memory"><a href="#GatkVariantCalling.genotypeGvcfs.memory">GatkVariantCalling.genotypeGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"18G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.Gvcf.haplotypeCallerGvcf.contamination"><a href="#GatkVariantCalling.Gvcf.haplotypeCallerGvcf.contamination">GatkVariantCalling.Gvcf.haplotypeCallerGvcf.contamination</a></dt>
<dd>
    <i>Float </i><i>&mdash; Default:</i> <code>0.0</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx"><a href="#GatkVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx">GatkVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.Gvcf.haplotypeCallerGvcf.memory"><a href="#GatkVariantCalling.Gvcf.haplotypeCallerGvcf.memory">GatkVariantCalling.Gvcf.haplotypeCallerGvcf.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.orderedScatters.dockerImage"><a href="#GatkVariantCalling.orderedScatters.dockerImage">GatkVariantCalling.orderedScatters.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python:3.7-slim"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.regions"><a href="#GatkVariantCalling.regions">GatkVariantCalling.regions</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterList.bamFile"><a href="#GatkVariantCalling.scatterList.bamFile">GatkVariantCalling.scatterList.bamFile</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterList.bamIndex"><a href="#GatkVariantCalling.scatterList.bamIndex">GatkVariantCalling.scatterList.bamIndex</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterList.javaXmx"><a href="#GatkVariantCalling.scatterList.javaXmx">GatkVariantCalling.scatterList.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterList.memory"><a href="#GatkVariantCalling.scatterList.memory">GatkVariantCalling.scatterList.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterList.notSplitContigs"><a href="#GatkVariantCalling.scatterList.notSplitContigs">GatkVariantCalling.scatterList.notSplitContigs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    ???
</dd>
<dt id="GatkVariantCalling.scatterSize"><a href="#GatkVariantCalling.scatterSize">GatkVariantCalling.scatterSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1000000000</code><br />
    ???
</dd>
</dl>
</details>


