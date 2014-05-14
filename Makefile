
BIN ?= clib-link
PREFIX ?= /usr/local

export TEST_PREFIX = $(shell pwd)/test/usr/local

install:
	cp $(BIN).sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

test: clean
	 cd test/lib &&  PREFIX=$(TEST_PREFIX) ../../clib-link.sh
	 cd test/project && PREFIX=$(TEST_PREFIX) ../../clib-link.sh test
	 test -L test/project/deps/test || exit 1

clean:
	rm -rf $(TEST_PREFIX)/clibs
	rm -rf ./test/project/deps

.PHONY: test
