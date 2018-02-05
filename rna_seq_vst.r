library(SummarizedExperiment)
io = import('ebits/io')
rnaseq = import('ebits/process/rna-seq')

INFILE = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = io$load(INFILE)
assay(data) = rnaseq$vst(assay(data))

save(data, file=OUTFILE)
