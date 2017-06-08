# Predict PaO2/FiO2 from non-laboratory data

The goal of this repository is to predict the PaO2/FiO2 ratio from non-laboratory data

# Literature review

Primary application was predicting pao2/fio2 from spo2/fio2 in ards

All patients had to have a previous PaO2/FiO2 ratio <= 300 before enrollment.

# data collection:

* based on various studies
* 24 hours BEFORE ENROLLMENT:
    * ventilator parameters, study hospital, volume of fluid administered in the 24
    hours before enrollment
* AT ENROLLMENT:
    * Age, sex, BMI, mean arterial pressure, and use of vasopressors *at* enrollment
        * any dose of norepinephrine, epinephrine, dopamine, phenylephrine, or vasopressin
* DAY OF ENROLLMENT:
    * ABG closest to 8 am *on the day* of enrollment
        * serum bilirubin, FIO 2 and SpO 2 at time of ABG


# data preprocessing

* excluded patients who did not have FIO2, PaO2, and SpO2 recorded from an ABG
* adjusted PaO2/FIO2 ratios at the Denver and Utah sites (altitude ~1500m) by the ratio of local to sea level barometric pressure (0.836 in Denver, 0.845 in Utah).

# equations used

* non-linear imputation based on the Severinghaus equation
    * Oxygen Saturation = (23,400 * (po^3 + 150 * po^2)-1 + 1)-1
    * inverting this equation is fun I promise
* log-linear imputation based on the Pandharipande equation
    * Log(PF) = 0.48 + 0.78 x Log(SF)
* linear imputation based on the Rice equation
    * S/F = 64 + 0.84 * (P/F)

# data analysis

* correlation between PaFi measured, PaFi imputed
    * once for all patients
    * once for patients w/ SpO2 <= 96
* RMSE of measured/imputed PaFi
* Built a regression with Imputed PaO2 + other features, outcome measured PaO2
* For the PaO2/FIO2 thresholds that were used to define mortality strata in the Berlin ARDS definition, we calculated the imputed PaO2/FIO2 that was associated with the same mortality as the measured PaO2/FIO2 threshold

results

* PaO2/FiO2 - all patients (N=1184)
    * correlations
        * 0.84 - non-linear
        * 0.73 - log-linear
        * 0.73 - linear
    * RMSE
        * p=0.92  non-linear vs log-linear
        * p<0.001 non-linear vs linear
* PaO2 - all patients
    * correlations
        * 0.72 for non-linear imputation
        * 0.30 for log-linear
        * 0.13 for linear
    * RMSE
        * p<0.001 non-linear vs log-linear
        * p<0.001 non-linear vs linear


* Patients with SpO2 <= 96%
    * PaO2/FiO2 - correlations
        * 0.90 - non-linear
        * 0.88 - log-linear
        * 0.88 - linear
    * RMSE - PaO2/FiO2
        * 51.7 - non-linear
        * 52.0 - log-linear
        * 66.4 - linear
    * RMSE - PaO2
        * 28.6 - non-linear
        * 32.2 - log-linear
        * 46.4 - linear
    * All RMSE p-values < 0.0001
* PaO2 - patients with SpO2 <= 96%  (N=707)
    * correlations
        * 0.72 for non-linear imputation
        * 0.13 for linear
        * 0.30 for log-linear
    * RMSE
        * p<0.001 non-linear vs linear
        * p<0.001 non-linear vs log-linear


Confusion matrix for PaO2/FiO2 > 200 (0 = lower, 1 = higher i.e. severe ARDS)

     | 0   | 1 (Imputed)
 --- | --- | ---
 0 | 764 (65%) | 101 (9%)
 1 (true) | 70 (6%) | 249 (20%)

Concordance was not associated with mortality after controlling for age, PEEP, and APACHE III score. "The sickness of the patient is not related to the concordance of this test".
