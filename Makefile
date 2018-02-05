grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))

PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.RData)
DTYPES = rna_seq_raw cnv_segments mirna_seq
DFILES = $(call grid,$(DTYPES),$(PFILES))

RNA_CPM = $(PFILES:%=rna_seq_log2cpm/%)
RNA_VST = $(PFILES:%=rna_seq_vst/%)

.PHONY: all
all: $(DFILES) $(RNA_CPM) $(RNA_VST)

define _pproc
$(PFILES:%=$(2)/%): $(2)/%.RData: $(2).r $(1)/%.RData
	@mkdir -p $$(dir $$@)
	Rscript $$^ $$@
endef
$(foreach _, rna_seq_log2cpm rna_seq_vst, $(eval $(call _pproc,rna_seq_raw,$_)))

define _proj
%/$(1).RData: %.r
	@mkdir -p $$(dir $$@)
	Rscript $$^ $(1) $$@
endef
$(foreach _, $(PROJECTS), $(eval $(call _proj,$_)))

projects.txt: projects.r
	Rscript $^ $@
