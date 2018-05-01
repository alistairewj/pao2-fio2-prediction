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
SELECT
    pf.patientunitstayid
  , pf.pfoffset

  , pf.pao2
  , pf.fio2
  , pf.pao2fio2

  , case when vent.patientunitstayid is not null then 1 else 0 end::int as ventilated
  , REPLACE(ve.peep, 'cmH2', '') as peep

  , vd.heartrate
  , vd.respiratoryrate
  , vd.o2saturation
  , vd.bp_systolic
  , vd.bp_diastolic
  , vd.bp_mean
  , vd.temperature
  , vd.gcs

  , ld.albumin
  , ld.bilirubin
  , ld.bun
  , ld.calcium
  , ld.creatinine
  , ld.glucose
  , ld.hco3
  , ld.hematocrit
  , ld.hemoglobin
  , ld.inr
  , ld.lactate
  , ld.platelets
  , ld.potassium
  , ld.ptt
  , ld.sodium
  , ld.wbc
  , ld.bands
  , ld.alt
  , ld.ast
  , ld.alp

from pf_pao2fio2_v2 pf
left join ventdurations vent
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
