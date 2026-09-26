# Run with: shiny::runApp(system.file("examples/shiny", package = "JsBarcode"))
library(shiny)
library(JsBarcode)

info <- barcode_format_info

# Selector grouped by family, showing friendly names
format_choices <- lapply(split(info, factor(info$family, unique(info$family))),
                         function(f) stats::setNames(f$format, f$name))

ui <- fluidPage(
  titlePanel("JsBarcode demo"),
  sidebarLayout(
    sidebarPanel(
      selectInput("format", "Format", format_choices, "CODE128"),
      textInput("value", "Value", "Example 1234"),
      actionLink("use_example", "Use an example value for this format"),
      hr(),
      sliderInput("bar_height", "Bar height", 20, 200, 100),
      checkboxInput("display_value", "Display value", TRUE)
    ),
    mainPanel(
      JsBarcodeOutput("barcode"),
      hr(),
      uiOutput("format_help"),
      helpText("Only linear (1D) barcodes are available. 2D codes such as",
               "QR Code, Data Matrix, PDF417 and Aztec are not supported",
               "by JsBarcode.")
    )
  )
)

server <- function(input, output, session) {
  selected <- reactive(info[info$format == input$format, ])

  observeEvent(input$use_example, {
    updateTextInput(session, "value", value = selected()$example)
  })

  output$format_help <- renderUI({
    f <- selected()
    tagList(
      h4(f$name, tags$small(tags$code(f$format))),
      p(f$description),
      tags$dl(
        class = "dl-horizontal",
        tags$dt("Type"), tags$dd(f$type),
        tags$dt("Characters"), tags$dd(f$character_set),
        tags$dt("Length"), tags$dd(f$length),
        tags$dt("Check digit"), tags$dd(f$check_digit),
        tags$dt("Typical use"), tags$dd(f$typical_use),
        tags$dt("Example"), tags$dd(tags$code(f$example))
      )
    )
  })

  output$barcode <- renderJsBarcode({
    req(input$value)
    JsBarcode(input$value,
              format = input$format,
              bar_height = input$bar_height,
              display_value = input$display_value)
  })
}

shinyApp(ui, server)
