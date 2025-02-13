# Carregar as bibliotecas necessárias
library(tsibble)
library(fable)
library(feasts)
library(ggplot2)
library(dplyr)


# Converter o conjunto de dados AirPassengers em um tsibble
air_data <- as_tsibble(AirPassengers)

# Criar um gráfico sazonal
gg_season(air_data, y = value) +
  labs(title = "Gráfico Sazonal do AirPassengers", y = "Número de Passageiros", x = "Mês") +
  theme_minimal()

# Criar um gráfico sazonal radial
gg_season(air_data, y = value, polar=TRUE) +
  labs(title = "Gráfico Sazonal do AirPassengers", y = "Número de Passageiros", x = "Mês") +
  theme_minimal()

# Definir o horizonte de previsão (24 meses)
h <- 24  

# Ajustar modelos de alisamento exponencial
modelos <- air_data %>%
  model(
    SES = ETS(value ~ error("A") + trend("N") + season("N")),  # Suavização Exponencial Simples
    Holt = ETS(value ~ error("A") + trend("A") + season("N")), # Holt (tendência aditiva)
    Holt_Damped = ETS(value ~ error("A") + trend("Ad") + season("N")), # Holt Amortecido
    Holt_Winters_Add = ETS(value ~ error("A") + trend("A") + season("A")), # Holt-Winters Aditivo
    Holt_Winters_Mul = ETS(value ~ error("M") + trend("A") + season("M"))  # Holt-Winters Multiplicativo
  )

# Criar previsões
previsoes <- modelos %>% forecast(h = h)

# Gerar gráficos para cada modelo
previsoes %>%
  autoplot(air_data) +
  facet_wrap(~ .model, scales = "free_y") +  # Criar um gráfico para cada modelo
  labs(title = "Previsões com Modelos de Alisamento Exponencial",
       y = "Número de Passageiros",
       x = "Ano") +
  theme_minimal()
