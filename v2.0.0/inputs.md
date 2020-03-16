---
layout: default
title: "Inputs: GatkVariantCalling"
---

# Inputs for GatkVariantCalling

The following is an overview of all available inputs in
GatkVariantCalling.


## Required inputs
<dl>
<dt id="GatkVariantCalling.bamFilesAndGenders"><a href="#GatkVariantCalling.bamFilesAndGenders">GatkVariantCalling.bamFilesAndGenders</a></dt>
<dd>
    <i>Array[struct(file : File, gender : String?, index : File)] </i><br />
    List of structs containing,BAM file, BAM index and gender. The BAM should be recalibrated beforehand if required. The gender string is optional. Actionable values are 'female','f','F','male','m' and 'M'.
</dd>
<dt id="GatkVariantCalling.referenceFasta"><a href="#GatkVariantCalling.referenceFasta">GatkVariantCalling.referenceFasta</a></dt>
<dd>
    <i>File </i><br />
    The reference fasta file
</dd>
<dt id="GatkVariantCalling.referenceFastaDict"><a href="#GatkVariantCalling.referenceFastaDict">GatkVariantCalling.referenceFastaDict</a></dt>
<dd>
    <i>File </i><br />
    Sequence dictionary (.dict) file of the reference
</dd>
<dt id="GatkVariantCalling.referenceFastaFai"><a href="#GatkVariantCalling.referenceFastaFai">GatkVariantCalling.referenceFastaFai</a></dt>
<dd>
    <i>File </i><br />
    Fasta index (.fai) file of the reference
</dd>
</dl>

## Other common inputs
<dl>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.excludeIntervalList"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.excludeIntervalList">GatkVariantCalling.callAutosomal.haplotypeCaller.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><br />
    Bed files or interval lists describing the regions to NOT operate on.
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.pedigree"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.pedigree">GatkVariantCalling.callAutosomal.haplotypeCaller.pedigree</a></dt>
<dd>
    <i>File? </i><br />
    Pedigree file for determining the population "founders"
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.ploidy"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.ploidy">GatkVariantCalling.callAutosomal.haplotypeCaller.ploidy</a></dt>
<dd>
    <i>Int? </i><br />
    The ploidy with which the variants should be called.
</dd>
<dt id="GatkVariantCalling.callX.excludeIntervalList"><a href="#GatkVariantCalling.callX.excludeIntervalList">GatkVariantCalling.callX.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><br />
    Bed files or interval lists describing the regions to NOT operate on.
</dd>
<dt id="GatkVariantCalling.callX.pedigree"><a href="#GatkVariantCalling.callX.pedigree">GatkVariantCalling.callX.pedigree</a></dt>
<dd>
    <i>File? </i><br />
    Pedigree file for determining the population "founders"
</dd>
<dt id="GatkVariantCalling.callY.excludeIntervalList"><a href="#GatkVariantCalling.callY.excludeIntervalList">GatkVariantCalling.callY.excludeIntervalList</a></dt>
<dd>
    <i>Array[File]+? </i><br />
    Bed files or interval lists describing the regions to NOT operate on.
</dd>
<dt id="GatkVariantCalling.callY.pedigree"><a href="#GatkVariantCalling.callY.pedigree">GatkVariantCalling.callY.pedigree</a></dt>
<dd>
    <i>File? </i><br />
    Pedigree file for determining the population "founders"
</dd>
<dt id="GatkVariantCalling.dbsnpVCF"><a href="#GatkVariantCalling.dbsnpVCF">GatkVariantCalling.dbsnpVCF</a></dt>
<dd>
    <i>File? </i><br />
    dbsnp VCF file used for checking known sites
</dd>
<dt id="GatkVariantCalling.dbsnpVCFIndex"><a href="#GatkVariantCalling.dbsnpVCFIndex">GatkVariantCalling.dbsnpVCFIndex</a></dt>
<dd>
    <i>File? </i><br />
    Index (.tbi) file for the dbsnp VCF
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.pedigree"><a href="#GatkVariantCalling.genotypeGvcfs.pedigree">GatkVariantCalling.genotypeGvcfs.pedigree</a></dt>
<dd>
    <i>File? </i><br />
    Pedigree file for determining the population "founders"
