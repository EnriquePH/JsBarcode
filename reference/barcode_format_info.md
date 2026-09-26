# Barcode format reference table

One row per symbology supported by the bundled JsBarcode library, with
the data each format accepts. The rules come from the validation code of
JsBarcode 3.12.3. Use it to build help text, e.g. in a Shiny app, or to
pick a valid example value for a format.

## Usage

``` r
barcode_format_info
```

## Format

A data frame with one row per format and these columns:

- format:

  Value for the `format` argument of
  [`JsBarcode()`](https://EnriquePH.github.io/JsBarcode/reference/JsBarcode.md).

- name:

  Human-readable name.

- family:

  Symbology family (`"CODE128"`, `"EAN/UPC"`, `"CODE39"`, `"CODE93"`,
  `"ITF"`, `"MSI"`, `"Pharmacode"`, `"Codabar"`).

- type:

  `"numeric"` or `"alphanumeric"`.

- character_set:

  Characters accepted in `value`.

- length:

  Accepted length of `value`.

- check_digit:

  How the check digit or character is handled.

- description:

  One-sentence description of the format.

- typical_use:

  Where the format is typically used.

- example:

  A value that JsBarcode accepts for this format.

## Details

All formats are linear (1D). 2D symbologies such as QR Code, Data
Matrix, PDF417 and Aztec are not supported by JsBarcode.

## See also

[barcode_formats](https://EnriquePH.github.io/JsBarcode/reference/barcode_formats.md)
for just the format names.

## Examples

``` r
barcode_format_info[, c("format", "name", "length")]
#>             format                          name
#> 1          CODE128          Code 128 (automatic)
#> 2         CODE128A             Code 128 subset A
#> 3         CODE128B             Code 128 subset B
#> 4         CODE128C             Code 128 subset C
#> 5            EAN13                        EAN-13
#> 6             EAN8                         EAN-8
#> 7             EAN5                  EAN-5 add-on
#> 8             EAN2                  EAN-2 add-on
#> 9              UPC                         UPC-A
#> 10            UPCE                         UPC-E
#> 11          CODE39                       Code 39
#> 12          CODE93                       Code 93
#> 13 CODE93FullASCII            Code 93 Full ASCII
#> 14             ITF            Interleaved 2 of 5
#> 15           ITF14                        ITF-14
#> 16             MSI                   MSI Plessey
#> 17           MSI10          MSI Plessey (Mod 10)
#> 18           MSI11          MSI Plessey (Mod 11)
#> 19         MSI1010 MSI Plessey (Mod 10 + Mod 10)
#> 20         MSI1110 MSI Plessey (Mod 11 + Mod 10)
#> 21      pharmacode                    Pharmacode
#> 22         codabar                       Codabar
#>                                                                                          length
#> 1                                                                                      Variable
#> 2                                                                                      Variable
#> 3                                                                                      Variable
#> 4                                                      Even number of digits (encoded in pairs)
#> 5                       12 digits (check digit is added) or 13 digits (check digit is verified)
#> 6                         7 digits (check digit is added) or 8 digits (check digit is verified)
#> 7                                                                              Exactly 5 digits
#> 8                                                                              Exactly 2 digits
#> 9                       11 digits (check digit is added) or 12 digits (check digit is verified)
#> 10 6 digits (number system 0 assumed) or 8 digits (number system 0 or 1, 6 digits, check digit)
#> 11                                                                                     Variable
#> 12                                                                                     Variable
#> 13                                                                                     Variable
#> 14                                                                        Even number of digits
#> 15                      13 digits (check digit is added) or 14 digits (check digit is verified)
#> 16                                                                                     Variable
#> 17                                                                                     Variable
#> 18                                                                                     Variable
#> 19                                                                                     Variable
#> 20                                                                                     Variable
#> 21                                                                  An integer from 3 to 131070
#> 22                                                                                     Variable

info <- barcode_format_info[barcode_format_info$format == "EAN13", ]
info$check_digit
#> [1] "Mod 10; computed if 12 digits are given, verified if 13"
JsBarcode(info$example, format = info$format)

{"x":{"value":"5901234123457","options":{"format":"EAN13","width":2,"height":100,"displayValue":true,"fontSize":20,"lineColor":"#000000","background":"#ffffff","margin":10}},"evals":[],"jsHooks":[]}
```
