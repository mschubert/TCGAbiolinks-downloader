grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))
HPC = #srun --ntasks=1 --cpus-per-task=1 --time=50:00:00 --partition=regular --mem=30G

# List all projects and data types
# use 'make print-VARIABLE' to inspect
PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.rds)
DTYPES = snv_mutect2 rna_seq_raw cnv_segments mirna_seq clinical clinicalsample \
		 rppa rna_isoform_raw meth_beta rna_exon_raw wgs_segments \
		 rna_seq_vst rna_seq_tmm
EXCLUDE = rppa/TCGA-LAML.rds
DFILES = $(filter-out $(EXCLUDE), $(call grid,$(DTYPES),$(PFILES)))
ALL = $(DFILES) \
	  $(PFILES:%=rna_seq_tmm/%) $(PFILES:%=rna_seq_vst/%) \
	  $(PFILES:%=rna_isoform_tmm/%) $(PFILES:%=rna_isoform_vst/%)

.PHONY: all
all: $(ALL)

# Rule to print variables
# for instance, use as 'make print-PROJECTS'
print-%:
	@echo '$*=$($*)'

define _tgt
.PHONY: $(1)
$(1): $(shell echo "$(ALL)" | tr ' ' '\n' | grep $(1))
endef
$(foreach _, $(PROJECTS), $(eval $(call _tgt,$_)))
$(foreach _, $(DTYPES), $(eval $(call _tgt,$_)))

# Run a specific post-processing workflow
# for instance, use 'make rna_seq_tmm' to create TMM files for all TCGA projects
define _pproc
$(PFILES:%=$(2)/%): $(2)/%.rds: pproc_$(3).r $(1)/%.rds
	@mkdir -p $$(dir $$@)
	$(HPC) Rscript $$^ $$@
endef
$(eval $(call _pproc,rna_seq_raw,rna_seq_vst,vst))
$(eval $(call _pproc,rna_seq_raw,rna_seq_tmm,tmm))
$(eval $(call _pproc,rna_isoform_raw,rna_isoform_vst,vst))
$(eval $(call _pproc,rna_isoform_raw,rna_isoform_tmm,tmm))

# Creates project-specific rules to generate all data
# for instance, use 'make TCGA-ACC' to make data objects for ACC
define _proj
%/$(1).rds: %.r
	@mkdir -p $$(dir $$@)
	Rscript $$^ $(1) $$@
endef
$(foreach _, $(PROJECTS), $(eval $(call _proj,$_)))

projects.txt: projects.r
	Rscript $^ $@

blacklist.tsv:
	wget -N http://gdac.broadinstitute.org/runs/sampleReports/latest/blacklist.tsv

redactions_2016_07_15__00_00_14.tsv:
	wget -N http://gdac.broadinstitute.org/runs/sampleReports/latest/redactions_2016_07_15__00_00_14.tsv

# tumor purity
ncomms9971-s2.xlsx:
	wget -N https://media.nature.com/original/nature-assets/ncomms/2015/151204/ncomms9971/extref/ncomms9971-s2.xlsx

tcga.tar: $(ALL)
	tar -cf $@ $(ALL)
