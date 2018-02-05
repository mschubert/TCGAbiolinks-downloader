grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))

PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.RData)
DTYPES = rna_seq_raw cnv_segments mirna_seq
DFILES = $(call grid,$(DTYPES),$(PFILES))

RNA_CPM = $(PFILES:%=rna_seq_log2cpm/%)
RNA_VST = $(PFILES:%=rna_seq_vst/%)

.PHONY: all
all: $(DFILES) $(RNA_CPM) $(RNA_VST)

$(RNA_CPM): rna_seq_log2cpm/%.RData: rna_seq_log2cpm.r rna_seq_raw/%.RData 
	@mkdir -p $(dir $@)
	Rscript $^ $@

$(RNA_VST): rna_seq_vst/%.RData: rna_seq_vst.r rna_seq_raw/%.RData 
	@mkdir -p $(dir $@)
	Rscript $^ $@

define _proj
%/$(1).RData: %.r
	@mkdir -p $$(dir $$@)
	Rscript $$^ $(1) $$@
endef
$(foreach _, $(PROJECTS), $(eval $(call _proj,$_)))

projects.txt:
	Rscript $^ $@
