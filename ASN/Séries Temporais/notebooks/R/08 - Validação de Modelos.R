# Criar Hold Out
# Métricas Penalizadas
# Imprimir AIC, BIC, AICC e HQIC do modelo
cat("AIC:", AIC(model6), "\n")
cat("BIC:", BIC(model6), "\n")
cat("AICC:", AIC(model6, k = log(length(df$clicks))), "\n")  # AICC pode ser calculado manualmente
cat("HQIC:", AIC(model6, k = 2*log(log(length(df$clicks)))), "\n")  # HQIC pode ser calculado manualmente
# Métricas Não Penalizadas
# Auto Arima