library(shiny)
library(dplyr)
library(tidyverse)
library(ggplot2)

coffee_data <- read.csv("/Users/imanmir/Downloads/simplified_coffee.csv")
unique_years <- unique(as.integer(format(as.Date(coffee_data$review_date), "%Y")))

# UI
ui <- fluidPage(
  titlePanel("Coffee Recommendation App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select Your Country:",
                  choices = c("All", unique(coffee_data$loc_country))),
      selectInput("roast_type", "Select Roast Type:",
                  choices = c("All", unique(coffee_data$roast))),
      sliderInput("price_range", "Select Price Range:",
                  min = min(coffee_data$X100g_USD), max = max(coffee_data$X100g_USD),
                  value = c(min(coffee_data$X100g_USD), max(coffee_data$X100g_USD)),
                  step = 1),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel("Coffee Name Recommendations", 
                 fluidRow(
                   column(width = 12, h4("Based on your choices:")),
                   column(width = 12, uiOutput("highly_recommended_coffee_panel")),
                   column(width = 12, h4("Reccommended Coffees per Price")),
                   column(width = 12, plotOutput("recommendation_plot")),
                   column(width = 12, h4("Table of Reccommended Data")),
                   column(width = 12, DT::dataTableOutput("recommendation_table"))
                   
                 )
        ),
        tabPanel("Coffee Roaster Recommendations", 
                 fluidRow(
                   column(width = 12, h4("Based on your choices:")),
                   column(width = 12, uiOutput("highly_recommended_roaster_panel")),
                   column(width = 12, h4("Reccommended Coffees per Price")),
                   column(width = 12, plotOutput("recommendation_plot2")),
                   column(width = 12, h4("Table of Reccommended Data")),
                   column(width = 12, DT::dataTableOutput("recommendation_table2"))
                   
                 

        ),
        
        tabPanel("Reviews", 
                 selectInput("selected_year", "Select Year:",
                             choices = c(unique(coffee_data$review_date))),
                 actionButton("submit_year", "Submit")),

    )
    )
  )
)

# Server
server <- function(input, output) {
  filtered_data <- reactive({
    filtered <- coffee_data
    if (input$country != "All") {
      filtered <- filtered %>% filter(loc_country == input$country)
    }
    filtered <- filtered %>% filter(roast == input$roast_type)
    filtered <- filtered %>% filter(X100g_USD >= input$price_range[1] & X100g_USD <= input$price_range[2])
    return(filtered)
  })
  
  
  output$recommendation_plot <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    p <- ggplot(filtered, aes(x = X100g_USD, y = name)) +
      geom_point() +
      labs(x = "Price (X100g_USD)", y = "Coffee Name")
    print(p)
  })
  
  output$recommendation_table <- DT::renderDataTable({
    req(input$submit)
    filtered <- filtered_data()
    filtered[c("name", "X100g_USD","rating", "roast")]  # Adjust columns as needed
  })
  
  output$recommendation_plot2 <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    p <- ggplot(filtered, aes(x = name, y = roaster)) +
      geom_point() +
      labs(x = "Name", y = "Roaster") + 
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    print(p)
  })
  
  output$recommendation_table2 <- DT::renderDataTable({
    req(input$submit)
    filtered <- filtered_data()
    filtered[c("name", "roaster","rating", "roast")]  # Adjust columns as needed
  })
  
  output$highly_recommended_coffee <- renderText({
    req(input$submit)
    filtered <- filtered_data()
    top_coffee <- filtered %>%
      filter(rating == max(rating)) %>%
      pull(name) %>%
      unique()
    
    if (length(top_coffee) > 0) {
      paste("Highly recommended coffee(s):", paste(top_coffee, collapse = ", "))
    } else {
      "No highly recommended coffee found based on the selected criteria."
    }
  })
  
  output$highly_recommended_roaster <- renderText({
    req(input$submit)
    filtered <- filtered_data()
    top_roaster <- filtered %>%
      filter(rating == max(rating)) %>%
      pull(roaster) %>%
      unique()
    
    if (length(top_roaster) > 0) {
      paste("Highly recommended roaster(s):", paste(top_roaster, collapse = ", "))
    } else {
      "No highly recommended roaster found based on the selected criteria."
    }
  })
  
  
  
  output$highly_recommended_coffee_panel <- renderUI({
    fluidRow(
      column(
        width = 12,
        verbatimTextOutput("highly_recommended_coffee")
      )
    )
  })
  
  output$highly_recommended_roaster_panel <- renderUI({
    fluidRow(
      column(
        width = 12,
        verbatimTextOutput("highly_recommended_roaster")
      )
    )
  })
  
  output$selected_info <- renderText({
    req(input$submit_year)
    
    # Filter data based on the selected year
    filtered_data <- subset(coffee_data,
                            format(review_date, "%Y") == input$selected_year)
    
    # Display the information for the selected year (modify as needed)
    paste(filtered_data$relevant_info_column, collapse = "<br>")
  })
  
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
