import numpy as np

def generate_ar_series(ar_params, n_samples=2000, burn_in=50, noise_std=0.5):
    """
    Generate a synthetic time series from an AR(p) process.
    
    Parameters:
        ar_params (list or array): Coefficients of the AR process [phi_1, phi_2, ..., phi_p].
        n_samples (int): Number of samples to generate (excluding burn-in).
        burn_in (int): Extra samples at the beginning to reduce the effect of initial conditions.
        noise_std (float): Standard deviation of the white noise.
    
    Returns:
        np.array: The generated AR(p) time series.
    """
    p = len(ar_params)  # Order of the AR process
    total_samples = n_samples + burn_in
    
    # Initialize series with zeros
    series = np.zeros(total_samples)
    noise = np.random.normal(0, noise_std, total_samples)  # White noise
    
    # Generate the series
    for t in range(p, total_samples):
        series[t] = np.dot(ar_params, series[t-p:t][::-1]) + noise[t]
    
    return series[burn_in:]  # Remove burn-in period

def generate_ma_series(ma_params, n_samples=2000, burn_in=50, noise_std=0.5):
    """
    Generate a synthetic time series from an MA(q) process.
    
    Parameters:
        ma_params (list or array): Coefficients of the MA process [theta_1, theta_2, ..., theta_q].
        n_samples (int): Number of samples to generate (excluding burn-in).
        burn_in (int): Extra samples at the beginning to reduce the effect of initial conditions.
        noise_std (float): Standard deviation of the white noise.
    
    Returns:
        np.array: The generated MA(q) time series.
    """
    q = len(ma_params)  # Order of the MA process
    total_samples = n_samples + burn_in
    
    # Initialize series with zeros
    series = np.zeros(total_samples)
    noise = np.random.normal(0, noise_std, total_samples)  # White noise
    
    # Generate the series
    for t in range(total_samples):
        series[t] = noise[t] + np.dot(ma_params, noise[t-q:t][::-1]) if t >= q else noise[t]
    
    return series[burn_in:]  # Remove burn-in period

def generate_arma_series(ar_params, ma_params, n_samples=2000, burn_in=50, noise_std=0.5):
    """
    Generate a synthetic time series from an ARMA(p, q) process.
    
    Parameters:
        ar_params (list or array): Coefficients of the AR process [phi_1, phi_2, ..., phi_p].
        ma_params (list or array): Coefficients of the MA process [theta_1, theta_2, ..., theta_q].
        n_samples (int): Number of samples to generate (excluding burn-in).
        burn_in (int): Extra samples at the beginning to reduce the effect of initial conditions.
        noise_std (float): Standard deviation of the white noise.
    
    Returns:
        np.array: The generated ARMA(p, q) time series.
    """
    p = len(ar_params)  # Order of the AR process
    q = len(ma_params)  # Order of the MA process
    total_samples = n_samples + burn_in
    
    # Initialize series with zeros
    series = np.zeros(total_samples)
    noise = np.random.normal(0, noise_std, total_samples)  # White noise
    
    # Generate the series
    for t in range(max(p, q), total_samples):
        ar_component = np.dot(ar_params, series[t-p:t][::-1]) if t >= p else 0
        ma_component = np.dot(ma_params, noise[t-q:t][::-1]) if t >= q else 0
        series[t] = ar_component + ma_component + noise[t]
    
    return series[burn_in:]  # Remove burn-in period