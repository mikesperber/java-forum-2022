SOURCES = index.org
HTML = $(SOURCES:.org=.html)
PDF = $(SOURCES:.org=.pdf)
CHROME = $(shell which google-chrome-beta || which google-chrome-stable || which google-chrome)
MAYBE_CHROME_PATH = $(if $(CHROME),--chrome-path $(CHROME),)

all: $(HTML)
.PHONY: all

%.html: %.org
	nix run --extra-experimental-features nix-command --extra-experimental-features flakes .# -- "$<"

pdf: $(PDF)
.PHONY: pdf

%.pdf: %.html
# large size is necessary to avoid layout problems
# https://github.com/astefanutti/decktape/issues/151
	nix run --extra-experimental-features nix-command --extra-experimental-features flakes --no-sandbox .#decktape -- --size='2048x1536'  $(MAYBE_CHROME_PATH) "$<" "$@"

clean:
	rm -f $(HTML)
	rm -f $(PDF)
.PHONY: clean
