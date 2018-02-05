grid = $(foreach x,$(1),$(foreach y,$(2),$(x)/$(y)))

PROJECTS = $(shell cat projects.txt)
PFILES = $(PROJECTS:%=%.RData)
DTYPES = rna_seq_raw
DFILES = $(call grid,$(DTYPES),$(PFILES))

all: $(DFILES)

define _proj
%/$(1).RData: %.r
	@mkdir -p $$(dir $$@)
	Rscript $$^ $(1) $$@
endef
$(foreach _, $(PROJECTS), $(eval $(call _proj,$_)))

projects.txt:
	Rscript $^ $@
