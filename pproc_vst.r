library(SummarizedExperiment)
library(DESeq2)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = readRDS(INFILE)
mat = assay(data)
dset = DESeqDataSetFromMatrix(mat, colData=data.frame(id=colnames(mat)), design=~1)
assay(data) = vst(dset)

saveRDS(data, file=OUTFILE)
