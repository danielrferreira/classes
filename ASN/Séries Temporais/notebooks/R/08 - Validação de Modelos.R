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

# Métricas Penalizadas
model <- Arima(train, order = c(1,1,0), seasonal = c(0,1,1))
# Imprimir AIC, BIC, AICC e HQIC do modelo
cat("AIC:", AIC(model), "\n")
cat("BIC:", BIC(model), "\n")
cat("AICC:", AIC(model, k = log(length(milk_prod))), "\n")  # AICC pode ser calculado manualmente
cat("HQIC:", AIC(model, k = 2*log(log(length(milk_prod)))), "\n")  # HQIC pode ser calculado manualmente

# Métricas Não Penalizadas
# Calcular resíduos
predictions <- forecast(model, h = length(test))$mean
residuals <- test - predictions
sum_residuals <- sum(residuals)

print(predictions)
# Calcular métricas de erro
mae <- mean(abs(test - predictions))
mape <- mean(abs((test - predictions) / test)) * 100
mse <- mean((test - predictions)^2)
rmse <- sqrt(mse)

# Exibir resultados
cat("Soma dos Resíduos:", sum_residuals, "\n")
cat("MAE:", mae, "\n")
cat("MAPE:", mape, "%\n")
cat("MSE:", mse, "\n")
cat("RMSE:", rmse, "\n")

# Auto Arima
auto_model <- auto.arima(milk_prod, 
                         seasonal = TRUE, 
                         D = 1,          # Seasonal differencing order
                         stepwise = TRUE, 
                         approximation = FALSE, 
                         ic = "aic",     # Information criterion
                         trace = TRUE)

summary(auto_model)
