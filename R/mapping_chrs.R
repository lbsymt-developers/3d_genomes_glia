library(rtracklayer)
GRangesForUCSCGenome("hg38")
SeqinfoForUCSCGenome("hg38")

library(GenomicInfoDb)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
seqlengths(TxDb.Hsapiens.UCSC.hg38.knownGene)
