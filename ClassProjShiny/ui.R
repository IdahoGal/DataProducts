
library(shiny)

# This application is a data set viewer for field biologists doing wildlife management.  
# There are 12 datasets publically downloadable
# from the Idaho Fish & Game web site here: http://fishandgame.idaho.gov/.
# This application will prompt the user for a year between 2002-2013 and display
# a data set based on that input.  The UI includes a tabbed display to plot
# the data, summarize the data, and display the data in a table view. 
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Data Products: Idaho Deer Harvest"),
        h4("This application is a data set view app used by field biologists interested in wildlife management.
                   It calculates harvest rate, then plots, summarizes, and displays one of 12 publically available data sets.", 
                   style = "color:blue"),
        # Sidebar with controls to provide a caption, select a dataset,
        # and specify the number of observations to view. Note that
        # changes made to the caption in the textInput control are
        # updated in the output area immediately as you type
        sidebarLayout(
                
                sidebarPanel(
                        h6("Choose a 'year' from the drop down box in the sidebar and data will be automatically refreshed."),
                        textInput("caption", "Deer Harvest:", "Data Summary"),
                        selectInput("dataset", "Choose a year:", 
                                    choices = c("2002", "2003", "2004", "2005", "2006", "2007",
                                                 "2008", "2009", "2010", "2011", "2012", "2013")),
                        numericInput("obs", "Number of observations to view:", 20)
                 ),
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        mainPanel(
                em("To view the output, navigate through the tabs below.", style = "font-family: 'verdana'; font-si20pt"),
                p(" "),
               
                 tabsetPanel(type = "tabs", 
                     tabPanel("Harvest Rate(%)", verbatimTextOutput("metric")), 
                     tabPanel("Plot", plotOutput("plot")), 
                     tabPanel("Summary", verbatimTextOutput("summary")), 
                     tabPanel("Table", tableOutput("view"))
                 )
        ))
))
