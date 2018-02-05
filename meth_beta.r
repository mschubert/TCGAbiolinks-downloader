library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "DNA Methylation",
                 platform = c("Illumina Human Methylation 450"))
#                 data.type = "Methylation Beta Value")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
