# $(call build, src_files, dst_file,
#               [build_command=CONCAT],
#               [lint_command=<none>],
#               [makedepend_command=<none>],
#               [targets=all min])
#
# # $(call $(build_command), src_files, dst_file)
# # $(call $(lint_command), src_files)
# # $(call $(makedepend_command), src_files, dst_file, dep_file)
#
build = $(eval $(call do-build,$1,$2,$3,$4,$5,$6))

# $(call copy-files, src_files, src_dir, dst_dir,
#                    [targets=all min], [lint_command])
copy-files = $(eval $(call do-copy-files,$1,$2,$3,$4,$5))

# $(call copy-wildcards, wildcards, src_dir, dst_dir,
#                        [targets=all min], [lint_command])
copy-wildcards = $(call copy-files,$(call rwildcards,$2,$1),$2,$3,$4,$5)

# $(call build-and-minify, src_files, build_file, min_file
#                          [build_command=CONCAT],
#                          [minify_command=CONCAT],
#                          [lint_command=<none>],
#                          [makedepend_command=<none>],
#                          [build_targets=all min],
#                          [min_targets=min])
#
# # $(call $(build_command), src_files, dst_file)
# # $(call $(minify_command), src_file, dst_file)
# # $(call $(lint_command), src_files)
# # $(call $(makedepend_command), src_files, dst_file, dep_file)
#
define build-and-minify
$(call build,$(1),$(2),$(4),$(6),$(7),$(8)) \
$(call build,$(2),$(3),$(5), , ,$(if $(strip $(9)),$(9),min))
endef


# $(eval $(call do-copy-files, src_files, src_dir, dst_dir,
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

# $(eval $(call do-build, src_files, dst_file,
#                         [build_command=CONCAT],[lint_command],
#                         [makedepend_command], [targets=all min]))
define do-build
$(call mkdirs,$(dir $2))

$(if $(strip $6),$6,all min): $2

ifneq "$(strip $5)" ""
$2: | $(DEP_DIR)
endif

$2: $1 | $(dir $2)
ifneq "$(strip $4)" ""
ifneq "$$(strip $$(LINT_ENABLED))" ""
	$$(call prefix,lint,$$(call $4, $$?))
endif
endif
ifneq "$(strip $5)" ""
	$$(call prefix,dep,$$(call $5,$1,$2,$(DEP_DIR)/$(notdir $1).d))
endif
	$$(call prefix,build,$$(call $(if $(strip $3),$3,CONCAT),$1,$2))
endef
