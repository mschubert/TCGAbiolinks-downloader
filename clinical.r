library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = GDCquery_clinic(PROJECT, type="clinical")

saveRDS(data, file=OUTFILE)
