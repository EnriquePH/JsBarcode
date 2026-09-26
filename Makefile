# Development tasks for the JsBarcode R package.
# Run `make help` to list targets.

R      ?= Rscript
PKG    := $(shell sed -n 's/^Package: //p' DESCRIPTION)
VER    := $(shell sed -n 's/^Version: //p' DESCRIPTION)
PORT   ?= 3838
JSVER  ?= $(shell curl -s https://registry.npmjs.org/jsbarcode/latest | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')

.DEFAULT_GOAL := help
.PHONY: help all document test check lint build install run site site-preview update-js release clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-13s\033[0m %s\n", $$1, $$2}'

all: document lint test check ## document + lint + test + check

document: ## Regenerate man/ and NAMESPACE with roxygen2
	$(R) -e 'devtools::document()'

test: ## Run the testthat suite
	$(R) -e 'devtools::test(stop_on_failure = TRUE)'

lint: ## Lint the package with lintr (config in .lintr; fails on any lint)
	LINTR_ERROR_ON_LINT=true $(R) -e 'print(lintr::lint_package())'

check: document ## Full R CMD check (fails on warnings)
	$(R) -e 'devtools::check(document = FALSE, error_on = "warning")'

build: document ## Build the source tarball
	$(R) -e 'devtools::build(path = ".")'

install: document ## Install the package into the local library
	$(R) -e 'devtools::install(upgrade = FALSE)'

run: install ## Launch the Shiny demo app (PORT=3838)
	$(R) -e 'shiny::runApp(system.file("examples/shiny", package = "$(PKG)"), port = $(PORT), launch.browser = FALSE)'

site: document ## Build the pkgdown site into docs/
	$(R) -e 'pkgdown::build_site(install = TRUE, new_process = TRUE)'

site-preview: ## Open the built site in the browser
	$(R) -e 'pkgdown::preview_site()'

update-js: ## Vendor the latest JsBarcode from npm (or JSVER=x.y.z)
	@test -n "$(JSVER)" || (echo "Could not resolve JsBarcode version" && exit 1)
	@echo "Vendoring JsBarcode $(JSVER)"
	tmp=$$(mktemp -d) && \
	curl -sL https://registry.npmjs.org/jsbarcode/-/jsbarcode-$(JSVER).tgz | tar -xz -C $$tmp && \
	rm -rf inst/htmlwidgets/lib/jsbarcode-* && \
	mkdir -p inst/htmlwidgets/lib/jsbarcode-$(JSVER) && \
	cp $$tmp/package/dist/JsBarcode.all.min.js inst/htmlwidgets/lib/jsbarcode-$(JSVER)/ && \
	cp $$tmp/package/MIT-LICENSE.txt inst/htmlwidgets/lib/jsbarcode-$(JSVER)/LICENSE && \
	rm -rf $$tmp
	sed -i -E 's/(version: ).*/\1$(JSVER)/; s#(src: htmlwidgets/lib/jsbarcode-).*#\1$(JSVER)#' inst/htmlwidgets/JsBarcode.yaml
	sed -i -E 's/"[0-9]+\.[0-9]+\.[0-9]+"\)$$/"$(JSVER)")/' tests/testthat/test-JsBarcode.R
	@echo "Done. Update README.md, NEWS.md and barcode_formats if needed, then run 'make check'."

release: ## Release: tag, push, GitHub release (BUMP=current|patch|minor|major|X.Y.Z, ARGS=--dry-run)
	scripts/release.sh $(or $(BUMP),current) $(ARGS)

clean: ## Remove build artefacts
	rm -rf docs $(PKG)_*.tar.gz $(PKG).Rcheck
