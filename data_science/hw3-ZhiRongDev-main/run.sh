rm -rf ./output

Rscript hw3_111753151.R --fold 5 --input ./data/Archaeal_tfpssm.csv --output ./output/test1.csv
Rscript hw3_111753151.R --fold 10 --input ./data/Archaeal_tfpssm.csv --output ./output/test2.csv

Rscript hw3_111753151.R --fold 4  --output ./output/test3.csv --input ./data/Archaeal_tfpssm.csv
Rscript hw3_111753151.R --fold 3  --output ./output/test4.csv --input ./data/Archaeal_tfpssm.csv
