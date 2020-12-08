#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(janitor)
library(shiny)
library(tidyverse)

# read data in
women_entrepreneur_data <- read_delim("women_in_labor_force.csv",
                                      delim = ";") %>%
    clean_names()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Women Entrepreneurship and Labor Force"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("y_variable",
                        "Select variable for y mapping:",
                        c("inflation_rate", 
                          "women_entrepreneurship_index",
                          "entrepreneurship_index" ,
                          "female_labor_force_participation_rate")),
            selectInput("filtering_variable",
                        "Select country type:",
                        c("Developed",
                          "Developing"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("my_plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$my_plot <- renderPlot({
        women_entrepreneur_data %>%
            filter(level_of_development == input$filtering_variable) %>%
            ggplot(aes(x = level_of_development)) +
            geom_boxplot(aes_string(y = input$y_variable)) +
            theme_linedraw()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
