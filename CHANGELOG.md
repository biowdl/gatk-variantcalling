Changelog
==========

<!--

Newest changes should be on top.

This document is user facing. Please word the changes in such a way
that users understand how the changes affect the new version.
-->
version 2.0.0
-----------------
+ Add a scatterSizeMillions parameter to make it easier to set larger scatter 
  sizes.
+ Multisample VCFs are only produced when joint genotyping is used.
+ Add option to output single-sample GVCFs
+ Make Joint Genotyping by GenotypeGVCF an optional step, so the pipeline can 
  be used for RNA variant calling.
+ Make using a dbsnp VCF file optional.
+ Added gender-aware capabilities to the pipeline. This has changed the input
  format.
+ Added inputs overview to the docs.
+ Added parameter_mets.
+ Added wdl-aid to linting.
+ Added miniwdl to linting.

version 1.0.0
---------------------------
+ Combine the bam-to-gvcf and joint-genotyping pipeline into one.
