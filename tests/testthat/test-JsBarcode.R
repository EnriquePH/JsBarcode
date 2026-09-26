test_that("JsBarcode() returns an htmlwidget with the expected payload", {
  w <- JsBarcode("Hello")
  expect_s3_class(w, "htmlwidget")
  expect_s3_class(w, "JsBarcode")
  expect_identical(w$x$value, "Hello")
  expect_identical(w$x$options$format, "CODE128")
  expect_identical(w$x$options$width, 2)
  expect_identical(w$x$options$height, 100)
  expect_true(w$x$options$displayValue)
  expect_null(w$x$options$text)
})

test_that("numeric values are coerced to character", {
  expect_identical(JsBarcode(12345)$x$value, "12345")
})

test_that("R arguments map to JsBarcode option names", {
  w <- JsBarcode("5901234123457", format = "EAN13", bar_width = 3,
                 bar_height = 50, display_value = FALSE, text = "label",
                 font_size = 12, line_color = "red", background = "#eee",
                 margin = 0)
  expect_identical(w$x$options, list(
    format = "EAN13", width = 3, height = 50, displayValue = FALSE,
    text = "label", fontSize = 12, lineColor = "red", background = "#eee",
    margin = 0
  ))
})

test_that("extra options in ... are passed through and can override", {
  w <- JsBarcode("A", textAlign = "left", flat = TRUE, fontSize = 30)
  expect_identical(w$x$options$textAlign, "left")
  expect_true(w$x$options$flat)
  expect_identical(w$x$options$fontSize, 30)
})

test_that("JS options that prefix R argument names are not partially matched", {
  w <- JsBarcode("A", font = "serif", text = "t", textAlign = "left")
  expect_identical(w$x$options$font, "serif")
  expect_identical(w$x$options$fontSize, 20)
  expect_identical(w$x$options$text, "t")
  expect_identical(w$x$options$textAlign, "left")
})

test_that("invalid input is rejected", {
  expect_error(JsBarcode(), "single non-missing")
  expect_error(JsBarcode(c("a", "b")), "single non-missing")
  expect_error(JsBarcode(NA), "single non-missing")
  expect_error(JsBarcode("a", format = "QR"), "should be one of")
  expect_error(JsBarcode("a", bar_width = -1), "bar_width")
  expect_error(JsBarcode("a", display_value = "yes"), "display_value")
  expect_error(JsBarcode("a", "CODE128", "oops"), "must be named")
})

test_that("bundled JavaScript dependency is declared and present", {
  deps <- htmlwidgets::getDependency("JsBarcode", "JsBarcode")
  jsb <- Filter(function(d) d$name == "jsbarcode", deps)[[1]]
  expect_identical(jsb$version, "3.12.3")
  expect_true(nzchar(system.file(jsb$src$file, jsb$script, package = "JsBarcode")))
})

test_that("barcode_formats lists the supported symbologies", {
  expect_true(all(c("CODE128", "EAN13", "UPC", "CODE39", "CODE93FullASCII",
                    "pharmacode") %in% barcode_formats))
  expect_false(anyDuplicated(barcode_formats) > 0)
})

test_that("barcode_format_info has one complete row per format", {
  expect_s3_class(barcode_format_info, "data.frame")
  expect_identical(barcode_format_info$format, barcode_formats)
  expect_named(barcode_format_info, c(
    "format", "name", "family", "type", "character_set", "length",
    "check_digit", "description", "typical_use", "example"
  ))
  expect_true(all(vapply(barcode_format_info, is.character, logical(1))))
  expect_false(any(is.na(as.matrix(barcode_format_info))))
  expect_false(any(as.matrix(barcode_format_info) == ""))
  expect_true(all(barcode_format_info$type %in% c("numeric", "alphanumeric")))
})

test_that("every format example builds a widget", {
  for (i in seq_len(nrow(barcode_format_info))) {
    f <- barcode_format_info[i, ]
    w <- JsBarcode(f$example, format = f$format)
    expect_identical(w$x$options$format, f$format)
  }
})

test_that("Shiny bindings are created", {
  skip_if_not_installed("shiny")
  out <- JsBarcodeOutput("bc")
  expect_s3_class(out, "shiny.tag.list")
  expect_type(renderJsBarcode(JsBarcode("x")), "closure")
})
