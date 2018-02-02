-- FINAL DATA TABLE!
-- This combines (1) the base cohort with (2) materialized views to get patient data
-- The result is a table which is (N*Hn)xM
--  Rows: N patients times Hn hours for each patient (hours is variable)
--  Columns: M features
-- the "hr" column is the integer hour since ICU admission
-- it can be negative since some labs are measured before ICU admission
DROP TABLE IF EXISTS pf_vital_data CASCADE;
CREATE TABLE pf_vital_data as
--
SELECT DISTINCT
    pf.patientunitstayid
  , pf.pfoffset

  , pf.pao2
  , pf.fio2
  , pf.pao2fio2

  -- vitals
  , LAST_VALUE(vi.HeartRate) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS HeartRate
  , LAST_VALUE(vi.RespiratoryRate) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS RespiratoryRate
  , LAST_VALUE(vi.o2saturation) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS o2saturation
  , LAST_VALUE(vi.nibp_systolic) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS nibp_systolic
  , LAST_VALUE(vi.nibp_diastolic) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS nibp_diastolic
  , LAST_VALUE(vi.nibp_mean) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS nibp_mean
  , LAST_VALUE(vi.ibp_systolic) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS ibp_systolic
  , LAST_VALUE(vi.ibp_diastolic) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS ibp_diastolic
  , LAST_VALUE(vi.ibp_mean) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS ibp_mean
  , LAST_VALUE(vi.map) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS map
  , LAST_VALUE(vi.temperature) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS temperature
  , LAST_VALUE(vi.gcs) OVER (
        partition by co.patientunitstayid, pf.labresultoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS gcs
from pf_pao2fio2 pf
-- now left join to all the data tables using the hours
left join pivoted_vital vi
  on  pf.patientunitstayid = vi.patientunitstayid
  and pf.labresultoffset > vi.chartoffset
  and pf.labresultoffset <= vi.chartoffset + 120
order by co.patientunitstayid, pf.labresultoffset;
