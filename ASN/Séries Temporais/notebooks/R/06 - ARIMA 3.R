library(ggplot2)

df <- read.csv('/Users/danielferreira/Documents/git/classes/ASN/Séries Temporais/dados/clicks_original.csv')

clicks <- df$clicks
price <- df$price

# Generate cross-correlation plot
ccf_result <- ccf(clicks, price)

# Convert to data frame for ggplot
ccf_df <- data.frame(
  lag = ccf_result$lag,
  correlation = ccf_result$acf
)

# Plot using ggplot2
ggplot(ccf_df, aes(x = lag, y = correlation)) +
  geom_stem() +
  geom_hline(yintercept = c(-1.96/sqrt(length(clicks)), 1.96/sqrt(length(clicks))), linetype = "dashed", color = "red") +
  labs(title = "Cross-correlation between clicks and price", x = "Lag", y = "Cross-correlation") +
  theme_minimal()
