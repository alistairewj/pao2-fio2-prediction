-- FINAL DATA TABLE!
-- This combines (1) the base cohort with (2) materialized views to get patient data
-- The result is a table which is (N*Hn)xM
--  Rows: N patients times Hn hours for each patient (hours is variable)
--  Columns: M features
-- the "pfoffset" column is the minutes since ICU admission
-- it can be negative since some labs are measured before ICU admission
SET search_path to public;
DROP TABLE IF EXISTS pf_data_v2 CASCADE;
CREATE TABLE pf_data_v2 as

with data_stg AS
(SELECT
 pf.patientunitstayid
,pf.pfoffset
,case when vent.patientunitstayid is not null then 1 else 0 end::int as ventilated

,REPLACE(ve.peep, 'cmH2', '') as peep,

ld.albumin , CASE WHEN ld.albumin IS NULL THEN 0 ELSE 1 END AS ld_albumin_null , 
SUM(CASE WHEN ld.albumin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_albumin_partition,

ld.alp , CASE WHEN ld.alp IS NULL THEN 0 ELSE 1 END AS ld_alp_null , 
SUM(CASE WHEN ld.alp IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_alp_partition,

ld.alt , CASE WHEN ld.alt IS NULL THEN 0 ELSE 1 END AS ld_alt_null , 
SUM(CASE WHEN ld.alt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_alt_partition,

ld.ast , CASE WHEN ld.ast IS NULL THEN 0 ELSE 1 END AS ld_ast_null , 
SUM(CASE WHEN ld.ast IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_ast_partition,

ld.bands , CASE WHEN ld.bands IS NULL THEN 0 ELSE 1 END AS ld_bands_null , 
SUM(CASE WHEN ld.bands IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_bands_partition,

ld.bilirubin , CASE WHEN ld.bilirubin IS NULL THEN 0 ELSE 1 END AS ld_bilirubin_null , 
SUM(CASE WHEN ld.bilirubin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_bilirubin_partition,

ld.bun , CASE WHEN ld.bun IS NULL THEN 0 ELSE 1 END AS ld_bun_null , 
SUM(CASE WHEN ld.bun IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_bun_partition,

ld.calcium , CASE WHEN ld.calcium IS NULL THEN 0 ELSE 1 END AS ld_calcium_null , 
SUM(CASE WHEN ld.calcium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_calcium_partition,

ld.creatinine , CASE WHEN ld.creatinine IS NULL THEN 0 ELSE 1 END AS ld_creatinine_null , 
SUM(CASE WHEN ld.creatinine IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_creatinine_partition,

ld.glucose , CASE WHEN ld.glucose IS NULL THEN 0 ELSE 1 END AS ld_glucose_null , 
SUM(CASE WHEN ld.glucose IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_glucose_partition,

ld.hco3 , CASE WHEN ld.hco3 IS NULL THEN 0 ELSE 1 END AS ld_hco3_null , 
SUM(CASE WHEN ld.hco3 IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_hco3_partition,

ld.hematocrit , CASE WHEN ld.hematocrit IS NULL THEN 0 ELSE 1 END AS ld_hematocrit_null , 
SUM(CASE WHEN ld.hematocrit IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_hematocrit_partition,

ld.hemoglobin , CASE WHEN ld.hemoglobin IS NULL THEN 0 ELSE 1 END AS ld_hemoglobin_null , 
SUM(CASE WHEN ld.hemoglobin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_hemoglobin_partition,

ld.inr , CASE WHEN ld.inr IS NULL THEN 0 ELSE 1 END AS ld_inr_null , 
SUM(CASE WHEN ld.inr IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_inr_partition,

ld.lactate , CASE WHEN ld.lactate IS NULL THEN 0 ELSE 1 END AS ld_lactate_null , 
SUM(CASE WHEN ld.lactate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_lactate_partition,

ld.platelets , CASE WHEN ld.platelets IS NULL THEN 0 ELSE 1 END AS ld_platelets_null , 
SUM(CASE WHEN ld.platelets IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_platelets_partition,

ld.potassium , CASE WHEN ld.potassium IS NULL THEN 0 ELSE 1 END AS ld_potassium_null , 
SUM(CASE WHEN ld.potassium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_potassium_partition,

ld.ptt , CASE WHEN ld.ptt IS NULL THEN 0 ELSE 1 END AS ld_ptt_null , 
SUM(CASE WHEN ld.ptt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_ptt_partition,

ld.sodium , CASE WHEN ld.sodium IS NULL THEN 0 ELSE 1 END AS ld_sodium_null , 
SUM(CASE WHEN ld.sodium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_sodium_partition,

ld.wbc , CASE WHEN ld.wbc IS NULL THEN 0 ELSE 1 END AS ld_wbc_null , 
SUM(CASE WHEN ld.wbc IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS ld_wbc_partition,

vd.bp_diastolic , CASE WHEN vd.bp_diastolic IS NULL THEN 0 ELSE 1 END AS vd_bp_diastolic_null , 
SUM(CASE WHEN vd.bp_diastolic IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_bp_diastolic_partition,

vd.bp_mean , CASE WHEN vd.bp_mean IS NULL THEN 0 ELSE 1 END AS vd_bp_mean_null , 
SUM(CASE WHEN vd.bp_mean IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_bp_mean_partition,

vd.bp_systolic , CASE WHEN vd.bp_systolic IS NULL THEN 0 ELSE 1 END AS vd_bp_systolic_null , 
SUM(CASE WHEN vd.bp_systolic IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_bp_systolic_partition,

vd.gcs , CASE WHEN vd.gcs IS NULL THEN 0 ELSE 1 END AS vd_gcs_null , 
SUM(CASE WHEN vd.gcs IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_gcs_partition,

vd.heartrate , CASE WHEN vd.heartrate IS NULL THEN 0 ELSE 1 END AS vd_heartrate_null , 
SUM(CASE WHEN vd.heartrate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_heartrate_partition,

vd.o2saturation , CASE WHEN vd.o2saturation IS NULL THEN 0 ELSE 1 END AS vd_o2saturation_null , 
SUM(CASE WHEN vd.o2saturation IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_o2saturation_partition,

vd.respiratoryrate , CASE WHEN vd.respiratoryrate IS NULL THEN 0 ELSE 1 END AS vd_respiratoryrate_null , 
SUM(CASE WHEN vd.respiratoryrate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_respiratoryrate_partition,

vd.temperature , CASE WHEN vd.temperature IS NULL THEN 0 ELSE 1 END AS vd_temperature_null , 
SUM(CASE WHEN vd.temperature IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY pf.patientunitstayid ORDER BY pf.pfoffset) AS vd_temperature_partition
FROM pf_pao2fio2_v2 pf
LEFT JOIN public.ventdurations vent
  ON pf.patientunitstayid = vent.patientunitstayid
AND pf.pfoffset >= vent.startoffset
  AND pf.pfoffset <= vent.endoffset
LEFT JOIN pf_vent_data_v2 ve
  ON pf.patientunitstayid = ve.patientunitstayid
  AND pf.pfoffset = ve.pfoffset
LEFT JOIN pf_vital_data_v2 vd
  ON pf.patientunitstayid = vd.patientunitstayid
  AND pf.pfoffset = vd.pfoffset
LEFT JOIN pf_lab_data_v2 ld
  ON pf.patientunitstayid = ld.patientunitstayid
  AND pf.pfoffset = ld.pfoffset
)

,dat AS
(
SELECT
 patientunitstayid
,pfoffset
,ventilated
,peep,
FIRST_VALUE(albumin) OVER (PARTITION BY patientunitstayid, ld_albumin_partition ORDER BY pfoffset) AS ld_albumin,

FIRST_VALUE(alp) OVER (PARTITION BY patientunitstayid, ld_alp_partition ORDER BY pfoffset) AS ld_alp,

FIRST_VALUE(alt) OVER (PARTITION BY patientunitstayid, ld_alt_partition ORDER BY pfoffset) AS ld_alt,

FIRST_VALUE(ast) OVER (PARTITION BY patientunitstayid, ld_ast_partition ORDER BY pfoffset) AS ld_ast,

FIRST_VALUE(bands) OVER (PARTITION BY patientunitstayid, ld_bands_partition ORDER BY pfoffset) AS ld_bands,

FIRST_VALUE(bilirubin) OVER (PARTITION BY patientunitstayid, ld_bilirubin_partition ORDER BY pfoffset) AS ld_bilirubin,

FIRST_VALUE(bun) OVER (PARTITION BY patientunitstayid, ld_bun_partition ORDER BY pfoffset) AS ld_bun,

FIRST_VALUE(calcium) OVER (PARTITION BY patientunitstayid, ld_calcium_partition ORDER BY pfoffset) AS ld_calcium,

FIRST_VALUE(creatinine) OVER (PARTITION BY patientunitstayid, ld_creatinine_partition ORDER BY pfoffset) AS ld_creatinine,

FIRST_VALUE(glucose) OVER (PARTITION BY patientunitstayid, ld_glucose_partition ORDER BY pfoffset) AS ld_glucose,

FIRST_VALUE(hco3) OVER (PARTITION BY patientunitstayid, ld_hco3_partition ORDER BY pfoffset) AS ld_hco3,

FIRST_VALUE(hematocrit) OVER (PARTITION BY patientunitstayid, ld_hematocrit_partition ORDER BY pfoffset) AS ld_hematocrit,

FIRST_VALUE(hemoglobin) OVER (PARTITION BY patientunitstayid, ld_hemoglobin_partition ORDER BY pfoffset) AS ld_hemoglobin,

FIRST_VALUE(inr) OVER (PARTITION BY patientunitstayid, ld_inr_partition ORDER BY pfoffset) AS ld_inr,

FIRST_VALUE(lactate) OVER (PARTITION BY patientunitstayid, ld_lactate_partition ORDER BY pfoffset) AS ld_lactate,

FIRST_VALUE(platelets) OVER (PARTITION BY patientunitstayid, ld_platelets_partition ORDER BY pfoffset) AS ld_platelets,

FIRST_VALUE(potassium) OVER (PARTITION BY patientunitstayid, ld_potassium_partition ORDER BY pfoffset) AS ld_potassium,

FIRST_VALUE(ptt) OVER (PARTITION BY patientunitstayid, ld_ptt_partition ORDER BY pfoffset) AS ld_ptt,

FIRST_VALUE(sodium) OVER (PARTITION BY patientunitstayid, ld_sodium_partition ORDER BY pfoffset) AS ld_sodium,

FIRST_VALUE(wbc) OVER (PARTITION BY patientunitstayid, ld_wbc_partition ORDER BY pfoffset) AS ld_wbc,

FIRST_VALUE(bp_diastolic) OVER (PARTITION BY patientunitstayid, vd_bp_diastolic_partition ORDER BY pfoffset) AS vd_bp_diastolic,

FIRST_VALUE(bp_mean) OVER (PARTITION BY patientunitstayid, vd_bp_mean_partition ORDER BY pfoffset) AS vd_bp_mean,

FIRST_VALUE(bp_systolic) OVER (PARTITION BY patientunitstayid, vd_bp_systolic_partition ORDER BY pfoffset) AS vd_bp_systolic,

FIRST_VALUE(gcs) OVER (PARTITION BY patientunitstayid, vd_gcs_partition ORDER BY pfoffset) AS vd_gcs,

FIRST_VALUE(heartrate) OVER (PARTITION BY patientunitstayid, vd_heartrate_partition ORDER BY pfoffset) AS vd_heartrate,

FIRST_VALUE(o2saturation) OVER (PARTITION BY patientunitstayid, vd_o2saturation_partition ORDER BY pfoffset) AS vd_o2saturation,

FIRST_VALUE(respiratoryrate) OVER (PARTITION BY patientunitstayid, vd_respiratoryrate_partition ORDER BY pfoffset) AS vd_respiratoryrate,

FIRST_VALUE(temperature) OVER (PARTITION BY patientunitstayid, vd_temperature_partition ORDER BY pfoffset) AS vd_temperature

FROM data_stg
)

SELECT DISTINCT
  pf.patientunitstayid
 ,pf.pfoffset
 ,pf.pao2
 ,pf.fio2
 ,pf.pao2fio2,
 LAST_VALUE(ld_albumin) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_albumin,
 LAST_VALUE(ld_alp) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_alp,
 LAST_VALUE(ld_alt) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_alt,
 LAST_VALUE(ld_ast) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_ast,
 LAST_VALUE(ld_bands) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_bands,
 LAST_VALUE(ld_bilirubin) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_bilirubin,
 LAST_VALUE(ld_bun) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_bun,
 LAST_VALUE(ld_calcium) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_calcium,
 LAST_VALUE(ld_creatinine) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_creatinine,
 LAST_VALUE(ld_glucose) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_glucose,
 LAST_VALUE(ld_hco3) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_hco3,
 LAST_VALUE(ld_hematocrit) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_hematocrit,
 LAST_VALUE(ld_hemoglobin) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_hemoglobin,
 LAST_VALUE(ld_inr) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_inr,
 LAST_VALUE(ld_lactate) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_lactate,
 LAST_VALUE(ld_platelets) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_platelets,
 LAST_VALUE(ld_potassium) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_potassium,
 LAST_VALUE(ld_ptt) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_ptt,
 LAST_VALUE(ld_sodium) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_sodium,
 LAST_VALUE(ld_wbc) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld_wbc,
 LAST_VALUE(vd_bp_diastolic) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_bp_diastolic,
 LAST_VALUE(vd_bp_mean) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_bp_mean,
 LAST_VALUE(vd_bp_systolic) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_bp_systolic,
 LAST_VALUE(vd_gcs) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_gcs,
 LAST_VALUE(vd_heartrate) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_heartrate,
 LAST_VALUE(vd_o2saturation) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_o2saturation,
 LAST_VALUE(vd_respiratoryrate) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_respiratoryrate,
 LAST_VALUE(vd_temperature) OVER( partition by pf.patientunitstayid,  pf.pfoffset ORDER BY dat.pfoffset ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd_temperature   
FROM pf_pao2fio2_v2 pf
LEFT JOIN dat
  ON pf.patientunitstayid = dat.patientunitstayid
LEFT JOIN public.ventdurations vent
  ON pf.patientunitstayid = vent.patientunitstayid
AND pf.pfoffset >= vent.startoffset
  AND pf.pfoffset <= vent.endoffset
LEFT JOIN pf_vent_data_v2 ve
  ON pf.patientunitstayid = ve.patientunitstayid
  AND pf.pfoffset = ve.pfoffset
LEFT JOIN pf_vital_data_v2 vd
  ON pf.patientunitstayid = vd.patientunitstayid
  AND pf.pfoffset = vd.pfoffset
LEFT JOIN pf_lab_data_v2 ld
  ON pf.patientunitstayid = ld.patientunitstayid
  AND pf.pfoffset = ld.pfoffset
ORDER BY pf.patientunitstayid, pf.pfoffset
