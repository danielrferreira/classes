# Carregando pacotes necessários
library(datasets)
library(ggplot2)
library(lubridate)
library(dplyr)
library(readr)
library(zoo)
library(tseries)
library(urca)
library(MASS)
library(forecast)

# CO2 Data
co2_df <- data.frame(co2 = as.numeric(co2))  # Garante que os dados estejam no formato correto
co2_df$co2 <- na.locf(co2_df$co2, na.rm = FALSE)  # Preenche valores ausentes sem remover NAs iniciais
co2_s <- ts(co2_df$co2, start = c(1958, 1), frequency = 12)  # Ajuste no início da série


# Air Passenger (Tendência e Sazonalidade Multiplicativa)
data("AirPassengers")
airp_s <- ts(AirPassengers, start = c(1949, 1), frequency = 12)

# Séries com ações
file <- "../../dados/closing_price.csv"
closing_price <- read_csv(file)
closing_price$Date <- as.Date(closing_price$Date, format = "%Y-%m-%d")
closing_price <- closing_price %>% group_by(Date = floor_date(Date, "month")) %>% summarise(across(everything(), mean, na.rm = TRUE))

apple <- ts(closing_price$AAPL, start = c(year(min(closing_price$Date)), month(min(closing_price$Date))), frequency = 12)
microsoft <- ts(closing_price$MSFT, start = c(year(min(closing_price$Date)), month(min(closing_price$Date))), frequency = 12)
ibm <- ts(closing_price$IBM, start = c(year(min(closing_price$Date)), month(min(closing_price$Date))), frequency = 12)

# Lançamentos Netflix
netf <- read_csv("../../dados/netflix_titles.csv")
netf$date_added <- as.Date(netf$date_added, format = "%B %d, %Y")
netflix <- table(floor_date(netf$date_added, "month"))
netflix <- ts(netflix[names(netflix) >= "2016-01-01"], start = c(2016, 1), frequency = 12)

# Lista com todas as séries
todas_series <- list(co2_s, airp_s, apple, microsoft, ibm, netflix)

# Plotando as séries temporais
par(mfrow = c(3, 2), mar = c(3, 3, 2, 1))
for (i in seq_along(todas_series)) {
    plot(todas_series[[i]], main = names(todas_series)[i], col = "blue", type = "l")
}
par(mfrow = c(1, 1))

# Operador Lag

set.seed(42)
y <- ts(sample(0:19, 10, replace = TRUE), start = c(2025, 1), frequency = 365)
# Operador Lag
y_lagged <- stats::lag(y,1)

# Função para testar estacionariedade
teste_estacionariedade <- function(s) {
  kpss_test <- ur.kpss(s)
  adf_test <- adf.test(s)
  
  kpss_pv <- kpss_test@teststat
  adf_pv <- adf_test$p.value
  
  kpssh <- ifelse(kpss_pv < 0.05, "Não Estacionário", "Estacionário")
  adfh <- ifelse(adf_pv < 0.05, "Estacionário", "Não Estacionário")
  
  return(c(KPSS = kpssh, ADF = adfh))
}

teste_estacionariedade(co2_s)


# Função para testar estacionariedade
teste_estacionariedade <- function(s) {
  kpss_test <- ur.kpss(s)
  adf_test <- adf.test(s)
  
  kpss_pv <- kpss_test@teststat
  adf_pv <- adf_test$p.value
  
  kpssh <- ifelse(kpss_pv < 0.05, "Não Estacionário", "Estacionário")
  adfh <- ifelse(adf_pv < 0.05, "Estacionário", "Não Estacionário")
  
  return(c(KPSS = kpssh, ADF = adfh))
}

teste_estacionariedade(co2_s)

# Transformacoes
serie_original <- co2_s
primeira_ordem <- diff(serie_original)

segunda_ordem <- diff(diff(serie_original))

diff_sazonal <- diff(serie_original, lag = 12)

log_diff <- diff(log(serie_original))

boxcox_result <- boxcox(serie_original ~ 1)

# ACF e PACF
Acf(y)

Pacf(y)

# Teste de correlação dos lags
ljung_box_test <- Box.test(co2_s, lag = 10, type = "Ljung-Box")
ljung_box_test


# Modelos AR

# AR(1)
model <- Arima(primeira_ordem, order = c(1, 0, 0), include.constant = FALSE)
summary(model)

# AR(3)
model <- Arima(primeira_ordem, order = c(3, 0, 0), include.constant = FALSE)
summary(model)

