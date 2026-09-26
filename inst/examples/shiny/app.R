# Run with: shiny::runApp(system.file("examples/shiny", package = "JsBarcode"))
library(shiny)
library(JsBarcode)

ui <- fluidPage(
  titlePanel("JsBarcode demo"),
  sidebarLayout(
    sidebarPanel(
      textInput("value", "Value", "Hello world"),
      selectInput("format", "Format", barcode_formats, "CODE128"),
      sliderInput("bar_height", "Bar height", 20, 200, 100),
      checkboxInput("display_value", "Display value", TRUE)
    ),
    mainPanel(JsBarcodeOutput("barcode"))
  )
)

server <- function(input, output, session) {
  output$barcode <- renderJsBarcode({
    req(input$value)
    JsBarcode(input$value,
              format = input$format,
              bar_height = input$bar_height,
              display_value = input$display_value)
  })
}

shinyApp(ui, server)
