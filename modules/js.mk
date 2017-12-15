APP_JS :=
JS_FILES := $(call uniq,$($(filter-out $(JS_IGNORE),JS_FILES)))
VARS += APP_OUT_JS_DIR JS_FILES APP_JS APP_MIN_JS

ifneq "$(strip $(JS_FILES))" ""
APP_JS := $(BUILD_DIR)/$(APP_NAME).js
BUILD_FILES += $(APP_JS)

#ifneq "$(strip $(LIBRARY))" ""
JS_FILES := $(APP_DIR)/umd/umd-start.js \
            $(JS_FILES) \
            $(APP_DIR)/umd/umd-end.js
#endif

TARGETS += copy-app-js copy-app-min-js

ifneq "$(strip $(LIBRARY))" ""
APP_MIN_JS := $(APP_JS:%.js=%.min.js)
BUILD_FILES += $(APP_MIN_JS)

all: copy-app-min-js
else
APP_MIN_JS := $(APP_JS:$(BUILD_DIR)%=$(MIN_DIR)%)
endif

all: copy-app-js
min: copy-app-min-js

copy-app-js: $(APP_JS) | $(APP_OUT_JS_DIR)
	$(call prefix,dist,$(CPDIST) $(APP_JS) $(APP_OUT_JS_DIR))

copy-app-min-js: $(APP_MIN_JS) | $(APP_OUT_JS_DIR)
	$(call prefix,dist,$(CPDIST) $(APP_MIN_JS) $(APP_OUT_JS_DIR))

$(APP_JS): $(JS_FILES) | $(BUILD_DIR)
ifneq "$(strip $(LINT_ENABLED))" ""
	$(call prefix,js-lint,$(LINTJS) $?)
endif
	$(call prefix,js-cat,$(CAT) $^ >$@.tmp)
	$(call prefix,js-cat,$(MV) $@.tmp $@)
endif
