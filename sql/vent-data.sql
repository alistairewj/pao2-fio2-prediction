DROP TABLE IF EXISTS pf_vent_data CASCADE;
CREATE TABLE pf_vent_data as
SELECT DISTINCT
    pf.patientunitstayid
  , pf.pfoffset

  , pf.pao2
  , pf.fio2
  , pf.pao2fio2

  , LAST_VALUE(t.peep) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by t.chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS peep

-- source from our "base" cohort
from pf_pao2fio2 pf
-- now left join to the lab data
left join ventevents t
  on  pf.patientunitstayid = t.patientunitstayid
  -- last value within 1 day preceeding
  and pf.pfoffset >= t.chartoffset
  and pf.pfoffset <= t.chartoffset + 240
order by pf.patientunitstayid, pf.pfoffset;
