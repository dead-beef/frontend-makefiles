APP_CSS =
VARS += SCSS_FILES SCSS_DIRS SCSS_DEPS \
        SCSS_INCLUDE_PATH APP_CSS APP_MIN_CSS

SCSS_DEPS := $(SCSS_FILES) $(foreach d,$(CSSS_DIRS),\
                                     $(call rwildcards,$d/,*.css *.scss))
SCSS_DEPS := $(filter-out $(LIB_SCSS_FILES) $(LIB_SCSS_DEPS),$(SCSS_DEPS))
SCSS_INCLUDE_PATH := $(call join-with,:,\
                            $(SCSS_DIRS) $(MODULE_DIRS) $(MODULE_PATH))

ifneq "$(strip $(SCSS_FILES))" ""
APP_CSS := $(BUILD_DIR)/$(APP_NAME).css
APP_OUT_DIR += $(APP_OUT_CSS_DIR)
BUILD_FILES += $(APP_CSS)

TARGETS += copy-app-css copy-app-min-css

ifneq "$(strip $(LIBRARY))" ""
APP_MIN_CSS := $(APP_CSS:%.css=%.min.css)
BUILD_FILES += $(APP_MIN_CSS)

all: copy-app-min-css
else
APP_MIN_CSS := $(APP_CSS:$(BUILD_DIR)%=$(MIN_DIR)%)
endif

all: copy-app-css
min: copy-app-min-css

copy-app-css: $(APP_CSS) | $(APP_OUT_CSS_DIR)
	$(call prefix,dist,$(CPDIST) $(APP_CSS) $(APP_OUT_CSS_DIR))

copy-app-min-css: $(APP_MIN_CSS) | $(APP_OUT_CSS_DIR)
	$(call prefix,dist,$(CPDIST) $(APP_MIN_CSS) $(APP_OUT_CSS_DIR))

$(APP_CSS): $(SCSS_DEPS) | $(BUILD_DIR)
	$(call prefix,scss,$(CAT) $(SCSS_FILES) | $(SASS) >$@.tmp)
	$(call prefix,scss,$(MV) $@.tmp $@)

endif
