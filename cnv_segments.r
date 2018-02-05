library(TCGAbiolinks)
library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

project_info = getGDCprojects()
projects = unique(project_info$project_id)

query = GDCquery(project = PROJECT,
                 data.category = "Copy Number Variation",
                 data.type = "Copy Number Segment")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
