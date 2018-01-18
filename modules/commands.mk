#SHELLJS = shx
SHELLJS =
MV = $(SHELLJS) mv -f
RM = $(SHELLJS) rm -rf
CP = $(SHELLJS) cp -f
CAT = $(SHELLJS) cat
#CPDIST = $(SHELLJS) cp -f
CPDIST = $(SHELLJS) ln -f
MKDIR = $(SHELLJS) mkdir -p
ECHO = echo

PRINTF = printf
RESET_MAKE = env -u MAKELEVEL -u MAKEFILES $(MAKE)

NODE = node

MAKE_VARS = $(MAKEFILE_DIR)/bin/make-vars
MAKE_VARS_CMD = $(MAKE_VARS) $(OVERRIDE_CONFIG_FILE)

#VER := $(shell ver)
#ifeq "$(findstring Windows, $(VER))" "Windows"
#	MV = ren
#	RM = del /f /s
#	CP = copy
#	MKDIR = mkdir
#	CAT = type
#endif
