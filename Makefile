SOURCES = $(wildcard *.org)
HTML = $(SOURCES:.org=.html)
PDF = $(SOURCES:.org=.pdf)
CHROME = $(shell which google-chrome-beta || which google-chrome-stable || which google-chrome)
MAYBE_CHROME_PATH = $(if $(CHROME),--chrome-path $(CHROME),)

all: $(HTML)
.PHONY: all

%.html: %.org
	nix run .# -- "$<"

pdf: $(PDF)
.PHONY: pdf

%.pdf: %.html
	nix run --no-sandbox .#decktape -- -s 1920x1080 $(MAYBE_CHROME_PATH) "$<" "$@"

clean:
	rm -f $(HTML)
	rm -f $(PDF)
.PHONY: clean
