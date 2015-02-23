library(shiny)

# Define UI for application that shows an adstock transformation modeling
shinyUI(
    fluidPage(
        # Application title
        titlePanel("Adstock Transformation !"),
        
        # Sidebar with a slider input for adstock rate
        sidebarLayout(
            sidebarPanel(
                p("Select the desired adstock rate."),
                sliderInput("adstock.rate", "Adstock Rate:", min = 0, max = 100, value = 0, 
                            animate=animationOptions(interval=500, loop=TRUE)),
                helpText("Note: The adstock rate is % of advertising retained from one week to the next. It is a recursive retention.
                         " ),
                p(a("App Help;To begin Select the desired Stock Rate on selector slider ", href="http://rpubs.com/gredoy/62543"), target="_blank")
                # Insert optimize button here.
                # actionButton("optimize", "Optimize")
            ),
            
            # Show tabed results
            mainPanel(
                tabsetPanel(type = "tabs", 
                            tabPanel("Plot", 
                                     p(strong("Time-series of Sales vs. Normalized Advertising Adstock"), align = "center"), 
                                     plotOutput("adstockPlot"), 
                                     p(strong("Scatter plot of Sales vs. Normalized Advertising Adstock"), align = "center"),
                                     plotOutput("scatterPlot")), 
                            tabPanel("Model", p(strong("Regression Model of Sales vs. Normalized Advertising Adstock"), align = "center"), 
                                     verbatimTextOutput("model")), 
                            tabPanel("Data", 
                                     tableOutput("data")))
                # plotOutput("adstockPlot"),
                # plotOutput("scatterPlot")
            )
        )
    )
)