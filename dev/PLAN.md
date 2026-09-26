# PLAN — JsBarcode (R package)

Last updated: 2026-09-26

## Goal

Turn the 2017 scaffold into a professional, distributable R package: clean
API, current JS library, tests, CI, documentation, and publication on GitHub,
r-universe and eventually CRAN.

## Phase 1 — Reorganisation and update ✅ (2026-09-26)

- [x] The repo root is now the package (it used to live in `JsBarcode/`).
- [x] 2017 material moved out to `../22-JsBarcode_legacy-2017/`: patched
      `htmlwidgets` 0.9 clone (only change: `--allow-root` for bower),
      `create-widget.R`, `.Rhistory`, `test.html/.Rhtml`, `figure/`,
      `test_package.R`, `.bowerrc`, bower sources of JsBarcode 3.8.0, and
      `snapshot-package-2017.tar` with the complete original package.
- [x] JsBarcode 3.8.0 → **3.12.3**; only `JsBarcode.all.min.js` + LICENSE are
      vendored (from ~1 MB down to ~65 KB).
- [x] JS binding fixed: it used to print the value as text; it now draws an SVG
      and shows a readable error when the value is invalid for the format.
- [x] New API: `format`, `bar_width`, `bar_height`, `display_value`, `text`,
      `font_size`, `line_color`, `background`, `margin`, `...`;
      `barcode_formats` constant; argument validation.
- [x] Real DESCRIPTION (title, description, MIT licence, authors including
      Johan Lindell as copyright holder of the JS library), roxygen2 markdown.
- [x] testthat 3e tests, Shiny demo app, README, NEWS, GitHub Actions
      `R-CMD-check` workflow, CLAUDE.md (in `.claude/`; this plan in `dev/`).
- [x] Verified: `devtools::check()` → 0 errors / 0 warnings / 0 notes; real
      rendering in headless Chromium.

## Phase 2 — Version control, CI/CD and documentation ✅ (2026-09-26)

- [x] `Makefile` with document/test/check/build/install/run/site/update-js/release/clean targets.
- [x] pkgdown site (`_pkgdown.yml`, *Getting started* vignette, *Development
      and CI/CD* article), deployed to `gh-pages` by `pkgdown.yaml`.
- [x] Author: Enrique Pérez Herrero; URL/BugReports in DESCRIPTION.
- [x] `scripts/release.sh` + `make release` (tag, GitHub release, dev bump).
- [x] `git init`, branch `main`, remote `EnriquePH/JsBarcode`, first push.
- [x] Both workflows green on GitHub (5 R-CMD-check configurations + pkgdown).
- [x] GitHub Pages serving `gh-pages` / root:
      <https://EnriquePH.github.io/JsBarcode/>.

## Roadmap

Principle: close and ship each version before adding features. No canvas/img
renderers, npm/bower or JS frameworks: vendored JsBarcode + a small htmlwidget
binding.

### v0.1.0 — release (current)

- [x] JS errors: invalid input (`valid` callback) separated from other failures.
- [x] README lists the 5 CI configurations.
- [x] File modes normalised (644; only `scripts/release.sh` executable).
- [x] `barcode_format_info` (22 formats, JsBarcode 3.12.3 validation rules,
      valid example verified in a browser) + contextual help in the Shiny app.
      `CODE93FullASCII` added.
- [x] R badge in README.
- [x] Everything in the repo written in English.
- [ ] `make release` → tag v0.1.0 + GitHub Release.
- [ ] Publish on r-universe (`EnriquePH.r-universe.dev`, repo
      `EnriquePH/EnriquePH.r-universe.dev` with `packages.json`).
- [ ] r-universe badges in README.

### v0.2.0 — quality and export

- [ ] **chromote** integration test: R → htmlwidget → `JsBarcode.js` →
      JsBarcode 3.12.3 → SVG; assert `<svg>`/`<rect>` and the error message.
      `skip_on_cran()` + `skip_if_not_installed("chromote")`; Chrome is
      available in CI.
- [ ] `validate_barcode(value, format)` → logical. Minimal R implementation
      (check digit for EAN-13/EAN-8/UPC/ITF-14, character sets for
      CODE39/CODE128C/ITF, numeric MSI/pharmacode), reusing the rules in
      `barcode_format_info`. Optional `JsBarcode(..., validate = TRUE)`, off by
      default so the library's logic is not duplicated.
- [ ] `save_barcode(widget, "file.svg")`: SVG first (no new dependencies if
      possible; if JS must run, chromote in Suggests). PNG later, optional.
- [ ] Coverage with `covr` + badge.

### v0.3.0 — label sheets

- [ ] `barcode_sheet(values, format, ...)`: widget/HTML with several codes;
      accepts a vector or a `data.frame` (`code`, `label`). `JsBarcode()`
      stays single-valued.
- [ ] Printable layout (grid, label size, CSS `@media print`).

### 1.0.0 — stable API

- [ ] Review names/arguments, deprecate where needed.
- [ ] CRAN preparation: `cran-comments.md`, `urlchecker`, `rhub::rhub_check()`.

## Decisions

- The function keeps the name `JsBarcode()` (compatibility with 2017);
  arguments are snake_case.
- `width`/`height` are the widget container; bar size is
  `bar_width`/`bar_height`.
- No bower or npm: the library is updated with `curl` from the npm registry
  (procedure in `.claude/CLAUDE.md`, automated by `make update-js`).
- Everything in the repository is written in English.
