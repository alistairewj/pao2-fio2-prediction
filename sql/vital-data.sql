-- FINAL DATA TABLE!
-- This combines (1) the base cohort with (2) materialized views to get patient data
-- The result is a table which is (N*Hn)xM
--  Rows: N patients times Hn hours for each patient (hours is variable)
--  Columns: M features
-- the "hr" column is the integer hour since ICU admission
-- it can be negative since some labs are measured before ICU admission
DROP TABLE IF EXISTS pf_vital_data CASCADE;
CREATE TABLE pf_vital_data as
with vi_stg as
(
  -- create partitions that identify NULL rows
  SELECT
    patientunitstayid
    , chartoffset
    , heartrate
    , CASE WHEN heartrate IS NULL THEN 0 ELSE 1 END AS heartrate_null
    , SUM(CASE WHEN heartrate IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as heartrate_partition
    , RespiratoryRate
    , CASE WHEN RespiratoryRate IS NULL THEN 0 ELSE 1 END AS RespiratoryRate_null
    , SUM(CASE WHEN RespiratoryRate IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as RespiratoryRate_partition
    , o2saturation
    , CASE WHEN o2saturation IS NULL THEN 0 ELSE 1 END AS o2saturation_null
    , SUM(CASE WHEN o2saturation IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as o2saturation_partition
    , coalesce(ibp_systolic, nibp_systolic) as bp_systolic
    , CASE WHEN coalesce(ibp_systolic, nibp_systolic) IS NULL THEN 0 ELSE 1 END AS bp_systolic_null
    , SUM(CASE WHEN coalesce(ibp_systolic, nibp_systolic) IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as bp_systolic_partition
    , coalesce(ibp_diastolic, nibp_diastolic) as bp_diastolic
    , CASE WHEN coalesce(ibp_diastolic, nibp_diastolic) IS NULL THEN 0 ELSE 1 END AS bp_diastolic_null
    , SUM(CASE WHEN coalesce(ibp_diastolic, nibp_diastolic) IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as bp_diastolic_partition
    , coalesce(map, ibp_mean, nibp_mean) as bp_mean
    , CASE WHEN coalesce(map, ibp_mean, nibp_mean) IS NULL THEN 0 ELSE 1 END AS bp_mean_null
    , SUM(CASE WHEN coalesce(map, ibp_mean, nibp_mean) IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as bp_mean_partition
    , temperature
    , CASE WHEN temperature IS NULL THEN 0 ELSE 1 END AS temperature_null
    , SUM(CASE WHEN temperature IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as temperature_partition
    , gcs
    , CASE WHEN gcs IS NULL THEN 0 ELSE 1 END AS gcs_null
    , SUM(CASE WHEN gcs IS NULL THEN 0 ELSE 1 END)
      OVER
      (
        PARTITION BY patientunitstayid
        ORDER BY chartoffset
      ) as gcs_partition
  FROM pivoted_vital
)
, vi as
(
  SELECT
    patientunitstayid
    , chartoffset
    -- propogate heartrate forward over nulls
    , FIRST_VALUE(heartrate) OVER
    (
      PARTITION BY patientunitstayid, heartrate_partition
      ORDER BY chartoffset
    ) as heartrate
    , FIRST_VALUE(RespiratoryRate) OVER
    (
      PARTITION BY patientunitstayid, RespiratoryRate_partition
      ORDER BY chartoffset
    ) as RespiratoryRate
    , FIRST_VALUE(o2saturation) OVER
    (
      PARTITION BY patientunitstayid, o2saturation_partition
      ORDER BY chartoffset
    ) as o2saturation
    , FIRST_VALUE(bp_systolic) OVER
    (
      PARTITION BY patientunitstayid, bp_systolic_partition
      ORDER BY chartoffset
    ) as bp_systolic
    , FIRST_VALUE(bp_diastolic) OVER
    (
      PARTITION BY patientunitstayid, bp_diastolic_partition
      ORDER BY chartoffset
    ) as bp_diastolic
    , FIRST_VALUE(bp_mean) OVER
    (
      PARTITION BY patientunitstayid, bp_mean_partition
      ORDER BY chartoffset
    ) as bp_mean
    , FIRST_VALUE(temperature) OVER
    (
      PARTITION BY patientunitstayid, temperature_partition
      ORDER BY chartoffset
    ) as temperature
    , FIRST_VALUE(gcs) OVER
    (
      PARTITION BY patientunitstayid, gcs_partition
      ORDER BY chartoffset
    ) as gcs
  FROM vi_stg
)
SELECT DISTINCT
    pf.patientunitstayid
  , pf.pfoffset

  , pf.pao2
  , pf.fio2
  , pf.pao2fio2

  -- vitals
  , LAST_VALUE(vi.HeartRate) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS HeartRate
  , LAST_VALUE(vi.RespiratoryRate) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS RespiratoryRate
  , LAST_VALUE(vi.o2saturation) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS o2saturation
  , LAST_VALUE(vi.bp_systolic) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS bp_systolic
  , LAST_VALUE(vi.bp_diastolic) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS bp_diastolic
  , LAST_VALUE(vi.bp_mean) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS bp_mean
  , LAST_VALUE(vi.temperature) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS temperature
  , LAST_VALUE(vi.gcs) OVER (
        partition by pf.patientunitstayid, pf.pfoffset
        order by vi.chartoffset
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
      AS gcs
from pf_pao2fio2 pf
-- now left join to all the data tables using the hours
left join vi
  on  pf.patientunitstayid = vi.patientunitstayid
  and pf.pfoffset > vi.chartoffset
  and pf.pfoffset <= vi.chartoffset + 360
order by pf.patientunitstayid, pf.pfoffset;
