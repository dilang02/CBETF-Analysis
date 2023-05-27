# Analysis of Commodity-Backed Exchange Traded Products
### Dilan Gangopadhyay - Georgetown University McDonough School of Business / Duke University Fuqua School of Business
#### Introduction
As financial markets continue to evolve, exchange traded funds and notes have become increasingly popular amongst retail and institutional investors as a method of easily generating exposure to certain asset groups. Exchange traded funds (ETFs) are pooled investment securities that are often used to track the performance of anything from equity and debt instruments to entire industry sectors. Similar to ETFs, exchange traded notes (ETNs) are unsecured debt securities that are not backed by physical assets but are still used to track securities; while similar in structure to other debt instruments like bonds, ETNs do not pay interest - a feature that allows it to be traded on major stock exchanges.
Because of the liqudity advantage that ETFs and ETNs provide to investors, the products themselves have become ubiquitous in global markets. For example, commodity-backed ETFs and ETNs are simpler to access and manage when compared to directly investing in commodities futures contracts. As a result of this, conducting predictive and prescriptive analyses on the exchange-traded products can provide valuable insights into trends in complex commodity markets. This research focuses on 20 commodity-backed ETF/ETNs as listed below:
1. *CORN* - Teucrium **Corn** Fund
2. *WEAT* - Teucrium **Wheat** Fund
3. *SOYB* - Teucrium **Soybean** Fund
4. *CANE* - Teucrium **Sugar** Fund
5. *SPY* - S&P 500 Index Fund
6. *AAAU* - Goldman Sachs Physical **Gold** ETF
7. *SLV* - iShares **Silver** Trust ETF
8. *CPER* - United States **Copper** Index Fund
9. *COW* - iPath Series B Bloomberg **Livestock** Subindex Total Return ETN
10. *BAL* - Barclays iPath Bloomberg **Cotton** Subindex Total Return ETN
11. *NIB* - Barclays iPath Bloomberg **Cocoa** Subindex Total Return ETN
12. *JO* - Barclays iPath Bloomberg **Coffee** Subindex Total Return ETN
13. *UNG* - United States **Natural Gas** Fund LP
14. *UCO* - ProShares Ultra Bloomberg **Crude Oil** ETF
15. *PALL* - abdrn Physical **Palladium** Shares ETF
16. *PPLT* - abrdn Phyiscal **Platinum** Shares ETF
17. *JJN* - Barclays iPath Bloomberg **Nickel** Subindex Total Return ETN
18. *JJT* - Barclays iPath Bloomberg **Tin** Subindex Total Return ETN
19. *JJU* - Barclays iPath Bloomberg **Aluminum** Subindex Total Return ETN
20. *LD* - Barclays iPath Bloomberg **Lead** Subindex Total Return ETN

#### Forecasting using Holt-Winters and ARIMA Modeling
The code in *Forecasting Analysis.R* is designed to conduct an optimized Holt-Winters, ETS, and ARIMA forecast on the adjusted closing price, trading volume, and daily returns of one of the above 20 commodity-backed ETFs. Please follow the directions below:
1. Ensure all datasets in *ETF DATA.zip* have been downloaded and are set into the correct working directory
2. Input the ticker symbol of the product to view graphical representations of a linear trend model, Holt-Winters forecast, optimized ETS forecast (and corresponding residuals fit chart), and optimized ARIMA forecast. Additionally, the annualized return and risk for the product is listed for both years, along with the corresponding parameters for each forecast conducted above.
#### Searching for Correlations amongst Commodity-Backed ETF/ETNs
The code in *Correlation Analysis.R* is designed to aggregate the data of all twenty commodity-backed ETF/ETNs and compare their respective annualized return and risk while also providing a user-friendly graphic that illustrates this comparison. This is furthered with a formatted correlation matrix that highlights relationships between products. Please follow the directions below:
1. Ensure all datasets in *ETF DATA.zip* have been downloaded and are set into the correct working directory
2. Run the code to view a graphical matrix-like representation of each product's risk/return as compared to the others for both years. Additionally, the correlation matrices for adjusted closing price, trading volume, and daily returns will be displayed and exported into a Excel spreadsheet for reference.
#### Classification Neural Network for Predictive Analysis
The code in *Neural Network.R* is designed to classify each of the twenty products tests into a broad category (ex. Agriculture) and a specific category (ex. Grain) for the purpose of predicting future risks and returns of other products utilizing a black-box model. Please follow the directions below:
1. Ensure all datasets in *ETF DATA.zip* have been downloaded and are set into the correct working directory
2. Run the code to create and view one neural network that broadly classifies the risks/returns of each product into a category and another that includes more specific categories [NOTE: In order to maximize the accuracy of the neural networks, the code may have to be ran multiple times]. Additionally, the confusion matrices for both networks will be displayed for reference.
#### LASSO Regression Modeling of Returns
The code in *LASSO Regression.R* is designed to create optimal multi-linear regression models for each of the twenty products' daily returns for the purpose of highlighting significant relationships between products utilizing machine learning techniques. Please follow the directions below:
1. Ensure all datasets in *ETF DATA.zip* have been downloaded and are set into the correct working directory
2. Run the code to view all significant LASSO models for each product's returns as a function of the returns of the remaining products along with a graphical representation of the lambda optimization process for each product. If the model has an R^2 value of below 50%, it will be reported as insignifcant accordingly. If it is significant, the corresponding parameter(s) will be displayed for reference.

All of the aforementioned analyses are reserved for private and referential use until the official publication of Dilan Gangopadhyay's thesis on commodity-backed ETPs.
