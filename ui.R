
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rCharts)
options(RCHART_LIB = 'polycharts')      ## Special Rcharts



shinyUI(
        navbarPage("Electricity Prediction",
         tabPanel("Introduction",                 
            p(" The production of electricity is a challenging area for prediction as electicity is produced to be cosummed"),
            p(" In the following pages I present the model used to come to a prediction level of about 2% MAPE over a period of 3 months"),
            p(" The data used for this model are from an German electricity producer"),
            p(" The graphic below shows the electricity production per year"), strong("The year 2014 is not complete"),
            fluidRow(column(2, selectInput("dispyear", 
                                           label= "Production Year",
                                           choices =list("2012","2013","2014"),
                                           selected ="2012")
                           )
                    ),                        
            showOutput("distPlot", "morris"),
            
            p("Electricty production is subject to huge varation -/+40%, this is due to the change in demand for example 25th December as visible above as well as production"),
            p("Germany produces 25% of its electricity from renewable energies sun and wind", a("Scientist Article", href="http://www.newscientist.com/article/dn27222-europes-electricity-grid-sails-through-solar-eclipse.html#.VSn6sFx1lRA")),
            p("For a recent and detailed analysis of the solar eclipses impact on the European Electricity production", a("Euroepean Impact", href="https://www.entsoe.eu/Documents/Publications/SOC/150219_Solar_Eclipse_Impact_Analysis_Final.pdf")),   
            p("Those changes in production due to its type rather than demand introduces new challenges in forecasting and planning for Electricty producers"),
            
            h4("The Trends"),
            p("On the graphic above its is difficult to notice the trends  "),
            p("The following graphic gives a longer perspective using the STL decomposition.A noticeable decrease in production is visible"), 
            plotOutput("timeserieplot"),
            
            
            h4("The Exceptional Periods"),
            p("It is noticeable that we have exceptional periods, those periods are listed below. The main and longest period of exceptions is the period Chirstmas New Year "),
            p("This period is common for low electricity production, a similar pattern exist for example for the Western Australia production"),
            tableOutput("exceptions"),
            
            h3("The Variables to consider"),
            p("Based on previous work with the Western Australian production, the temperature has significant influence"),
            p("The following graphic represent daily production of electricity in WA as a function of yhe maximum temprature in Central Perth"),
            imageOutput("perthtempprod")
            ),
         tabPanel("Eceptions and Outliers",
                  h4("The outliers"),
                  p("In the introduction page, one could notice the periodicity of the production as well as huge variations such as Christmas and as we shall see Easter"),
                  p("Some other time periods are also present, what is not obvious is the transient exceptions, such as one day drecrease or increase in production, for example Monday"),
                  p("To collect insights about the outliers, we conducted one analysis. Exceptiona are context dependant, in our case we use Extreme Studentized Deviate (ESD) Test as we can not assume a normal distribution."),
                  h4("Method used"),
                  p("As mentioned in previous paragraph, we use ESD, which is a robust method. This method is used for computer load as well. The follwing graphic shows the exceptions"),
                  plotOutput("outliersplot"),
                  p("There is a problem currently with the X axis. The 16h marks a period"),
                  h4("Exceptional Dates"),
                  p("The exceptions represented above are associated with a date, which we shall use as a clue in our model. Starting with the date we try to find out in the context the events, which trigger the decrease and increase in consumption production")
         ),                 
         tabPanel("The forecast model",
                  h3("The variables"),
                  p("The model of prediction used is based on multiple varaibles, one challenge is to slect the siginifanct variables. Concerdireing that we can include variables such as economic growth, solar eclipse as mentioned in previous pages, official holidays and much more"),
                  p("... ")
         )                          
  )
)
