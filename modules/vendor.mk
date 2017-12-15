APP_OUT_FONT_DIR := $(DIST_DIR)/fonts
LIB_FONT_TYPES_WILDCARD := $(subst %,*,$(LIB_FONT_TYPES))
LIB_FONTS :=
BUILD_FONTS :=
LIB_JS :=
LIB_CSS :=
VARS += LIB_JS_FILES LIB_CSS_FILES LIB_SCSS_DEPS LIB_SCSS_MAIN \
        LIB_JS LIB_CSS LIB_MIN_JS LIB_MIN_CSS \
        LIB_FONTS BUILD_FONTS APP_OUT_FONT_DIR

$(foreach \
    dirs,\
    $(join $(LIB_FONT_DIRS),$(addprefix -->,$(LIB_FONT_DIST_DIRS))),\
    $(eval $(call make-font-target,$(dirs)))\
)
ifeq "$(strip $(LIBRARY))" ""
BUILD_COPY_ALL += $(BUILD_FONTS)
endif

ifneq "$(strip $(LIB_JS_FILES))" ""
LIB_JS := $(BUILD_DIR)/$(LIB_NAME).js
LIB_MIN_JS := $(LIB_JS:$(BUILD_DIR)%=$(MIN_DIR)%)

TARGETS += copy-lib-js copy-lib-min-js

ifeq "$(strip $(LIBRARY))" ""
all: copy-lib-js
min: copy-lib-min-js
else
pre-test: $(LIB_JS)
endif

copy-lib-js: $(LIB_JS) | $(APP_OUT_JS_DIR)
	$(call prefix,dist,$(CPDIST) $(LIB_JS) $(APP_OUT_JS_DIR))

copy-lib-min-js: $(LIB_MIN_JS) | $(APP_OUT_JS_DIR)
	$(call prefix,dist,$(CPDIST) $(LIB_MIN_JS) $(APP_OUT_JS_DIR))

$(LIB_JS): $(LIB_JS_FILES) | $(BUILD_DIR)
	$(call prefix,lib-js,$(CAT) $^ >$@.tmp)
	$(call prefix,lib-js,$(MV) $@.tmp $@)
endif

ifneq "$(strip $(LIB_CSS_FILES) $(LIB_SCSS_FILES))" ""
LIB_CSS := $(BUILD_DIR)/$(LIB_NAME).css
LIB_MIN_CSS := $(LIB_CSS:$(BUILD_DIR)%=$(MIN_DIR)%)

TARGETS += copy-lib-css copy-lib-min-css

ifeq "$(strip $(LIBRARY))" ""
all: copy-lib-css
min: copy-lib-min-css
else
pre-test: $(LIB_CSS)
endif

copy-lib-css: $(LIB_CSS) | $(APP_OUT_CSS_DIR)
	$(call prefix,dist,$(CPDIST) $(LIB_CSS) $(APP_OUT_CSS_DIR))

copy-lib-min-css: $(LIB_MIN_CSS) | $(APP_OUT_CSS_DIR)
	$(call prefix,dist,$(CPDIST) $(LIB_MIN_CSS) $(APP_OUT_CSS_DIR))

ifneq "$(strip $(LIB_CSS_FILES))" ""
$(LIB_CSS): $(LIB_CSS_FILES) | $(BUILD_DIR)
	$(call prefix,lib-css,$(CAT) $(LIB_CSS_FILES) >$@.tmp)
	$(call prefix,lib-css,$(MV) $@.tmp $@)
else
$(LIB_CSS): $(LIB_SCSS_FILES) $(LIB_SCSS_DEPS) | $(BUILD_DIR)
	$(call prefix,lib-scss,$(CAT) $(LIB_SCSS_FILES) | $(SASS) >$@.tmp)
	$(call prefix,lib-scss,$(MV) $@.tmp $@)
endif
endif

ifeq "$(strip $(LIBRARY))" ""
BUILD_FILES += $(LIB_JS) $(LIB_CSS)
endif
