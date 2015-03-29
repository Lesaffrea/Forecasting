
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rCharts)
options(RCHART_LIB = 'polycharts')      ## Special Rcharts



shinyUI(fluidPage(

        # Application title
        titlePanel("Electricity Prediction"),
        
        sidebarPanel(
               selectInput("dispyear", 
                           label= "Production Year",
                           choices =list("2012","2013","2014"),
                           selected ="2012"
                           )
                ),

         mainPanel(
            p(" The production of electricity is a challenging area for prediction as electicity is produced to be cosummed"),
            p(" In the follwing page I present the models is used to come to a prediction level of about 2% MAPE over a period of 3 months"),
            p(" It is already noticeable that we have outliers, which will involved special treatment"),
            showOutput("distPlot", "morris"),
            p("The following graphic gives a longer perspective using the STL decomposition.A noticeable decrease in production is noticeable"), 
            plotOutput("timeserieplot")
            )
  )
)
