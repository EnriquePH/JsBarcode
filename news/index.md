# Changelog

## JsBarcode 0.1.0

- Repository reorganised: the package now lives at the repo root; 2017
  scaffolding artefacts were moved out of the repo.
- Bundled JsBarcode updated from 3.8.0 to 3.12.3. Only the minified
  bundle and its license are vendored (no more bower source tree).
- [`JsBarcode()`](https://EnriquePH.github.io/JsBarcode/reference/JsBarcode.md)
  gains `format`, `bar_width`, `bar_height`, `display_value`, `text`,
  `font_size`, `line_color`, `background`, `margin` and `...` for any
  other JsBarcode option. Arguments after `format` must be named.
- The widget now actually renders an SVG barcode (the 2017 scaffold only
  printed the value as text) and shows an inline error for invalid
  input.
- New `barcode_formats` constant, Shiny demo app, testthat suite and
  GitHub Actions R CMD check.
- `Makefile` with document/test/check/install/run/site/update-js
  targets.
- pkgdown documentation site with a “Getting started” vignette and a
  “Development and CI/CD” article, deployed to `gh-pages` by GitHub
  Actions.
- `scripts/release.sh` (`make release`) automates tagging and GitHub
  releases.

## JsBarcode 0.0.0.9000

- Initial htmlwidgets scaffold (2017).
