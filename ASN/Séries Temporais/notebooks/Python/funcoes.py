import numpy as np
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller, kpss
import warnings

def all_ac(Y, lags=15):
    """
    Plota a Função de Autocorrelação (ACF) e a Função de Autocorrelação Parcial (PACF) para uma série temporal.

    Parâmetros:
    Y (pd.Series): Série temporal.
    lags (int): Número de defasagens a serem plotadas. Padrão é 15.
    """
    fig, ax = plt.subplots(1, 2, figsize=(16, 5))
    plot_acf(Y, zero=False, ax=ax[0], lags=lags)
    ax[0].set_title('ACF')
    plot_pacf(Y, zero=False, ax=ax[1], lags=lags)
    ax[1].set_title('PACF')
    plt.show()

def plot_forecast(serie_original, previsao):
    """
    Plota a série histórica e a previsão.

    Parâmetros:
    serie_original (pd.Series): Série temporal original.
    previsao (pd.Series): Série temporal de previsão.
    """
    plt.plot(serie_original, label='Serie Histórica', linestyle='-')
    plt.plot(previsao, label='Previsão', linestyle='--')
    plt.xlabel('Data')
    plt.ylabel('Valores')
    plt.title('Serie histórica com previsão')
    plt.legend()
    plt.show()

def teste_estacionariedade(s):
    """
    Realiza testes de estacionariedade KPSS e ADF em uma série temporal.

    Parâmetros:
    s (pd.Series): Série temporal a ser testada.

    Retorna:
    tuple: Resultados dos testes KPSS e ADF ('Estacionário' ou 'Não Estacionário').
    """
    warnings.simplefilter("ignore", category=UserWarning)
    kps = kpss(s)
    adf = adfuller(s)
    warnings.simplefilter("default", category=UserWarning)
    kpss_pv, adf_pv = kps[1], adf[1]
    kpssh, adfh = 'Estacionário', 'Não Estacionário'
    if adf_pv < 0.05:
        adfh = 'Estacionário'
    if kpss_pv < 0.05:
        kpssh = 'Não Estacionário'
    return (kpssh, adfh)

def diagnostico(model, lags=15):
    """
    Plota o diagnóstico do modelo e as funções de autocorrelação dos resíduos.

    Parâmetros:
    model (statsmodels.tsa.arima.model.ARIMAResults): Modelo ajustado.
    lags (int): Número de defasagens a serem plotadas. Padrão é 15.
    """
    print(model.summary())
    model.plot_diagnostics()
    plt.show()
    residuo = model.resid
    residuo = residuo[1:]
    all_ac(residuo, lags=lags)
    plt.show()

def compara_previsoes(serie_original, previsao_list, model_list):
    """
    Plota a série histórica e múltiplas previsões de diferentes modelos.

    Parâmetros:
    serie_original (pd.Series): Série temporal original.
    previsao_list (list of pd.Series): Lista de séries temporais de previsão.
    model_list (list of str): Lista de nomes dos modelos correspondentes às previsões.
    """
    plt.plot(serie_original, label='Serie Histórica', linestyle='-')
    colors = ['blue', 'green', 'red', 'cyan', 'magenta', 'yellow', 'black']
    for i, (p, m) in enumerate(zip(previsao_list, model_list)):
        plt.plot(p, label=m, linestyle='--', color=colors[i % len(colors)])
    plt.xlabel('Data')
    plt.ylabel('Valores')
    plt.title('Serie histórica com previsões')
    plt.legend()
    plt.show()

def correlacao_cruzada(y,x, max_lags = 24, titulo = 'Correlação Cruzada'):
    """
    Calcula e plota a correlação cruzada entre duas séries temporais com defasagens especificadas.

    Parâmetros:
    y (pd.Series): A série temporal dependente.
    x (pd.Series): A série temporal independente.
    max_lags (int): O número máximo de defasagens a considerar para a correlação cruzada.
    """
    correl = []
    lags = range(-max_lags, max_lags + 1)
    for l in lags:
        c = y.corr(x.shift(l))
        correl.append(c)
    plt.figure(figsize=(10, 5))
    plt.stem(lags, correl)
    plt.xlabel('Lag')
    plt.title(titulo)
    conf_interval = 1.96 / np.sqrt(len(y))
    plt.axhline(-conf_interval, color='k', ls='--')
    plt.axhline(conf_interval, color='k', ls='--')
    plt.show()
    
def compara_estatisticas(model_list, model_list_names):
    """
    Compara métricas estatísticas (BIC, AIC, RMSE) de diferentes modelos.

    Parâmetros:
    model_list (list): Uma lista de objetos de modelos ajustados.
    model_list_names (list): Uma lista de nomes correspondentes aos modelos."
    """
    for m,n in zip(model_list, model_list_names):
        rmse = round(np.sqrt(np.mean(m.resid**2)))
        bic = round(m.bic)
        aic = round(m.aic)
        print(f'BIC = {bic} -- AIC = {aic} --  RMSE = {rmse} - {n}')
