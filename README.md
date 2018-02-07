TCGAbiolinks-downloader
=======================

This workflow is using the [TCGAbiolinks
package](http://bioconductor.org/packages/release/bioc/html/TCGAbiolinks.html)
to download data from the NCI's [Genomic Data Commons](https://docs.gdc.cancer.gov/).

All files are stored as `<cohort>.RData` in their respecitive analysis
directories.

Requirements
------------

The following software is required to run this workflow:

* A recent version of R
* The [TCGAbiolinks package](http://bioconductor.org/packages/release/bioc/html/TCGAbiolinks.html) from [Bioconductor](http://bioconductor.org/)
* GNU make

Optionally, the following R packages for post-processing:

* [edgeR](http://bioconductor.org/packages/release/bioc/html/edgeR.html) - for `log2 cpm transformation of RNA-seq reads`
* [DESeq2](http://bioconductor.org/packages/release/bioc/html/DESeq2.html) - for variance stabilizing transformation of RNA-seq reads

Downloading the data
--------------------

The are three options to download and save TCGA data:

```r
# Download everything
make

# Selection by cohort
# - see projects.txt for valid cohorts
make <cohort> # eg. 'TCGA-LUAD' for lung adenocarcinoma

# Selection by data type
# - valid types are: snv_mutect2, rna_seq_raw, cnv_segments, mirna_seq, clinical
make <data type> # eg. 'clinical' for downloading clinical data
```

Data will be stored as `RData` files (containing a `data.frame` or
`SummarizedExperiment` object) for each cohort in the respective data type
directories.


Additional documentation
------------------------

The data processing steps underlying the data being downloaded is fully
documented on the [GDC webpage](https://docs.gdc.cancer.gov/Data/Introduction/).
