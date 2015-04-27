#
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
            p(" To build the forcasting model we followed the following process"),
            img(src='process.jpg', align = "middle", height='350px', width='1000px'),
            h3("Electricity Production"),
            p(" The graphic below shows the electricity production per year"), strong("The year 2014 is not complete"),
            fluidRow(column(2, selectInput("dispyear", 
                                           label= "Production Year:",
                                           choices =list("2012","2013","2014"),
                                           selected ="2012"),
                            helpText("The data used has been shared by RWE electricity producer and are related to European country.")
                           ),
                     column(3,   showOutput("distPlot", "morris"))
                    ),                        
           
            h4("Wider Perspective"),
            p("Forecasting has three components, the trends, the seasonal variations and noise. Using time series we display below those components. One could notice the trend toward a decrease in production over the years"),
            plotOutput(outputId = "timeserieplot", height = "350px"),
            p(""),
            p("Electricty production is subject to huge varation -/+40%, due to changes in demand.  For example 25th December as visible above is the lowest consumption of the year. The data we work on are for a European country, for Western Australia the lowest production will be the 1st January."),
            p("In our case we waork with German data. Germany produces 25% of its electricity from renewable energies sun and wind", a("Scientist Article", href="http://www.newscientist.com/article/dn27222-europes-electricity-grid-sails-through-solar-eclipse.html#.VSn6sFx1lRA")),
            p("For a recent and detailed analysis of the solar eclipses impact on the European Electricity production", a("European Impact", href="https://www.entsoe.eu/Documents/Publications/SOC/150219_Solar_Eclipse_Impact_Analysis_Final.pdf")),   
            p("During the period considered for this forecast we did not have one", a("Solar Eclipse",href="http://en.wikipedia.org/wiki/List_of_solar_eclipses_in_the_21st_century") ),
            p("Those changes in production due to its type rather than demand introduce new challenges in forecasting and planning for Electricty producers"),
            
            h3("The variables to consider"),
            p("We consider few variables. First the exceptions, after EDA it appeared, we shall have difficulties to build one model for all cases, therefore the exceptional periods such as Easter and Christmas have been modelized using a different model as explained in the outliers page"),
            p("The non exceptions, that is the days of productions subject to non exceptional events. Then as explained in the Forecast Page we build one aggregate of models of various types"),
            p(""),
            h6("Site under construction",style = "color:blue"),        
            h6("Created and maintained by Alain Lesaffre",style = "color:blue")
            ),
         tabPanel("Exceptions and Outliers",
                  h4("The outliers"),
                  p("In the introduction page, one could notice the periodicity of the production and the important variations around Christmas and Easter"),
                  p("Some other time periods are also present. It is more difficult to notice transient exceptions, such as one day drecrease or increase in production after one day more holidays"),
                  p("To collect insights about the outliers, we conducted one analysis. As exceptions are context dependant, we use Extreme Studentized Deviate (ESD) Test."),
                  h4("Method used"),
                  p("We use ESD. This method is used for computer load as well. The following table shows the first 15 exceptions"),
                  p("It was not possible to plot the exceptions due to a problem with the package and shiny"),
                  tableOutput('outlierstable'),
                  h4("Exceptional Dates"),
                  p("The exceptions represented above are associated with a date and a date type. Apart from Sunday and Saturday (SU, SD) all date types have some other attributes (EM = Easter Monday, CD = Christmas, BD = Boxing Day). Using ESD method the exceptional periods have been selected and we are confident that by removing the exceptions we could come to accurate predictions"),
                  p("The following graphic show the variation on production for the Easter period."),
                  
                  h4("Different Models"),
                  p("Based on the analysis of the outliers, it appears that holidays specially school holidays have one important influence on the production, consumption of electricty. Therefore as presented introduction page we shall build mutliple models. Some models for regular periods and some for exceptions")
                  
         ),                 
         tabPanel("The forecast model",
                  h3("The variables"),
                  p("The model of prediction used is based on multiple variables. One challenge is to retain siginifanct variables. Considering that we can include variables such as economic growth, solar eclipse as mentioned in previous pages, official holidays and much more"),
                  p("Based the production graphic, it appears that we have a quite regular cycle during the week and then some exceptions as mentioned in the exceptions pages"),
                  p("The daily variations over the weeks are displayed below. We can notice the greater amount of outliers on Monday after removing Easter, End of the year and the M1 and M2 special periods"),
                  imageOutput("week"),
                  h4("List of variables"),
                  p("The table below list the variables used with a short explanation.After the EDA stage, based on the significance, we dropped three initial variables, which were not significant"),
                  tableOutput("variables"),
                  p(" The variables Month and Year have been built out of the initial time stamp"),
                  h3("The models"),
                  p("To come to a final forcasting, we built a set of models. As shown in the exceptions the variations are too important to be used with the regular production."),
                  h4("Week days"),
                  p("We build one model for each day of the week. We first remove all the exception periods for the training set and the run multiple models and picked up the one with the least error."),
                  h5("Production and Temperature"),
                  p("One variable to consider is temperature. As example in Perth Western Australia the production / temperature is a quadratic function, in case of European consumption pattern this "),
                  
                  fluidRow(column(2, selectInput("place", 
                                                 label= "Production Place",
                                                 choices =list("Germany", "Perth WA"),
                                                 selected ="Germany" ),
                                  helpText("You can compare variation in Production as dependent of Temperature")
                                  ),
                           column(7,  plotOutput(outputId="temperature"))
                  ), 
                  p("On this graphic one could notice again the exception in production due to Christmas and various periods but we do not have a quadratic function production temp")
         )
  )
)