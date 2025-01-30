library(readr)
library(dplyr)
library(lubridate)
library(zoo)

df <- read_csv('/Users/danielferreira/Documents/git/classes/ASN/Séries Temporais/dados/netflix_titles.csv')

head(df)

df$date_added <- as.Date(df$date_added, format="%B %d, %Y")

colSums(is.na(df))

df$director <- ifelse(is.na(df$director), 'No Director', df$director)
df$cast <- ifelse(is.na(df$cast), 'No Cast', df$cast)
df$country <- ifelse(is.na(df$country), 'No Country', df$country)
df$rating <- ifelse(is.na(df$rating), 'No Rating', df$rating)
df$duration <- ifelse(is.na(df$duration), 'No Duration', df$duration)

# Remove rows where 'date_added' is NA
df <- df[!is.na(df$date_added), ]

colSums(is.na(df))

lancamentos <- df %>%
  group_by(month = floor_date(date_added, "month")) %>%
  summarise(count = n())

print(lancamentos)

lancamentos <- lancamentos[-(nrow(lancamentos) - 2), ]

all_months <- seq.Date(from = min(df$date_added), to = max(df$date_added), by = "month")

# Find missing months by comparing with lancamentos$month
missing_months <- setdiff(all_months, lancamentos$month)

# Resultado
if (length(missing_months) == 0) {
  print("Nenhum mês faltando.")
} else {
  print(paste("Meses faltando:", toString(missing_months)))
}

lancamentos_zero <- left_join(data.frame(month = all_months), lancamentos, by = "month") %>%
  mutate(count = replace(count, is.na(count), 0))

lancamentos_ffill <- zoo(lancamentos$count, lancamentos$month)
lancamentos_ffill <- na.locf(lancamentos_ffill, fromLast = FALSE)

lancamentos_bfill <- zoo(lancamentos$count, lancamentos$month)
lancamentos_bfill <- na.locf(lancamentos_bfill, fromLast = TRUE)

lancamentos_neighbors <- zoo(lancamentos$count, lancamentos$month)
lancamentos_neighbors <- na.approx(lancamentos_neighbors, method = "linear")

lancamentos_quadratic <- zoo(lancamentos$count, lancamentos$month)
lancamentos_quadratic <- na.approx(lancamentos_quadratic, method = "Spline")
