library(shiny)
library(dplyr)

ui <- fluidPage(
  titlePanel("Coffee Recommender"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("rating", "Rating of Coffee:", min = 84, max = 97, value = c(90)),
      actionButton("recommend", "Get Coffee Recommendation")
    ),
    mainPanel(
      textOutput("recommendation")
    )
  )
)



server <- function(input, output) {
  output$recommendation <- renderText({
    filtered_data <- coffee_data %>%
      filter(rating == input$rating)
    
    if (nrow(filtered_data) > 0) {
      # If filtered_data is not empty, continue with further operations
      recommended_coffees <- paste(filtered_data$name)
      return(recommended_coffees)
    } else {
      # If filtered_data is empty, show a message
      return("Sorry, no coffee matches your criteria.")
    }
  })
}

# Run Shiny app
shinyApp(ui = ui, server = server)