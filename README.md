# Variance-Delay-Fuzzy-Approximate-Entropy
MATLAB implementation of variance delay fuzzy approximate entropy for heart rate variability (HRV) complex analysis.

## Reference
[Li Y, Wu S, Yang Q, Liu G, Ge L. Application of the Variance Delay Fuzzy Approximate Entropy for Autonomic Nervous System Fluctuation Analysis in Obstructive Sleep Apnea Patients. _Entropy_. 2020; 22(9):915.](https://www.mdpi.com/1099-4300/22/9/915)

## Description

### scripts
- `main.m`              (script) : data processing and indices calculation.
- `simulation_test.m`   (script) : nonlinear signal system model constructed to verify the feasibility of VD_fApEn for ANS analysis.
- `significance_test.m` (script) : significance test of HRV indices by one-way ANOVA.
- `show_sample_RR.m`      (script) : display of typical R-R interval signals.
- `show_psd.m`            (script) : display of power spectrum density of typical R-R interval signals.
- `show_barplot.m`        (script) : display of bar-plot for indices comparison.
- `show_param.m`          (script) : display of entropy-parameter graph for parameter selection.

### functions
- `MIX.m`             (function) : generate simulated nonlinear signals.
- `MyfApEn.m`         (function) : compute fuzzy approximate entropy of an input R-R interval signal.
- `MyVDfApEn.m`       (function) : compute variance delay fuzzy approximate entropy of an input R-R interval signal.
- `N_points_interp.m` (function) : perform interpolation on an input signal to obtain an N-point array.
