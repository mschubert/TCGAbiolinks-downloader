library(SummarizedExperiment)
library(DESeq2)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

load(INFILE)
mat = assay(data)
dset = DESeqDataSetFromMatrix(mat, colData=data.frame(id=colnames(mat)), design=~1)
assay(data) = vst(dset)

save(data, file=OUTFILE)
