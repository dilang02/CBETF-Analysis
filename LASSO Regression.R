rm(list=ls()) # Clear RStudio and receive user input
graphics.off()
returns <- c() # Establish variables
product_list <- c("CORN","WEAT","SOYB","CANE","SPY","AAAU","SLV","CPER","COW","BAL","NIB","JO","UNG","UCO","PALL","PPLT","JJN","JJT","JJU","LD") # Adjustable list of commodity-backed ETFs
show(paste("Number of commodity-backed ETFs:",length(product_list)))

for (i in 1:length(product_list)){ # Create databases for each product
  assign(paste0(product_list[i],"_data"), read.csv(paste0("~/Thesis/",product_list[i],".csv")))
  n=1
  while (n <= nrow(read.csv(paste0("~/Thesis/",product_list[i],".csv")))){ # Calculate daily returns
    if (n == 1){
      returns <- append(returns,0)
    }
    else{
      return <- (read.csv(paste0("~/Thesis/",product_list[i],".csv"))[n,6] / read.csv(paste0("~/Thesis/",product_list[i],".csv"))[n-1,6] - 1)*100
      returns <- append(returns, return)
    }
    n=n+1
  }
  
  if (i == 1){
    returns_matrix <- matrix(returns,ncol=1)
  }else{
    returns_matrix <- cbind(returns_matrix,returns)
  }
  returns <- c()
}
colnames(returns_matrix) <- product_list

library(glmnet)
for (i in 1:length(product_list)){ # Create LASSO model for each product
  y <- returns_matrix[,i] # Isolate each product as the dependent variable
  x <- data.matrix(returns_matrix[,-i])
  cv_model <- cv.glmnet(x,y,alpha=1)
  best_lambda <- cv_model$lambda.min # Optimize the lambda parameter
  plot(cv_model,main=paste("Lambda Optimization:",product_list[i]))
  best_model <- glmnet(x,y,alpha=1,lambda=best_lambda) # Calculate best LASSO model
  y_pred <- predict(best_model,s=best_lambda,newx=x)
  SST <- sum((y-mean(y))^2) # Determine accuracy of best model
  SSE <- sum((y_pred-y)^2)
  rsq <- 100*(1 - SSE/SST)
  if (rsq > 50){ # Check if model is significant enough for further analysis
    show(paste("DEPENDENT:",product_list[i]))
    show(paste("OPTIMAL LAMBDA:",best_lambda))
    show(coef(best_model))
    show(paste0("R^2: ",round(rsq,2),"%"))
  } else{
    show(paste("The model for",product_list[i],"was insignificant with R^2 of:",round(rsq,2),"%"))
  }
}

