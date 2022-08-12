library(HiCBricks)
mcool_path <- "../tmpTOP/data_raw/Astro_all_brain.txt_1kb_contacts.mcool"
out_dir <- file.path("data_tmp", "mcool_to_Brick_test")
HiCBricks::Create_many_Bricks_from_mcool(output_directory = out_dir,
                              file_prefix = "mcool_to_Brick_test",
                              mcool = mcool_path,
                              resolution = 1000,
                              experiment_name = "Testing mcool creation",
                              remove_existing = TRUE)

My_BrickContainer <- HiCBricks::load_BrickContainer(project_dir = out_dir)
# print(My_BrickContainer)
HiCBricks::Brick_load_data_from_mcool(Brick = My_BrickContainer,
                           mcool = mcool_path,
                           resolution = 1000,
                           cooler_read_limit = 10000000,
                           matrix_chunk = 2000,
                           remove_prior = TRUE,
                           norm_factor = "Iterative-Correction")

My_BrickContainer <- HiCBricks::load_BrickContainer(project_dir = out_dir)
HiCBricks::Brick_export_to_sparse(Brick = My_BrickContainer,
                        out_file="../tmpTOP/data/brick_export_mil.tsv",
                        remove_file=TRUE,
                        resolution=1000,
                        sep="\t")
