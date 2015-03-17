
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rCharts)
library(lubridate)
library(BH)
options(RCHART_WIDTH = 400)

# We put it there to see 
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

#
#  Transform tha dat in Year Month Day 
#
reformatdate <-function(Date){
        Date <-unlist(strsplit(Date, split="-"))
        Date[3] <-paste0(c("20"), Date[3])
        Date <-paste(Date[3],Date[2],Date[1],sep="-")
        Date
}


#   ---------------------
#   Build the fix objects
#   ---------------------
trainingset <-GetDataRWE()
for( loop in 1:nrow(trainingset)){
        trainingset$Date[loop] <-reformatdate(trainingset$Date[loop])
}
trainingset12 <-trainingset[year(trainingset$Date) %in% c("2012"),]


shinyServer(function(input, output) {
        
output$distPlot <- renderChart({
        
         Rmgraph <-mPlot(x = "Date", y = "volume", type = "Line", data = trainingset12,
                          pointSize = 0, lineWidth = 1 )
         Rmgraph$set(dom = 'distPlot')
         return(Rmgraph)
         })

    output$processingMessage<- renderText({ 
            "In Process"
    })
    
    
    
})
