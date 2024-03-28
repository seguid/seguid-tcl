SHELL=bash

all: check-cli


#---------------------------------------------------------------
# Check CLI using 'seguid-tests' test suite
#---------------------------------------------------------------
add-submodules:
	git submodule add https://github.com/seguid/seguid-tests seguid-tests

seguid-tests:
	git submodule init
	git submodule update
	cd "$@" && git pull origin main

check-cli: seguid-tests
	$(MAKE) -C seguid-tests check-cli CLI_CALL="tclsh $(CURDIR)/seguid"

.PHONY: seguid-tests
