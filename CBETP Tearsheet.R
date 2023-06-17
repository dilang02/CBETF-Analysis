graphics.off()
rm(list=ls()) # Reset work environment
library(yahoofinancer) # Call packages for financial data API, forecasting, and statistical testing
library(forecast)
library(zoo)
library(lubridate)
library(urca)
product_list <- c("CORN","WEAT","SOYB","CANE","SPY","AAAU","SLV","CPER","COW","BAL","NIB","JO","UNG","UCO","PALL","PPLT","JJN","JJT","JJU","LD") # Adjustable list of commodity-backed ETFs
for (i in 1:length(product_list)){ # Iterate through all 20 products
symbol <- product_list[i]
product <- Ticker$new(symbol)
product$fund_performance # !! Extract fund data from here
data_mo <- product$get_history(start = Sys.Date()-years(5), end = Sys.Date(), interval = '1mo') # Monthly data from past 5 years
data_d <- product$get_history(start = Sys.Date()-years(2), end = Sys.Date(), interval = '1d') # Daily data from past 2 years
data_mo_ts <- ts(data_mo$adj_close,frequency=12)
data_d_ts <- ts(data_d$adj_close,frequency=1)
#plot(decompose(data_mo_ts))
#plot(ur.df(data_mo_ts,type = "drift",selectlags = "AIC"))
#plot(ur.df(data_d_ts,type = "drift",selectlags = "AIC"))

MA <- rollmean(data_d_ts,k=30,fill=NA,align="right") # Create moving average and ARIMA forecasts
#plot(data_d_ts,main="Moving Average Forecast")
#lines(MA,col="red")
arima <- auto.arima(data_d_ts,ic="aic")
#show(summary(arima))
#show(Box.test(residuals(arima),type="Ljung-Box"))
#plot(forecast(arima,h=100))

library(knitr)
library(rmarkdown)
tearsheet <- paste0("C:/Users/dilan/OneDrive/Documents/Thesis/",symbol,".Tearsheet.rmd") # Create tearsheet template
content <- "
# Commodity-Backed Exchange-Traded Product Tearsheet
The following data is for the CBETP:
```{r}
show(as.data.frame(product$fund_performance$risk_statistics))
```

# Product Information

Fund Details:

# ETP Performance

Fund Performance:

# Analysis:

```{r,fig.width=6,fig.height=4,echo=FALSE}
plot(decompose(data_mo_ts))
plot(ur.df(data_mo_ts,type = 'drift',selectlags = 'AIC'))
plot(ur.df(data_d_ts,type = 'drift',selectlags = 'AIC'))
plot(data_d_ts,main='Moving Average Forecast')
lines(MA,col='red')
plot(forecast(arima,h=100))
```

The following is a test document for CBETP research purposes.
"
library(pagedown) # Export markdown file to HTML & PDF
writeLines(content,tearsheet)
chrome_print(input = tearsheet, output = paste0("C:/Users/dilan/OneDrive/Documents/Thesis/",symbol,".Tearsheet.pdf"))
}
