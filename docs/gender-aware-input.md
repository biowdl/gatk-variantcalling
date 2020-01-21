---
layout: default
title: Inputs
---

# Inputs for GenderAwareVariantCalling

The following is an overview of all available inputs in
GenderAwareVariantCalling.


## Required inputs
<dl>
<dt id="GenderAwareVariantCalling.bamFilesAndGenders"><a href="#GenderAwareVariantCalling.bamFilesAndGenders">GenderAwareVariantCalling.bamFilesAndGenders</a></dt>
<dd>
    <i>Array[Pair[struct(file : File, index : File, md5sum : String?),String]] </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.dbsnpVCF"><a href="#GenderAwareVariantCalling.dbsnpVCF">GenderAwareVariantCalling.dbsnpVCF</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    dbsnp VCF file used for checking known sites
</dd>
<dt id="GenderAwareVariantCalling.dbsnpVCFIndex"><a href="#GenderAwareVariantCalling.dbsnpVCFIndex">GenderAwareVariantCalling.dbsnpVCFIndex</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    index (.tbi) file for the dbsnp VCF
</dd>
<dt id="GenderAwareVariantCalling.referenceFasta"><a href="#GenderAwareVariantCalling.referenceFasta">GenderAwareVariantCalling.referenceFasta</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    The reference fasta file
</dd>
<dt id="GenderAwareVariantCalling.referenceFastaDict"><a href="#GenderAwareVariantCalling.referenceFastaDict">GenderAwareVariantCalling.referenceFastaDict</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    Sequence dictionary (.dict) file of the reference
</dd>
<dt id="GenderAwareVariantCalling.referenceFastaFai"><a href="#GenderAwareVariantCalling.referenceFastaFai">GenderAwareVariantCalling.referenceFastaFai</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    Fasta index (.fai) file of the reference
</dd>
<dt id="GenderAwareVariantCalling.XNonParRegions"><a href="#GenderAwareVariantCalling.XNonParRegions">GenderAwareVariantCalling.XNonParRegions</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.YNonParRegions"><a href="#GenderAwareVariantCalling.YNonParRegions">GenderAwareVariantCalling.YNonParRegions</a></dt>
<dd>
    <i>File </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
</dl>

## Other common inputs
<dl>
<dt id="GenderAwareVariantCalling.outputDir"><a href="#GenderAwareVariantCalling.outputDir">GenderAwareVariantCalling.outputDir</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory where the output files should be located
</dd>
<dt id="GenderAwareVariantCalling.vcfBasename"><a href="#GenderAwareVariantCalling.vcfBasename">GenderAwareVariantCalling.vcfBasename</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"multisample"</code><br />
    The basename of the VCF and GVCF files that are outputted by the workflow
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="GenderAwareVariantCalling.callX.contamination"><a href="#GenderAwareVariantCalling.callX.contamination">GenderAwareVariantCalling.callX.contamination</a></dt>
<dd>
    <i>Float </i><i>&mdash; Default:</i> <code>0.0</code><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GenderAwareVariantCalling.callX.javaXmx"><a href="#GenderAwareVariantCalling.callX.javaXmx">GenderAwareVariantCalling.callX.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.callX.memory"><a href="#GenderAwareVariantCalling.callX.memory">GenderAwareVariantCalling.callX.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.callY.contamination"><a href="#GenderAwareVariantCalling.callY.contamination">GenderAwareVariantCalling.callY.contamination</a></dt>
<dd>
    <i>Float </i><i>&mdash; Default:</i> <code>0.0</code><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GenderAwareVariantCalling.callY.javaXmx"><a href="#GenderAwareVariantCalling.callY.javaXmx">GenderAwareVariantCalling.callY.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.callY.memory"><a href="#GenderAwareVariantCalling.callY.memory">GenderAwareVariantCalling.callY.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.dockerImages"><a href="#GenderAwareVariantCalling.dockerImages">GenderAwareVariantCalling.dockerImages</a></dt>
<dd>
    <i>Map[String,String] </i><i>&mdash; Default:</i> <code>{"bedtools": "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3", "picard": "quay.io/biocontainers/picard:2.20.5--0", "gatk4": "quay.io/biocontainers/gatk4:4.1.0.0--0", "biopet-scatterregions": "quay.io/biocontainers/biopet-scatterregions:0.2--0"}</code><br />
    specify which docker images should be used for running this pipeline
</dd>
<dt id="GenderAwareVariantCalling.gatherGvcfs.intervals"><a href="#GenderAwareVariantCalling.gatherGvcfs.intervals">GenderAwareVariantCalling.gatherGvcfs.intervals</a></dt>
<dd>
    <i>Array[File] </i><i>&mdash; Default:</i> <code>[]</code><br />
    Bed files or interval lists describing the regions to operate on.
