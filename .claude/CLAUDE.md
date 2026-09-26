# CLAUDE.md

Guía para Claude Code en este repositorio.

## Qué es

Paquete R **JsBarcode**: un `htmlwidget` que envuelve la librería JavaScript
[JsBarcode](https://github.com/lindell/JsBarcode) (vendorizada, v3.12.3) para
generar códigos de barras 1D en SVG (viewer de RStudio, R Markdown/Quarto, Shiny).

La raíz del repo **es** el paquete. Este fichero vive en `.claude/` y el plan en `dev/` para que pkgdown no los publique (pkgdown renderiza todo `*.md` de la raíz). El material de 2017 (clon parcheado de
`htmlwidgets`, script de scaffolding, `.Rhistory`, fuentes bower de JsBarcode
3.8.0) está fuera del repo en `../22-JsBarcode_legacy-2017/`. No reintroducirlo.

## Estructura

| Ruta | Contenido |
|---|---|
| `R/JsBarcode.R` | API: `JsBarcode()`, `JsBarcodeOutput()`, `renderJsBarcode()` |
| `R/formats.R` | `barcode_format_info` (tabla de formatos, fuente única) y `barcode_formats` (derivado) |
| `inst/htmlwidgets/JsBarcode.js` | Binding JS: crea un `<svg>` y llama a `JsBarcode(svg, value, options)` |
| `inst/htmlwidgets/JsBarcode.yaml` | Declara la dependencia JS (nombre, versión, ruta) |
| `inst/htmlwidgets/lib/jsbarcode-<ver>/` | `JsBarcode.all.min.js` + `LICENSE` — solo esos dos ficheros |
| `inst/examples/shiny/app.R` | App demo |
| `tests/testthat/` | Tests (testthat 3e) |
| `man/`, `NAMESPACE` | Generados por roxygen2 — **no editar a mano** |
| `dev/PLAN.md` | Hoja de ruta y estado (fuera del paquete y de la web) |
| `scripts/release.sh` | Lanzamiento: versión, check, tag, push, GitHub release, bump a .9000 (`make release`) |
| `Makefile` | Tareas: document, test, check, install, run, site, update-js, clean |
| `_pkgdown.yml`, `vignettes/` | Web de documentación; `vignettes/articles/development.Rmd` documenta CI/CD |
| `.github/workflows/` | `R-CMD-check.yaml` (CI) y `pkgdown.yaml` (CD a `gh-pages`) |

## Comandos

```bash
make document   # tras tocar roxygen en R/
make test
make check      # debe quedar 0 errors / 0 warnings
make site       # construir la web pkgdown en docs/
```

## Convenciones

- Argumentos R en `snake_case`; se traducen a los nombres camelCase de
  JsBarcode dentro de `JsBarcode()` (`bar_width` → `width`, `line_color` →
  `lineColor`, …). `width`/`height` del widget son el tamaño del contenedor, no
  de las barras.
- Opciones extra van por `...` con su nombre JS y sobrescriben a las anteriores
  (`utils::modifyList`). Las opciones `NULL` se eliminan antes de enviar a JS.
- Validar argumentos en R con mensajes claros (`stop(..., call. = FALSE)`); los
  errores de codificación (valor inválido para el formato) se muestran en el
  widget, no en R.
- Cada cambio de comportamiento: test en `tests/testthat/` + entrada en `NEWS.md`.
- Documentación del usuario (README, roxygen, NEWS) en inglés; CLAUDE.md y
  PLAN.md en español.

## Actualizar la librería JsBarcode

Automático: `make update-js` (o `make update-js JSVER=x.y.z`). Pasos manuales:

1. `curl -sL https://registry.npmjs.org/jsbarcode/latest | jq -r .version`
2. Descargar `https://registry.npmjs.org/jsbarcode/-/jsbarcode-<ver>.tgz`,
   copiar `package/dist/JsBarcode.all.min.js` y `package/MIT-LICENSE.txt`
   (como `LICENSE`) a `inst/htmlwidgets/lib/jsbarcode-<ver>/`; borrar la carpeta
   de la versión anterior.
3. Actualizar versión/ruta en `JsBarcode.yaml`, el test de dependencia, README y
   NEWS. Revisar `src/barcodes/index.js` y los `valid()` de la nueva versión y
   actualizar `barcode_format_info` en `R/formats.R` (cada `example` debe
   renderizar sin error).

## Entorno

R 4.5 en Linux; no hay `npm`/`node` (usar `curl` contra el registry).
Repo: <https://github.com/EnriquePH/JsBarcode> (rama `main`). Web de
documentación: <https://EnriquePH.github.io/JsBarcode/>, desplegada por
`.github/workflows/pkgdown.yaml` en la rama `gh-pages` (no editar a mano; `docs/`
está en `.gitignore`). Tareas habituales: `make help`.
