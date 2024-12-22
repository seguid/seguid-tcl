SHELL=bash

all: check-cli

build: seguid

# https://core.tcl-lang.org/tcllib/raw/c3201341e46d53d6915073ac2703f3b83eb121a609a5ed3bfc90eed8b32c59d5?at=license.terms

src/tcllib/license.terms:
	curl -L -o "$@" https://core.tcl-lang.org/tcllib/raw/c3201341e46d53d6915073ac2703f3b83eb121a609a5ed3bfc90eed8b32c59d5?at=license.terms

src/tcllib/base64.tcl: src/tcllib/license.terms
	@url=https://core.tcl-lang.org/tcllib/raw/f6bea09d4aa9768279d2b74f7ab4a114dfb7c0583beded9da44eda66e888b8f7?at=base64.tcl; \
	tf=$$(mktemp --suffix="base64.tcl"); \
	curl --silent "$${url}" > "$${tf}"; \
	{ \
	  echo "## The following Base64 encode code was extracted from the tcllib source code"; \
	  echo "## $${url}"; \
	  echo ; \
	  head -n 19 "$${tf}"; \
	  sed -n -e '/namespace eval base64 {/,$$p' "$${tf}" | sed -e '/# ::base64::decode --/,$$d' | sed 's/ decode//'; \
	} >> "$@.tmp"; \
	rm "$${tf}"
	@mv "$@.tmp" "$@"

src/tcllib/sha1.tcl: src/tcllib/license.terms
	url=https://core.tcl-lang.org/tcllib/raw/b52facec511fa8edea4e8f0d3a71214fe137c179?at=sha1.tcl; \
	tf=$$(mktemp --suffix="sha1.tcl"); \
	curl --silent "$${url}" > "$${tf}"; \
	{ \
	  echo "## The following SHA-1 code was extracted from the tcllib source code"; \
	  echo "## $${url}"; \
	  echo ; \
	  head -n 22 "$${tf}" | head -n -1; \
	  sed -n -e '/    namespace eval ::sha1 {/,$$p' "$${tf}" | sed '/# test sha1/,/proc ::sha1::sha1 {msg}/{/proc ::sha1::sha1 {msg}/!d}' | sed -e '/### These procedures are either inlined or replaced with a normal/,$$d'; \
	} >> "$@.tmp"; \
	rm "$${tf}"
	@mv "$@.tmp" "$@"


seguid: src/seguid.tcl src/tcllib/base64.tcl src/tcllib/sha1.tcl
	@echo "Building $@ from $^ ..."
	@grep -q -F 'source [file join $$script_path ' "$<"
	@while IFS= read -r line; do \
	    if [[ "$${line}" == "source "* ]]; then \
	        file=$$(sed 's/source \[file join [$$]script_path /src\//' <<< "$${line}" | sed 's/\]//'); \
	        echo "## DON'T EDIT: The source of this part is $${file}"; \
	        cat "$${file}"; \
	        echo; \
	    elif [[ "$${line}" != "set script_path "* ]]; then \
	        echo "$${line}"; \
	    fi; \
	done < "$<" > "$@.tmp"
	@chmod ugo+x "$@.tmp"
	@mv "$@.tmp" "$@"
	@ls -l "$@"
	@echo "Version built: $$(tclsh seguid --version)"
	@echo "Building $@ from $^ ... done"


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
