library(TCGAbiolinks)
library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

query = GDCquery(project = PROJECT,
                 data.category = "Gene expression",
                 data.type = "Isoform expression quantification",
#                 experimental.strategy = "RNA-Seq",
                 legacy = TRUE)

# prevent duplicates
query$results[[1]] = query$results[[1]] %>% filter(sapply(tags, function(x) x[1]) == "unnormalized")

# also discard the ones where there are still duplicates left
# req for BRCA, PRAD, LAML, UCEC, COAD
query$results[[1]] = query$results[[1]][!duplicated(query$results[[1]]$cases),]

GDCdownload(query)
GDCprepare(query, save=TRUE, save.filename=OUTFILE, remove.files.prepared=TRUE)
