# MSE

$$
\Large \frac{1}{n} \sum\limits_{t=1}^{n} \left(Y_{t} - \hat{Y}_{t} \right)^2
$$

# Passeio Aleatório
$$
\Large \hat{Y}_{t}=Y_{t-1}
$$

# Passeio Aleatório Sazonal
$$
\Large \hat{Y}_{t}=Y_{t-12}
$$

# Suavização Exponencial

$$
\Large \hat{Y}_{t} = \alpha Y_{t-1} + (1 - \alpha) \hat{Y}_{t-1} 
$$

$$
\Large \hat{Y}_{t-1} = \alpha Y_{t-2} + (1 - \alpha) \hat{Y}_{t-2} 
$$

$$
\Large \hat{Y}_{t} = \alpha Y_{t-1} + (1 - \alpha) \alpha Y_{t-2} + (1 - \alpha) \hat{Y}_{t-2} 
$$

$$
\Large \hat{Y}_{t} = \alpha Y_{t-1} + (1 - \alpha) \alpha Y_{t-2} + (1 - \alpha)^2 \alpha Y_{t-3} + ...
$$