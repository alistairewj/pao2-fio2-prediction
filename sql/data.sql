-- FINAL DATA TABLE!
-- This combines (1) the base cohort with (2) materialized views to get patient data
-- The result is a table which is (N*Hn)xM
--  Rows: N patients times Hn hours for each patient (hours is variable)
--  Columns: M features
-- the "hr" column is the integer hour since ICU admission
-- it can be negative since some labs are measured before ICU admission
DROP TABLE IF EXISTS pf_data CASCADE;
CREATE TABLE pf_data as
select
  co.patientunitstayid
  , pf.laboffset

  , pf.pao2 / pf.fio2 as pao2fio2
  , pf.pao2
  , pf.fio2

  -- vitals
  , vi.HeartRate
  , vi.RespiratoryRate
  , vi.o2saturation
  , vi.nibp_systolic
  , vi.nibp_diastolic
  , vi.nibp_mean
  , vi.ibp_systolic
  , vi.ibp_diastolic
  , vi.ibp_mean
  , vi.map
  , vi.temperature
  , vi.gcs

-- source from our "base" cohort
from pf_cohort co
inner join pf_pao2fio2 pf
  on co.patientunitstayid = pf.patientunitstayid
-- now left join to all the data tables using the hours
left join pivoted_vital vi
  on  pf.patientunitstayid = vi.patientunitstayid
  and pf.laboffset = vi.nursingchartoffset
where co.excluded = 0
order by co.patientunitstayid, pf.laboffset;
