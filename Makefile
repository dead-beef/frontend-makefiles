MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(MAKEFILE_DIR)/modules/utils.mk
$(call load-modules,commands vars build)
