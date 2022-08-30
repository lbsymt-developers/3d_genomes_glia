get_chrCoords <- function(chr = "chr1"){
  out_dir <- file.path("data_tmp", "mcool_to_Brick_test")
  My_BrickContainer <- load_BrickContainer(project_dir = out_dir)
  library(HiCBricks)
  mt_contacts <- vroom::vroom("../tmpTOP/data/brick_export_10000_CHR1.csv")
  mt_contacts <- mt_contacts[mt_contacts$chr1==chr,]
  ranges_brick <- Brick_get_ranges(Brick = My_BrickContainer,
                                   rangekey = "Bintable", resolution = 10000)
  ranges_df <- data.frame(ranges_brick)
  ranges_df$seqnames <- as.character(ranges_df$seqnames)
  cols <- vector()
  for(i in 1:nrow(ranges_df)){
    id <- paste0(ranges_df[i,1:3], collapse = ":")
    col <- Brick_return_region_position(Brick = My_BrickContainer,
                                        region = id,
                                        resolution = 10000)
    cols <- c(cols, col)
  }
  ranges_df$col <- cols
  return(ranges_df)
}


