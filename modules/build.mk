# $(call CONCAT, input_files, output_file)
CONCAT = $(CAT) $(1) >$(2).tmp && $(MV) $(2).tmp $(2)

# $(call build, src_files, dist_file,
#               [targets=all min],
#               [build_command=CONCAT],
#               [lint_command],
#               [makedepend_command])
#
# # $(call $(build_command), src_files, dist_file)
# # $(call $(lint_command), src_files)
# # $(call $(makedepend_command), src_files, dist_file, dep_file)
#
build = $(eval $(call do-build,$1,$2,$3,$4,$5,$6))

# $(call copy-files, src_files, src_dir, dist_dir,
#                    [targets=all min], [lint_command])
copy-files = $(eval $(call do-copy-files,$1,$2,$3,$4,$5))

# $(call copy-wildcards, wildcards, src_dir, dist_dir,
#                        [targets=all min], [lint_command])
copy-wildcards = $(call copy-files,$(call rwildcards,$2,$1),$2,$3,$4,$5)


# $(eval $(call do-copy-files, src_files, src_dir, dist_dir,
#                              [targets=all min], [lint_command]))
define do-copy-files
$(eval _srcdir := $(strip $2))
$(eval _distdir := $(strip $3))
$(eval _distfiles := $(strip $(1:$(_srcdir)/%=$(_distdir)/%)))
$(eval _distdirs := $(call get-dirs,$(_distfiles)))

$(call mkdirs,$(_distdirs))

$(if $(strip $4),$4,all min): $(_distfiles)

$(_distfiles): $(_distdir)/%: $(_srcdir)/% | $(_distdirs)
ifneq "$(strip $5)" ""
ifneq "$$(strip $$(LINT_ENABLED))" ""
	$$(call prefix,lint,$$(call $5, $$<))
endif
endif
	$$(call prefix,copy,$$(CP) $$< $$@)
endef

# $(eval $(call do-build, src_files, dist_file,
#                         [targets=all min],[build_command=CONCAT],
#                         [lint_command],[makedepend_command]))
define do-build
$(call mkdirs,$(dir $2))

$(if $(strip $3),$3,all min): $2

ifneq "$(strip $6)" ""
$2: | $(DEP_DIR)
endif

$2: $1 | $(dir $2)
ifneq "$(strip $5)" ""
ifneq "$$(strip $$(LINT_ENABLED))" ""
	$$(call prefix,lint,$$(call $5, $$?))
endif
endif
ifneq "$(strip $6)" ""
	$$(call prefix,deps,$$(call $6,$1,$2,$(DEP_DIR)/$(notdir $1).d))
endif
	$$(call prefix,build,$$(call $(if $(strip $4),$4,CONCAT),$1,$2))
endef
