rm(list=ls()) # Clear RStudio and receive user input
graphics.off()
returns <- c() # Establish variables
product_list <- c("CORN","WEAT","SOYB","CANE","SPY","AAAU","SLV","CPER","COW","BAL","NIB","JO","UNG","UCO","PALL","PPLT","JJN","JJT","JJU","LD") # Adjustable list of commodity-backed ETFs
show(paste("Number of commodity-backed ETFs:",length(product_list)))

library(tidyverse) # Import risk-return data from previous analyses
library(neuralnet)
library(xlsx)
nn_data <- read.xlsx("~/Thesis/Risk-Return.xlsx",sheetName="Categories")
options(mySeed=7410)

model = neuralnet( # Create broad categorization network
  formula = Category~year1_returns+year1_risk+year2_returns+year2_risk,
  data=nn_data,
  hidden=c(4,3),
  linear.output = FALSE,
  stepmax = 1e+06,
  threshold = 0.01,
  rep = 10
)
plot(model,rep = "best")

pred <- predict(model, nn_data) # Check accuracy of model
confusion <- table(as.numeric(factor(nn_data$Category)),max.col(pred))
row.names(confusion) <- levels(factor(nn_data$Category))
colnames(confusion) <- levels(factor(nn_data$Category))
names(dimnames(confusion)) <- c("observed","predicted")
check = as.numeric(factor(nn_data$Category)) == max.col(pred)
accuracy = (sum(check)/nrow(nn_data))*100
show(paste0(accuracy,"% accurate"))
show(confusion)

model2 = neuralnet( # Repeat with detailed categorizations
  formula = Category2~year1_returns+year1_risk+year2_returns+year2_risk,
  data=nn_data,
  hidden=c(5,3),
  linear.output = FALSE,
  stepmax = 1e+06,
  threshold = 0.01,
  rep = 10
)
plot(model2,rep = "best")

pred <- predict(model2, nn_data)
confusion2 <- table(as.numeric(factor(nn_data$Category2)),max.col(pred))
row.names(confusion2) <- levels(factor(nn_data$Category2))
colnames(confusion2) <- levels(factor(nn_data$Category2))
names(dimnames(confusion2)) <- c("observed","predicted")
check = as.numeric(factor(nn_data$Category2)) == max.col(pred)
accuracy = (sum(check)/nrow(nn_data))*100
show(paste0(accuracy,"% accurate"))
show(confusion2)

library(xlsx)
write.xlsx(as.data.frame(confusion),"Neural Network.xlsx",sheetName="Broad Categorization")
write.xlsx(as.data.frame(confusion2),"Neural Network.xlsx",sheetName="Specific Categorization",append = TRUE)