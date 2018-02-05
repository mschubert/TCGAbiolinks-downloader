library(TCGAbiolinks)
library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

project_info = getGDCprojects()
projects = unique(project_info$project_id)

query = GDCquery(project = PROJECT,
                 data.category = "DNA Methylation",
                 data.type = "Methylation Beta Value")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE)
