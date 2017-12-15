COPY_JS_FILES := $(filter %.js,$(COPY_FILES))
COPY_JSON_FILES := $(filter %.json,$(COPY_FILES))
COPY_CSS_FILES := $(filter %.css,$(COPY_FILES))
COPY_HTML_FILES := $(filter %.html,$(COPY_FILES))
COPY_FILES := $(filter-out %.js %.json %.css %.html,$(COPY_FILES))

BUILD_COPY := $(COPY_FILES:$(APP_DIR)%=$(DIST_DIR)%)
BUILD_COPY_JS := $(COPY_JS_FILES:$(APP_DIR)%=$(BUILD_DIR)%)
BUILD_COPY_JSON := $(COPY_JSON_FILES:$(APP_DIR)%=$(BUILD_DIR)%)
BUILD_COPY_CSS := $(COPY_CSS_FILES:$(APP_DIR)%=$(BUILD_DIR)%)
BUILD_COPY_HTML := $(COPY_HTML_FILES:$(APP_DIR)%=$(BUILD_DIR)%)
BUILD_COPY_DIST := $(BUILD_COPY_JS) $(BUILD_COPY_JSON) \
                   $(BUILD_COPY_CSS) $(BUILD_COPY_HTML)
BUILD_COPY_DIST_MIN := $(BUILD_COPY_DIST:$(BUILD_DIR)%=$(MIN_DIR)%)
BUILD_COPY_ALL += $(BUILD_COPY) $(BUILD_COPY_DIST)

VARS += COPY_FILES COPY_JS_FILES COPY_CSS_FILES \
        COPY_HTML_FILES BUILD_COPY BUILD_COPY_JS BUILD_COPY_CSS \
        BUILD_COPY_HTML BUILD_COPY_DIST BUILD_COPY_ALL

ifneq "$(strip $(BUILD_COPY_DIST))" ""
BUILD_FILES += $(BUILD_COPY_DIST)
TARGETS += copy-files copy-min-files

COPY_DIST_DIRS := $(call get-dirs,\
                         $(BUILD_COPY_DIST:$(BUILD_DIR)/%=$(DIST_DIR)/%))

$(call make-dir-targets,$(COPY_DIST_DIRS))
$(call make-copy-target,$(BUILD_COPY),$(APP_DIR),$(DIST_DIR))
$(call make-copy-js-target,$(BUILD_COPY_JS),$(APP_DIR),$(BUILD_DIR))
$(call make-copy-target, \
       $(BUILD_COPY_JSON) $(BUILD_COPY_CSS) $(BUILD_COPY_HTML), \
       $(APP_DIR), \
       $(BUILD_DIR) \
)

all min: $(BUILD_COPY_ALL)
all: copy-files
min: copy-min-files

copy-files: $(BUILD_COPY_DIST) | $(COPY_DIST_DIRS)
	$(call prefix,dist,\
	  $(foreach f,$(BUILD_COPY_DIST),\
	    $(CPDIST) $f $(DIST_DIR)/$(dir $(f:$(BUILD_DIR)/%=%)) &&)\
	      $(TRUE))

copy-min-files: $(BUILD_COPY_DIST_MIN) | $(COPY_DIST_DIRS)
	$(call prefix,dist,\
	  $(foreach f,$(BUILD_COPY_DIST_MIN),\
	    $(CPDIST) $f $(DIST_DIR)/$(dir $(f:$(MIN_DIR)/%=%)) &&)\
	      $(TRUE))
endif
