# Holdout
library(dplyr)
library(lubridate)

# Exemplo: Suponha que temos uma série temporal com datas
data <- data.frame(
  date = seq(ymd("2000-01-01"), ymd("2023-12-01"), by = "months"),
  value = rnorm(288) # Exemplo de valores aleatórios
)

# Definir o ponto de corte para os últimos 24 meses
cutoff_date <- max(data$date) %m-% months(24)

# Criar conjuntos de treinamento e holdout
train <- data %>% filter(date <= cutoff_date)
holdout <- data %>% filter(date > cutoff_date)

library(ggplot2)

ggplot(data, aes(x = date, y = value)) +
  geom_line() +
  geom_vline(xintercept = as.numeric(cutoff_date), linetype = "dashed", color = "red") +
  labs(title = "Divisão entre Treinamento e Holdout", x = "Data", y = "Valor") +
  theme_minimal()

# Random Walk
library(forecast)

model_naive <- naive(train$value, h = 24)
autoplot(model_naive)

# Naive Sazonal
model_snaive <- snaive(train$value, h = 24)
autoplot(model_snaive)

library(TTR)

# Media Movel
moving_avg <- SMA(train$value, n = 12) # Média móvel de 12 períodos
plot(moving_avg, type = "l")

library(Metrics)

# Alisamento Exponencial
model_ets <- ses(train$value, h = 24)
autoplot(model_ets)
