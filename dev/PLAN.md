# PLAN — JsBarcode (paquete R)

Última actualización: 2026-09-26

## Objetivo

Convertir el scaffold de 2017 en un paquete R profesional y publicable:
API limpia, librería JS actual, tests, CI, documentación y, a medio plazo,
publicación en GitHub (y opcionalmente CRAN / r-universe).

## Fase 1 — Reorganización y actualización ✅ (2026-09-26)

- [x] La raíz del repo pasa a ser el paquete (antes estaba en `JsBarcode/`).
- [x] Material de 2017 movido fuera, a `../22-JsBarcode_legacy-2017/`:
      clon parcheado de `htmlwidgets` 0.9 (solo cambiaba `--allow-root` en bower),
      `create-widget.R`, `.Rhistory`, `test.html/.Rhtml`, `figure/`,
      `test_package.R`, `.bowerrc`, fuentes bower de JsBarcode 3.8.0 y un
      `snapshot-package-2017.tar` con el paquete original completo.
- [x] JsBarcode 3.8.0 → **3.12.3**; se vendoriza solo `JsBarcode.all.min.js` + LICENSE
      (de ~1 MB a ~65 KB).
- [x] Binding JS reparado: antes solo escribía el texto; ahora dibuja un SVG y
      muestra un error legible si el valor no es válido para el formato.
- [x] API nueva: `format`, `bar_width`, `bar_height`, `display_value`, `text`,
      `font_size`, `line_color`, `background`, `margin`, `...`; constante
      `barcode_formats`; validación de argumentos.
- [x] DESCRIPTION real (título, descripción, licencia MIT, autores incl. Johan
      Lindell como cph de la librería JS), roxygen2 7 con markdown.
- [x] Tests testthat 3e (26 expectativas), app Shiny de ejemplo, README, NEWS,
      workflow GitHub Actions `R-CMD-check`, CLAUDE.md (ahora en `.claude/`; este plan en `dev/`).
- [x] Verificado: `devtools::check()` → 0 errors / 0 warnings / 0 notes;
      render real en Chromium headless (CODE128 dibuja barras; EAN13 inválido
      muestra el mensaje de error).

## Fase 2 — Control de versiones, CI/CD y documentación ✅ (2026-09-26)

- [x] `Makefile` con targets document/test/check/build/install/run/site/update-js/clean.
- [x] Web pkgdown (`_pkgdown.yml`, vignette *Getting started*, artículo
      *Development and CI/CD*), desplegada a `gh-pages` por `pkgdown.yaml`.
- [x] Autor: Enrique Pérez Herrero; URL/BugReports en DESCRIPTION.
- [x] `scripts/release.sh` + `make release` (tag, GitHub release, bump dev).
- [x] `git init`, rama `main`, remoto `EnriquePH/JsBarcode`, primer push.
- [ ] Activar GitHub Pages: Settings → Pages → rama `gh-pages`, carpeta `/`
      (tras la primera ejecución de `pkgdown.yaml`).
- [ ] Confirmar que ambos workflows pasan en GitHub (Linux/macOS/Windows).
- [ ] Primera release: `make release` → v0.1.0.

## Fase 3 — Funcionalidad

- [ ] Vectorización: `JsBarcode(c("A","B","C"))` → varios códigos en un widget
      (o helper `barcode_sheet()` para etiquetas imprimibles).
- [ ] Exportar a fichero: `save_barcode(x, "code.svg" | "code.png")`
      (SVG vía `saveWidget` + extracción; PNG con `webshot2`/`chromote`).
- [ ] Renderer `canvas`/`img` opcional (`renderer = c("svg","canvas","img")`).
- [ ] Validación de valores en R para EAN/UPC (dígito de control) para dar el
      error en R antes de llegar al navegador.
- [ ] Soporte Quarto/R Markdown estático probado (vignette).

## Fase 4 — Calidad y documentación

- [ ] Cobertura con `covr` + badge.
- [ ] Test JS de render (chromote) en CI, no solo tests del payload R.
- [ ] `lintr`/`styler` en CI.

## Fase 5 — Distribución (opcional)

- [ ] r-universe.
- [ ] Preparación CRAN: `cran-comments.md`, `urlchecker`, `rhub::rhub_check()`.

## Decisiones tomadas

- Se mantiene el nombre de la función `JsBarcode()` (compatibilidad con 2017),
  argumentos en snake_case.
- `width`/`height` son del contenedor del widget; el tamaño de las barras va en
  `bar_width`/`bar_height`.
- Sin bower ni npm: la librería se actualiza con `curl` desde el registry de npm
  (procedimiento en `.claude/CLAUDE.md`).
