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

MKDIRS :=
mkdirs = $(eval MKDIRS += $1)

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
