#' Barcode formats supported by the bundled JsBarcode library
#'
#' Character vector with every symbology accepted by the `format` argument of
#' [JsBarcode()].
#'
#' @format A character vector.
#' @export
barcode_formats <- c(
  "CODE128", "CODE128A", "CODE128B", "CODE128C",
  "EAN13", "EAN8", "EAN5", "EAN2", "UPC", "UPCE",
  "CODE39", "CODE93",
  "ITF", "ITF14",
  "MSI", "MSI10", "MSI11", "MSI1010", "MSI1110",
  "pharmacode", "codabar"
)

#' Create a barcode widget
#'
#' Renders a barcode as an SVG using the
#' [JsBarcode](https://github.com/lindell/JsBarcode) JavaScript library. The
#' widget works in the RStudio viewer, R Markdown / Quarto documents and Shiny
#' apps.
#'
#' @param value Value to encode. Coerced to a single string.
#' @param format Barcode symbology, one of [barcode_formats].
#' @param ... Additional JsBarcode options, passed verbatim using their
#'   JavaScript (camelCase) names, e.g. `textAlign = "left"`, `font = "serif"`.
#'   See <https://github.com/lindell/JsBarcode/wiki/Options>. Arguments after
#'   `...` must be named in full.
#' @param bar_width Width in pixels of a single bar.
#' @param bar_height Height in pixels of the bars.
#' @param display_value Whether to print the value under the barcode.
#' @param text Text to display instead of `value`. `NULL` shows `value`.
#' @param font_size Font size in pixels of the displayed text.
#' @param line_color Colour of the bars and text.
#' @param background Background colour.
#' @param margin Margin in pixels around the barcode.
#' @param width,height Size of the widget container. Must be a valid CSS unit
#'   (like `"100%"`, `"400px"`, `"auto"`) or a number, which will be coerced to
#'   a string and have `"px"` appended.
#' @param elementId Optional id for the widget's HTML element.
#'
#' @return An `htmlwidget` object.
#'
#' @examples
#' JsBarcode("Hello world")
#' JsBarcode("5901234123457", format = "EAN13", line_color = "#1a4f8b")
#' JsBarcode("12345", bar_height = 40, display_value = FALSE)
#'
#' @import htmlwidgets
#' @export
JsBarcode <- function(value,
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
                      elementId = NULL) {

  if (missing(value) || length(value) != 1L || is.na(value)) {
    stop("`value` must be a single non-missing value.", call. = FALSE)
  }
  format <- match.arg(format, barcode_formats)
  check_number(bar_width, "bar_width")
  check_number(bar_height, "bar_height")
  check_number(font_size, "font_size")
  check_number(margin, "margin")
  if (!is.logical(display_value) || length(display_value) != 1L || is.na(display_value)) {
    stop("`display_value` must be TRUE or FALSE.", call. = FALSE)
  }

  extra <- list(...)
  if (length(extra) > 0L && (is.null(names(extra)) || any(names(extra) == ""))) {
    stop("Arguments passed in `...` must be named.", call. = FALSE)
  }

  options <- utils::modifyList(
    list(
      format = format,
      width = bar_width,
      height = bar_height,
      displayValue = display_value,
      text = text,
      fontSize = font_size,
      lineColor = line_color,
      background = background,
      margin = margin
    ),
    extra
  )

  x <- list(
    value = as.character(value),
    options = options[!vapply(options, is.null, logical(1))]
  )

  htmlwidgets::createWidget(
    name = "JsBarcode",
    x = x,
    width = width,
    height = height,
    package = "JsBarcode",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "auto",
      defaultHeight = "auto",
      padding = 0,
      viewer.fill = FALSE,
      browser.fill = FALSE,
      knitr.figure = FALSE
    )
  )
}

#' Shiny bindings for JsBarcode
#'
#' Output and render functions for using JsBarcode within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like `"100%"`,
#'   `"400px"`, `"auto"`) or a number, which will be coerced to a
#'   string and have `"px"` appended.
#' @param expr An expression that generates a JsBarcode
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Is `expr` a quoted expression (with `quote()`)? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name JsBarcode-shiny
#'
#' @export
JsBarcodeOutput <- function(outputId, width = "100%", height = "auto") {
  htmlwidgets::shinyWidgetOutput(outputId,
                                 "JsBarcode",
                                 width,
                                 height,
                                 package = "JsBarcode")
}

#' @rdname JsBarcode-shiny
#' @export
renderJsBarcode <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr) # force quoted
  }
  htmlwidgets::shinyRenderWidget(expr,
                                 JsBarcodeOutput,
                                 env,
                                 quoted = TRUE)
}

check_number <- function(x, arg) {
  if (!is.numeric(x) || length(x) != 1L || is.na(x) || x < 0) {
    stop(sprintf("`%s` must be a single non-negative number.", arg), call. = FALSE)
  }
  invisible(x)
}
