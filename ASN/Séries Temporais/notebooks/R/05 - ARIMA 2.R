# Carregando pacotes necessários
library(ggplot2)
library(dplyr)
library(readr)
library(zoo)
library(tseries)
library(urca)
library(MASS)
library(forecast)


df <- read_csv('../../dados/AR_Exemplo.csv')

Y <- ts(df$preco_diff, start = c(2024, 1), frequency = 1)

autoplot(Y) + ggtitle("Time Series Plot") + xlab("Date") + ylab("Preco Diff")

# ARIMA Model (3,1,0)
model <- Arima(primeira_ordem, order = c(3, 1, 0), include.constant = FALSE)
summary(model)

# Exemplo ARIMA com possibilidade de modelos incompletos:
Y <- read.csv('../../dados/ARIMA_Exemplo.csv')
Y$Date <- seq(from = as.Date('2024-01-01'), by = "day", length.out = nrow(Y))
Y <- ts(Y$preco, start = c(2024, 1), frequency = 365) 
plot(Y, type = "l", col = "blue", main = "Time Series Plot", xlab = "Date", ylab = "Preco Diff")

# Modelo incompleto
model_arma_custom <- arima(Y, order = c(3, 1, 3), fixed = c(NA, NA, NA, 0, 0, NA))
summary(model_arma_custom)
residuals_arma <- model_arma_custom$residuals
acf(residuals_arma, main = "ACF of Residuals")
pacf(residuals_arma, main = "PACF of Residuals")
