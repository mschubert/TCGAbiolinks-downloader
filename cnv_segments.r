library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Copy Number Variation",
                 data.type = "Copy Number Segment")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
