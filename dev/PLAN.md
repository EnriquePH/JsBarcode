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

## Roadmap

Principio: cerrar y distribuir cada versión antes de añadir funcionalidad. No
se añaden renderers canvas/img, npm/bower ni frameworks JS: JsBarcode
vendorizado + binding htmlwidget pequeño.

### v0.1.0 — release (actual)

- [x] Errores JS: entrada inválida (callback `valid`) separada de otros fallos.
- [x] README describe las 5 configuraciones de CI.
- [x] Permisos normalizados (644; solo `scripts/release.sh` ejecutable).
- [x] `barcode_format_info` (22 formatos, reglas de JsBarcode 3.12.3, ejemplo
      válido verificado en navegador) + ayuda contextual en la app Shiny.
      Se añade `CODE93FullASCII`.
- [x] Badge de R en README.
- [ ] `make release` → tag v0.1.0 + GitHub Release.
- [ ] Publicar en r-universe (`EnriquePH.r-universe.dev`, repo `EnriquePH/EnriquePH.r-universe.dev` con `packages.json`).
- [ ] Badges de r-universe en README.

### v0.2.0 — calidad y exportación

- [ ] Test de integración con **chromote**: R → htmlwidget → `JsBarcode.js` →
      JsBarcode 3.12.3 → SVG; comprobar `<svg>`/`<rect>` y el mensaje de error.
      `skip_on_cran()` + `skip_if_not_installed("chromote")`; en CI, Chrome disponible.
- [ ] `validate_barcode(value, format)` → lógico. Implementación mínima en R
      (dígito de control EAN-13/EAN-8/UPC/ITF-14, charset CODE39/CODE128C/ITF,
      numérico MSI/pharmacode). Opcional `JsBarcode(..., validate = TRUE)`;
      no por defecto, para no duplicar la lógica de la librería.
- [ ] `save_barcode(widget, "file.svg")`: SVG primero (sin dependencias
      nuevas si es posible; si hace falta ejecutar JS, chromote en Suggests).
      PNG después, opcional.
- [ ] Cobertura con `covr` + badge.

### v0.3.0 — hojas de etiquetas

- [ ] `barcode_sheet(values, format, ...)`: widget/HTML con varios códigos;
      acepta vector o `data.frame` (`code`, `label`). `JsBarcode()` sigue siendo
      de un solo valor.
- [ ] Layout imprimible (rejilla, tamaño de etiqueta, CSS `@media print`).

### 1.0.0 — API estable

- [ ] Revisión de nombres/argumentos, deprecaciones si hace falta.
- [ ] Preparación CRAN: `cran-comments.md`, `urlchecker`, `rhub::rhub_check()`.

## Decisiones tomadas

- Se mantiene el nombre de la función `JsBarcode()` (compatibilidad con 2017),
  argumentos en snake_case.
- `width`/`height` son del contenedor del widget; el tamaño de las barras va en
  `bar_width`/`bar_height`.
- Sin bower ni npm: la librería se actualiza con `curl` desde el registry de npm
  (procedimiento en `.claude/CLAUDE.md`).
