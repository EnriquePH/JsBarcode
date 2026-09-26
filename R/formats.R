format_row <- function(format, name, family, type, character_set, length,
                       check_digit, description, typical_use, example) {
  data.frame(
    format = format, name = name, family = family, type = type,
    character_set = character_set, length = length,
    check_digit = check_digit, description = description,
    typical_use = typical_use, example = example,
    stringsAsFactors = FALSE
  )
}

#' Barcode format reference table
#'
#' One row per symbology supported by the bundled JsBarcode library, with the
#' data each format accepts. The rules come from the validation code of
#' JsBarcode 3.12.3. Use it to build help text, e.g. in a Shiny app, or to pick
#' a valid example value for a format.
#'
#' All formats are linear (1D). 2D symbologies such as QR Code, Data Matrix,
#' PDF417 and Aztec are not supported by JsBarcode.
#'
#' @format A data frame with one row per format and these columns:
#' \describe{
#'   \item{format}{Value for the `format` argument of [JsBarcode()].}
#'   \item{name}{Human-readable name.}
#'   \item{family}{Symbology family (`"CODE128"`, `"EAN/UPC"`, `"CODE39"`,
#'     `"CODE93"`, `"ITF"`, `"MSI"`, `"Pharmacode"`, `"Codabar"`).}
#'   \item{type}{`"numeric"` or `"alphanumeric"`.}
#'   \item{character_set}{Characters accepted in `value`.}
#'   \item{length}{Accepted length of `value`.}
#'   \item{check_digit}{How the check digit or character is handled.}
#'   \item{description}{One-sentence description of the format.}
#'   \item{typical_use}{Where the format is typically used.}
#'   \item{example}{A value that JsBarcode accepts for this format.}
#' }
#'
#' @seealso [barcode_formats] for just the format names.
#'
#' @examples
#' barcode_format_info[, c("format", "name", "length")]
#'
#' info <- barcode_format_info[barcode_format_info$format == "EAN13", ]
#' info$check_digit
#' JsBarcode(info$example, format = info$format)
#' @export
barcode_format_info <- rbind(
  format_row(
    "CODE128", "Code 128 (automatic)", "CODE128", "alphanumeric",
    "ASCII characters 0-127", "Variable",
    "Mod 103, added automatically",
    "High-density code for any ASCII text; switches between subsets A, B and C automatically to produce the shortest barcode.",
    "Logistics, shipping labels, general identification",
    "Example 1234"
  ),
  format_row(
    "CODE128A", "Code 128 subset A", "CODE128", "alphanumeric",
    "Uppercase letters, digits, punctuation and ASCII control characters (0-95); no lowercase",
    "Variable",
    "Mod 103, added automatically",
    "Code 128 restricted to subset A, which adds control characters but has no lowercase letters.",
    "Industrial and legacy systems that need control characters",
    "EXAMPLE-128A"
  ),
  format_row(
    "CODE128B", "Code 128 subset B", "CODE128", "alphanumeric",
    "Printable ASCII (32-127): upper- and lowercase letters, digits, punctuation",
    "Variable",
    "Mod 103, added automatically",
    "Code 128 restricted to subset B, suited to mixed-case text.",
    "General-purpose text labels",
    "Example-128B"
  ),
  format_row(
    "CODE128C", "Code 128 subset C", "CODE128", "numeric",
    "Digits 0-9", "Even number of digits (encoded in pairs)",
    "Mod 103, added automatically",
    "Code 128 restricted to subset C, which packs two digits per symbol for very compact numeric codes.",
    "Long numeric identifiers, serial numbers",
    "12345678"
  ),
  format_row(
    "EAN13", "EAN-13", "EAN/UPC", "numeric",
    "Digits 0-9", "12 digits (check digit is added) or 13 digits (check digit is verified)",
    "Mod 10; computed if 12 digits are given, verified if 13",
    "International retail product code (GTIN-13).",
    "Retail products worldwide",
    "5901234123457"
  ),
  format_row(
    "EAN8", "EAN-8", "EAN/UPC", "numeric",
    "Digits 0-9", "7 digits (check digit is added) or 8 digits (check digit is verified)",
    "Mod 10; computed if 7 digits are given, verified if 8",
    "Short version of EAN-13 (GTIN-8) for small packages.",
    "Small retail products",
    "96385074"
  ),
  format_row(
    "EAN5", "EAN-5 add-on", "EAN/UPC", "numeric",
    "Digits 0-9", "Exactly 5 digits",
    "None (parity pattern only)",
    "Five-digit supplement printed next to an EAN-13 or UPC-A barcode.",
    "Suggested retail price on books",
    "54495"
  ),
  format_row(
    "EAN2", "EAN-2 add-on", "EAN/UPC", "numeric",
    "Digits 0-9", "Exactly 2 digits",
    "None (parity pattern only)",
    "Two-digit supplement printed next to an EAN-13 or UPC-A barcode.",
    "Issue number of magazines and periodicals",
    "53"
  ),
  format_row(
    "UPC", "UPC-A", "EAN/UPC", "numeric",
    "Digits 0-9", "11 digits (check digit is added) or 12 digits (check digit is verified)",
    "Mod 10; computed if 11 digits are given, verified if 12",
    "Universal Product Code used for retail products (GTIN-12).",
    "Retail products, mainly in the United States and Canada",
    "123456789999"
  ),
  format_row(
    "UPCE", "UPC-E", "EAN/UPC", "numeric",
    "Digits 0-9",
    "6 digits (number system 0 assumed) or 8 digits (number system 0 or 1, 6 digits, check digit)",
    "Mod 10 of the expanded UPC-A; verified if 8 digits are given",
    "Zero-suppressed, compact form of UPC-A.",
    "Small retail packages with little space",
    "123456"
  ),
  format_row(
    "CODE39", "Code 39", "CODE39", "alphanumeric",
    "Uppercase A-Z, digits 0-9, space and - . $ / + %", "Variable",
    "None by default; optional Mod 43 with `mod43 = TRUE`",
    "Self-checking alphanumeric code; simple and widely supported, but not very compact.",
    "Industry, automotive, defence, ID badges",
    "CODE39 EXAMPLE"
  ),
  format_row(
    "CODE93", "Code 93", "CODE93", "alphanumeric",
    "Uppercase A-Z, digits 0-9, space and - . $ / + %", "Variable",
    "Two check characters (C and K), added automatically",
    "More compact and more secure successor of Code 39 with the same character set.",
    "Logistics, postal services, electronics",
    "CODE93 EXAMPLE"
  ),
  format_row(
    "CODE93FullASCII", "Code 93 Full ASCII", "CODE93", "alphanumeric",
    "ASCII characters 0-127", "Variable",
    "Two check characters (C and K), added automatically",
    "Code 93 extended to the full ASCII set, including lowercase letters, using shift characters.",
    "Code 93 applications that need lowercase or symbols",
    "Code93 Full ASCII"
  ),
  format_row(
    "ITF", "Interleaved 2 of 5", "ITF", "numeric",
    "Digits 0-9", "Even number of digits",
    "None",
    "Compact numeric code that interleaves pairs of digits in bars and spaces.",
    "Warehousing, cartons, distribution",
    "123456"
  ),
  format_row(
    "ITF14", "ITF-14", "ITF", "numeric",
    "Digits 0-9", "13 digits (check digit is added) or 14 digits (check digit is verified)",
    "Mod 10; computed if 13 digits are given, verified if 14",
    "Interleaved 2 of 5 carrying a 14-digit GTIN for trade units.",
    "Shipping cartons and outer cases",
    "98765432109213"
  ),
  format_row(
    "MSI", "MSI Plessey", "MSI", "numeric",
    "Digits 0-9", "Variable",
    "None",
    "Numeric code without check digit.",
    "Inventory control, supermarket shelf labels",
    "1234"
  ),
  format_row(
    "MSI10", "MSI Plessey (Mod 10)", "MSI", "numeric",
    "Digits 0-9", "Variable",
    "One Mod 10 check digit, added automatically",
    "MSI with a Mod 10 check digit; the most common MSI variant.",
    "Inventory control, shelf labels",
    "1234"
  ),
  format_row(
    "MSI11", "MSI Plessey (Mod 11)", "MSI", "numeric",
    "Digits 0-9", "Variable",
    "One Mod 11 check digit, added automatically",
    "MSI with a Mod 11 check digit.",
    "Inventory control, shelf labels",
    "1234"
  ),
  format_row(
    "MSI1010", "MSI Plessey (Mod 10 + Mod 10)", "MSI", "numeric",
    "Digits 0-9", "Variable",
    "Two Mod 10 check digits, added automatically",
    "MSI with two successive Mod 10 check digits.",
    "Inventory control, shelf labels",
    "1234"
  ),
  format_row(
    "MSI1110", "MSI Plessey (Mod 11 + Mod 10)", "MSI", "numeric",
    "Digits 0-9", "Variable",
    "Mod 11 then Mod 10 check digits, added automatically",
    "MSI with a Mod 11 check digit followed by a Mod 10 check digit.",
    "Inventory control, shelf labels",
    "1234"
  ),
  format_row(
    "pharmacode", "Pharmacode", "Pharmacode", "numeric",
    "Digits 0-9", "An integer from 3 to 131070",
    "None",
    "Binary code of thin and wide bars that encodes a single number; no human-readable text.",
    "Packaging control in the pharmaceutical industry",
    "1234"
  ),
  format_row(
    "codabar", "Codabar", "Codabar", "alphanumeric",
    "Digits 0-9 and - $ : / . +, between optional start/stop characters A-D",
    "Variable",
    "None",
    "Older self-checking code; start and stop characters A are added if omitted.",
    "Libraries, blood banks, laboratories, courier services",
    "A1234-5678B"
  )
)

#' Barcode formats supported by the bundled JsBarcode library
#'
#' Character vector with every symbology accepted by the `format` argument of
#' [JsBarcode()]. See [barcode_format_info] for what each format accepts.
#'
#' @format A character vector.
#' @export
barcode_formats <- barcode_format_info$format
