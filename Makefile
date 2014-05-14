
export PREFIX = $(shell pwd)/test/usr/local

install:

uninstall:

test: clean
	 cd test/lib &&  ../../clib-link.sh

clean:
	rm -rf $(PREFIX)/clibs

.PHONY: test
