library(shiny)
library(tidyverse)
library(ggplot2)
library(datateachr)

ui <- fluidPage(
  
  titlePanel("Annual Bow River Banff Flow Rate Extremes"), 
  h4("Use this app to explore flow rates per year at station 05BB001"),
  
  sidebarLayout(
    sidebarPanel(
      #Feature 1 : Creating a slider to select year range of data to 
      #allow for trend analysis and dynamic visualization of the data
      sliderInput("id_slider", "Select a year range:", min = 1909, max=2018, 
                  value = c(2001, 2005))
    ),
    
    mainPanel(
      
      #Feature 2: Creating two seperate tabs for table and histogram as 
      #it allows for better organization of the content and enhances user 
      # engagement
      
      tabsetPanel(
        
        #Feature 3: Adding color to the histogram plot, this allows for 
        #improved readability and understanding, and greater visual appeal 
        # and engagement with users
        tabPanel( "Histogram", 
                  colourpicker::colourInput("col", "Choose colour", "red"),
                  plotOutput("id_histogram")
        ),
        #Feature 4: Creating interactive table, useful because users can search up diverse  
        #by conducting specific inquiries 
        tabPanel("Table",  DT::dataTableOutput("id_table")))
      
    )
  )
)

server <- function(input, output) {
  observe(print(input$id_slider))
  
  flow_filtered <- reactive ({flow_sample %>% 
      filter (year < input$id_slider[2], 
              year > input$id_slider[1])})
  
  output$id_histogram <- renderPlot({
    flow_filtered() %>%
      ggplot(aes(flow))+ 
      geom_histogram(fill = input$col)  })
  
  output$id_table <- DT::renderDataTable({
    flow_filtered()
  })
  
}

shinyApp(ui = ui, server = server)



