ifeq "$(CONFIG_FILE)" ""
CONFIG_FILE := config/app.mk
endif

ifeq "$(OVERRIDE_CONFIG_FILE)" ""
OVERRIDE_CONFIG_FILE := config/override.js
endif

BUILD_DIR = build
DEP_DIR := $(BUILD_DIR)/deps
MIN_DIR := $(BUILD_DIR)/min
DIST_DIR = dist
LINT_ENABLED := 1

TARGETS :=
NPM_SCRIPTS :=
LOAD_MODULES :=
VARS := MODULE_PATH VARS_FILE MAKEFILES TARGETS NPM_SCRIPTS

VARS_FILE := $(BUILD_DIR)/vars.mk
MAKEFILES := Makefile $(VARS_FILE) $(wildcard $(MAKEFILE_PATH)/*.mk) \
             $(CONFIG_FILE)
MODULE_DIRS := node_modules

-include $(VARS_FILE)

ifneq "$(MAKECMDGOALS)" "install"
$(VARS_FILE): package.json $(MAKE_VARS) $(OVERRIDE_CONFIG_FILE) | $(BUILD_DIR) $(MODULE_DIRS)
	$(call prefix,vars,$(MAKE_VARS_CMD) >$@.tmp)
	$(call prefix,vars,$(MV) $@.tmp $@)
endif
