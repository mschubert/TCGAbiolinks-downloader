library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

data = GDCquery_Maf(tumor = sub("^TCGA-", "", PROJECT), pipelines="mutect2")

save(data, file=OUTFILE)
