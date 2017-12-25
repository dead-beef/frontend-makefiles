define do-copy-files # (src_files, src_dir, dist_dir, [lint_command])
$(eval _srcdir := $(strip $2))
$(eval _distdir := $(strip $3))
$(eval _distfiles := $(strip $(1:$(_srcdir)/%=$(_distdir)/%)))
$(eval _distdirs := $(call get-dirs,$(_distfiles)))

all min: $(_distfiles)

$(call mkdirs,$(_distdirs))

$(_distfiles): $(_distdir)/%: $(_srcdir)/% | $(_distdirs)
ifneq "$(strip $4)" ""
ifneq "$$(strip $$(LINT_ENABLED))" ""
	$$(call prefix,lint,$$(call $4, $$<))
endif
endif
	$$(call prefix,copy,$$(CP) $$< $$@)
endef

# $(call copy-files, src_files, src_dir, dist_dir, [lint_command])
copy-files = $(eval $(call do-copy-files,$1,$2,$3,$4))

# (call copy-wildcards, wildcards, src_dir, dist_dir, [lint_command])
copy-wildcards = $(call copy-files,$(call rwildcards,$2,$1),$2,$3,$4)
