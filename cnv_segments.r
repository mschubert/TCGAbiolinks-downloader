library(TCGAbiolinks)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Copy Number Variation",
                 data.type = "Copy Number Segment")

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)

#TODO: remove this when the data is fixed
if (PROJECT == "TCGA-CESC" && data[287152,'End']-1.4 < .Machine$double.eps) {
    load(OUTFILE)
    data[287152,'End'] = 14000000
    save(data, file=OUTFILE)
}
