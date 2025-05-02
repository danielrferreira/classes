# Carregar pacotes necessários
library(readr)
library(lubridate)
library(dplyr)
library(forecast)

# Ler o arquivo CSV
df <- read_csv("../../dados/clicks_original.csv")
# Remover a última linha
df <- df[-nrow(df), ]
df$date <- seq(as.Date("2008-07-01"), by = "days", length.out = nrow(df))

y <- as.numeric(df$clicks)
x_matrix <- as.matrix(as.numeric(df$price))

# SARIMAX

model1 <- Arima(y, order = c(1,1,1), xreg = x_matrix)
summary(model1)


# Variável de Outlier

df <- read_csv("../../dados/clicks_original_bug.csv")
df$date <- seq(as.Date("2008-07-01"), by = "days", length.out = nrow(df))

# Definir as datas de início e fim
start_date <- as.Date("2008-07-22")
end_date <- as.Date("2008-07-28")


# Criar a coluna 'bug' como 1 se a data estiver dentro do intervalo, senão 0
df$bug <- ifelse(df$date >= start_date & df$date <= end_date, 1, 0)
model2 <- Arima(df$clicks, order = c(0,1,1), xreg = df$bug)
summary(model2)
