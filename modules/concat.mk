# $(call CONCAT, input_files, output_file)
CONCAT = $(CAT) $(1) >$(2).tmp && $(MV) $(2).tmp $(2)

define do-concat-files
$(eval _cmd := $(strip $3))
ifeq "$(_cmd)" ""
$(eval _cmd := CONCAT)
endif
$(eval _distdir := $(dir $(strip $2)))

all min: $2

$(call mkdirs,$(_distdir))

$2: $1 | $(_distdir)
ifneq "$(strip $4)" ""
ifneq "$$(strip $$(LINT_ENABLED))" ""
	$$(call prefix,lint,$$(call $4, $$?))
endif
endif
	$$(call prefix,concat,$$(call $(_cmd),$$^,$$@))
endef

# $(call concat-files, src_files, dist_file, [concat_command, [lint_command]])
concat-files = $(eval $(call do-concat-files,$1,$2,$3,$4))
