library(TCGAbiolinks)
library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Gene expression",
                 data.type = "Exon quantification",
                 experimental.strategy = "RNA-Seq",
                 legacy = TRUE)

# only use RNAseq v2, otherwise error with duplicated samples
query$results[[1]] = query$results[[1]] %>% filter(sapply(tags, function(x) x[2]) == "v2")

## also discard the ones where there are still duplicates left
#query$results[[1]] = query$results[[1]][!duplicated(query$results[[1]]),]

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