</dd>
<dt id="GatkVariantCalling.jointgenotyping"><a href="#GatkVariantCalling.jointgenotyping">GatkVariantCalling.jointgenotyping</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>true</code><br />
    Whether to perform jointgenotyping (using HaplotypeCaller to call GVCFs and merge them with GenotypeGVCFs) or not
</dd>
<dt id="GatkVariantCalling.outputDir"><a href="#GatkVariantCalling.outputDir">GatkVariantCalling.outputDir</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"."</code><br />
    The directory where the output files should be located
</dd>
<dt id="GatkVariantCalling.regions"><a href="#GatkVariantCalling.regions">GatkVariantCalling.regions</a></dt>
<dd>
    <i>File? </i><br />
    A bed file describing the regions to operate on.
</dd>
<dt id="GatkVariantCalling.singleSampleGvcf"><a href="#GatkVariantCalling.singleSampleGvcf">GatkVariantCalling.singleSampleGvcf</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Whether to output single-sample gvcfs
</dd>
<dt id="GatkVariantCalling.vcfBasename"><a href="#GatkVariantCalling.vcfBasename">GatkVariantCalling.vcfBasename</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"multisample"</code><br />
    The basename of the VCF and GVCF files that are outputted by the workflow
</dd>
<dt id="GatkVariantCalling.XNonParRegions"><a href="#GatkVariantCalling.XNonParRegions">GatkVariantCalling.XNonParRegions</a></dt>
<dd>
    <i>File? </i><br />
    Bed file with the non-PAR regions of X
</dd>
<dt id="GatkVariantCalling.YNonParRegions"><a href="#GatkVariantCalling.YNonParRegions">GatkVariantCalling.YNonParRegions</a></dt>
<dd>
    <i>File? </i><br />
    Bed file with the non-PAR regions of Y
</dd>
</dl>

## Advanced inputs
<details>
<summary> Show/Hide </summary>
<dl>
<dt id="GatkVariantCalling.calculateRegions.mergeBeds.outputBed"><a href="#GatkVariantCalling.calculateRegions.mergeBeds.outputBed">GatkVariantCalling.calculateRegions.mergeBeds.outputBed</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"merged.bed"</code><br />
    The path to write the output to
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.contamination"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.contamination">GatkVariantCalling.callAutosomal.haplotypeCaller.contamination</a></dt>
<dd>
    <i>Float? </i><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.emitRefConfidence"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.emitRefConfidence">GatkVariantCalling.callAutosomal.haplotypeCaller.emitRefConfidence</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>if gvcf then "GVCF" else "NONE"</code><br />
    Whether to include reference calls. Three modes: 'NONE', 'BP_RESOLUTION' and 'GVCF'
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.javaXmx"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.javaXmx">GatkVariantCalling.callAutosomal.haplotypeCaller.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.memory"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.memory">GatkVariantCalling.callAutosomal.haplotypeCaller.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.callAutosomal.haplotypeCaller.outputMode"><a href="#GatkVariantCalling.callAutosomal.haplotypeCaller.outputMode">GatkVariantCalling.callAutosomal.haplotypeCaller.outputMode</a></dt>
<dd>
    <i>String? </i><br />
    Specifies which type of calls we should output. Same as HaplotypeCaller's `--output-mode` option.
</dd>
<dt id="GatkVariantCalling.callX.contamination"><a href="#GatkVariantCalling.callX.contamination">GatkVariantCalling.callX.contamination</a></dt>
<dd>
    <i>Float? </i><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GatkVariantCalling.callX.emitRefConfidence"><a href="#GatkVariantCalling.callX.emitRefConfidence">GatkVariantCalling.callX.emitRefConfidence</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>if gvcf then "GVCF" else "NONE"</code><br />
    Whether to include reference calls. Three modes: 'NONE', 'BP_RESOLUTION' and 'GVCF'
</dd>
<dt id="GatkVariantCalling.callX.javaXmx"><a href="#GatkVariantCalling.callX.javaXmx">GatkVariantCalling.callX.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.callX.memory"><a href="#GatkVariantCalling.callX.memory">GatkVariantCalling.callX.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.callX.outputMode"><a href="#GatkVariantCalling.callX.outputMode">GatkVariantCalling.callX.outputMode</a></dt>
<dd>
    <i>String? </i><br />
    Specifies which type of calls we should output. Same as HaplotypeCaller's `--output-mode` option.
