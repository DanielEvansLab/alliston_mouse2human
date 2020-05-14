#format BMD and fracture gene-based results for web-app

library(tidyverse)
setwd("~/work/alliston/mouse2human_pre/")
bmd <- read_table("data/bmd.genes.out", 
                  col_types = cols(GENE = col_integer(), 
                                   CHR = col_character(),
                                   START = col_integer(), 
                                   STOP = col_integer(),
                                   NSNPS = col_integer(),
                                   NPARAM = col_integer(),
                                   N = col_integer(),
                                   ZSTAT = col_double(),
                                   P = col_double()))
frac <- read_table("data/frac.genes.out", 
                   col_types = cols(GENE = col_integer(), 
                                    CHR = col_character(),
                                    START = col_integer(), 
                                    STOP = col_integer(),
                                    NSNPS = col_integer(),
                                    NPARAM = col_integer(),
                                    N = col_integer(),
                                    ZSTAT = col_double(),
                                    P = col_double()))

frac <- frac %>%
  select(GENE, CHR, START, STOP, NSNPS, ZSTAT, P) %>%
  rename(entrez_geneID_human = GENE, chr_build37 = CHR, start_build37 = START,
         stop_build37 = STOP, NSNPS_FRAC = NSNPS, ZSTAT_FRAC = ZSTAT, P_FRAC = P)

bmd <- bmd %>%
  select(GENE, CHR, START, STOP, NSNPS, ZSTAT, P) %>%
  rename(entrez_geneID_human = GENE, CHR_BMD = CHR, START_BMD = START, STOP_BMD = STOP, 
         NSNPS_BMD = NSNPS, ZSTAT_BMD = ZSTAT, P_BMD = P)

gene_dat <- full_join(frac, bmd, by = "entrez_geneID_human")

gene_dat %>%
  filter(is.na(ZSTAT_FRAC)) %>%
  summarize(n()) # 5 BMD genes without frac results
gene_dat %>%
  filter(is.na(ZSTAT_BMD)) %>%
  summarize(n()) # 6 FRAC genes without BMD results
gene_dat <- gene_dat %>%
  mutate(chr_build37 = ifelse(is.na(chr_build37), CHR_BMD, chr_build37),
         start_build37 = ifelse(is.na(start_build37), START_BMD, start_build37),
         stop_build37 = ifelse(is.na(stop_build37), STOP_BMD, stop_build37)
         )

gene_dat %>%
  filter(is.na(chr_build37)) %>%
  summarize(n()) 

drop_cols <- c("CHR_BMD", "START_BMD", "STOP_BMD")
gene_dat <- gene_dat %>%
  select(-one_of(drop_cols))

map_int(gene_dat, function(x) sum(is.na(x)))

gene_dat %>%
  filter(duplicated(entrez_geneID_human)) %>%
  summarise(n()) #no duplicated gene ids. Good.

# Mouse-human homology
# http://www.informatics.jax.org/downloads/reports/index.html#homology
# File HOM_MouseHumanSequence.rpt
# Accessed 2020-04-28
hom <- read_delim("data/HOM_MouseHumanSequence.rpt", 
                  delim = "\t", 
                  skip = 1,
                  col_names = c("homologene_ID",
                                "organism_name",
                                "NCBI_taxon_ID",
                                "symbol",
                                "entrez_gene_ID",
                                "mouse_MGI_ID",
                                "HGNC_ID",
                                "OMIM_gene_ID",
                                "genetic_location",
                                "genomic_coordinates",
                                "nuc_refseq_IDs",
                                "protein_refseq_IDs",
                                "swissprot_IDs"
                  )
                  )


hom %>%
  select(NCBI_taxon_ID) %>%
  table()

#Create separate human and mouse tables
hom_9606 <- hom %>%
  filter(NCBI_taxon_ID == 9606)
hom_10090 <- hom %>%
  filter(NCBI_taxon_ID == 10090)

#some homologene IDs with up to 19 genes. Most with only 1.
hom_9606 %>%
  group_by(homologene_ID) %>%
  tally() %>%
  select(n) %>%
  table()
hom_9606 %>%
  group_by(homologene_ID) %>%
  tally() %>%
  filter(n == 19)
hom_9606 %>%
  filter(homologene_ID == 133053) %>%
  pull(symbol)

hom_9606 <- hom_9606 %>%
  select(entrez_gene_ID, homologene_ID, symbol) %>%
  rename(entrez_geneID_human = entrez_gene_ID, symbol_human = symbol)

gene_dat <- inner_join(gene_dat, hom_9606, by = "entrez_geneID_human")
gene_dat %>%
  filter(is.na(homologene_ID)) %>%
  summarize(n()) # 0 with missing homologene IDs

gene_dat %>%
  group_by(homologene_ID) %>%
  tally() %>%
  select(n) %>%
  table()

gene_dat %>%
  group_by(homologene_ID) %>%
  tally() %>%
  filter(n == 8)
test <- gene_dat %>%
  filter(homologene_ID == 48022) 

hom_10090 <- hom_10090 %>%
  select(entrez_gene_ID, homologene_ID, symbol) %>%
  rename(entrez_geneID_mouse = entrez_gene_ID, symbol_mouse = symbol)

gene_dat <- inner_join(gene_dat, hom_10090, by = "homologene_ID")
gene_dat %>%
  filter(is.na(homologene_ID)) %>%
  summarize(n()) 
gene_dat %>%
  group_by(homologene_ID) %>%
  tally() %>%
  select(n) %>%
  table()

gene_dat <- gene_dat %>%
  select(symbol_mouse, entrez_geneID_mouse, symbol_human, entrez_geneID_human, 
         chr_build37, start_build37, stop_build37, homologene_ID, 
         NSNPS_FRAC, ZSTAT_FRAC, P_FRAC, 
         NSNPS_BMD, ZSTAT_BMD, P_BMD) %>%
  rename(chr = chr_build37, locus_start = start_build37, locus_end = stop_build37,
         entrez_mouse = entrez_geneID_mouse, entrez_human = entrez_geneID_human,
         FRAC_NSNPS = NSNPS_FRAC, FRAC_ZSTAT = ZSTAT_FRAC, FRAC_P = P_FRAC,
         BMD_NSNPS = NSNPS_BMD, BMD_ZSTAT = ZSTAT_BMD, BMD_P = P_BMD)

gene_dat[["entrez_human"]] <- gsub("(.*)", "<a href='https://www.ncbi.nlm.nih.gov/gene/?term=\\1' target='_blank'>\\1</a>", gene_dat[["entrez_human"]])
gene_dat[["entrez_mouse"]] <- gsub("(.*)", "<a href='https://www.ncbi.nlm.nih.gov/gene/?term=\\1' target='_blank'>\\1</a>", gene_dat[["entrez_mouse"]])
gene_dat[["homologene_ID"]] <- gsub("(.*)", "<a href='https://www.ncbi.nlm.nih.gov/homologene/?term=\\1' target='_blank'>\\1</a>", gene_dat[["homologene_ID"]])

write_rds(gene_dat, path = "out/gene_dat.rds")


