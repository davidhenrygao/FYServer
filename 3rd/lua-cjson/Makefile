##### Available defines for CJSON_CFLAGS #####
##
## USE_INTERNAL_ISINF:      Workaround for Solaris platforms missing isinf().
## DISABLE_INVALID_NUMBERS: Permanently disable invalid JSON numbers:
##                          NaN, Infinity, hex.
##
## Optional built-in number conversion uses the following defines:
## USE_INTERNAL_FPCONV:     Use builtin strtod/dtoa for numeric conversions.
## IEEE_BIG_ENDIAN:         Required on big endian architectures.
## MULTIPLE_THREADS:        Must be set when Lua CJSON may be used in a
##                          multi-threaded application. Requries _pthreads_.

##### Build defaults #####
LUA_VERSION =       5.3
TARGET =            cjson.so
#PREFIX =            /usr/local
PREFIX =            ../..
#CFLAGS =            -g -Wall -pedantic -fno-inline
CFLAGS =            -O3 -Wall -pedantic -DNDEBUG
CJSON_CFLAGS =      -fpic
CJSON_LDFLAGS =     -shared
#LUA_INCLUDE_DIR =   $(PREFIX)/include
LUA_INCLUDE_DIR =   $(PREFIX)/skynet/3rd/lua

## Use Libc support for number conversion (default)
FPCONV_OBJS =       fpconv.o

TEST_FILES =        README bench.lua genutf8.pl test.lua octets-escaped.dat \
                    example1.json example2.json example3.json example4.json \
                    example5.json numbers.json rfc-example1.json \
                    rfc-example2.json types.json
DATAPERM =          644
EXECPERM =          755

ASCIIDOC =          asciidoc

BUILD_CFLAGS =      -I$(LUA_INCLUDE_DIR) $(CJSON_CFLAGS)
OBJS =              lua_cjson.o strbuf.o $(FPCONV_OBJS)

.PHONY: all clean doc

.SUFFIXES: .html .adoc

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(BUILD_CFLAGS) -o $@ $<

.adoc.html:
	$(ASCIIDOC) -n -a toc $<

all: $(TARGET)

doc: manual.html performance.html

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(CJSON_LDFLAGS) -o $@ $(OBJS)

clean:
	rm -f *.o $(TARGET)