</dd>
<dt id="GatkVariantCalling.callY.contamination"><a href="#GatkVariantCalling.callY.contamination">GatkVariantCalling.callY.contamination</a></dt>
<dd>
    <i>Float? </i><br />
    Equivalent to HaplotypeCaller's `-contamination` option.
</dd>
<dt id="GatkVariantCalling.callY.emitRefConfidence"><a href="#GatkVariantCalling.callY.emitRefConfidence">GatkVariantCalling.callY.emitRefConfidence</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>if gvcf then "GVCF" else "NONE"</code><br />
    Whether to include reference calls. Three modes: 'NONE', 'BP_RESOLUTION' and 'GVCF'
</dd>
<dt id="GatkVariantCalling.callY.javaXmx"><a href="#GatkVariantCalling.callY.javaXmx">GatkVariantCalling.callY.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"4G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.callY.memory"><a href="#GatkVariantCalling.callY.memory">GatkVariantCalling.callY.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.callY.outputMode"><a href="#GatkVariantCalling.callY.outputMode">GatkVariantCalling.callY.outputMode</a></dt>
<dd>
    <i>String? </i><br />
    Specifies which type of calls we should output. Same as HaplotypeCaller's `--output-mode` option.
</dd>
<dt id="GatkVariantCalling.dockerImages"><a href="#GatkVariantCalling.dockerImages">GatkVariantCalling.dockerImages</a></dt>
<dd>
    <i>Map[String,String] </i><i>&mdash; Default:</i> <code>{"bedtools": "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3", "picard": "quay.io/biocontainers/picard:2.20.5--0", "gatk4": "quay.io/biocontainers/gatk4:4.1.0.0--0", "biopet-scatterregions": "quay.io/biocontainers/biopet-scatterregions:0.2--0"}</code><br />
    specify which docker images should be used for running this pipeline
</dd>
<dt id="GatkVariantCalling.gatherGvcfs.intervals"><a href="#GatkVariantCalling.gatherGvcfs.intervals">GatkVariantCalling.gatherGvcfs.intervals</a></dt>
<dd>
    <i>Array[File] </i><i>&mdash; Default:</i> <code>[]</code><br />
    Bed files or interval lists describing the regions to operate on.
</dd>
<dt id="GatkVariantCalling.gatherGvcfs.javaXmx"><a href="#GatkVariantCalling.gatherGvcfs.javaXmx">GatkVariantCalling.gatherGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.gatherGvcfs.memory"><a href="#GatkVariantCalling.gatherGvcfs.memory">GatkVariantCalling.gatherGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.gatherVcfs.javaXmx"><a href="#GatkVariantCalling.gatherVcfs.javaXmx">GatkVariantCalling.gatherVcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.gatherVcfs.memory"><a href="#GatkVariantCalling.gatherVcfs.memory">GatkVariantCalling.gatherVcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.annotationGroups"><a href="#GatkVariantCalling.genotypeGvcfs.annotationGroups">GatkVariantCalling.genotypeGvcfs.annotationGroups</a></dt>
<dd>
    <i>Array[String] </i><i>&mdash; Default:</i> <code>["StandardAnnotation"]</code><br />
    Which annotation groups will be used for the annotation
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.javaXmx"><a href="#GatkVariantCalling.genotypeGvcfs.javaXmx">GatkVariantCalling.genotypeGvcfs.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"6G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.genotypeGvcfs.memory"><a href="#GatkVariantCalling.genotypeGvcfs.memory">GatkVariantCalling.genotypeGvcfs.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"18G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.mergeSingleSampleGvcf.intervals"><a href="#GatkVariantCalling.mergeSingleSampleGvcf.intervals">GatkVariantCalling.mergeSingleSampleGvcf.intervals</a></dt>
<dd>
    <i>Array[File] </i><i>&mdash; Default:</i> <code>[]</code><br />
    Bed files or interval lists describing the regions to operate on.
