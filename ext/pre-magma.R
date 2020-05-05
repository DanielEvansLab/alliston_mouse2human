library(tidyverse)

#filename <- "../../data/GWAS/Biobank2-British-FracA-As-C-Gwas-SumStats.txt.gz"
filename <- "../../data/GWAS/Biobank2-British-Bmd-As-C-Gwas-SumStats.txt.gz"

format_magma_snploc <- function(filename){
  #select SNPID, chromosome, and base pair position
  require(data.table)
  if(grepl("Frac", filename)){
    dat <- fread(paste0("gunzip -c ", filename))
    snp_loc <- dat[,.(SNP, CHR, BP)]
    fwrite(snp_loc, file = "../data/snp_loc_frac.txt", sep = "\t", na = "NA", quote = F)
  } else {
    dat <- fread(paste0("gunzip -c ", filename))
    snp_loc <- dat[,.(RSID, CHR, BP)]
    setnames(snp_loc, c("SNP", "CHR", "BP"))
    fwrite(snp_loc, file = "../data/snp_loc_bmd.txt", sep = "\t", na = "NA", quote = F)
  }
}

format_magma_snploc(filename)

format_magma_pvalfile <- function(filename){
  #select SNPID, p values, and N
  require(data.table)
  if(grepl("Frac", filename)){
    dat <- fread(paste0("gunzip -c ", filename))
    pval_file <- dat[,.(SNP, P.I, N)]
    setnames(pval_file, c("SNP", "P", "N"))
    fwrite(pval_file, file = "../data/pvalfile_frac.txt", sep = "\t", na = "NA", quote = F)
  } else {
    dat <- fread(paste0("gunzip -c ", filename))
    pval_file <- dat[,.(RSID, P.NI, N)]
    setnames(pval_file, c("SNP", "P", "N") )
    fwrite(pval_file, file = "../data/pvalfile_bmd.txt", sep = "\t", na = "NA", quote = F)
  }
}

format_magma_pvalfile(filename)

#creating geneset file from multiple files
format_magma_geneset <- function(file1){
  require(data.table)
  dat <- fread(paste0("../data/aging/", file1))
  paste(c(sub(".csv", "", file1), dat$Entrez_Id), collapse = " ")
}

all.files <- list.files("../data/aging/")
result <- lapply(all.files, format_magma_geneset)
result <- do.call(rbind, result)
write.table(result, file = "../data/genesets.txt", col.names = F, row.names = F, quote = F)

