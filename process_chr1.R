library(dplyr)
mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_2doINTENTO.tsv")
mt_contacts <- na.omit(mt_contacts)
snps_contacts <- readr::read_csv("../tmpTOP/data/prueba_PROCESAMIENTO_SNPs.csv")
# mt_contacs <- mt_contacts[mt_contacts$row_coord %in% snps_contacts$col,]

list.of.packages <- c(
  "foreach",
  "doParallel"
)
for(package.i in list.of.packages){
  suppressPackageStartupMessages(
    library(
      package.i,
      character.only = TRUE
    )
  )
}
parallel::detectCores()
n.cores <- parallel::detectCores() - 3
#create the cluster
my.cluster <- parallel::makeCluster(
  n.cores,
  type = "PSOCK"
)

doParallel::registerDoParallel(cl = my.cluster)
print(my.cluster)
# values <- vector()
pos <- unique(snps_contacts$col)

values <- foreach(i = 1:length(pos),
                .combine = 'c') %dopar% {
  a <- mt_contacts[mt_contacts$row_coord==snps_contacts$col[i],]
  b <- a[a$value>= 0.003756,]
  b <- b[-1,]
  nombre <- b$row_coord[1]
  b <- b[which.max(b$value), ]$col_coord
  names(b) <- nombre
  # values <- c(values, b$col_coord = b$value)
  # rows <- c(rows, b$col_coord)
}

parallel::stopCluster(cl = my.cluster)

snps_contacts$coord2 <- values
readr::write_csv(snps_contacts, "../tmpTOP/data/snps_coords.csv")

# a <- mt_contacts[mt_contacts$row_coord==snps_contacts$col[1],]
# a <- a[-1,]
# summary(a)
#
# # Se usa la media de todos los valores de correlación
# b <- a[a$value>= 0.003756,]
# readr::write_csv(mt_contacts, "../tmpTOP/data/SNPs_colrow_value.csv")
#
# snp_row <- vroom::vroom("../tmpTOP/data/SNPs_colrow_value.csv")



