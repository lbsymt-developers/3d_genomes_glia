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
###########################
####### CHROMOSOMA 1 ######
###########################

chr1_astro <- join_files_perChr(chr = "chr1", cell = "astrocyte")



snps_1 <- snps[snps$seqnames==1,]
