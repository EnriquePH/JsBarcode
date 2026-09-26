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

Pick a symbology with `format`. `barcode_format_info` describes every
supported format: the characters it accepts, its length, how the check
digit is handled, and a valid example value.

``` r

knitr::kable(barcode_format_info[, c("format", "name", "character_set",
                                     "length", "check_digit")])
```

| format | name | character_set | length | check_digit |
|:---|:---|:---|:---|:---|
| CODE128 | Code 128 (automatic) | ASCII characters 0-127 | Variable | Mod 103, added automatically |
| CODE128A | Code 128 subset A | Uppercase letters, digits, punctuation and ASCII control characters (0-95); no lowercase | Variable | Mod 103, added automatically |
| CODE128B | Code 128 subset B | Printable ASCII (32-127): upper- and lowercase letters, digits, punctuation | Variable | Mod 103, added automatically |
| CODE128C | Code 128 subset C | Digits 0-9 | Even number of digits (encoded in pairs) | Mod 103, added automatically |
| EAN13 | EAN-13 | Digits 0-9 | 12 digits (check digit is added) or 13 digits (check digit is verified) | Mod 10; computed if 12 digits are given, verified if 13 |
| EAN8 | EAN-8 | Digits 0-9 | 7 digits (check digit is added) or 8 digits (check digit is verified) | Mod 10; computed if 7 digits are given, verified if 8 |
| EAN5 | EAN-5 add-on | Digits 0-9 | Exactly 5 digits | None (parity pattern only) |
| EAN2 | EAN-2 add-on | Digits 0-9 | Exactly 2 digits | None (parity pattern only) |
| UPC | UPC-A | Digits 0-9 | 11 digits (check digit is added) or 12 digits (check digit is verified) | Mod 10; computed if 11 digits are given, verified if 12 |
| UPCE | UPC-E | Digits 0-9 | 6 digits (number system 0 assumed) or 8 digits (number system 0 or 1, 6 digits, check digit) | Mod 10 of the expanded UPC-A; verified if 8 digits are given |
| CODE39 | Code 39 | Uppercase A-Z, digits 0-9, space and - . \$ / + % | Variable | None by default; optional Mod 43 with `mod43 = TRUE` |
| CODE93 | Code 93 | Uppercase A-Z, digits 0-9, space and - . \$ / + % | Variable | Two check characters (C and K), added automatically |
| CODE93FullASCII | Code 93 Full ASCII | ASCII characters 0-127 | Variable | Two check characters (C and K), added automatically |
| ITF | Interleaved 2 of 5 | Digits 0-9 | Even number of digits | None |
| ITF14 | ITF-14 | Digits 0-9 | 13 digits (check digit is added) or 14 digits (check digit is verified) | Mod 10; computed if 13 digits are given, verified if 14 |
| MSI | MSI Plessey | Digits 0-9 | Variable | None |
| MSI10 | MSI Plessey (Mod 10) | Digits 0-9 | Variable | One Mod 10 check digit, added automatically |
| MSI11 | MSI Plessey (Mod 11) | Digits 0-9 | Variable | One Mod 11 check digit, added automatically |
| MSI1010 | MSI Plessey (Mod 10 + Mod 10) | Digits 0-9 | Variable | Two Mod 10 check digits, added automatically |
| MSI1110 | MSI Plessey (Mod 11 + Mod 10) | Digits 0-9 | Variable | Mod 11 then Mod 10 check digits, added automatically |
| pharmacode | Pharmacode | Digits 0-9 | An integer from 3 to 131070 | None |
| codabar | Codabar | Digits 0-9 and - \$ : / . +, between optional start/stop characters A-D | Variable | None |

All formats are linear (1D). 2D codes such as QR Code, Data Matrix,
PDF417 and Aztec are not supported by JsBarcode.

The `example` column gives a value that is valid for each format:

``` r

info <- barcode_format_info[barcode_format_info$format == "ITF14", ]
JsBarcode(info$example, format = info$format)
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
