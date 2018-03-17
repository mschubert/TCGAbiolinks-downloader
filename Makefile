grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))
HPC = #srun --ntasks=1 --cpus-per-task=1 --time=50:00:00 --partition=regular --mem=30G

#TODO: subtypes, methylation
PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.RData)
DTYPES = snv_mutect2 rna_seq_raw cnv_segments mirna_seq clinical clinicalsample rppa rna_isoform_raw
EXCLUDE = rppa/TCGA-LAML.RData
DFILES = $(filter-out $(EXCLUDE), $(call grid,$(DTYPES),$(PFILES)))
ALL = $(DFILES) \
	  $(PFILES:%=rna_seq_log2cpm/%) $(PFILES:%=rna_seq_vst/%) \
	  $(PFILES:%=rna_isoform_log2cpm/%) $(PFILES:%=rna_isoform_vst/%)

.PHONY: all
all: $(ALL)

define _tgt
.PHONY: $(1)
$(1): $(shell echo "$(ALL)" | tr ' ' '\n' | grep $(1))
endef
$(foreach _, $(PROJECTS), $(eval $(call _tgt,$_)))
$(foreach _, $(DTYPES), $(eval $(call _tgt,$_)))

define _pproc
$(PFILES:%=$(2)/%): $(2)/%.RData: pproc_$(3).r $(1)/%.RData
	@mkdir -p $$(dir $$@)
	$(HPC) Rscript $$^ $$@
endef
$(eval $(call _pproc,rna_seq_raw,rna_seq_log2cpm,log2cpm))
$(eval $(call _pproc,rna_seq_raw,rna_seq_vst,vst))
$(eval $(call _pproc,rna_isoform_raw,rna_isoform_log2cpm,log2cpm))
$(eval $(call _pproc,rna_isoform_raw,rna_isoform_vst,vst))

define _proj
%/$(1).RData: %.r
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
