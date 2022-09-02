library(rtracklayer)
GRangesForUCSCGenome("hg38")
SeqinfoForUCSCGenome("hg38")

library(GenomicInfoDb)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
seqlengths(TxDb.Hsapiens.UCSC.hg38.knownGene)

library(dplyr)
ch1_astro <- vroom::vroom("../tmpTOP/cells_HiC/astrocyte/chr1chr1") %>%
  na.omit()

snps <- readr::read_csv("../tmpTOP/data/SNPs_differentDataset_uniques.csv")
snps <- snps[order(snps$seqnames),]
snps$seqnames <- as.factor(snps$seqnames)

join_files_perChr <- function(chr, cell){
  selection <- paste0(chr, "chr")
  general_path <- "../tmpTOP/cells_HiC/"
  files_path <- paste0(general_path, cell, "/")
  files_cell <- list.files(files_path)
  a <- stringr::str_detect(files_astro, "chr1chr")
  chr_select <- files_astro[a]
  df <- data.frame()
  suppressMessages(library(dplyr))
  for(i in 1:length(chr_select)){
    tmpPATH <- paste0(files_path, chr_select[i])
    tmpcsv <- suppressMessages(vroom::vroom(tmpPATH)) %>%
      na.omit() %>% filter(count > 10)
    df <- rbind(df, tmpcsv)
  }
  return(df)

}

chromosomes <- paste0("chr",1:22)
###########################
#######    HiC UNV   ######
###########################

astro <- lapply(chromosomes, join_files_perChr, cell = "astrocyte")
names(astro) <- chromosomes
save(astro, file = "../Mapping_nonconding/data/HiC_cells/astrocyte.rda")

odc <- lapply(chromosomes, join_files_perChr, cell = "odc")
names(odc) <- chromosomes
save(odc, file = "../Mapping_nonconding/data/HiC_cells/oligodendrocyte.rda")

mg <- lapply(chromosomes, join_files_perChr, cell = "mg")
names(mg) <- chromosomes
save(mg, file = "../Mapping_nonconding/data/HiC_cells/microglia.rda")

endo <- lapply(chromosomes, join_files_perChr, cell = "endo")
names(endo) <- chromosomes
save(endo, file = "../Mapping_nonconding/data/HiC_cells/endothelial.rda")

opc <- lapply(chromosomes, join_files_perChr, cell = "opc")
names(opc) <- chromosomes
save(opc, file = "../Mapping_nonconding/data/HiC_cells/OPC.rda")

l2_3 <- lapply(chromosomes, join_files_perChr, cell = "l2_3")
names(l2_3) <- chromosomes
save(l2_3, file = "../Mapping_nonconding/data/HiC_cells/L2_3.rda")

l4 <- lapply(chromosomes, join_files_perChr, cell = "l4")
names(l4) <- chromosomes
save(l4, file = "../Mapping_nonconding/data/HiC_cells/L4.rda")

l5 <- lapply(chromosomes, join_files_perChr, cell = "l5")
names(l5) <- chromosomes
save(l5, file = "../Mapping_nonconding/data/HiC_cells/L5.rda")

l6 <- lapply(chromosomes, join_files_perChr, cell = "l6")
names(l6) <- chromosomes
save(l6, file = "../Mapping_nonconding/data/HiC_cells/L6.rda")

ndnf <- lapply(chromosomes, join_files_perChr, cell = "ndnf")
names(ndnf) <- chromosomes
save(ndnf, file = "../Mapping_nonconding/data/HiC_cells/Ndnf.rda")

pvalb <- lapply(chromosomes, join_files_perChr, cell = "pvalb")
names(pvalb) <- chromosomes
save(pvalb, file = "../Mapping_nonconding/data/HiC_cells/Pvalb.rda")

sst <- lapply(chromosomes, join_files_perChr, cell = "sst")
names(sst) <- chromosomes
save(sst, file = "../Mapping_nonconding/data/HiC_cells/Sst.rda")

vip <- lapply(chromosomes, join_files_perChr, cell = "vip")
names(vip) <- chromosomes
save(vip, file = "../Mapping_nonconding/data/HiC_cells/Vip.rda")

snps_1 <- snps[snps$seqnames==1,]
