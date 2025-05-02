library(readr)
library(dplyr)
library(lubridate)
library(zoo)
library(ggplot2)

# 01 - Criando Séries Temporais
# Esse código mostra algumas formas de criar e séries temporais através de dados transacionais. Iremos usar uma tabela com os lançamentos da Netflix. Mais informações sobre a tabela [aqui](https://www.kaggle.com/datasets/anandshaw2001/netflix-movies-and-tv-shows/code).

# Links importantes:
# - https://pandas.pydata.org/docs/reference/api/pandas.to_datetime.html
# - https://pandas.pydata.org/docs/reference/api/pandas.date_range.html
# - https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.resample.html#pandas.DataFrame.resample

## Preparação dos dados

df <- read_csv('../../dados/netflix_titles.csv')

head(df)

# Transformando a coluna em tipo data:

df$date_added <- as.Date(df$date_added, format="%B %d, %Y")

# Checagem Missings:
colSums(is.na(df))

# Muitos missings, substituir alguns e checar missings de novo:
df$director <- ifelse(is.na(df$director), 'No Director', df$director)
df$cast <- ifelse(is.na(df$cast), 'No Cast', df$cast)
df$country <- ifelse(is.na(df$country), 'No Country', df$country)
df$rating <- ifelse(is.na(df$rating), 'No Rating', df$rating)
df$duration <- ifelse(is.na(df$duration), 'No Duration', df$duration)
df <- df[!is.na(df$date_added), ]
colSums(is.na(df))

# Para agregar os dados, podemos usar dplyr
lancamentos <- df %>%
  group_by(month = floor_date(date_added, "month")) %>%
  summarise(count = n())
print(lancamentos)

# Criando uma função para plotar esses dados:
plot_lancamentos <- function(data, title = "Lançamentos ao longo do tempo") {
  ggplot(data, aes(x = month, y = count)) +
    geom_line() +
    geom_point() +
    labs(title = title,
         x = "Ano",
         y = "Número de Lançamentos") +
    theme_minimal()
}

# Plotar lancamentos
plot_lancamentos((lancamentos))

# Código para checar se falta data:
all_months <- seq.Date(from = min(lancamentos$month),
                       to = max(lancamentos$month),
                       by = "month")
missing_months <- setdiff(all_months, lancamentos$month)
missing_months <- as.Date(missing_months)

if (length(missing_months) == 0) {
  print("Nenhum mês faltando.")
} else {
  print("Meses faltando:")
  print(format(missing_months, "%Y-%m"))
}

# Como filtrar usando ano:
lancamentos <- lancamentos %>%
  filter(year(month) >= 2016)

plot_lancamentos((lancamentos))

# Tratamento de Missings, Reparem que o gráfico esconde a falta de uma data:
lancamentos <- lancamentos[-(nrow(lancamentos) - 2), ]
plot_lancamentos((lancamentos))

all_months <- seq.Date(from = min(lancamentos$month),
                       to = max(lancamentos$month),
                       by = "month")
missing_months <- setdiff(all_months, lancamentos$month)
missing_months <- as.Date(missing_months)

if (length(missing_months) == 0) {
  print("Nenhum mês faltando.")
} else {
  print("Meses faltando:")
  print(format(missing_months, "%Y-%m"))
}

# Código para checar se falta data:
all_months <- seq.Date(from = min(lancamentos$month),
                       to = max(lancamentos$month),
                       by = "month")
missing_months <- setdiff(all_months, lancamentos$month)
missing_months <- as.Date(missing_months) 

if (length(missing_months) == 0) {
  print("Nenhum mês faltando.")
} else {
  print("Meses faltando:")
  print(format(missing_months, "%Y-%m"))
}

# Preenchimento de Missings
# 0
lancamentos_zero <- left_join(data.frame(month = all_months), lancamentos, by = "month") %>%
  mutate(count = replace(count, is.na(count), 0))
plot_lancamentos((lancamentos_zero))

# Forward Fill
lancamentos_ffill <- merge(zoo(lancamentos$count, lancamentos$month), zoo(, all_months), all = TRUE)
lancamentos_ffill <- na.locf(lancamentos_ffill, fromLast = FALSE)
print(lancamentos_ffill)
lancamentos_ffill_df <- data.frame(
  month = index(lancamentos_ffill),
  count = coredata(lancamentos_ffill)
)
plot_lancamentos((lancamentos_ffill_df))

# Backward Fill
lancamentos_bfill <- merge(zoo(lancamentos$count, lancamentos$month), zoo(, all_months), all = TRUE)
lancamentos_bfill <- na.locf(lancamentos_bfill, fromLast = TRUE)
lancamentos_bfill_df <- data.frame(
  month = index(lancamentos_bfill),
  count = coredata(lancamentos_bfill)
)
plot_lancamentos((lancamentos_bfill_df))

# Linear
lancamentos_linear <- merge(zoo(lancamentos$count, lancamentos$month), zoo(, all_months), all = TRUE)
lancamentos_linear <- na.approx(lancamentos_linear, method = "linear")
lancamentos_linear_df <- data.frame(
  month = index(lancamentos_linear),
  count = coredata(lancamentos_linear))
plot_lancamentos((lancamentos_linear_df))
