SHELL=bash

all: check-cli

build: seguid

seguid: src/seguid-cli.tcl src/base64.tcl src/sha1.tcl src/seguid.tcl
	grep -F 'source [file join $$script_path ' "$<"
	while IFS= read -r line; do \
	    if [[ "$${line}" == "source "* ]]; then \
	        file=$$(sed 's/source \[file join [$$]script_path /src\//' <<< "$${line}" | sed 's/\]//'); \
	        echo "## DON'T EDIT: The source of this part is $${file}"; \
	        cat "$${file}"; \
	        echo; \
	    elif [[ "$${line}" != "set script_path "* ]]; then \
	        echo "$${line}"; \
	    fi; \
	done < "$<" > "$@.tmp"
	chmod ugo+x "$@.tmp"
	mv "$@.tmp" "$@"


#---------------------------------------------------------------
# Check CLI using 'seguid-tests' test suite
#---------------------------------------------------------------
add-submodules:
	git submodule add https://github.com/seguid/seguid-tests seguid-tests

seguid-tests:
	git submodule init
	git submodule update
	cd "$@" && git pull origin main

check-cli: seguid seguid-tests
	$(MAKE) -C seguid-tests check-cli CLI_CALL="tclsh $(CURDIR)/seguid"

check-api: seguid-tests
	TCL_PATH="$(shell pwd)/$<"; $(MAKE) -C seguid-tests check-api/seguid-tcl

.PHONY: seguid-tests
