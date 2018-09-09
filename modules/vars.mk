$(call set-default,OVERRIDE_CONFIG_FILE,config/override.js)
$(call set-default,BUILD_DIR,build)
$(call set-default,DEP_DIR,$(BUILD_DIR)/deps)
$(call set-default,MIN_DIR,$(BUILD_DIR)/min)
$(call set-default,DIST_DIR,dist)

LINT_ENABLED := 1

SERVER_IP := 127.0.0.1
SERVER_PORT := 8080

TARGETS :=
NPM_SCRIPTS :=
LOAD_MODULES :=
VARS := MODULE_PATH VARS_FILE MAKEFILES TARGETS NPM_SCRIPTS

VARS_FILE := $(BUILD_DIR)/vars.mk
MAKEFILES := Makefile $(VARS_FILE) $(wildcard $(MAKEFILE_PATH)/*.mk)
MODULE_DIRS := node_modules
INSTALL_TOUCH := $(BUILD_DIR)/install.touch

-include $(VARS_FILE)

INCLUDE_PATH := $(call join-with,:,$(MODULE_PATH))

ifneq "$(MAKECMDGOALS)" "install"
ifneq "$(MAKECMDGOALS)" "clean"
$(VARS_FILE): $(INSTALL_TOUCH) $(MAKE_VARS) $(OVERRIDE_CONFIG_FILE) | $(BUILD_DIR)
	$(call prefix,vars,$(MAKE_VARS_CMD) >$@.tmp)
	$(call prefix,vars,$(MV) $@.tmp $@)
endif
endif
