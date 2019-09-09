library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Gene expression",
                 data.type = "Isoform expression quantification",
#                 experimental.strategy = "RNA-Seq",
                 legacy = TRUE)

#TODO: map hg19 to GRCh38

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
