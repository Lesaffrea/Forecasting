# Forecasting
The forecasting to conduct is about electricity production. You can find more explanations and the results under [Shiny](https://innovitnow.shinyapps.io/Shiny/). The full application has been built using R and Shiny. 
The forecasting application built is for daily prediction.  After evaluation only six main variables were siginificant (for the moment), the training set was two and half years of production.
In this repository you will find:

1. The Shiny files

2. The Presentation in Html and Rpres format. To view the presentation go to [Rpubs](http://rpubs.com/Lesaffrea/76671)

**About the model**

The final forcasting application is made of eleven models using two main methods:

1. The daily modols. One model per day of the week, the method used is gradient bosting. 

2. Chistmas Period. Using a GAM model after testing with loess and cubic polynomial. This model goes over a period of twelve days. 

3. Easter as for Christmas but shorter.

4. Some other special period using GAM as well. 


**About Shiny Design**

Some graphics such as process or the boxplot for production by day have been integrated as graphic rather than to be built live. 
 1. In the summary page.  The process is an image in html wherea the yearly production plot has been made with RCharts type Morris
 2. In the Model page.    The first boxplot is integrated as image, wheras the graphic production * Temp is made as plot using ggplot 
