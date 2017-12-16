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

START = http-server -a $(SERVER_IP) -p $(SERVER_PORT) -c-1 $(DIST_DIR)
STOP = pkill -f http-server

TEST = karma start config/karma.conf.js --single-run
TEST_WATCH = karma start config/karma.conf.js
TEST_E2E = ./e2e-test

MAKE_VARS = $(MAKEFILE_DIR)/js/make-vars.js
MAKE_VARS_CMD = $(NODE) $(MAKE_VARS) $(OVERRIDE_CONFIG_FILE)

#VER := $(shell ver)
#ifeq "$(findstring Windows, $(VER))" "Windows"
#	MV = ren
#	RM = del /f /s
#	CP = copy
#	MKDIR = mkdir
#	CAT = type
#endif
