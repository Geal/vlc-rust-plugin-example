PREFIX = /usr
LD = ld
CC = cc
INSTALL = install
CFLAGS = -g -O2 -Wall -Wextra
LDFLAGS =
VLC_PLUGIN_CFLAGS := -D__PLUGIN__ -D_FILE_OFFSET_BITS=64 -D__USE_UNIX98 -D_REENTRANT -D_THREAD_SAFE -I../vlc/include
VLC_PLUGIN_LIBS := -L../vlc/build/vlc_install_dir/lib/ -lvlccore

libdir = $(PREFIX)/lib
plugindir = $(libdir)/vlc/plugins

override CC += -std=gnu99
override CPPFLAGS += -DPIC -I. -Isrc
override CFLAGS += -fPIC
#override LDFLAGS += -Wl,-no-undefined,-z,defs
override LDFLAGS += -Wl

override CPPFLAGS += -DMODULE_STRING=\"rustnormvol\"
override CFLAGS += $(VLC_PLUGIN_CFLAGS)
override LDFLAGS += $(VLC_PLUGIN_LIBS)

TARGETS = librustnormvol_plugin.so

all: librustnormvol_plugin.so

install: all
	mkdir -p -- $(DESTDIR)$(plugindir)/misc
	$(INSTALL) --mode 0755 libfoo_plugin.so $(DESTDIR)$(plugindir)/misc

install-strip:
	$(MAKE) install INSTALL="$(INSTALL) -s"

uninstall:
	rm -f $(plugindir)/misc/librustnormvol_plugin.so

clean:
	rm -f -- librustnormvol_plugin.so *.o *.bc

mostlyclean: clean

SOURCES = normvol.c

$(SOURCES:%.c=src/%.o): %:

librustnormvol_plugin.so: $(SOURCES:%.c=%.o) rust_normvol.o
	$(CC) $(LDFLAGS) -shared -o $@ $^

rust_normvol.bc: rust_normvol.rs
	rustc --emit=bc rust_normvol.rs

rust_normvol.o: rust_normvol.bc
	$(CC) -c -fPIC rust_normvol.bc

.PHONY: all install install-strip uninstall clean mostlyclean
