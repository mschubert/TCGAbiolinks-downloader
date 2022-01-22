library(SummarizedExperiment)
library(edgeR)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = readRDS(INFILE)
names(assays(data)) = "counts"
dset = SE2DGEList(data)
norm = calcNormFactors(dset, method="TMM")
assay(data) = cpm(norm)

saveRDS(data, file=OUTFILE)
