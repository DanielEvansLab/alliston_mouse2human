# Description of mouse2human resource

## Introduction

Genome-wide profiling of mouse gene expression yields large data sets, and even after applying statistical methods to control for false discovery, researchers are often forced to sift through long lists of significant differentially expressed genes (DEGs). A major challenge to laboratory researchers using unbiased genomic approaches is making informed decisions about which novel genes to pursue further using time-and resource-intensive laboratory-based analyses. 

The mouse2human web resource provides an easy-to-use web-based tool to determine which mouse genes have relevance to human osteoporosis and bone fracture. Knowing which genes have relevance in humans will facilitate translation of experimental laboratory results to human clinical research, and also identify genes that should be prioritized for in-depth laboratory investigation. 

Genome-wide association studies (GWAS) have been performed on bone mineral density (BMD) and fracture at any site in the UK Biobank with hundreds of thousands of participants (Morris, Kemp et al. 2019). Typically, only genetic variant associations that pass multiple test correction (P-value ≤ 5x10-8) are reported in publications, but many more true positives do not reach this stringent multiple testing threshold. Furthermore, a genome-wide significance threshold is too strict when a lab researcher wants to perform a focused gene-based lookup. There are many variant associations that are not genome-wide significant, but would be significant if only a limited number of tests were examined. The full richness of GWAS results can only be utilized by accessing the full genome-wide results. 

## Results on this website

We estimated gene-based scores using full GWAS results based on 426,824 UK Biobank participants with bone mineral density estimated from quantitative heel ultrasounds (eBMD) and 53,184/373,611 fracture cases/controls (Morris, Kemp et al. 2019) available for download from the [GEFOS](http://www.gefos.org/) website [here](http://www.gefos.org/?q=content/data-release-2018). We used MAGMA to estimate gene scores based on the most significant variant association within a gene region (50 kb upstream and downstream of each gene). The gene-based empirical P-value was estimated by MAGMA with an adaptive permutation method, which adjusts for the number of variants and linkage disequilibrium (LD) in the gene region (de Leeuw, Mooij et al. 2015). 

Homology between human and mouse genes was based on NCBI's homologene resource. Homologene IDs for human-mouse homologs reported on this website were from the file HOM_MouseHumanSequence.rpt downloaded on 2020-04-28 from [here](http://www.informatics.jax.org/downloads/reports/index.html#homology)

Gene-based results for all genes are provided in an interactive searchable table (Full table tab). Users can search the table based on human or mouse gene symbols or NCBI IDs. Clicking on NCBI gene IDs takes users to the corresponding NCBI Gene page.

Batch queries for multiple genes can be performed by first selecting whether the human or mouse gene symbols will be provided, followed by entering or pasting gene symbols into the text box. One gene symbol per line. Upon clicking on the "Execute batch query" button, the batch query results can be found in the Batch query tab. Multiple testing correction for the number of batch query genes is provided using the Bonferroni method to control the family-wise error rate and the Benjamini-Hochberg (1995) procedure to control the false-discovery rate.

Batch query results can be downloaded using the csv or excel buttons at the bottom of the batch query result table, or can be copied to the clipboard using the copy button at the bottom of the result table.

The complete table of gene-based scores can be downloaded using the `Download all data` button in the Download tab. 

## References

1. Morris, J.A., Kemp, J.P., Youlten, S.E. et al. An atlas of genetic influences on osteoporosis in humans and mice. Nat Genet 51, 258–266 (2019). https://doi.org/10.1038/s41588-018-0302-x

2. de Leeuw CA, Mooij JM, Heskes T, Posthuma D (2015) MAGMA: Generalized Gene-Set Analysis of GWAS Data. PLoS Comput Biol 11(4): e1004219. https://doi.org/10.1371/journal.pcbi.1004219

## Research groups and funding

This resource is a collaborative effort between Serra Kaya and Tamara Alliston at UCSF and Daniel Evans at UCSF/CPMCRI. This resource was supported by the UCSF Core Center for Musculoskeletal Biology and Medicine (CCMBM) of the National Institute of Health's National Institute of Arthritis and Musculoskeletal and Skin Diseases (NIAMS) under the award number P30AR075055 and the National Institute of Dental and Craniofacial Research (NIDCR) under the award number R01DE019284.