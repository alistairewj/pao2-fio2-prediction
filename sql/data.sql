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
  , pf.pfoffset
albumin , CASE WHEN albumin IS NULL THEN 0 ELSE 1 END AS albumin_null , 
SUM(CASE WHEN albumin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS albumin_partition,

, case when vent.patientunitstayid is not null then 1 else 0 end::int as ventilated

, REPLACE(ve.peep, 'cmH2', '') as peep,

ld.albumin , CASE WHEN ld.albumin IS NULL THEN 0 ELSE 1 END AS ld.albumin_null , 
SUM(CASE WHEN ld.albumin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.albumin_partition,

ld.alp , CASE WHEN ld.alp IS NULL THEN 0 ELSE 1 END AS ld.alp_null , 
SUM(CASE WHEN ld.alp IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.alp_partition,

ld.alt , CASE WHEN ld.alt IS NULL THEN 0 ELSE 1 END AS ld.alt_null , 
SUM(CASE WHEN ld.alt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.alt_partition,

ld.ast , CASE WHEN ld.ast IS NULL THEN 0 ELSE 1 END AS ld.ast_null , 
SUM(CASE WHEN ld.ast IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.ast_partition,

ld.bands , CASE WHEN ld.bands IS NULL THEN 0 ELSE 1 END AS ld.bands_null , 
SUM(CASE WHEN ld.bands IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.bands_partition,

ld.bilirubin , CASE WHEN ld.bilirubin IS NULL THEN 0 ELSE 1 END AS ld.bilirubin_null , 
SUM(CASE WHEN ld.bilirubin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.bilirubin_partition,

ld.bun , CASE WHEN ld.bun IS NULL THEN 0 ELSE 1 END AS ld.bun_null , 
SUM(CASE WHEN ld.bun IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.bun_partition,

ld.calcium , CASE WHEN ld.calcium IS NULL THEN 0 ELSE 1 END AS ld.calcium_null , 
SUM(CASE WHEN ld.calcium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.calcium_partition,

ld.creatinine , CASE WHEN ld.creatinine IS NULL THEN 0 ELSE 1 END AS ld.creatinine_null , 
SUM(CASE WHEN ld.creatinine IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.creatinine_partition,

ld.glucose , CASE WHEN ld.glucose IS NULL THEN 0 ELSE 1 END AS ld.glucose_null , 
SUM(CASE WHEN ld.glucose IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.glucose_partition,

ld.hco3 , CASE WHEN ld.hco3 IS NULL THEN 0 ELSE 1 END AS ld.hco3_null , 
SUM(CASE WHEN ld.hco3 IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.hco3_partition,

ld.hematocrit , CASE WHEN ld.hematocrit IS NULL THEN 0 ELSE 1 END AS ld.hematocrit_null , 
SUM(CASE WHEN ld.hematocrit IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.hematocrit_partition,

ld.hemoglobin , CASE WHEN ld.hemoglobin IS NULL THEN 0 ELSE 1 END AS ld.hemoglobin_null , 
SUM(CASE WHEN ld.hemoglobin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.hemoglobin_partition,

ld.inr , CASE WHEN ld.inr IS NULL THEN 0 ELSE 1 END AS ld.inr_null , 
SUM(CASE WHEN ld.inr IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.inr_partition,

ld.lactate , CASE WHEN ld.lactate IS NULL THEN 0 ELSE 1 END AS ld.lactate_null , 
SUM(CASE WHEN ld.lactate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.lactate_partition,

ld.platelets , CASE WHEN ld.platelets IS NULL THEN 0 ELSE 1 END AS ld.platelets_null , 
SUM(CASE WHEN ld.platelets IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.platelets_partition,

ld.potassium , CASE WHEN ld.potassium IS NULL THEN 0 ELSE 1 END AS ld.potassium_null , 
SUM(CASE WHEN ld.potassium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.potassium_partition,

ld.ptt , CASE WHEN ld.ptt IS NULL THEN 0 ELSE 1 END AS ld.ptt_null , 
SUM(CASE WHEN ld.ptt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.ptt_partition,

ld.sodium , CASE WHEN ld.sodium IS NULL THEN 0 ELSE 1 END AS ld.sodium_null , 
SUM(CASE WHEN ld.sodium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.sodium_partition,

ld.wbc , CASE WHEN ld.wbc IS NULL THEN 0 ELSE 1 END AS ld.wbc_null , 
SUM(CASE WHEN ld.wbc IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ld.wbc_partition,

vd.bp_diastolic , CASE WHEN vd.bp_diastolic IS NULL THEN 0 ELSE 1 END AS vd.bp_diastolic_null , 
SUM(CASE WHEN vd.bp_diastolic IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.bp_diastolic_partition,

vd.bp_mean , CASE WHEN vd.bp_mean IS NULL THEN 0 ELSE 1 END AS vd.bp_mean_null , 
SUM(CASE WHEN vd.bp_mean IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.bp_mean_partition,

vd.bp_systolic , CASE WHEN vd.bp_systolic IS NULL THEN 0 ELSE 1 END AS vd.bp_systolic_null , 
SUM(CASE WHEN vd.bp_systolic IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.bp_systolic_partition,

vd.gcs , CASE WHEN vd.gcs IS NULL THEN 0 ELSE 1 END AS vd.gcs_null , 
SUM(CASE WHEN vd.gcs IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.gcs_partition,

vd.heartrate , CASE WHEN vd.heartrate IS NULL THEN 0 ELSE 1 END AS vd.heartrate_null , 
SUM(CASE WHEN vd.heartrate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.heartrate_partition,

vd.o2saturation , CASE WHEN vd.o2saturation IS NULL THEN 0 ELSE 1 END AS vd.o2saturation_null , 
SUM(CASE WHEN vd.o2saturation IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.o2saturation_partition,

vd.respiratoryrate , CASE WHEN vd.respiratoryrate IS NULL THEN 0 ELSE 1 END AS vd.respiratoryrate_null , 
SUM(CASE WHEN vd.respiratoryrate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.respiratoryrate_partition,

vd.temperature , CASE WHEN vd.temperature IS NULL THEN 0 ELSE 1 END AS vd.temperature_null , 
SUM(CASE WHEN vd.temperature IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS vd.temperature_partition,
FROM

)

,dat AS
(
SELECT
patientunitstayid,
chartoffset,
ventilated,
peep,
FIRST_VALUE(ld.albumin) OVER (PARTITION BY patientunitstayid, ld.albumin_partition ORDER BY chartoffset) AS ld.albumin,

FIRST_VALUE(ld.alp) OVER (PARTITION BY patientunitstayid, ld.alp_partition ORDER BY chartoffset) AS ld.alp,

FIRST_VALUE(ld.alt) OVER (PARTITION BY patientunitstayid, ld.alt_partition ORDER BY chartoffset) AS ld.alt,

FIRST_VALUE(ld.ast) OVER (PARTITION BY patientunitstayid, ld.ast_partition ORDER BY chartoffset) AS ld.ast,

FIRST_VALUE(ld.bands) OVER (PARTITION BY patientunitstayid, ld.bands_partition ORDER BY chartoffset) AS ld.bands,

FIRST_VALUE(ld.bilirubin) OVER (PARTITION BY patientunitstayid, ld.bilirubin_partition ORDER BY chartoffset) AS ld.bilirubin,

FIRST_VALUE(ld.bun) OVER (PARTITION BY patientunitstayid, ld.bun_partition ORDER BY chartoffset) AS ld.bun,

FIRST_VALUE(ld.calcium) OVER (PARTITION BY patientunitstayid, ld.calcium_partition ORDER BY chartoffset) AS ld.calcium,

FIRST_VALUE(ld.creatinine) OVER (PARTITION BY patientunitstayid, ld.creatinine_partition ORDER BY chartoffset) AS ld.creatinine,

FIRST_VALUE(ld.glucose) OVER (PARTITION BY patientunitstayid, ld.glucose_partition ORDER BY chartoffset) AS ld.glucose,

FIRST_VALUE(ld.hco3) OVER (PARTITION BY patientunitstayid, ld.hco3_partition ORDER BY chartoffset) AS ld.hco3,

FIRST_VALUE(ld.hematocrit) OVER (PARTITION BY patientunitstayid, ld.hematocrit_partition ORDER BY chartoffset) AS ld.hematocrit,

FIRST_VALUE(ld.hemoglobin) OVER (PARTITION BY patientunitstayid, ld.hemoglobin_partition ORDER BY chartoffset) AS ld.hemoglobin,

FIRST_VALUE(ld.inr) OVER (PARTITION BY patientunitstayid, ld.inr_partition ORDER BY chartoffset) AS ld.inr,

FIRST_VALUE(ld.lactate) OVER (PARTITION BY patientunitstayid, ld.lactate_partition ORDER BY chartoffset) AS ld.lactate,

FIRST_VALUE(ld.platelets) OVER (PARTITION BY patientunitstayid, ld.platelets_partition ORDER BY chartoffset) AS ld.platelets,

FIRST_VALUE(ld.potassium) OVER (PARTITION BY patientunitstayid, ld.potassium_partition ORDER BY chartoffset) AS ld.potassium,

FIRST_VALUE(ld.ptt) OVER (PARTITION BY patientunitstayid, ld.ptt_partition ORDER BY chartoffset) AS ld.ptt,

FIRST_VALUE(ld.sodium) OVER (PARTITION BY patientunitstayid, ld.sodium_partition ORDER BY chartoffset) AS ld.sodium,

FIRST_VALUE(ld.wbc) OVER (PARTITION BY patientunitstayid, ld.wbc_partition ORDER BY chartoffset) AS ld.wbc,

FIRST_VALUE(vd.bp_diastolic) OVER (PARTITION BY patientunitstayid, vd.bp_diastolic_partition ORDER BY chartoffset) AS vd.bp_diastolic,

FIRST_VALUE(vd.bp_mean) OVER (PARTITION BY patientunitstayid, vd.bp_mean_partition ORDER BY chartoffset) AS vd.bp_mean,

FIRST_VALUE(vd.bp_systolic) OVER (PARTITION BY patientunitstayid, vd.bp_systolic_partition ORDER BY chartoffset) AS vd.bp_systolic,

FIRST_VALUE(vd.gcs) OVER (PARTITION BY patientunitstayid, vd.gcs_partition ORDER BY chartoffset) AS vd.gcs,

FIRST_VALUE(vd.heartrate) OVER (PARTITION BY patientunitstayid, vd.heartrate_partition ORDER BY chartoffset) AS vd.heartrate,

FIRST_VALUE(vd.o2saturation) OVER (PARTITION BY patientunitstayid, vd.o2saturation_partition ORDER BY chartoffset) AS vd.o2saturation,

FIRST_VALUE(vd.respiratoryrate) OVER (PARTITION BY patientunitstayid, vd.respiratoryrate_partition ORDER BY chartoffset) AS vd.respiratoryrate,

FIRST_VALUE(vd.temperature) OVER (PARTITION BY patientunitstayid, vd.temperature_partition ORDER BY chartoffset) AS vd.temperature,

FROM data_stg
)

SELECT DISTINCT
    pf.patientunitstayid
  , pf.pfoffset
  , pf.pao2
  , pf.fio2
  , pf.pao2fio2,
 LAST_VALUE(t.ld.albumin) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.albumin,
 LAST_VALUE(t.ld.alp) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.alp,
 LAST_VALUE(t.ld.alt) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.alt,
 LAST_VALUE(t.ld.ast) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.ast,
 LAST_VALUE(t.ld.bands) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.bands,
 LAST_VALUE(t.ld.bilirubin) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.bilirubin,
 LAST_VALUE(t.ld.bun) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.bun,
 LAST_VALUE(t.ld.calcium) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.calcium,
 LAST_VALUE(t.ld.creatinine) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.creatinine,
 LAST_VALUE(t.ld.glucose) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.glucose,
 LAST_VALUE(t.ld.hco3) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.hco3,
 LAST_VALUE(t.ld.hematocrit) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.hematocrit,
 LAST_VALUE(t.ld.hemoglobin) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.hemoglobin,
 LAST_VALUE(t.ld.inr) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.inr,
 LAST_VALUE(t.ld.lactate) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.lactate,
 LAST_VALUE(t.ld.platelets) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.platelets,
 LAST_VALUE(t.ld.potassium) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.potassium,
 LAST_VALUE(t.ld.ptt) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.ptt,
 LAST_VALUE(t.ld.sodium) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.sodium,
 LAST_VALUE(t.ld.wbc) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ld.wbc,
 LAST_VALUE(t.vd.bp_diastolic) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.bp_diastolic,
 LAST_VALUE(t.vd.bp_mean) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.bp_mean,
 LAST_VALUE(t.vd.bp_systolic) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.bp_systolic,
 LAST_VALUE(t.vd.gcs) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.gcs,
 LAST_VALUE(t.vd.heartrate) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.heartrate,
 LAST_VALUE(t.vd.o2saturation) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.o2saturation,
 LAST_VALUE(t.vd.respiratoryrate) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.respiratoryrate,
 LAST_VALUE(t.vd.temperature) OVER( partition by pf.patientunitstayid, pf.pfoffset      order by t.chartoffset      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS vd.temperature   
from pf_pao2fio2_v2 pf
left join public.ventdurations vent
  on pf.patientunitstayid = vent.patientunitstayid
AND pf.pfoffset >= vent.startoffset
  AND pf.pfoffset <= vent.endoffset
left join pf_vent_data_v2 ve
  on pf.patientunitstayid = ve.patientunitstayid
  and pf.pfoffset = ve.pfoffset
left join pf_vital_data_v2 vd
  on pf.patientunitstayid = vd.patientunitstayid
  and pf.pfoffset = vd.pfoffset
left join pf_lab_data_v2 ld
  on pf.patientunitstayid = ld.patientunitstayid
  and pf.pfoffset = ld.pfoffset
order by pf.patientunitstayid, pf.pfoffset;
