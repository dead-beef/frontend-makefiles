MV = mv -f
RM = rm -rfv
CP = cp -f
#CPDIST = cp -f
CPDIST = ln -f
MKDIR = mkdir -p
ECHO = echo
PRINTF = printf
CAT = cat
TRUE = true
RESET_MAKE = env -u MAKELEVEL -u MAKEFILES $(MAKE)

NODE = node
SASS = node-sass --include-path $(SCSS_INCLUDE_PATH)
LINTJS = eslint
MINJS = uglifyjs
MINJSON = $(NODE) $(MAKEFILE_DIR)/js/min-json.js
MINCSS = csso
MINHTML = html-minifier -c config/html-minifier.conf.json
WATCH = chokidar $(WATCH_FILES) -i '**/.*' -c

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
