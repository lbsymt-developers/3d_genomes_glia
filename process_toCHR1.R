get_chrCoords <- function(snps){
  suppressMessages(library(HiCBricks))
  suppressMessages(library(GenomicRanges))
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
  out_dir <- file.path("data_tmp", "mcool_to_Brick_test")
  My_BrickContainer <- load_BrickContainer(project_dir = out_dir)
  # mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_2doINTENTO.tsv")
  # Overlap GRanges with SNPs
  ranges_snps <- GRanges(seqnames = snps$seqnames,
                         IRanges(start = snps$pos,
                                 end = snps$pos),
                         rsID = snps$RefSNP_id)

  chrs <- as.character(unique(paste0("chr",GenomeInfoDb::seqnames(ranges_snps))))
  GenomeInfoDb::seqlevels(ranges_snps) <- chrs
  # mt_contacts <- mt_contacts[mt_contacts$chr1==chr,]
  ranges_brick <- Brick_get_ranges(Brick = My_BrickContainer,
                                   rangekey = "Bintable",
                                   resolution = 10000)
  # Overlap credible SNPs with contact regions.
  olap <- IRanges::findOverlaps(ranges_brick, ranges_snps)
  credcontact <- ranges_brick[S4Vectors::queryHits(olap)]
  mcols(credcontact) <- cbind(mcols(credcontact),
                               mcols(ranges_snps[S4Vectors::subjectHits(olap)]))

  ranges_df <- data.frame(credcontact)
  ranges_df$seqnames <- as.character(ranges_df$seqnames)

  parallel::detectCores()
  n.cores <- parallel::detectCores() - 2
  #create the cluster
  my.cluster <- parallel::makeCluster(
    n.cores,
    type = "PSOCK"
  )
  doParallel::registerDoParallel(cl = my.cluster)
  # foreach::getDoParRegistered()
  # foreach::getDoParWorkers()
  #check cluster definition (optional)
  print(my.cluster)
  cols <- foreach(i = 1:nrow(ranges_df),
                  .combine = 'c') %dopar% {
    # print(i)
    id <- paste0(ranges_df[i,1:3], collapse = ":")
    HiCBricks::Brick_return_region_position(Brick = My_BrickContainer,
                                        region = id,
                                        resolution = 10000)
                  }
  parallel::stopCluster(cl = my.cluster)
  ranges_df$col <- cols
  message("The process it's done")
  return(ranges_df)
}


snps <- readr::read_csv("../tmpTOP/data/SNPs_differentDataset_uniques.csv")
prueba_con <- get_chrCoords(snps = snps)
readr::write_csv(prueba_con, "../tmpTOP/data/prueba_PROCESAMIENTO_SNPs.csv")


# list.of.packages <- c(
#   "foreach",
#   "doParallel",
#   "ranger",
#   "palmerpenguins",
#   "tidyverse",
#   "kableExtra"
# )
#
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
#
# if(length(new.packages) > 0){
#   install.packages(new.packages, dep=TRUE)
# }
#
# for(package.i in list.of.packages){
#   suppressPackageStartupMessages(
#     library(
#       package.i,
#       character.only = TRUE
#     )
#   )
# }

mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_2doINTENTO.tsv")
mt_contacts <- mt_contacts[mt_contacts$chr1==chr,]

