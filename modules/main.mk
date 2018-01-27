TARGETS += all min rebuild rebuild-min rebuild-all rebuild-all-min \
           clean clean-build clean-vars install

.DEFAULT_GOAL := all
.PHONY: $(TARGETS)

$(call mkdirs,$(BUILD_DIR) $(DIST_DIR) $(MIN_DIR) $(DEP_DIR))
MKDIRS := $(call uniq,$(MKDIRS))

$(MKDIRS):
	$(call prefix,mkdirs,$(MKDIR) $@)

$(MODULE_DIRS):
	$(call prefix,install,$(RESET_MAKE) install)

$(NPM_SCRIPTS):
	$(call prefix,npm,npm run $(subst -,:,$@) --silent)

rebuild: clean-build
	$(RESET_MAKE)

rebuild-min: clean-build
	$(RESET_MAKE) min

rebuild-all: clean
	$(RESET_MAKE)

rebuild-all-min: clean
	$(RESET_MAKE) min

clean: clean-build
	$(call prefix,clean,$(RM) $(DIST_DIR)/*)

clean-build:
	$(call prefix,clean,$(RM) $(BUILD_DIR)/*)

clean-vars:
	$(call prefix,clean,$(RM) $(VARS_FILE))

install:
	$(call prefix,install,npm install)
	$(call prefix,install,$(RESET_MAKE) $(VARS_FILE))

-include $(wildcard $(DEP_DIR)/*.d)
