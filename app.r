library(shiny)
library(dplyr)
library(magrittr)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      
      # 2 Dropdowns with random data
      
      selectInput("cyl", label = "cyl" ,choices = unique(mtcars$cyl)),
      selectizeInput("gear", label = "gear", choices = NULL)
    ),
    
    mainPanel(
      dataTableOutput("table")
    )
  )
)

server <- function(session, input, output) {
  
  output$table <- renderDataTable({
    
    # Filter
    
    mtcars %>%
      filter(
        cyl == input$cyl,
        gear == input$gear
      )
    
  } )
  
  reactive <- reactive({mtcars})
  
  updateSelectizeInput(
    session = session, 
    inputId = 'gear',
    choices = mtcars$gear[mtcars$cyl == "4"],
    server = TRUE)
  
  observe({
    updateSelectizeInput(
      session = session, 
      inputId = 'gear',
      choices = mtcars$gear[mtcars$cyl == input$cyl],
      server = TRUE)
  })
  
  session$onSessionEnded(function() { stopApp() })
}

# Run the application 
shinyApp(ui = ui, server = server)

# stop app running when closed in browser. 

