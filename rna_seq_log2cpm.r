library(SummarizedExperiment)
io = import('ebits/io')

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = io$load(INFILE)
assay(data) = edgeR::cpm(assay(data), log=TRUE)

save(data, file=OUTFILE)
