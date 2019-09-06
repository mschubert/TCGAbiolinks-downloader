library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "DNA methylation",
                 data.type = "Methylation beta value",
                 legacy = TRUE,
                 platform = c("Illumina Human Methylation 450")) # we ignore 27K

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
