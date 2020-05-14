# Gene-based BMD and fracture results

Gene-based genetic-association results with human BMD and fracture are provided in the interactive, searchable table.

## Description of variables in Full Table tab

+ `symbol_mouse`: NCBI mouse gene symbol.

+ `entrez_mouse`: NCBI mouse gene ID. Link opens a new tab with the NCBI Gene page.

+ `symbol_human`: NCBI human gene symbol.

+ `entrez_human`: NCBI human gene ID. Link opens a new tab with the NCBI Gene page.

+ `chr`: Chromosome location of human gene on NCBI genome assembly build 37.

+ `locus_start`: Base-pair position of start of human gene physical boundary used in MAGMA based on NCBI genome assembly build 37.

+ `locus_end`: Base-pair position of end of human gene physical boundary used in MAGMA based on NCBI genome assembly build 37.

+ `homologene_ID`: NCBI homologene ID for human-mouse homologs based on HOM_MouseHumanSequence.rpt downloaded from [here](http://www.informatics.jax.org/downloads/reports/index.html#homology)

+ `FRAC_NSNPS`: Number of SNP associations with fracture in gene region.

+ `FRAC_ZSTAT`: Test statistic (Z-score) of most significant SNP association with human bone fracture in gene region.

+ `FRAC_P`: P-value of most significant SNP association with human bone fracture in gene region.

+ `BMD_NSNPS`: Number of SNP associations with BMD in gene region.

+ `BMD_ZSTAT`: Test statistic (Z-score) of most significant SNP association with BMD in gene region.

+ `BMD_P`: P-value of most significant SNP association with BMD in gene region.

## Description of additional variables in Batch query tab

+ `FRAC_P_Bonf`: Bonferroni-corrected gene-based P-values for human bone fracture, corrected for number of genes in batch query.

+ `FRAC_P_BH`: Adjusted human bone fracture P-values using the Benjamini-Hochberg (1995) FDR procedure, corrected for number of genes in batch query.

+ `BMD_P_Bonf`: Bonferroni-corrected gene-based P-values for human BMD, corrected for number of genes in batch query. 

+ `BMD_P_BH`: Adjusted human BMD P-values using the Benjamini-Hochberg (1995) FDR procedure, corrected for number of genes in batch query.

