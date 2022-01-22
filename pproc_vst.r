library(SummarizedExperiment)
library(DESeq2)

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = readRDS(INFILE)

eset = DESeqDataSet(data, design=~1)
vst = varianceStabilizingTransformation(eset)

saveRDS(vst, file=OUTFILE)
