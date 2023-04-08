rm -rf ./output

Rscript hw2_111753151.R --target bad --badthre 0.5 --input examples/method1.csv examples/method2.csv --output output/test1/output1.csv
Rscript hw2_111753151.R --target bad --badthre 0.4 --input examples/method1.csv examples/method3.csv examples/method5.csv --output output/test1/output2.csv
Rscript hw2_111753151.R --target good --badthre 0.6 --input examples/method2.csv examples/method4.csv examples/method6.csv --output output/test1/output3.csv

Rscript hw2_111753151.R --target bad --badthre 0.5 --output output/test2/output1.csv --input examples/method1.csv examples/method2.csv
Rscript hw2_111753151.R --target bad --badthre 0.4 --output output/test2/output2.csv --input examples/method1.csv examples/method3.csv examples/method5.csv
Rscript hw2_111753151.R --target good --badthre 0.6 --output output/test2/output3.csv --input examples/method2.csv examples/method4.csv examples/method6.csv


# error test
# Rscript hw2_111753151.R --target bad --badthre 0.5  --input examples/method1.csv examples/method2.csv
# Rscript hw2_111753151.R --target bad --badthre 0.5 --output output/test2/output1.csv
# Rscript hw2_111753151.R --target bad --badthre 0.5 --output output/test2/output1.csv --input examples/method1.csv examples/metho
