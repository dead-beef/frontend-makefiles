TARGETS += $(TEST_TARGETS)
TEST_TARGETS += $(filter test%,$(NPM_SCRIPTS))
VARS += TEST_TARGETS

pre-test:

$(TEST_TARGETS): pre-test
