
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
        

         mainPanel(
            p(" The production of electricity is a challenging area for prediction as shown below the production varies"),
            p(" It is alread noticeable that we have outliers"),
            showOutput("distPlot", "morris"),
            p(" Please note that the outliers have not been removed at this stage")
            )
  )
)
