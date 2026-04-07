# Biomedical EEG Signal Acquisition and Analysis

This repository contains MATLAB code for preprocessing and analyzing EEG signals, developed as a project for the course **Biomedical Signal Processing** in the **Master of Biomedical Engineering program** at **Aristotle University of Thessaloniki**.

## Project Overview
The project provides a reproducible workflow for EEG signal processing and exploratory analysis, covering:

- EEG data preprocessing:
  - Channel interpolation
  - High-pass (1 Hz) and low-pass (45 Hz) filtering
  - Line noise removal (50 Hz)
  - Artifact correction using Independent Component Analysis (ICA)
  - Automated detection of bad channels and re-referencing to the common average
- Time- and frequency-domain signal analysis
- Linear and nonlinear univariate analyses
- Linear multivariate analyses across selected electrodes (F3, P3)
- Feature extraction for future machine learning applications

## Dataset
- EEG signals from healthy subjects in resting state
- **Electrode system:** International 10-20 system, 19 channels
- **Sampling rate:** 256 Hz

## Code Structure
- `feature_estimation.m` – Calculates morphology features, autocovariance, autocorrelation, power spectrum, approximate entropy, correlation dimension, coherence, and cross-spectrum
- `powerSpectrum.m` – Computes and visualizes power spectrum using sliding windows, STFT, and Continuous Wavelet Transform (CWT)

## Tools & Libraries
- MATLAB
- EEGLAB
- (Optional Python tools: NumPy, Pandas, SciPy, Matplotlib)

## Visualizations
- Sliding-window features and power spectrum
- Time-frequency analysis via STFT and CWT
- Bar plots for entropy and correlation dimension
- Coherence and cross-spectrum plots for multivariate analysis
