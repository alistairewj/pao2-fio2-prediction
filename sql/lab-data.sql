DROP TABLE IF EXISTS pf_lab_data CASCADE;
CREATE TABLE pf_lab_data as
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
from pf_pao2fio2 pf
-- now left join to the lab data
left join pivoted_lab t
  on  pf.patientunitstayid = t.patientunitstayid
  -- last value within 1 day preceeding
  and pf.pfoffset >= t.chartoffset
  and pf.pfoffset <= t.chartoffset + 1440
order by pf.patientunitstayid, pf.pfoffset;
