import cooler
import pandas as pd
import os.path

# Cargamos el archivo .cool
c = cooler.Cooler('../tmpTOP/data_raw/Human_cluster_mcool/ODC_all_brain.txt_1kb_contacts.mcool::resolutions/10000')

# Para balancear los datos
#c = cooler.balance_cooler(c)

# Hacemos una lista de los cromosomas
chrs = ["chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8","chr9",
"chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21", "chr22"]

for x in chrs:
             for y in chrs:
                 data = c.matrix(balance=False, as_pixels=True, join=True).fetch(x,y)
                 paths = '../tmpTOP/cells_HiC/odc/'
                 termination = x+y
                 paths_1 = os.path.join(paths, termination)
                 data.to_csv(paths_1, index = False, header = True)
                 print("Matriz: %s con %s" %(x,y))

