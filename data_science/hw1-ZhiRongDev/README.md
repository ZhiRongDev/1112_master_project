# Familiar with R basics & submit homework on github

#### Name: 程至榮
#### Student ID: 111753151

## Description
* Your R code should output and round the set name with maximum value of weight and height.
* You should implement the command parser by yourself without using any library.

### cmd
```R
Rscript hw1_yourID.R --input input1.csv --output output1.csv

Rscript hw1_yourID.R --output output1.csv --input input1.csv
```

### Read an input file

Input data will have other numeric & category columns besides weight and height.

#### examples: `input1.csv`
| persons | weight | height | gender |
| --- | --- | --- | --- |
| person1 | 92.24459 | 182.0007 | F |
| person2 | 79.88506 | 199.0311 | F |
| person3 | 65.59031 | 180.8477 | F |
| … | … | … | … |
| person25 | 80.16016 | 196.6961 | M |
| person26 | 87.0112 | 174.8087 | F |

### Output a summary file

Please follow the same format of the output1.csv, i.e., round number into two digitals

#### examples: `output1.csv`
| set | weight | height |
| --- | --- | --- |
| input1 | 99.76 | 199.03 |

### Code for reference
```R
# Simple example of extracting input args
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("USAGE: Rscript hw1_exam.R input", call.=FALSE)
} else if (length(args)==1) {
  i_f <- args[1] 
}
print(i_f)
```
## Score

### 10 testing data (90%)

```R
Rscript hw1_5566.R --input hw1/data/test.1.csv --output hw1/eval/test1/hw1_001.csv
Rscript hw1_5566.R --output hw1/eval/test2/hw1_002.csv --input hw1/data/test.2.csv
```
Correct answer gets 9 points of each testing data.

### Bonus (10%)

- Output format without “: 3 points
- Concise file name without path: 3 points
- Concise file name without .csv extension: 4 points

### Penalty: -2 points of each problem

- Can not detect missing --input/--ouptut flag
- Arguments order cannot change
- Wrong file name
- Wrong column name
- Not round number to 2 digitals

## Note
- **Please use R version above 4**
- Please do not set working directory(setwd) in a fixed folder. For example,
```R
d <- read.csv("D://DataScience/hw1/example/output1.csv")
```
- **execution time: 1 hour maximum**
