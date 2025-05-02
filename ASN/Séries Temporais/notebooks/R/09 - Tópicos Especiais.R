library(readr)
library(lubridate)
library(tsibble)
library(forecast)
library(Metrics)

# Carregar os dados
milk <- read_csv("../../dados/milk_production.csv")

# Converter a coluna 'month' para o formato de data (ano-mês)
milk$month <- yearmonth(milk$month)

# Criar um objeto tsibble, que é uma estrutura adequada para séries temporais em R
milk_ts <- as_tsibble(milk, index = month)

# Extrair apenas a série de produção de leite
milk_prod <- milk_ts$production

# Criar Hold Out
# Definir o tamanho do teste (10% dos dados)
test_size <- round(0.10 * nrow(milk_ts))

# Criar conjunto de treino e teste
train <- head(milk_prod, -test_size)  # Mantém os dados iniciais para treino
train <- ts(train, frequency = 12)
test <- tail(milk_prod, test_size)
test <- as.numeric(test)  # Usa os últimos 10% dos dados para teste

# Auto Arima
auto_model <- auto.arima(milk_prod, 
                         seasonal = TRUE, 
                         D = 1,          # Seasonal differencing order
                         stepwise = TRUE, 
                         approximation = FALSE, 
                         ic = "aic",     # Information criterion
                         trace = TRUE)

summary(auto_model)

# Prophet
library(prophet)
milk_prod <- data.frame(
  ds = milk$month, # Datas
  y = milk_prod  # Valores com sazonalidade
)

# Ajustando o modelo Prophet
model <- prophet(milk_prod)

# Fazendo previsões para os próximos 12 meses
future <- make_future_dataframe(model, periods = 12, freq = "month")
forecast <- predict(model, future)

# Visualizando as previsões
plot(model, forecast)

# Visualizando os componentes (tendência e sazonalidade)
prophet_plot_components(model, forecast)

# Outliers
milk_prod <- milk_ts$production
lag.plot(milk_prod, lags = 1, main = "Lag Plot (Lag = 1)")
