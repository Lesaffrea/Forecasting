#
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# 12/04/2015 - Add the display of outliears using the the outlier detection library 
# 23/04/2015 - We have a problem between shiny and the exception handling I have to remove it 
library(shiny)
library(rCharts)
library(lubridate)
library(dplyr)
#library(AnomalyDetection)


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

# Load the outliers as we can not do it live !!!

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

#-----------------------------------------------------------------
# We build the graphic data for the trend analysis
#-----------------------------------------------------------------
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
#------------------------------------------------------------------
# Prepare the outliers
# 1. Build the outliers 
# 2. Load the exception as AnomalyDetectionTs does not work on shiny
#    but we keep the preparation code. Hope it works one day
#-------------------------------------------------------------------
OutlierAnalysis <- trainingset %>% select(Date, volume) 
OutlierAnalysis$Date<-strptime(paste(OutlierAnalysis$Date, c("12:00:00")), format="%Y-%m-%d %H:%M:%S")
#outlierproductionweekbooth<-AnomalyDetectionTs(OutlierAnalysis, max_anoms=0.2, alpha=0.1, direction='both', plot=TRUE, longterm=TRUE, xlabel="3 Years period")
outliersdata <-read.csv("data/outliers.csv", stringsAsFactor = FALSE)
# Clean the global environment 
rm(trainingset)
#------------------------------------------------------------------
#
#  Other datas for display using shiny widget 
#
#------------------------------------------------------------------
modelvariables <-c("Days", "Date Type", "School Holydays" , "Winter", "Month", "Year")
modelvariablestext <-c("The week day on day per model", "The type of period use only build various models", "If children are at school", "Two seasons only", "Used as variable for the daily model",  "Used as variable for the daily model" )
variableexplanation <-data.frame(Variables=modelvariables, Comments=modelvariablestext)




#---------------------------
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
 

#output$outliersplot <-renderPlot({
#         return(outlierproductionweekbooth$plot)      
# })
 
output$outlierstable <-renderDataTable({
                        return(outliersdata)        
}) 
 
output$process <-renderImage({
              return(list (src = "images/process.jpg",
                           contentType = "image/jpeg",
                           alt = "Forecasting Project Steps" )
                      
              )
})


output$week <-renderImage({
                return( list (src = "images/week.jpg",
                contentType = "image/jpeg",
                alt = "Week Variations" )
                 )
})


output$variables <-renderTable({
        return(variableexplanation) 
})


})
