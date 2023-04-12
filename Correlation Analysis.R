rm(list=ls()) # Clear RStudio and receive user input
graphics.off()
returns <- c() # Establish variables
product_list <- c("CORN","WEAT","SOYB","CANE","SPY","AAAU","SLV","CPER","COW") # Adjustable list of commodity-backed ETFs


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


# Report profitability/risk metrics
year1 <- returns_matrix[1:252,]
year2 <- returns_matrix[253:503,] 
year1_returns <- colMeans(year1)
year1_risk <- apply(year1,2,sd)
year2_returns <- colMeans(year2)
year2_risk <- apply(year2,2,sd)
sharpe <- rbind(year1_returns,year1_risk,year2_returns,year2_risk)
show(sharpe)
plot(year1_risk,year1_returns, col="red",main="Year 1: Products by Risk/Returns") # Visualize risk/returns
abline(v=mean(year1_risk))
abline(h=mean(year1_returns))
text(year1_risk,year1_returns,labels=product_list)
plot(year2_risk,year2_returns, col="red",main="Year 2: Products by Risk/Returns")
abline(v=mean(year2_risk))
abline(h=mean(year2_returns))
text(year2_risk,year2_returns,labels=product_list)

# Aggregate price and volume data for all products
price_matrix <- cbind(read.csv(paste0("~/Thesis/",product_list[1],".csv"))[,6],read.csv(paste0("~/Thesis/",product_list[2],".csv"))[,6])
volume_matrix <- cbind(read.csv(paste0("~/Thesis/",product_list[1],".csv"))[,7],read.csv(paste0("~/Thesis/",product_list[2],".csv"))[,7])
for (i in 1:length(product_list)){
  price <- read.csv(paste0("~/Thesis/",product_list[i],".csv"))[,6]
  volume <- read.csv(paste0("~/Thesis/",product_list[i],".csv"))[,7]
  assign(paste0("price_",i),price)
  assign(paste0("volume_",i),volume)
  price_matrix <- cbind(price_matrix,price)
  volume_matrix <- cbind(volume_matrix,volume)
}
price_matrix <- price_matrix[,-c(1,2)]
volume_matrix <- volume_matrix[,-c(1,2)]
colnames(price_matrix) <- product_list
colnames(volume_matrix) <- product_list

price_cormatrix <- cor(price_matrix) # Determine correlation matrix for all products with respect to price and volume
vol_cormatrix <- cor(volume_matrix)
print("PRICE CORRELATION MATRIX:")
show(price_cormatrix)
print("VOLUME CORRELATION MATRIX:")
show(vol_cormatrix)