DROP TABLE IF EXISTS pf_vent_data CASCADE;
CREATE TABLE pf_vent_data AS
with vent_stg AS
(  SELECT
    patientunitstayid
    , chartoffset

peep , CASE WHEN peep IS NULL THEN 0 ELSE 1 END AS peep_null , 
SUM(CASE WHEN peep IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS peep_partition
FROM pivoted_vent
),
ven AS(
SELECT
patientunitstayid,
chartoffset,
FIRST_VALUE(peep) OVER (PARTITION BY patientunitstayid, peep_partition ORDER BY chartoffset) AS peep
    FROM vent_stg
)
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
LEFT join ven
  on  pf.patientunitstayid = ven.patientunitstayid
  -- last value within 1 day preceeding
  and pf.pfoffset >= ven.chartoffset
  and pf.pfoffset <= ven.chartoffset + 240
order by pf.patientunitstayid, pf.pfoffset;
