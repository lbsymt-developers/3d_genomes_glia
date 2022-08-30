library(dplyr)
mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_2doINTENTO.tsv")
mt_contacts <- na.omit(mt_contacts)
snps_contacts <- readr::read_csv("../tmpTOP/data/prueba_PROCESAMIENTO_SNPs.csv")
# mt_contacs <- mt_contacts[mt_contacts$row_coord %in% snps_contacts$col,]

library(purrr)

get_cols <- function(row_snp){
  a <- mt_contacts[mt_contacts$row_coord==row_snp,]
  b <- a[a$value>= 0.003756,]
  b <- b[-1,]
  b <- b[which.max(b$value), ]
}

preliminar_result <- purrr::map(snps_contacts$col, safely(get_cols))
select_true <- transpose(preliminar_result)
results <- select_true[["result"]]

results_df <- do.call(rbind, results)

snps_data <- dplyr::right_join(snps_contacts, results_df,
                               by = c("col" = "row_coord"))
snps_data <- snps_data[!duplicated(snps_data$rsID),]


