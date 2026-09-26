# Getting started with JsBarcode

``` r

library(JsBarcode)
```

[`JsBarcode()`](https://EnriquePH.github.io/JsBarcode/reference/JsBarcode.md)
turns a value into an SVG barcode widget. Widgets render in the RStudio
viewer, in HTML documents such as this one, and in Shiny apps.

## Basic usage

The default symbology is CODE128, which accepts any ASCII text.

``` r

JsBarcode("Hello world")
```

## Formats

Pick a symbology with `format`. All supported values are in
`barcode_formats`:

``` r

barcode_formats
#>  [1] "CODE128"    "CODE128A"   "CODE128B"   "CODE128C"   "EAN13"     
#>  [6] "EAN8"       "EAN5"       "EAN2"       "UPC"        "UPCE"      
#> [11] "CODE39"     "CODE93"     "ITF"        "ITF14"      "MSI"       
#> [16] "MSI10"      "MSI11"      "MSI1010"    "MSI1110"    "pharmacode"
#> [21] "codabar"
```

``` r

JsBarcode("5901234123457", format = "EAN13")
```

``` r

JsBarcode("123456789999", format = "UPC")
```

``` r

JsBarcode("CODE39 TEXT", format = "CODE39")
```

A value that is not valid for the chosen format produces an inline
message instead of a barcode:

``` r

JsBarcode("not a number", format = "EAN13")
```

## Styling

``` r

JsBarcode("ABC-123",
          bar_width = 3,
          bar_height = 60,
          line_color = "#1a4f8b",
          background = "#eef3fa",
          font_size = 16)
```

``` r


JsBarcode("NO-TEXT", display_value = FALSE, bar_height = 40)
```

``` r

JsBarcode("id-0042", text = "Custom label")
```

Any other [JsBarcode
option](https://github.com/lindell/JsBarcode/wiki/Options) can be passed
through `...` using its JavaScript name:

``` r

JsBarcode("Top text", textPosition = "top", textAlign = "left", font = "serif")
```

## Shiny

``` r

library(shiny)

ui <- fluidPage(JsBarcodeOutput("code"))
server <- function(input, output) {
  output$code <- renderJsBarcode(JsBarcode("Hello Shiny"))
}
shinyApp(ui, server)
```

A full demo app ships with the package:

``` r

shiny::runApp(system.file("examples/shiny", package = "JsBarcode"))
```