</dd>
<dt id="GenderAwareVariantCalling.gatherGvcfs.javaXmx"><a href="#GenderAwareVariantCalling.gatherGvcfs.javaXmx">GenderAwareVariantCalling.gatherGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.gatherGvcfs.memory"><a href="#GenderAwareVariantCalling.gatherGvcfs.memory">GenderAwareVariantCalling.gatherGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.gatherVcfs.javaXmx"><a href="#GenderAwareVariantCalling.gatherVcfs.javaXmx">GenderAwareVariantCalling.gatherVcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.gatherVcfs.memory"><a href="#GenderAwareVariantCalling.gatherVcfs.memory">GenderAwareVariantCalling.gatherVcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.genotypeGvcfs.javaXmx"><a href="#GenderAwareVariantCalling.genotypeGvcfs.javaXmx">GenderAwareVariantCalling.genotypeGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"6G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.genotypeGvcfs.memory"><a href="#GenderAwareVariantCalling.genotypeGvcfs.memory">GenderAwareVariantCalling.genotypeGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"18G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.contamination"><a href="#GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.contamination">GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.contamination</a></dt>
<dd>
    <i>Float </i><i>&mdash; Default:</i> <code>0.0</code><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx"><a href="#GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx">GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.memory"><a href="#GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.memory">GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.inverseBed.outputBed"><a href="#GenderAwareVariantCalling.inverseBed.outputBed">GenderAwareVariantCalling.inverseBed.outputBed</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>basename(inputBed,"\.bed") + ".complement.bed"</code><br />
    The path to write the output to
</dd>
<dt id="GenderAwareVariantCalling.mergeBeds.outputBed"><a href="#GenderAwareVariantCalling.mergeBeds.outputBed">GenderAwareVariantCalling.mergeBeds.outputBed</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"merged.bed"</code><br />
    The path to write the output to
</dd>
<dt id="GenderAwareVariantCalling.orderedAllScatters.dockerImage"><a href="#GenderAwareVariantCalling.orderedAllScatters.dockerImage">GenderAwareVariantCalling.orderedAllScatters.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python:3.7-slim"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="GenderAwareVariantCalling.orderedAutosomalScatters.dockerImage"><a href="#GenderAwareVariantCalling.orderedAutosomalScatters.dockerImage">GenderAwareVariantCalling.orderedAutosomalScatters.dockerImage</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"python:3.7-slim"</code><br />
    The docker image used for this task. Changing this may result in errors which the developers may choose not to address.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.bamFile"><a href="#GenderAwareVariantCalling.scatterAllRegions.bamFile">GenderAwareVariantCalling.scatterAllRegions.bamFile</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    Equivalent to biopet scatterregions' `--bamfile` option.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.bamIndex"><a href="#GenderAwareVariantCalling.scatterAllRegions.bamIndex">GenderAwareVariantCalling.scatterAllRegions.bamIndex</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    The index for the bamfile given through bamFile.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.javaXmx"><a href="#GenderAwareVariantCalling.scatterAllRegions.javaXmx">GenderAwareVariantCalling.scatterAllRegions.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.memory"><a href="#GenderAwareVariantCalling.scatterAllRegions.memory">GenderAwareVariantCalling.scatterAllRegions.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.notSplitContigs"><a href="#GenderAwareVariantCalling.scatterAllRegions.notSplitContigs">GenderAwareVariantCalling.scatterAllRegions.notSplitContigs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Equivalent to biopet scatterregions' `--notSplitContigs` flag.
</dd>
<dt id="GenderAwareVariantCalling.scatterAllRegions.regions"><a href="#GenderAwareVariantCalling.scatterAllRegions.regions">GenderAwareVariantCalling.scatterAllRegions.regions</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    The regions to be scattered.
</dd>
<dt id="GenderAwareVariantCalling.scatterAutosomalRegions.bamFile"><a href="#GenderAwareVariantCalling.scatterAutosomalRegions.bamFile">GenderAwareVariantCalling.scatterAutosomalRegions.bamFile</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    Equivalent to biopet scatterregions' `--bamfile` option.
</dd>
<dt id="GenderAwareVariantCalling.scatterAutosomalRegions.bamIndex"><a href="#GenderAwareVariantCalling.scatterAutosomalRegions.bamIndex">GenderAwareVariantCalling.scatterAutosomalRegions.bamIndex</a></dt>
<dd>
    <i>File? </i><i>&mdash; Default:</i> <code>None</code><br />
    The index for the bamfile given through bamFile.
</dd>
<dt id="GenderAwareVariantCalling.scatterAutosomalRegions.javaXmx"><a href="#GenderAwareVariantCalling.scatterAutosomalRegions.javaXmx">GenderAwareVariantCalling.scatterAutosomalRegions.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GenderAwareVariantCalling.scatterAutosomalRegions.memory"><a href="#GenderAwareVariantCalling.scatterAutosomalRegions.memory">GenderAwareVariantCalling.scatterAutosomalRegions.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GenderAwareVariantCalling.scatterAutosomalRegions.notSplitContigs"><a href="#GenderAwareVariantCalling.scatterAutosomalRegions.notSplitContigs">GenderAwareVariantCalling.scatterAutosomalRegions.notSplitContigs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Equivalent to biopet scatterregions' `--notSplitContigs` flag.
</dd>
</dl>
</details>



## Other inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="GenderAwareVariantCalling.callX.excludeIntervalList"><a href="#GenderAwareVariantCalling.callX.excludeIntervalList">GenderAwareVariantCalling.callX.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.callY.excludeIntervalList"><a href="#GenderAwareVariantCalling.callY.excludeIntervalList">GenderAwareVariantCalling.callY.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.excludeIntervalList"><a href="#GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.excludeIntervalList">GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.ploidy"><a href="#GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.ploidy">GenderAwareVariantCalling.Gvcf.haplotypeCallerGvcf.ploidy</a></dt>
<dd>
    <i>Int? </i><i>&mdash; Default:</i> <code>None</code><br />
    ???
</dd>
<dt id="GenderAwareVariantCalling.scatterSize"><a href="#GenderAwareVariantCalling.scatterSize">GenderAwareVariantCalling.scatterSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1000000000</code><br />
    ???
</dd>
</dl>
</details>


