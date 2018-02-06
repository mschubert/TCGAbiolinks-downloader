library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery_clinic(PROJECT, type="clinical")

save(query, file=OUTFILE)
