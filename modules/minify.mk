$(MIN_DIR)/%.js: $(BUILD_DIR)/%.js | $(MIN_DIR)
	$(call prefix,js-min,$(MINJS) $< -c -m >$@.tmp)
	$(call prefix,js-min,$(MV) $@.tmp $@)

$(BUILD_DIR)/%.min.js: $(BUILD_DIR)/%.js | $(MIN_DIR)
	$(call prefix,js-min,$(MINJS) $< -c -m >$@.tmp)
	$(call prefix,js-min,$(MV) $@.tmp $@)

$(MIN_DIR)/%.css: $(BUILD_DIR)/%.css | $(MIN_DIR)
	$(call prefix,css-min,$(MINCSS) -i $< -o $@)

$(BUILD_DIR)/%.min.css: $(BUILD_DIR)/%.css | $(MIN_DIR)
	$(call prefix,css-min,$(MINCSS) -i $< -o $@)

$(MIN_DIR)/%.json: $(BUILD_DIR)/%.json | $(MIN_DIR)
	$(call prefix,json-min,$(MINJSON) $< >$@.tmp)
	$(call prefix,json-min,$(MV) $@.tmp $@)

$(MIN_DIR)/%.html: $(BUILD_DIR)/%.html | $(MIN_DIR)
	$(call prefix,html-min,$(MINHTML) $< -o $@.tmp)
	$(call prefix,html-min,$(MV) $@.tmp $@)
