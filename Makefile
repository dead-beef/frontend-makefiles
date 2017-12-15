MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILE_DIR)/modules/macros.mk
$(call load-modules,commands vars)
include $(CONFIG_FILE)
LOAD_MODULES += copy test minify main info
$(call load-modules,$(LOAD_MODULES))
