library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery_clinic(PROJECT, type="clinical")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
