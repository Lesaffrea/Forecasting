#
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rCharts)
library(lubridate)
library(BH)
options(RCHART_WIDTH = 800)

# Load the three years of production 
GetDataRWE <-function(){
        filename =c("data/E_round3_train.csv")
        train.columns <-c('character',    # Date
                          'numeric',      # Temp
                          'numeric',      # Wind_Speed
                          'numeric',      # Precip_Amt
                          'numeric',      # Solar_Rad
                          'factor',       # Day_Type
                          'factor',       # School_Holyday
                          'factor',       # Winter
                          'numeric'       # Volume
        )
        initialtrainingset <-read.csv(filename, colClasses= train.columns, header=TRUE)
        initialtrainingset$Date <-gsub(c("/"), c("-"), initialtrainingset$Date)
        initialtrainingset
}

# Load the outliers 

GetOutliers <-function(){
        filename =c("data/outliers.csv")
        train.columns <-c('character',    # Date
                          'numeric',      # Temp
                          'numeric',      # Wind_Speed
                          'numeric',      # Precip_Amt
                          'numeric',      # Solar_Rad
                          'factor',       # Day_Type
                          'factor',       # School_Holyday
                          'factor',       # Winter
                          'numeric'       # Volume
        )
        outliersset <-read.csv(filename, colClasses= train.columns, header=TRUE)
        outliersset$Date <-gsub(c("/"), c("-"), outliersset$Date)
        outliersset
}

#   ---------------------
#   Build the fix objects
#   ---------------------
trainingset <-GetDataRWE()
trainingset$Date <-sub(c(" UTC"),"", dmy(trainingset$Date))
trainingset12 <-trainingset[year(trainingset$Date) %in% c("2012"),]
trainingset13 <-trainingset[year(trainingset$Date) %in% c("2013"),]
trainingset14 <-trainingset[year(trainingset$Date) %in% c("2014"),]

#
# We build the graphic data for the trend analysis
#
beginningyear <-sub(c(" UTC"), "",dmy(paste0(c("01-01-"),year(trainingset$Date[1]) )))
firstday <-as.numeric(as.Date(trainingset$Date[1]) -as.Date(beginningyear))

#  We build the time serie 
tsprod <-ts(trainingset$volume, start=c(year(trainingset$Date[1]),
                                               firstday),
            frequency =365 )
#
#  We do the decomposition
#
trendseason <-stl(tsprod, "periodic")
rm(trainingset)
#--------------------------
#      Outliers LOad 
#--------------------------
exceptions <-GetOutliers()
exceptions <-exceptions[,c("Date", "volume")]







shinyServer(function(input, output) {
        
output$distPlot <- renderChart({
        todisplay <-reactive({
                  selected <-paste0(c("y"), input$dispyear)
                  switch(selected,
                        y2012 = trainingset12,
                        y2013 = trainingset13,
                        y2014 = trainingset14 )
        })
         
         Rmgraph <-mPlot(x = "Date", y = "volume", type = "Line", data = todisplay(),
                          pointSize = 0, lineWidth = 1 )
         Rmgraph$set(dom = 'distPlot')
         return(Rmgraph)
         })

 output$timeserieplot <-renderPlot({
           threeyears<-plot(trendseason, main="Three production overview with STL decomposition")
           return(threeyears)
          })
 
 output$exceptions <-renderTable({
          head(exceptions, n= 20)                 
          })
    
    
    
})
