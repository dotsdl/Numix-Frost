SASS=scss
SASSFLAGS=--sourcemap=none
GLIB_COMPILE_RESOURCES=glib-compile-resources
RES_DIR=gtk-3.0
SCSS_DIR=$(RES_DIR)/scss
DIST_DIR=$(RES_DIR)/dist
INSTALL_DIR=$(DESTDIR)/usr/share/themes/Numix-Frost

all: clean gresource

css:
	$(SASS) --update $(SASSFLAGS) $(SCSS_DIR):$(DIST_DIR)

gresource: css
	$(GLIB_COMPILE_RESOURCES) --sourcedir=$(RES_DIR) $(RES_DIR)/gtk.gresource.xml

watch: clean
	while true; do \
		make gresource; \
		inotifywait @gtk.gresource -qr -e modify -e create -e delete $(RES_DIR); \
	done

clean:
	rm -rf $(DIST_DIR)
	rm -f $(RES_DIR)/gtk.gresource

install: all
	install -d -m755 $(INSTALL_DIR)

	for f in *; do cp -pr $$f $(INSTALL_DIR)/; done

uninstall:
	rm -rf $(INSTALL_DIR)

.PHONY: all
.PHONY: css
.PHONY: watch
.PHONY: gresource
.PHONY: clean
.PHONY: install
.PHONY: uninstall

.DEFAULT_GOAL := all

# vim: set ts=4 sw=4 tw=0 noet :
