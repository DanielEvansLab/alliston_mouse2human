# Gene-based BMD and fracture results

Gene-based genetic-association results with human BMD and fracture are provided in the interactive, searchable table.

## Description of variables in Full Table tab

+ `entrez_geneID_human`: NCBI human gene ID. Link opens a new tab with the NCBI Gene page.

+ `symbol_human`: NCBI human gene symbol.

+ `chr_build37`: Chromosome location of human gene on genome assembly build 37.

+ `start_build37`: Base-pair position of start of human gene physical boundary used in MAGMA based on genome assembly build 37.

+ `stop_build37`: Base-pair position of end of human gene physical boundary used in MAGMA based on genome assembly build 37.

+ `homologene_ID`: NCBI homologene ID for human-mouse homologs based on HOM_MouseHumanSequence.rpt downloaded from [here](http://www.informatics.jax.org/downloads/reports/index.html#homology)

+ `entrez_geneID_mouse`: NCBI mouse gene ID. Link opens a new tab with the NCBI Gene page.

+ `symbol_mouse`: NCBI mouse gene symbol.

+ `NSNPS_FRAC`: Number of SNP associations with fracture in gene region.

+ `ZSTAT_FRAC`: Test statistic (Z-score) of most significant SNP association with human bone fracture in gene region.

+ `P_FRAC`: P-value of most significant SNP association with human bone fracture in gene region.

+ `NSNPS_BMD`: Number of SNP associations with BMD in gene region.

+ `ZSTAT_BMD`: Test statistic (Z-score) of most significant SNP association with BMD in gene region.

+ `P_BMD`: P-value of most significant SNP association with BMD in gene region.

## Description of additional variables in Batch query tab

+ `P_FRAC_Bonf`: Bonferroni-corrected gene-based P-values for human bone fracture, corrected for number of genes in batch query.

+ `P_BMD_Bonf`: Bonferroni-corrected gene-based P-values for human BMD, corrected for number of genes in batch query. 

+ `P_FRAC_BH`: Adjusted human bone fracture P-values using the Benjamini-Hochberg (1995) FDR procedure, corrected for number of genes in batch query.

+ `P_BMD_BH`: Adjusted human BMD P-values using the Benjamini-Hochberg (1995) FDR procedure, corrected for number of genes in batch query.

