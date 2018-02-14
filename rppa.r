library(dplyr)

PROJECT = commandArgs(TRUE)[1]
OUTFILE = commandArgs(TRUE)[2]

tmp = tempdir()
fname = paste0(PROJECT, "-L4.zip")
url = paste0("http://tcpaportal.org/tcpa/download/", fname)

fpath = file.path(tmp, fname)
download.file(url, destfile=fpath)
unzip(fpath, exdir=tmp)

csv = sub("\\.zip$", ".csv", fpath)
data = tbl_df(read.csv(csv, stringsAsFactors=FALSE))

save(data, file=OUTFILE)
