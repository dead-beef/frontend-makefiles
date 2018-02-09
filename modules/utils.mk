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

# $(call load-modules, modules)
load-modules = $(eval include $(addprefix $(MAKEFILE_DIR)/modules/,\
                                          $(addsuffix .mk,$1)))
# $(call main)
main = $(call load-modules, main info test)
# $(call set-default, var, default_value)
set-default = $(eval $(1) := $$(if $$($(1)),$$($(1)),$2))
# $(call join-with, separator, list)
join-with = $(subst $(SPACE),$1,$(strip $2))
# $(call uniq, list)
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
# $(call get-dirs, paths)
get-dirs = $(call uniq,$(foreach d,$1,$(dir $d)))
# $(call src-to-min, paths)
src-to-min = $(patsubst %.js,%.min.js,$(patsubst %.css,%.min.css,$1))

MKDIRS :=
mkdirs = $(eval MKDIRS += $1)

# $(call prefix, prefix, command)
define prefix
@$(PRINTF) "  %-10s " "[$1]"
$(2)
endef

# $(call rwildcard, dir, wildcard)
define rwildcard
$(sort $(wildcard $1$2)) \
$(foreach d,$(sort $(wildcard $1*)),$(call rwildcard,$d/,$2))
endef

# $(call rwildcards, dir, wildcards)
define rwildcards
$(sort $(foreach p,$2,$(wildcard $1$p))) \
$(foreach d,$(sort $(wildcard $1*)),$(call rwildcards,$d/,$2))
endef

# $(call add-include-path, paths)
define add-include-path
$(eval INCLUDE_PATH := $(call join-with,:,$(1) $(INCLUDE_PATH)))
endef
