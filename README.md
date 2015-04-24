# Forecasting
The forecasting to conduct is about electricity production. You can find more explanations and the results under [Shiny](https://innovitnow.shinyapps.io/Shiny/). The full application has been built using R and Shiny. 
The forecasting application built is for daily prediction.  After evalaution only six main variables were siginificant (for the moment), the training set was two and half years of production.

**About the model**

The final forcasting application is made of eleven models using two main methods:

1. The daily modoels. One model per day of the week, the method used is gradient bosting. 

2. Chistmas Period. Using a GAM model after testing with loess and cubic polynomial. This model goes over a period of twelve days. 

3. Easter as for Christmas but shorter.

4. Some other special period using GAM as well to model. 


**About Shiny Design**

Some graphics such as time serie, boxplot have been integrated as graphic rather than to be built live.  
I the summary page, the first graphic has been made with RCharts type Morris. The other "live" graphics use the R vasis Graphic functions. 
