library(SummarizedExperiment)
library(biomaRt)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = readRDS(INFILE)

saveRDS(data, file=OUTFILE)
