library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Transcriptome Profiling",
                 data.type = "Gene Expression Quantification",
                 workflow.type = "HTSeq - Counts")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
