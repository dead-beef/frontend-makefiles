TEST_TARGETS := test test-watch test-e2e test-all
TARGETS += $(TEST_TARGETS)
TEST_TARGETS += $(filter test%,$(NPM_SCRIPTS))
VARS += TEST_TARGETS

#$(TEST_TARGETS): all

pre-test:

$(TEST_TARGETS): pre-test

test:
	$(call prefix,test,$(TEST))

test-watch:
	$(call prefix,test,$(TEST_WATCH))

test-e2e:
	$(call prefix,test,$(TEST_E2E))

test-all: test test-e2e
