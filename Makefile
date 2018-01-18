MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILE_DIR)/modules/utils.mk
$(call load-modules,commands vars build)
include $(CONFIG_FILE)
$(call load-modules,test main info)