</dd>
<dt id="GatkVariantCalling.mergeSingleSampleGvcf.javaXmx"><a href="#GatkVariantCalling.mergeSingleSampleGvcf.javaXmx">GatkVariantCalling.mergeSingleSampleGvcf.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"12G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.mergeSingleSampleGvcf.memory"><a href="#GatkVariantCalling.mergeSingleSampleGvcf.memory">GatkVariantCalling.mergeSingleSampleGvcf.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.mergeSingleSampleVcf.javaXmx"><a href="#GatkVariantCalling.mergeSingleSampleVcf.javaXmx">GatkVariantCalling.mergeSingleSampleVcf.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.mergeSingleSampleVcf.memory"><a href="#GatkVariantCalling.mergeSingleSampleVcf.memory">GatkVariantCalling.mergeSingleSampleVcf.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.scatterAllRegions.bamFile"><a href="#GatkVariantCalling.scatterAllRegions.bamFile">GatkVariantCalling.scatterAllRegions.bamFile</a></dt>
<dd>
    <i>File? </i><br />
    Equivalent to biopet scatterregions' `--bamfile` option.
</dd>
<dt id="GatkVariantCalling.scatterAllRegions.bamIndex"><a href="#GatkVariantCalling.scatterAllRegions.bamIndex">GatkVariantCalling.scatterAllRegions.bamIndex</a></dt>
<dd>
    <i>File? </i><br />
    The index for the bamfile given through bamFile.
</dd>
<dt id="GatkVariantCalling.scatterAllRegions.javaXmx"><a href="#GatkVariantCalling.scatterAllRegions.javaXmx">GatkVariantCalling.scatterAllRegions.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.scatterAllRegions.memory"><a href="#GatkVariantCalling.scatterAllRegions.memory">GatkVariantCalling.scatterAllRegions.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.scatterAllRegions.notSplitContigs"><a href="#GatkVariantCalling.scatterAllRegions.notSplitContigs">GatkVariantCalling.scatterAllRegions.notSplitContigs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Equivalent to biopet scatterregions' `--notSplitContigs` flag.
</dd>
<dt id="GatkVariantCalling.scatterAutosomalRegions.bamFile"><a href="#GatkVariantCalling.scatterAutosomalRegions.bamFile">GatkVariantCalling.scatterAutosomalRegions.bamFile</a></dt>
<dd>
    <i>File? </i><br />
    Equivalent to biopet scatterregions' `--bamfile` option.
</dd>
<dt id="GatkVariantCalling.scatterAutosomalRegions.bamIndex"><a href="#GatkVariantCalling.scatterAutosomalRegions.bamIndex">GatkVariantCalling.scatterAutosomalRegions.bamIndex</a></dt>
<dd>
    <i>File? </i><br />
    The index for the bamfile given through bamFile.
</dd>
<dt id="GatkVariantCalling.scatterAutosomalRegions.javaXmx"><a href="#GatkVariantCalling.scatterAutosomalRegions.javaXmx">GatkVariantCalling.scatterAutosomalRegions.javaXmx</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"8G"</code><br />
    The maximum memory available to the program. Should be lower than `memory` to accommodate JVM overhead.
</dd>
<dt id="GatkVariantCalling.scatterAutosomalRegions.memory"><a href="#GatkVariantCalling.scatterAutosomalRegions.memory">GatkVariantCalling.scatterAutosomalRegions.memory</a></dt>
<dd>
    <i>String </i><i>&mdash; Default:</i> <code>"24G"</code><br />
    The amount of memory this job will use.
</dd>
<dt id="GatkVariantCalling.scatterAutosomalRegions.notSplitContigs"><a href="#GatkVariantCalling.scatterAutosomalRegions.notSplitContigs">GatkVariantCalling.scatterAutosomalRegions.notSplitContigs</a></dt>
<dd>
    <i>Boolean </i><i>&mdash; Default:</i> <code>false</code><br />
    Equivalent to biopet scatterregions' `--notSplitContigs` flag.
</dd>
<dt id="GatkVariantCalling.scatterSize"><a href="#GatkVariantCalling.scatterSize">GatkVariantCalling.scatterSize</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>scatterSizeMillions * 1000000</code><br />
    The size of the scattered regions in bases. Scattering is used to speed up certain processes. The genome will be seperated into multiple chunks (scatters) which will be processed in their own job, allowing for parallel processing. Higher values will result in a lower number of jobs. The optimal value here will depend on the available resources.
</dd>
<dt id="GatkVariantCalling.scatterSizeMillions"><a href="#GatkVariantCalling.scatterSizeMillions">GatkVariantCalling.scatterSizeMillions</a></dt>
<dd>
    <i>Int </i><i>&mdash; Default:</i> <code>1000</code><br />
    Same as scatterSize, but is multiplied by 1000000 to get scatterSize. This allows for setting larger values more easily
</dd>
</dl>
</details>




