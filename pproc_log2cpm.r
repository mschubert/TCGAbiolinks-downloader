library(SummarizedExperiment)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

load(INFILE)
assay(data) = edgeR::cpm(assay(data), log=TRUE)

save(data, file=OUTFILE)
