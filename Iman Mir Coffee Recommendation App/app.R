#Loading libraries
library(shiny)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(readr)

#Creating coffee_data dataset and renaming columns 
simplified_coffee <- read_csv("simplified_coffee.csv", show_col_types = FALSE)
coffee_data <- simplified_coffee
coffee_data <- coffee_data %>% rename(USD = "100g_USD")

# UI of App
ui <- fluidPage(
  
  #Title Information
  titlePanel("Coffee Recommendation App"),
  h5("Use this app to get reccomendations of coffees and roasters based on your location
     and prefered roast type and price range"),
  
  #Sidebar Layout
  sidebarLayout(
    
    sidebarPanel(
      #Feature 1 : Creating a input drop-down bar to select country  
      # and determine reccommended coffee name and roaster in area 
      selectInput("country", "Select Your Country:",
                  choices = c("All", unique(coffee_data$loc_country))),
      
      #Creating a input drop-down bar to select roast_type  
      # and determine recommended coffee name 
      selectInput("roast_type", "Select Roast Type:",
                  choices = c("All", unique(coffee_data$roast))),
      
      #Feature 2 : Creating a slider input to select price range  
      # and determine recommended coffee names within that range
      sliderInput("price_range", "Select Price per 100g Range (in USD):",
                  min = min(coffee_data$USD), max = max(coffee_data$USD),
                  value = c(min(coffee_data$USD), max(coffee_data$USD)),
                  step = 1),
      #Feature 3 : Creating action button to submit the selected preferences 
      actionButton("submit", "Submit")
    ),
    
    
    #Main Panel Layout
    mainPanel(
      
      #Tab Panel Layout
      #Feature 4: Creating tabs to allow for easier access to different 
      #data for coffee name, roaster and reviews
      
      tabsetPanel(
        
        #Tab Panel for Coffee Name Recommendations
        tabPanel("Coffee Name Recommendations", 
                 fluidRow(
                   column(width = 12, h4("Based on your choices:")),
                   
                   #Feature 4: Creating panel of highly recommended panel to highlight
                   #information and make it easier for user to see 
                   column(width = 12, uiOutput("highly_recommended_coffee_panel")),
                   column(width = 12, h4("Recommended Coffees per Price")),
                   column(width = 12, plotOutput("recommendation_plot")),
                   column(width = 12, h4("Table of Recommended Data")),
                   
                   #Feature 5: Creating tableoutput to create dyanmic table  
                   #and allow users to search further
                   column(width = 12, DT::dataTableOutput("recommendation_table")))
        ),
        
        
        #Tab Panel for Coffee Roaster Recommendations
        tabPanel("Coffee Roaster Recommendations", 
                 fluidRow(
                   column(width = 12, h4("Based on your choices:")),
                   
                   #Creating panel of highly recommended panel to highlight
                   #information and make it easier for user to see 
                   column(width = 12, uiOutput("highly_recommended_roaster_panel")),
                   column(width = 12, h4("Recommended Roasters per Coffee")),
                   column(width = 12, plotOutput("recommendation_plot2")),
                   column(width = 12, h4("Table of Recommended Data")),
                   
                   #Creating tableoutput to create dyanmic table  
                   #and allow users to search further
                   column(width = 12, DT::dataTableOutput("recommendation_table2")))
                 
                 ),
        
        #Tab Panel for Customer Reviews
        #Creating tableoutput to create dyanmic table  
        #and allow users to search further into reviews
        tabPanel("Customer Reviews", 
                 DT::dataTableOutput("highly_review_table")),
        
      )
    )
  )
)



# Server of App 
server <- function(input, output) {
  
  #Feature #6: Creating reactive expression for filtered data based on preferences 
  filtered_data <- reactive({
    filtered <- coffee_data
    if (input$country != "All") {
      filtered <- filtered %>% filter(loc_country == input$country)
    }
    filtered <- filtered %>% filter(roast == input$roast_type)
    filtered <- filtered %>% filter(USD >= input$price_range[1] & USD <= input$price_range[2])
    return(filtered)
  })
  

  #Feature 7:Creating render plot for coffee name
  output$recommendation_plot <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    plot1 <- ggplot(filtered, aes(x = USD, y = name)) +
      geom_point(color = "blue") +
      labs(x = "Price", y = "Coffee Name")
    print(plot1)
  })
  
  
  #Creating recommendation table for coffee name
  output$recommendation_table <- DT::renderDataTable({
    req(input$submit)
    filtered <- filtered_data()
    filtered[c("name", 'USD',"rating", "roast")] 
  })
  
  #Creating recommendation plot for roaster
  output$recommendation_plot2 <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    plot2 <- ggplot(filtered, aes(x = name, y = roaster)) +
      geom_point(color = "green") +
      labs(x = "Coffee Name", y = "Roaster") + 
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    print(plot2)
  })
  
  #Creating recommendation table for roaster
  output$recommendation_table2 <- DT::renderDataTable({
    req(input$submit)
    filtered <- filtered_data()
    filtered[c( "roaster","rating", "roast")]  
  })
  
  #Feature #8: Determining highly recommended coffee in renderText
  output$highly_recommended_coffee <- renderText({
    req(input$submit)
    filtered <- filtered_data()
    top_coffee <- filtered %>%
      filter(rating == max(rating)) %>%
      pull(name) %>%
      unique()
    if (length(top_coffee) > 0) {paste("Highly recommended coffee(s):", paste(top_coffee, collapse = ", "))} 
    else {"No highly recommended coffee found based on selected criteria."}
  })
  
  # Determining highly recommended rosater in renderText
  output$highly_recommended_roaster <- renderText({
    req(input$submit)
    filtered <- filtered_data()
    top_roaster <- filtered %>%
      filter(rating == max(rating)) %>%
      pull(roaster) %>%
      unique()
    if (length(top_roaster) > 0) {
      paste("Highly recommended roaster(s):", paste(top_roaster, collapse = ", "))} 
    else { "No highly recommended roaster found based on the selected criteria."}
  })
  
  
  #Feature #9: Creating highly recommended coffee panel with renderUI
  output$highly_recommended_coffee_panel <- renderUI({
    fluidRow(
      column(
        width = 12,
        verbatimTextOutput("highly_recommended_coffee")
      )
    )
  })
  
  #Creating highly recommended roaster panel with renderUI
  output$highly_recommended_roaster_panel <- renderUI({
    fluidRow(
      column(
        width = 12,
        verbatimTextOutput("highly_recommended_roaster")
      )
    )
  })
  
  #Creating highly review table with renderDataTable
  output$highly_review_table <- DT::renderDataTable({
    req(input$submit)
    filtered <- filtered_data()
    filtered[c("name","roaster", "review_date", "review")] 
  })
  
}


# Run App 
shinyApp(ui = ui, server = server)
