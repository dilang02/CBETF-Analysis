rm(list=ls()) # Clear RStudio and receive user input
graphics.off()
product_list <- c("CORN","WEAT","SOYB","CANE","SPY")
ticker <- readline("Enter the ticker symbol of the commodity-backed ETF:")
sample_data <- read.csv(paste0("~/Thesis/",ticker,".csv"))
returns <- c() # Establish variables
i=1
while (i <= nrow(sample_data)){ # Calculate daily returns
  if (i == 1){
    returns <- append(returns,0)
  }
  else{
    return <- (sample_data[i,6] / sample_data[i-1,6] - 1)*100
    returns <- append(returns, return)
  }
  i=i+1
}
sample_data <- cbind(sample_data,returns)
year1 <- sample_data[1:252,]
year2 <- sample_data[253:503,] # Report profitability/risk metrics
show(paste("Year 1 Annualized Return:",mean(year1$returns),"%"))
show(paste("Year 1 Annualized Volatility:",sd(year1$Adj.Close),"%"))
show(paste("Year 2 Annualized Return:",mean(year1$returns),"%"))
show(paste("Year 2 Annualized Volatility:",sd(year2$Adj.Close),"%"))

for (i in 6:8){ # Show forecasts for price, volume, and returns
  sample_data_ts <- ts(sample_data[i]) # Report linear regression model of time series
  plot.ts(sample_data_ts,main=paste("Linear Model:",colnames(sample_data[i])))
  abline((lm(unlist(sample_data[i])~c(1:nrow(sample_data[i])),col="red")))
  
  plot(HoltWinters(sample_data_ts,gamma=FALSE),main=paste("Holt-Winters Fit:",colnames(sample_data[i]))) # HW Plot
  
  fit <- ets(sample_data_ts) # Create optimized ETS model
  print(colnames(sample_data[i]))
  show(summary(fit))
  acf(residuals(fit)) # Ensure normality of residuals and autocorrelation
  show(Box.test(residuals(fit),type="Ljung-Box"))
  plot(forecast(fit,h=365),main=paste("ETS Model:",colnames(sample_data[i])),xlab="Time") # Plot ETS model
  
  arima <- auto.arima(sample_data_ts,ic="aic") # Determine optimized ARIMA model parameters and report
  show(arima)
  plot(forecast(arima,h=30))
}
