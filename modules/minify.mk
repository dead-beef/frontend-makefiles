# $(call MINJS, src_file, dst_file)
MINJS = uglifyjs $1 -c -m >$2.tmp && $(MV) $2.tmp $2
# $(call MINJSON, src_file, dst_file)
MINJSON = $(MAKEFILE_DIR)/bin/min-json $1 >$2.tmp && $(MV) $2.tmp $2
# $(call MINCSS, src_file, dst_file)
MINCSS = csso -i $1 -o $2
# $(call MINHTML, src_file, dst_file)
MINHTML = html-minifier -c config/html-minifier.conf.json $1 -o $2.tmp \
          && $(MV) $2.tmp $2

# $(call minify, src_file, dst_file, command)
minify = $(call build,$1,$2,min,$3)

# $(call src-to-min, paths)
src-to-min = $(patsubst %.js,%.min.js,$(patsubst %.css,%.min.css,$1))
