# Falta obtener las coordenadas de cada GRanges para la matriz de contactos.
library(HiCBricks)
source("R/backend_functions.R")
source("R/config_functions.R")
source("R/hdf_functions.R")

out_dir <- file.path("data_tmp", "mcool_to_Brick_test")
My_BrickContainer <- load_BrickContainer(project_dir = out_dir)

bintable <- Brick_get_bintable(My_BrickContainer, resolution = 100000)
require(GenomicRanges)

df1 <- data.frame(seqnames=seqnames(bintable),
                start(bintable)-1,
                ends=end(bintable),
                names=c(rep(".",length(bintable))),
                scores=c(rep(".", length(bintable))),
                strands=strand(bintable))

# save the bintable as a bed file
write.table(df1,
            file="bintable.bed",
            quote=FALSE,
            row.names=FALSE,
            col.names=FALSE,
            sep="\t")

BrickContainer_dir <- file.path("data_tmp", "mcool_to_Brick_test")
My_BrickContainer <- load_BrickContainer(project_dir = BrickContainer_dir)

Brick_list_rangekeys(Brick = My_BrickContainer, resolution = 100000)
Brick_get_bintable(My_BrickContainer, resolution = 100000)
Brick_get_ranges(Brick = My_BrickContainer,
                 rangekey = "Bintable", resolution = 100000)
Brick_get_ranges(Brick = My_BrickContainer,
                 rangekey = "Bintable",
                 chr = "chr3",
                 resolution = 100000)

# Identifying matrix row/col using ranges operations
Brick_return_region_position(Brick = My_BrickContainer,
                             region = "chr3:120000:19800000",
                             resolution = 100000)

Brick_fetch_range_index(Brick = My_BrickContainer,
                        chr = "chr3",
                        start = 5000000,
                        end = 10000000, resolution = 100000)

# Retrieving points separated by a certain distance
Values <- Brick_get_values_by_distance(Brick = My_BrickContainer,
                                       chr = "chr1",
                                       distance = 2000,
                                       resolution = 100000)
Failsafe_median_log10 <- function(x){
  x[is.nan(x) | is.infinite(x) | is.na(x)] <- 0
  return(median(log10(x+1)))
}

# Retrieving subsets of a matrix
Sub_matrix <- Brick_get_matrix_within_coords(Brick = My_BrickContainer,
                                             x_coords="chr2:50000:10000000",
                                             force = TRUE,
                                             resolution = 100000,
                                             y_coords = "chr2:50000:10000000")

Coordinate <- c("chr3:1:100000","chr3:100001:200000")
Test_Run <- Brick_fetch_row_vector(Brick = My_BrickContainer,
                                   chr1 = "chr3",
                                   chr2 = "chr3",
                                   by = "ranges",
                                   resolution = 100000,
                                   vector = Coordinate)

Test_Run <- Brick_fetch_row_vector(Brick = My_BrickContainer,
                                   chr1 = "chr3",
                                   chr2 = "chr3",
                                   by = "position",
                                   resolution = 100000,
                                   vector = Coordinate)
