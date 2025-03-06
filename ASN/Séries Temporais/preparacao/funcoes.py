import numpy as np
import pandas as pd
from statsmodels.tsa.arima.model import ARIMA
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller, kpss
import warnings

def all_ac(Y, lags = 15):
    fig, ax = plt.subplots(1, 2, figsize=(16,5))
    plot_acf(Y, zero=False, ax=ax[0], lags=lags)
    ax[0].set_title('ACF')
    plot_pacf(Y, zero=False, ax=ax[1],lags=lags)
    ax[1].set_title('PACF')
    plt.show()

def plot_forecast(serie_original, previsao):
    plt.plot(serie_original, label='Serie Histórica', linestyle='-')  
    plt.plot(previsao, label='Previsão', linestyle='--')  
    plt.xlabel('Data')
    plt.ylabel('Valores')
    plt.title('Serie histórica com previsão')
    plt.legend()
    plt.show()
    
def teste_estacionariedade(s):
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

def diagnostico(model, lags = 15):
    print(model.summary())
    model.plot_diagnostics()
    plt.show()
    residuo = model.resid
    residuo = residuo[1:] 
    all_ac(residuo, lags = lags)
    plt.show()

def compara_previsoes(serie_original,previsao_list, model_list):
    plt.plot(serie_original, label='Serie Histórica', linestyle='-')  
    colors = ['blue', 'green', 'red', 'cyan', 'magenta', 'yellow', 'black']
    for i, (p, m) in enumerate(zip(previsao_list,model_list)):
        plt.plot(p, label=m, linestyle='--', color=colors[i % len(colors)])  
    plt.xlabel('Data')
    plt.ylabel('Valores')
    plt.title('Serie histórica com previsões')
    plt.legend()
    plt.show()
