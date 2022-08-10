# Falta obtener las coordenadas de cada GRanges para la matriz de contactos.
library(HiCBricks)

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
