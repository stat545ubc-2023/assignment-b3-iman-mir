library(shiny)
library(dplyr)
library(tidyverse)
library(ggplot2)

coffee_data <- read.csv("/Users/imanmir/Downloads/simplified_coffee.csv")

# UI
ui <- fluidPage(
  titlePanel("Coffee Recommendation App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("roast_type", "Select Roast Type:",
                  choices = c("All", unique(coffee_data$roast))),
      sliderInput("price_range", "Select Price Range:",
                  min = min(coffee_data$X100g_USD), max = max(coffee_data$X100g_USD),
                  value = c(min(coffee_data$X100g_USD), max(coffee_data$X100g_USD)),
                  step = 1),
      sliderInput("rating_range", "Select Rating Range:",
                  min = min(coffee_data$rating), max = max(coffee_data$rating),
                  value = c(min(coffee_data$rating), max(coffee_data$rating)),
                  step = 1),
    
      actionButton("submit", "Submit")
    ),
    mainPanel(
      plotOutput("recommendation_plot"),
      plotOutput("recommendation_plot2")
    )
  )
)

# Server
server <- function(input, output) {
  filtered_data <- reactive({
    filtered <- coffee_data
    if (input$roast_type != "All") {
      filtered <- filtered %>% filter(roast == input$roast_type)
    }
    filtered <- filtered %>% filter(X100g_USD >= input$price_range[1] & X100g_USD <= input$price_range[2])
    filtered <- filtered %>% filter(rating >= input$rating_range[1] & rating <= input$rating_range[2])
    return(filtered)
  })
  
  
  output$recommendation_plot <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    p <- ggplot(filtered, aes(x = X100g_USD, y = name)) +
      geom_point() +
      labs(x = "Price (X100g_USD)", y = "Coffee Name", title = "Coffee Recommendations")
    print(p)
  })
  
  
  output$recommendation_plot2 <- renderPlot({
    req(input$submit)
    filtered <- filtered_data()
    p <- ggplot(filtered, aes(x = name, y = roaster)) +
      geom_point() +
      labs(x = "Name", y = "Roaster", title = "Coffee Recommendations")
    print(p)
  })
  
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
