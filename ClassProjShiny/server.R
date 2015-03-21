# The 12 data sets for this application have been downloaded to a local folder
# from this public web site: http://fishandgame.idaho.gov/
# Each data set includes deer harvest data from the general season hunting years
# spanning 2002 - 2013.  

library(shiny)
library(ggplot2)

d2002 <- read.csv("idaho-2002-deer-general-harvest-stats.csv")
d2003 <- read.csv("idaho-2003-deer-general-harvest-stats.csv")
d2004 <- read.csv("idaho-2004-deer-general-harvest-stats.csv")
d2005 <- read.csv("idaho-2005-deer-general-harvest-stats.csv")
d2006 <- read.csv("idaho-2006-deer-general-harvest-stats.csv")
d2007 <- read.csv("idaho-2007-deer-general-harvest-stats.csv")
d2008 <- read.csv("idaho-2008-deer-general-harvest-stats.csv")
d2009 <- read.csv("idaho-2009-deer-general-harvest-stats.csv")
d2010 <- read.csv("idaho-2010-deer-general-harvest-stats.csv")
d2011 <- read.csv("idaho-2011-deer-general-harvest-stats.csv")
d2012 <- read.csv("idaho-2012-deer-general-harvest-stats.csv")
d2013 <- read.csv("idaho-2013-deer-general-harvest-stats.csv")

# Clean the data sets up.  They will consist of 3 categorical
# variables (TakeMethod, Unit, and Year) and 1 continuous variable
# (Hunters) with Harvest as an outcome.  
# First remove all summary rows in the data.  Summary rows contain the
# phrase 'All Weapons Combined' in the TakeMethod attribute.   
d2002 <- subset(d2002, d2002$TakeMethod != "All Weapons Combined")
d2003 <- subset(d2003, d2003$TakeMethod != "All Weapons Combined")
d2004 <- subset(d2004, d2004$TakeMethod != "All Weapons Combined")
d2005 <- subset(d2005, d2005$TakeMethod != "All Weapons Combined")
d2006 <- subset(d2006, d2006$TakeMethod != "All Weapons Combined")
d2007 <- subset(d2007, d2007$TakeMethod != "All Weapons Combined")
d2008 <- subset(d2008, d2008$TakeMethod != "All Weapons Combined")
d2009 <- subset(d2009, d2009$TakeMethod != "All Weapons Combined")
d2010 <- subset(d2010, d2010$TakeMethod != "All Weapons Combined")
d2011 <- subset(d2011, d2011$TakeMethod != "All Weapons Combined")
d2012 <- subset(d2012, d2012$TakeMethod != "All Weapons Combined")
d2013 <- subset(d2013, d2013$TakeMethod != "All Weapons Combined")


# Subset data.  Remove columns x.4.Pts, x.5.Pts, x.whitetail
d2002 <- subset(d2002, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2003 <- subset(d2003, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2004 <- subset(d2004, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2005 <- subset(d2005, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2006 <- subset(d2006, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2007 <- subset(d2007, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2008 <- subset(d2008, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2009 <- subset(d2009, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2010 <- subset(d2010, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2011 <- subset(d2011, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2012 <- subset(d2012, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))
d2013 <- subset(d2013, select=c("Year","TakeMethod", "Unit", "Hunters", "Harvest"))

# Calculate linear regression  model
#fit <- lm( d2002$Harvest  ~ d2002$Hunters + d2002$TakeMethod, data = d2002)

# Users can enter Hunters and TakeMethod to predict harvest
#predict(fit, userdata, interval = predict)


# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
        
        # By declaring datasetInput as a reactive expression we ensure 
        # that:
        #  1) It is only called when the inputs it depends on changes
        #  2) The computation and result are shared by all the callers 
        #          (it only executes a single time)
        #
        datasetInput <- reactive({
                switch(input$dataset,
                       "2002" = d2002,
                       "2003" = d2003,
                       "2004" = d2004,
                       "2005" = d2005,
                       "2006" = d2006,
                       "2007" = d2007,
                       "2008" = d2008,
                       "2009" = d2009,
                       "2010" = d2010,
                       "2011" = d2011,
                       "2012" = d2012,
                       "2013" = d2013)
        })
        
        # The output$caption is computed based on a reactive expression
        # that returns input$caption. When the user changes the
        # "caption" field:
        #
        #  1) This function is automatically called to recompute the 
        #     output 
        #  2) The new caption is pushed back to the browser for 
        #     re-display
        # 
        # Note that because the data-oriented reactive expressions
        # below don't depend on input$caption, those expressions are
        # NOT called when input$caption changes.
        output$caption <- renderText({
                input$caption
        })
        
        # The output$summary depends on the datasetInput reactive
        # expression, so will be re-executed whenever datasetInput is
        # invalidated
        # (i.e. whenever the input$dataset changes)
        output$summary <- renderPrint({
                dataset <- datasetInput()
                summary(dataset)
        })
        
        # The output$view depends on both the databaseInput reactive
        # expression and input$obs, so will be re-executed whenever
        # input$dataset or input$obs is changed. 
        output$view <- renderTable({
                head(datasetInput(), n = input$obs)
        })
        
        # Generate bar plot  
        output$plot <- renderPlot({
                dataset <- datasetInput()
                x <- dataset$Harvest
                y <- dataset$Hunters
                ggplot(data=ds2, aes(x=TakeMethod, fill = factor(TakeMethod), y=Harvest)) +
                        geom_bar(stat="identity") +  
                        xlab("Method") + ylab("Harvest Count") + labs(title="Method vs. Count") 
                
        })
        # Generate Harvest metric
        output$metric <- renderPrint({
                dataset <- datasetInput()
                sum(dataset$Harvest)/ sum(dataset$Hunters)  
        })
        
})
