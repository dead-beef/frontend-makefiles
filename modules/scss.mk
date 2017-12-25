SCSS_INCLUDE_PATH := $(call join-with,:,$(MODULE_PATH))

# $(call SCSS_BUILD, input_scss, output_css)
SCSS_BUILD = node-sass --include-path $(SCSS_INCLUDE_PATH) $1 >$2.tmp \
             && $(MV) $2.tmp $2
# $(call SCSS_MAKEDEPEND, input_scss, output_dir, output_deps)
SCSS_MAKEDEPEND = sass-makedepend \
                  -I $(SCSS_INCLUDE_PATH) -i /node_modules/ -r \
                  -p $(2)/ $(1) >$(3).tmp \
                  && $(MV) $(3).tmp $(3)

# $(call add-scss-include-path, paths)
define add-scss-include-path
$(eval SCSS_INCLUDE_PATH := $(call join-with,:,$(1) $(SCSS_INCLUDE_PATH)))
endef

define do-build-scss
$(eval _distfile := $2/$(notdir $1))
$(eval _distfile := $(_distfile:%.scss=%.css))
$(eval _distfile := $(_distfile:%.sass=%.css))

$(eval _dep := $(DEP_DIR)/$(notdir $(1)).d)

$(call mkdirs,$2)

all min: $(_distfile)

$(_distfile): $1 | $2 $(DEP_DIR)
	$$(call prefix,deps,$$(call SCSS_MAKEDEPEND,$1,$2,$(_dep)))
	$$(call prefix,scss,$$(call SCSS_BUILD, $$<, $$@))
endef

# $(call build-scss, src_file, dist_dir)
build-scss = $(eval $(call do-build-scss,$1,$2))
