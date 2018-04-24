DROP TABLE IF EXISTS public.pf_lab_data_v2 CASCADE;
CREATE TABLE public.pf_lab_data_v2 AS

with lab_stg AS
(  SELECT
    patientunitstayid,
    chartoffset,

albumin , CASE WHEN albumin IS NULL THEN 0 ELSE 1 END AS albumin_null , 
SUM(CASE WHEN albumin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS albumin_partition,

alp , CASE WHEN alp IS NULL THEN 0 ELSE 1 END AS alp_null , 
SUM(CASE WHEN alp IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS alp_partition,

alt , CASE WHEN alt IS NULL THEN 0 ELSE 1 END AS alt_null , 
SUM(CASE WHEN alt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS alt_partition,

ast , CASE WHEN ast IS NULL THEN 0 ELSE 1 END AS ast_null , 
SUM(CASE WHEN ast IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ast_partition,

bands , CASE WHEN bands IS NULL THEN 0 ELSE 1 END AS bands_null , 
SUM(CASE WHEN bands IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS bands_partition,

bilirubin , CASE WHEN bilirubin IS NULL THEN 0 ELSE 1 END AS bilirubin_null , 
SUM(CASE WHEN bilirubin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS bilirubin_partition,

bun , CASE WHEN bun IS NULL THEN 0 ELSE 1 END AS bun_null , 
SUM(CASE WHEN bun IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS bun_partition,

calcium , CASE WHEN calcium IS NULL THEN 0 ELSE 1 END AS calcium_null , 
SUM(CASE WHEN calcium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS calcium_partition,

creatinine , CASE WHEN creatinine IS NULL THEN 0 ELSE 1 END AS creatinine_null , 
SUM(CASE WHEN creatinine IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS creatinine_partition,

glucose , CASE WHEN glucose IS NULL THEN 0 ELSE 1 END AS glucose_null , 
SUM(CASE WHEN glucose IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS glucose_partition,

hco3 , CASE WHEN hco3 IS NULL THEN 0 ELSE 1 END AS hco3_null , 
SUM(CASE WHEN hco3 IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS hco3_partition,

hematocrit , CASE WHEN hematocrit IS NULL THEN 0 ELSE 1 END AS hematocrit_null , 
SUM(CASE WHEN hematocrit IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS hematocrit_partition,

hemoglobin , CASE WHEN hemoglobin IS NULL THEN 0 ELSE 1 END AS hemoglobin_null , 
SUM(CASE WHEN hemoglobin IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS hemoglobin_partition,

inr , CASE WHEN inr IS NULL THEN 0 ELSE 1 END AS inr_null , 
SUM(CASE WHEN inr IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS inr_partition,

lactate , CASE WHEN lactate IS NULL THEN 0 ELSE 1 END AS lactate_null , 
SUM(CASE WHEN lactate IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS lactate_partition,

platelets , CASE WHEN platelets IS NULL THEN 0 ELSE 1 END AS platelets_null , 
SUM(CASE WHEN platelets IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS platelets_partition,

potassium , CASE WHEN potassium IS NULL THEN 0 ELSE 1 END AS potassium_null , 
SUM(CASE WHEN potassium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS potassium_partition,

ptt , CASE WHEN ptt IS NULL THEN 0 ELSE 1 END AS ptt_null , 
SUM(CASE WHEN ptt IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS ptt_partition,

sodium , CASE WHEN sodium IS NULL THEN 0 ELSE 1 END AS sodium_null , 
SUM(CASE WHEN sodium IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS sodium_partition,

wbc , CASE WHEN wbc IS NULL THEN 0 ELSE 1 END AS wbc_null , 
SUM(CASE WHEN wbc IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS wbc_partition

FROM pivoted_lab
)

,la AS
(
  SELECT
    patientunitstayid,
    chartoffset,
FIRST_VALUE(albumin) OVER (PARTITION BY patientunitstayid, albumin_partition ORDER BY chartoffset) AS albumin,
FIRST_VALUE(alp) OVER (PARTITION BY patientunitstayid, alp_partition ORDER BY chartoffset) AS alp,
FIRST_VALUE(alt) OVER (PARTITION BY patientunitstayid, alt_partition ORDER BY chartoffset) AS alt,
FIRST_VALUE(ast) OVER (PARTITION BY patientunitstayid, ast_partition ORDER BY chartoffset) AS ast,
FIRST_VALUE(bands) OVER (PARTITION BY patientunitstayid, bands_partition ORDER BY chartoffset) AS bands,
FIRST_VALUE(bilirubin) OVER (PARTITION BY patientunitstayid, bilirubin_partition ORDER BY chartoffset) AS bilirubin,
FIRST_VALUE(bun) OVER (PARTITION BY patientunitstayid, bun_partition ORDER BY chartoffset) AS bun,
FIRST_VALUE(calcium) OVER (PARTITION BY patientunitstayid, calcium_partition ORDER BY chartoffset) AS calcium,
FIRST_VALUE(creatinine) OVER (PARTITION BY patientunitstayid, creatinine_partition ORDER BY chartoffset) AS creatinine,
FIRST_VALUE(glucose) OVER (PARTITION BY patientunitstayid, glucose_partition ORDER BY chartoffset) AS glucose,
FIRST_VALUE(hco3) OVER (PARTITION BY patientunitstayid, hco3_partition ORDER BY chartoffset) AS hco3,
FIRST_VALUE(hematocrit) OVER (PARTITION BY patientunitstayid, hematocrit_partition ORDER BY chartoffset) AS hematocrit,
FIRST_VALUE(hemoglobin) OVER (PARTITION BY patientunitstayid, hemoglobin_partition ORDER BY chartoffset) AS hemoglobin,
FIRST_VALUE(inr) OVER (PARTITION BY patientunitstayid, inr_partition ORDER BY chartoffset) AS inr,
FIRST_VALUE(lactate) OVER (PARTITION BY patientunitstayid, lactate_partition ORDER BY chartoffset) AS lactate,
FIRST_VALUE(platelets) OVER (PARTITION BY patientunitstayid, platelets_partition ORDER BY chartoffset) AS platelets,
FIRST_VALUE(potassium) OVER (PARTITION BY patientunitstayid, potassium_partition ORDER BY chartoffset) AS potassium,
FIRST_VALUE(ptt) OVER (PARTITION BY patientunitstayid, ptt_partition ORDER BY chartoffset) AS ptt,
FIRST_VALUE(sodium) OVER (PARTITION BY patientunitstayid, sodium_partition ORDER BY chartoffset) AS sodium,
FIRST_VALUE(wbc) OVER (PARTITION BY patientunitstayid, wbc_partition ORDER BY chartoffset) AS wbc

FROM lab_stg
)    

SELECT DISTINCT
    pf.patientunitstayid
  , pf.pfoffset

  , pf.pao2
  , pf.fio2
  , pf.pao2fio2

  , LAST_VALUE(t.albumin) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS albumin
  , LAST_VALUE(t.bilirubin) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS bilirubin
  , LAST_VALUE(t.bun) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS bun
  , LAST_VALUE(t.calcium) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS calcium
  , LAST_VALUE(t.creatinine) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS creatinine
  , LAST_VALUE(t.glucose) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS glucose
  , LAST_VALUE(t.hco3) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS hco3
  , LAST_VALUE(t.hematocrit) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS hematocrit
  , LAST_VALUE(t.hemoglobin) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS hemoglobin
  , LAST_VALUE(t.inr) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS inr
  , LAST_VALUE(t.lactate) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS lactate
  , LAST_VALUE(t.platelets) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS platelets
  , LAST_VALUE(t.potassium) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS potassium
  , LAST_VALUE(t.ptt) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS ptt
  , LAST_VALUE(t.sodium) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS sodium
  , LAST_VALUE(t.wbc) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS wbc
  , LAST_VALUE(t.bands) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS bands
  , LAST_VALUE(t.alt) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS alt
  , LAST_VALUE(t.ast) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS ast
  , LAST_VALUE(t.alp) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS alp
-- source from our "base" cohort
from public.pf_pao2fio2_v2 pf
-- now left join to the lab data
left join pivoted_lab t
  on  pf.patientunitstayid = t.patientunitstayid
  -- last value within 1 day preceeding
  and pf.pfoffset >= t.chartoffset
  and pf.pfoffset <= t.chartoffset + 1440
order by pf.patientunitstayid, pf.pfoffset;
