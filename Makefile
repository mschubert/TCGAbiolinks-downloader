grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))
HPC = srun --ntasks=1 --cpus-per-task=1 --time=50:00:00 --partition=regular --mem=30G

PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.RData)
DTYPES = rna_seq_raw cnv_segments mirna_seq clinical
DFILES = $(call grid,$(DTYPES),$(PFILES))
ALL = $(DFILES) $(PFILES:%=rna_seq_log2cpm/%) $(PFILES:%=rna_seq_vst/%)

.PHONY: all
all: $(ALL)

define _tgt
.PHONY: $(1)
$(1): $(shell echo "$(ALL)" | tr ' ' '\n' | grep $(1))
endef
$(foreach _, $(PROJECTS), $(eval $(call _tgt,$_)))
$(foreach _, $(DTYPES), $(eval $(call _tgt,$_)))

define _pproc
$(PFILES:%=$(2)/%): $(2)/%.RData: $(2).r $(1)/%.RData
	@mkdir -p $$(dir $$@)
	$(HPC) Rscript $$^ $$@
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
