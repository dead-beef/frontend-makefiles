TARGETS += vars targets
LIST_TARGETS := $(addprefix print-,$(TARGETS))
LIST_NPM_SCRIPTS := $(addprefix print-,$(NPM_SCRIPTS))
VARS += LIST_TARGETS LIST_NPM_SCRIPTS

.PHONY: $(TARGETS) $(NPM_SCRIPTS) $(LIST_TARGETS) $(LIST_NPM_SCRIPTS) $(VARS) \
        print-npm-header print-targets-header

vars: $(VARS)
targets: $(LIST_TARGETS) $(LIST_NPM_SCRIPTS)

$(VARS):
	@$(ECHO) "  " $@ = $($@)

$(LIST_TARGETS): print-targets-header
	@$(ECHO) '    ' $(@:print-%=%)

$(LIST_NPM_SCRIPTS): print-npm-header
	@$(ECHO) '    ' $(@:print-%=%)

print-npm-header:
	@$(ECHO) NPM scripts:

print-targets-header:
	@$(ECHO) Make targets:

