DROP TABLE IF EXISTS public.pf_vent_data_v2 CASCADE;
CREATE TABLE public.pf_vent_data_v2 AS
with vent_stg AS
(  SELECT
    patientunitstayid, 
    chartoffset,
peep , CASE WHEN peep IS NULL THEN 0 ELSE 1 END AS peep_null , 
SUM(CASE WHEN peep IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY patientunitstayid ORDER BY chartoffset) AS peep_partition
FROM public.vent_unpivot_rc
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
  , LAST_VALUE(peep) OVER (
      partition by pf.patientunitstayid, pf.pfoffset
      order by chartoffset
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS peep
-- source from our "base" cohort
from public.pf_pao2fio2_v2 pf
-- now left join to the lab data
LEFT join ven
  on  pf.patientunitstayid = ven.patientunitstayid
  -- last value within 1 day preceeding
  and pf.pfoffset >= ven.chartoffset
  and pf.pfoffset <= ven.chartoffset + 240
order by pf.patientunitstayid, pf.pfoffset;
