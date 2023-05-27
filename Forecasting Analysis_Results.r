rm(list=ls()) # Clear RStudio
graphics.off()
returns <- c() # Establish variables
fit_methods <- c()
fit_aics <- c()
box_ps <- c()
arima_pars <- c()
arima_aics <- c()
library(forecast)
# RESULTS
product_list <- c("CORN","WEAT","SOYB","CANE","SPY","AAAU","SLV","CPER","COW","BAL","NIB","JO","UNG","UCO","PALL","PPLT","JJN","JJT","JJU","LD") # Adjustable list of commodity-backed ETFs
slope_list <- c()
for (x in 1:length(product_list)){
  sample_data <- read.csv(paste0("~/Thesis/",product_list[x],".csv"))
  n=1
  while (n <= nrow(read.csv(paste0("~/Thesis/",product_list[x],".csv")))){ # Calculate daily returns
    if (n == 1){
      returns <- append(returns,0)
    }
    else{
      return <- (read.csv(paste0("~/Thesis/",product_list[x],".csv"))[n,6] / read.csv(paste0("~/Thesis/",product_list[x],".csv"))[n-1,6] - 1)*100
      returns <- append(returns, return)
    }
    n=n+1
  }
  sample_data <- cbind(sample_data,returns)
  
  for (i in 6:8){ # Show forecasts for price, volume, and returns
    lm_temp <- lm(unlist(sample_data[i])~c(1:nrow(sample_data[i]))) # Report linear regression model of time series
    slope_temp <- summary(lm_temp)$coef[2,1]
    slope_list <- append(slope_list,slope_temp)
    sample_data_ts <- ts(sample_data[i])
    fit <- ets(sample_data_ts) # Create optimized ETS model
    fit_method <- fit$method
    fit_methods <- append(fit_methods, fit_method)
    fit_aic <- fit$aic
    fit_aics <- append(fit_aics,fit_aic)
    box_test <- Box.test(residuals(fit),type="Ljung-Box")
    box_p <- box_test$p.value
    box_ps <- append(box_ps,box_p)
    arima <- auto.arima(sample_data_ts,ic="aic") # Determine optimized ARIMA model parameters and report
    arima_par <- toString(arimaorder(arima))
    arima_pars <- append(arima_pars,arima_par)
    arima_aic <- arima$aic
    arima_aics <- append(arima_aics,arima_aic)
  }
}
slope_matrix <- matrix(unlist(slope_list),length(product_list),3,byrow=TRUE) # Export all results to Excel
rownames(slope_matrix) <- product_list
colnames(slope_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(slope_matrix)
library(xlsx)
write.xlsx(as.data.frame(slope_matrix),"LM Results.xlsx",sheetName="Results")

fitmethods_matrix <- matrix(unlist(fit_methods),length(product_list),3,byrow=TRUE)
rownames(fitmethods_matrix) <- product_list
colnames(fitmethods_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(fitmethods_matrix)
write.xlsx(as.data.frame(fitmethods_matrix),"ETS Results.xlsx",sheetName="ETS Parameter Results")

fitaic_matrix <- matrix(unlist(fit_aics),length(product_list),3,byrow=TRUE)
rownames(fitaic_matrix) <- product_list
colnames(fitaic_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(fitaic_matrix)
write.xlsx(as.data.frame(fitaic_matrix),"ETS Results.xlsx",sheetName="ETS AIC Results",append=TRUE)

boxp_matrix <- matrix(unlist(box_ps),length(product_list),3,byrow=TRUE)
rownames(boxp_matrix) <- product_list
colnames(boxp_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(boxp_matrix)
write.xlsx(as.data.frame(boxp_matrix),"Ljung-Box Results.xlsx",sheetName="P-value Results")

arimap_matrix <- matrix(unlist(arima_pars),length(product_list),3,byrow=TRUE)
rownames(arimap_matrix) <- product_list
colnames(arimap_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(arimap_matrix)
write.xlsx(as.data.frame(arimap_matrix),"ARIMA Results.xlsx",sheetName="ARIMA Parameter Results")

arimaaic_matrix <- matrix(unlist(arima_aics),length(product_list),3,byrow=TRUE)
rownames(arimaaic_matrix) <- product_list
colnames(arimaaic_matrix) <- c("Adj. Closing Price","Volume","Returns")
show(arimaaic_matrix)
write.xlsx(as.data.frame(arimaaic_matrix),"ARIMA Results.xlsx",sheetName="ARIMA AIC Results",append=TRUE)