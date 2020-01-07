Reference fasta file in this directory.

- Chromosome 1 -> from [../reference.fasta](../reference.fasta).
- Chromosome X (GRCh38.p13) from https://www.ncbi.nlm.nih.gov/nuccore/NC_000023.11
- Chromosome Y (GRCh38.p13) from https://www.ncbi.nlm.nih.gov/nuccore/568815574/

The first pseudoautosomal region for both chromosome X and chromosome Y starts
at position 10,001 and ends at 2,781,479. For both chromosome X and Chromosome 
Y, positions 2,776,479 until position 2,786,478 were taken using 
`extract_regions.py`. ChrX and chrY in the test data therefore contain both 
part of the PAR and non-PAR regions.


