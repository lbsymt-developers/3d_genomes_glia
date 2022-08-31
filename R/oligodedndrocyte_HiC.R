library(HiCBricks)
mcool_path <- "../tmpTOP/data_raw/Human_cluster_mcool/ODC_all_brain.txt_1kb_contacts.mcool"
Brick_list_mcool_normalisations()
Brick_mcool_normalisation_exists(mcool = mcool_path,
                                 norm_factor = "VC_SQRT",
                                 resolution = 10000)

out_dir <- file.path("data_tmp", "mcool_to_Brick_ODC")
dir.create(out_dir)
Create_many_Bricks_from_mcool(output_directory = out_dir,
                              file_prefix = "mcool_to_Brick_ODC",
                              mcool = mcool_path,
                              resolution = 10000,
                              experiment_name = "Testing mcool creation",
                              remove_existing = TRUE)
My_BrickContainer <- load_BrickContainer(project_dir = out_dir)
Brick_load_data_from_mcool(Brick = My_BrickContainer,
                           mcool = mcool_path,
                           resolution = 10000,
                           cooler_read_limit = 10000000,
                           matrix_chunk = 2000,
                           remove_prior = TRUE,
                           norm_factor = "Iterative-Correction")

BrickContainer_dir <- file.path("data_tmp", "mcool_to_Brick_ODC")
My_BrickContainer <- load_BrickContainer(project_dir = BrickContainer_dir)

Brick_export_to_sparse(Brick = My_BrickContainer,
                       out_file="../tmpTOP/data/brick_export_10000_oligodendrocyte.tsv",
                       remove_file=TRUE,
                       resolution=10000,
                       sep="\t")

load("functions_toProcess.RData")

snps <- readr::read_csv("../tmpTOP/data/SNPs_differentDataset_uniques.csv")
prueba_con <- get_chrCoords(snps = snps)
readr::write_csv(prueba_con, "../tmpTOP/data/oligodendrocyte_PROCESAMIENTO_SNPs.csv")


library(dplyr)
mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_oligodendrocyte.tsv")
mt_contacts <- na.omit(mt_contacts)
snps_contacts <- readr::read_csv("../tmpTOP/data/oligodendrocyte_PROCESAMIENTO_SNPs.csv")
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
readr::write_csv(snps_data, "../tmpTOP/data/oligodendrocyte_SNPs.csv")
