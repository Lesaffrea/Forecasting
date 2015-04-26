Electricity Prediction 
========================================================
author: Alain Lesaffre
date:  24th April 2015
![Distribution](./images/pylons.jpg)
Summary
========================================================

This presentation is about electricty production forecasting and its supporting application. 
The [application](https://innovitnow.shinyapps.io/Shiny/) explains how the model has been built and exhibits some "chucks" of data and few graphics. The final application has been made in multiple steps are represented on the Introduction page of the application. The steps take have been:

- Preprocessing. 
- Eda and first evaluation of the models.
- Build the models selected
- Build the final report which will run the prediction 
The Data
=======================================================

The data set we used comes from one German electricity producer and includes three years of daily data. To the difference of usual models, the prediction was for one day. In some other case the prediction should be made for 30 minutes or 48 predictions per day. 

<img src="Presentation-figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="800px" />


Preprocessing and Outliers
========================================================

The first step in building the model is to identify the outliers as those exceptions even if we use a robust model some exceptions should be removed. The following graphic shows the exceptions. 
The exceptions have been group in three categories: Week day, Christmas, Easter and onter exceptional period classified as M1 and M2 by the day_type variable (see application for details)

<img src="Presentation-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="800px" />
The Variables
========================================================

To build the final model we uses not more than ten variables, which are:

1. The day of the week (Monday to Sunday)
2. The Month ot the year 
3. The year 
4. The temperature even if not so influencial based on linear model the variable is significant 
5. School Holidays or not 
6. The radiance, that is the sun intensity 

The Model and final report 
========================================================
As mentioned before and explained in the Introduction page of the application, we build multiple models, which we stacked. 

1. One prediction model per week day using gradient boosting 
2. One model for the Christmas period built using GAM 
3. One model for Easter also build using GAM 
4. One model for the two other exceptiona period

Caret and Code example  
========================================================
The following example is usage of boosting for one day of the week. The training set has be cleared from its exception at this stage.
The number of iteration has been defined after optimization 

library(mboost)
....

niterations <- c(10000)

fridayobs <-dayweekproduction[ dayweekproduction$weekday %in% c("Friday"),]

fridaylmmodelmonth <-glmboost(volume~winter+Solar_Rad+Temp+month+year+school_holiday, 
                              data = fridayobs,
                              control = boost_control(mstop = niterations ))








