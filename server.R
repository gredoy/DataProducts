library(shiny)

sales       <- c(1018, 0, 236, 490, 1760, 443, 1670, 526, 4522, 2524, 400, 2527, 4602, 168, 2795, 7195, 6277, 2974, 5268    ,4310, 2127, 1081, 4794, 806, 2565, 1223, 4141, 2994, 4079, 1883, 635, 1980, 1275, 4497, 1579, 2726, 1901, 4683, 1686, 1745, 1404, 1096, 2825, 2331, 1711, 2041, 1210, 914, 4162, 1166, 4228, 914)
advertising <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 117.913, 120.112, 125.828, 115.354, 177.09, 141.647, 137.892, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 158.511, 109.385, 91.084, 79.253, 102.706, 78.494, 135.114, 114.549, 87.337, 107.829, 125.02, 82.956, 60.813, 83.149, 0, 0, 0, 0, 0, 0, 129.515, 105.486, 111.494, 107.099, 0, 0)
week        <- c(1:length(sales))

# Define adstock calculation function
adstock.transform <- function(x, rate){
    return(as.numeric(filter(x=x, filter=rate, method="recursive")))
}

# Define normalization function to transform data to 0-1 ranges.
normalize <- function(x){
    return((x-min(x)) / (max(x)-min(x)) * 100)
}

# Define server logic required to draw a histogram
shinyServer(
    function(input, output) {    
        # Reactive expression to generate the requested adstock transformation.
        adstock.calc <- reactive({
            as.numeric(filter(x=advertising, filter=input$adstock.rate/100, method="recursive"))
        })
        
        # Reactive expression to generate the requested normalized adstock transformation.
        adstock.calc.normalize <- reactive({
            normalize(adstock.calc())
        })
        
        output$adstockPlot <- renderPlot({    
            # Draw Time Series
            par(mar = c(5,5,0,5))
            plot(x=week, y=sales, type="l", col="black",
                 xlab="Time (Usually in Weeks)", ylab="Sales",
                 frame=F)
            par(new=T)
            plot(x=week, y=adstock.calc.normalize(), type="l", col="blue",
                 xlab=NA, ylab=NA, main=NA,
                 axes=F)
            axis(4); mtext(side=4, line=3, text="Normalized Advertising Adstock", col="blue")
        })
        
        output$scatterPlot <- renderPlot({
            # Draw Scatterplot
            par(mar = c(5,5,0,5))
            plot(x=adstock.calc.normalize(), y=sales, type="p",
                 xlab="Normalized Advertising Adstock", ylab="Sales")
            
            fitline <- lm(sales ~ adstock.calc.normalize())
            abline(fitline)
        })
        
        output$model <- renderPrint({
            advertising <- adstock.calc.normalize()
            summary(lm(sales~advertising))
        })
        
        # Generate an HTML table view of the data
        output$data <- renderTable({
            data.frame(week=week, 
                       sales=sales, 
                       advertising=advertising, 
                       advertising.adstock=adstock.calc(), 
                       normalized.advertising.adstock=adstock.calc.normalize())
        })
    }
)