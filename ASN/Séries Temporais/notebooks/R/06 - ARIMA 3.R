library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)
library(stats)
library(tibble)
library(forecast)

# Importação das séries
Y <- read_csv('../../dados/ARIMA_Exemplo.csv')
milk <- read_csv('../../dados/milk_production.csv')
milk$mes <- milk$month  
milk$mes <- ymd(milk$mes)
milk_ts <- ts(milk$production, start = c(year(min(milk$mes)), month(min(milk$mes))), frequency = 12)
milk_tibble <- tibble(Date = milk$mes, `produção de leite` = milk$production)

# Modelo incompleto
model <- arima(Y, order = c(2, 1, 3), fixed = c(NA, NA, 0, 0, NA)) # Fixando os MA dos lags 1 e 2 a serem 0
coef(model)

# Modelo sazonal
model2 <- Arima(milk_ts, order = c(1, 1, 0), seasonal = c(0, 1, 1)) # Reparem que o 12 já foi declarado na criação da série milk_ts
summary(model2)

# CCF Plot
df <- read.csv('../../dados/clicks_original.csv')

clicks <- df$clicks
price <- df$price
ccf_result <- ccf(clicks, price)
ccf_df <- data.frame(
  lag = ccf_result$lag,
  correlation = ccf_result$acf
)
ggplot(ccf_df, aes(x = lag, y = correlation)) +
  geom_stem() +
  geom_hline(yintercept = c(-1.96/sqrt(length(clicks)), 1.96/sqrt(length(clicks))), linetype = "dashed", color = "red") +
  labs(title = "Cross-correlation between clicks and price", x = "Lag", y = "Cross-correlation") +
  theme_minimal()
