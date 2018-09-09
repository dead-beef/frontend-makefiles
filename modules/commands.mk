### shell ###

#SHELLJS = shx
SHELLJS =
MV = $(SHELLJS) mv -f
RM = $(SHELLJS) rm -rf
CP = $(SHELLJS) cp -f
CAT = $(SHELLJS) cat
LN = $(SHELLJS) ln -sfn
#CPDIST = $(SHELLJS) cp -f
CPDIST = $(SHELLJS) ln -f
MKDIR = $(SHELLJS) mkdir -p
ECHO = echo
TOUCH = $(SHELLJS) touch

PRINTF = printf
RESET_MAKE = env -u MAKELEVEL -u MAKEFILES $(MAKE)

NODE = node

MAKE_VARS = $(MAKEFILE_DIR)/bin/make-vars
MAKE_VARS_CMD = $(MAKE_VARS) $(OVERRIDE_CONFIG_FILE)

SERVER_START = http-server -a $(SERVER_IP) -p $(SERVER_PORT) -c-1 $(DIST_DIR)
SERVER_STOP = -pkill -f http-server

# $(call WATCH, files, command)
WATCH = chokidar $(1) -i '**/.*' -c $(2)

#VER := $(shell ver)
#ifeq "$(findstring Windows, $(VER))" "Windows"
#	MV = ren
#	RM = del /f /s
#	CP = copy
#	MKDIR = mkdir
#	CAT = type
#endif

### build ###
##
# $(call <command>, input_files, output_file)

COPY = $(CP) $(1) $(2)
CONCAT = $(CAT) $(1) >$(2).tmp && $(MV) $(2).tmp $(2)
SOURCE_MAP_CONCAT = source-map-concat -o $(2) $(1)
NG1_TEMPLATE_CONCAT = ng1-template-concat -r $(TMPL_DIR) -o $(2) $(1)
SLM = slm -i $(1) -o $(2)

NODE_SASS = node-sass --include-path $(INCLUDE_PATH) \
            $(1) >$(2).tmp \
            && $(MV) $(2).tmp $(2)
AUTOPREFIXER = postcss $(1) --use autoprefixer --no-map -o $(2)

UGLIFYJS = uglifyjs $(1) -c -m -o $(2)
CSSO = csso -i $(1) -o $(2)
HTML_MINIFIER = html-minifier -c config/html-minifier.conf.json $(1) -o $(2)

define SOURCE_MAP_UGLIFY
$(call UGLIFYJS,$(1),$(2)) \
       --source-map content=$(strip $1).map,url=$(notdir $2).map
endef

### lint ###
##
# $(call <command>, input_files)

ESLINT = eslint $(1)

### makedepend ###
##
# $(call <command>, input_files, output_file, output_deps)

SASS_MAKEDEPEND = sass-makedepend \
                  -I $(INCLUDE_PATH) -m -r \
                  -p $(dir $(2)) $(1) >$(3).tmp \
                  && $(MV) $(3).tmp $(3)
