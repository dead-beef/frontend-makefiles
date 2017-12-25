# $(call MINJS, src_file, dst_file)
MINJS = uglifyjs $1 -c -m >$2.tmp && $(MV) $2.tmp $2
# $(call MINJSON, src_file, dst_file)
MINJSON = $(MAKEFILE_DIR)/bin/min-json $1 >$2.tmp && $(MV) $2.tmp $2
# $(call MINCSS, src_file, dst_file)
MINCSS = csso -i $1 -o $2
# $(call MINHTML, src_file, dst_file)
MINHTML = html-minifier -c config/html-minifier.conf.json $1 -o $2.tmp \
          && $(MV) $2.tmp $2

define do-minify
$(eval _distdir := $(dir $(strip $2)))

$(call mkdirs, $(_distdir))

min: $2

$2: $1 | $(_distdir)
	$$(call prefix,min,$$(call $3,$1,$2))
endef

# $(call minify, src_file, dst_file, command)
minify = $(eval $(call do-minify,$1,$2,$3))
