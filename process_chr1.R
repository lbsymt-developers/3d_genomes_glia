library(HiCBricks)
library(dplyr)

mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_2doINTENTO.tsv")
mt_contacts <- mt_contacts %>% filter(chr1 == "chr1") 

readr::write_csv(mt_contacts, "../tmpTOP/data/brick_export_10000_CHR1.csv")

