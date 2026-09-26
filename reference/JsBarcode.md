# Create a barcode widget

Renders a barcode as an SVG using the
[JsBarcode](https://github.com/lindell/JsBarcode) JavaScript library.
The widget works in the RStudio viewer, R Markdown / Quarto documents
and Shiny apps.

## Usage

``` r
JsBarcode(
  value,
  format = "CODE128",
  ...,
  bar_width = 2,
  bar_height = 100,
  display_value = TRUE,
  text = NULL,
  font_size = 20,
  line_color = "#000000",
  background = "#ffffff",
  margin = 10,
  width = NULL,
  height = NULL,
  elementId = NULL
)
```

## Arguments

- value:

  Value to encode. Coerced to a single string.

- format:

  Barcode symbology, one of
  [barcode_formats](https://EnriquePH.github.io/JsBarcode/reference/barcode_formats.md).
  See
  [barcode_format_info](https://EnriquePH.github.io/JsBarcode/reference/barcode_format_info.md)
  for the values each format accepts.

- ...:

  Additional JsBarcode options, passed verbatim using their JavaScript
  (camelCase) names, e.g. `textAlign = "left"`, `font = "serif"`. See
  <https://github.com/lindell/JsBarcode/wiki/Options>. Arguments after
  `...` must be named in full.

- bar_width:

  Width in pixels of a single bar.

- bar_height:

  Height in pixels of the bars.

- display_value:

  Whether to print the value under the barcode.

- text:

  Text to display instead of `value`. `NULL` shows `value`.

- font_size:

  Font size in pixels of the displayed text.

- line_color:

  Colour of the bars and text.

- background:

  Background colour.

- margin:

  Margin in pixels around the barcode.

- width, height:

  Size of the widget container. Must be a valid CSS unit (like `"100%"`,
  `"400px"`, `"auto"`) or a number, which will be coerced to a string
  and have `"px"` appended.

- elementId:

  Optional id for the widget's HTML element.

## Value

An `htmlwidget` object.

## Examples

``` r
JsBarcode("Hello world")

{"x":{"value":"Hello world","options":{"format":"CODE128","width":2,"height":100,"displayValue":true,"fontSize":20,"lineColor":"#000000","background":"#ffffff","margin":10}},"evals":[],"jsHooks":[]}JsBarcode("5901234123457", format = "EAN13", line_color = "#1a4f8b")

{"x":{"value":"5901234123457","options":{"format":"EAN13","width":2,"height":100,"displayValue":true,"fontSize":20,"lineColor":"#1a4f8b","background":"#ffffff","margin":10}},"evals":[],"jsHooks":[]}JsBarcode("12345", bar_height = 40, display_value = FALSE)

{"x":{"value":"12345","options":{"format":"CODE128","width":2,"height":40,"displayValue":false,"fontSize":20,"lineColor":"#000000","background":"#ffffff","margin":10}},"evals":[],"jsHooks":[]}
```
