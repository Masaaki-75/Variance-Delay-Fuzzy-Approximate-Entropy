# Variance-Delay-Fuzzy-Approximate-Entropy
MATLAB implementation of variance delay fuzzy approximate entropy for HRV complex analysis.

## Reference: 
- Li, Yifan, et al. "Application of the Variance Delay Fuzzy Approximate Entropy for Autonomic Nervous System Fluctuation Analysis in Obstructive Sleep Apnea Patients." Entropy 22.9 (2020): 915.
(https://www.mdpi.com/1099-4300/22/9/915)

## Description:

### scripts (with some built-in functions)
- main.m              (scripts) : data processing and indices calculation.
- simulation_test.m   (scripts) : nonlinear signal system model constructed to verify the feasibility of VD_fApEn for ANS analysis.
- significance_test.m (scripts) : significance test of HRV indices by one-way ANOVA.
- show_sample_RR      (scripts) : display of typical R-R interval signals.
- show_psd            (scripts) : display of power spectrum density of typical R-R interval signals.
- show_barplot        (scripts) : display of bar-plot for indices comparison.
- show_param          (scripts) : display of entropy-parameter graph for parameter selection.

### functions
- MIX.m             (functions) : generate simulated nonlinear signals.
- MyfApEn.m         (functions) : compute fuzzy approximate entropy of an input R-R interval signal.
- MyVDfApEn.m       (functions) : compute variance delay fuzzy approximate entropy of an input R-R interval signal.
- N_points_interp.m (functions) : perform interpolation on an input signal to obtain an N-point array.
