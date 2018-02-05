library(TCGAbiolinks)

OUTFILE = commandArgs(TRUE)[1]
if (is.na(OUTFILE)) OUTFILE = "projects.txt"

project_info = getGDCprojects()
projects = unique(project_info$project_id)

use = grep("TCGA-", projects, value=TRUE)

write.table(use, file=OUTFILE, quote=FALSE, col.names=FALSE, row.names=FALSE)
