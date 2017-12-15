SPACE :=
SPACE +=
LP := (
RP := )
COMMA := ,
QUOTE := "
# "
QUOTE2 := \"
# "

#--------

load-modules = $(eval include $(addprefix $(MAKEFILE_DIR)/modules/,\
                                          $(addsuffix .mk,$1)))

join-with = $(subst $(SPACE),$1,$(strip $2))
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
src-to-min = $(patsubst %.js,%.min.js,$(patsubst %.css,%.min.css,$1))
get-dirs = $(call uniq,$(foreach d,$1,$(dir $d)))


define prefix # (prefix, command)
	@$(PRINTF) "  %-10s " "[$1]"
	$(2)
endef

define rwildcard # (dir, wildcard)
	$(sort $(wildcard $1$2)) \
	$(foreach d,$(sort $(wildcard $1*)),$(call rwildcard,$d/,$2))
endef

define rwildcards # (dir, wildcards)
	$(sort $(foreach p,$2,$(wildcard $1$p))) \
	$(foreach d,$(sort $(wildcard $1*)),$(call rwildcards,$d/,$2))
endef

define do-make-dir-target # (dirs)
$1:
	$$(call prefix,mkdirs,$$(MKDIR) $$@)
endef

define do-make-copy-target # (dist_files, src_dir, dist_dir)
$(eval dstdirs := $(call get-dirs,$1))
$(call make-dir-target,$(dstdirs))
$(strip $1): $(strip $3)/%: $(strip $2)/% | $(dstdirs)
	$$(call prefix,copy,$$(CP) $$< $$@)
endef

define do-make-copy-js-target # (dist_files, src_dir, dist_dir)
$(eval dstdirs := $(call get-dirs,$1))
$(call make-dir-target,$(dstdirs))
$(strip $1): $(strip $3)/%: $(strip $2)/% | $(dstdirs)
ifneq "$(strip $(LINT_ENABLED))" ""
	$$(call prefix,js-lint,$$(LINTJS) $$<)
endif
	$$(call prefix,copy,$$(CP) $$< $$@)
endef

define make-font-target # (src-->dst)
$(eval srcdst := $(subst -->, ,$1))
$(eval src := $(firstword $(srcdst)))
$(eval dst := $(lastword $(srcdst)))
$(eval files := $(call rwildcards,$(src)/,$(LIB_FONT_TYPES_WILDCARD)))
$(eval distfiles := \
       $(foreach f,$(files),$(patsubst $(src)%,$(APP_OUT_FONT_DIR)/$(dst)%,$f)))
$(eval LIB_FONTS += $(files))
$(eval BUILD_FONTS += $(distfiles))
$(call make-copy-target,$(distfiles),$(src),$(APP_OUT_FONT_DIR)/$(dst))
endef

make-dir-target = $(eval $(call do-make-dir-target,$1))
make-copy-target = $(eval $(call do-make-copy-target,$1,$2,$3))
make-copy-js-target = $(eval $(call do-make-copy-js-target,$1,$2,$3))
