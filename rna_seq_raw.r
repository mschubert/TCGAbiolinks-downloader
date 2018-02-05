library(TCGAbiolinks)
library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

project_info = getGDCprojects()
projects = unique(project_info$project_id)

query = GDCquery(project = PROJECT,
                 data.category = "Transcriptome Profiling",
                 data.type = "Gene Expression Quantification",
                 workflow.type = "HTSeq - Counts")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
