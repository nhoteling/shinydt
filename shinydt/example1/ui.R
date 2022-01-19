
# Define UI for application that draws a histogram
ui <- fluidPage(
    br(),
    DTOutput("table"),
    strong("Clicked Model:"),
    verbatimTextOutput("model"),
    shiny::includeScript("js/script.js")
)
