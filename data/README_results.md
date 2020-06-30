# Trait listing
To do: include rendering of Rmd to display table

+ `longevity 90` = Human longevity association with 90th percentile lifespan.

+ `longevity 99` = Human longevity association with 99th percentile lifespan.

# Description of variables
+ `trait` = S-PrediXcan association with which trait/outcome
+ `gene` = Ensembl gene ID
+ `gene_name` = Human gene symbol
+ `zscore` = S-PrediXcan's effect size divided by the standard error for the association between the tissue-specific predicted gene expression and the trait
+ `effect_size` = S-PrediXcan's effect size for the association between the tissue-specific predicted gene expression and the trait
+ `pvalue` = P-value of the S-PrediXcan association between tissue-specific predicted gene expression and the trait
+ `var_g` = Variance of the gene expression
+ `pred_perf_r2` = R2 of tissue model's correlation to gene's measured transcriptome (prediction performance)
+ `pred_perf_pval` = P-value of tissue model's correlation to gene's measured transcriptome (prediction performance)
+ `n_snps_used` = Number of snps from GWAS that were used in S-PrediXcan analysis
+ `n_snps_in_cov` = Number of snps in the covariance matrix
+ `n_snps_in_model` = Number of snps in the tissue-specific PredictDB model
+ `tissue` = GTEx tissue used for prediction
+ `category` = Trait category
+ `n` = Sample size of the GWAS meta-analysis used in each S-PrediXcan trait association

