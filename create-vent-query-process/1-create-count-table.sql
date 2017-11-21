-- can copy data out from this table as follows:
-- \copy d_respiratorycharting to respiratorycharting.csv CSV HEADER;
DROP TABLE IF EXISTS d_respiratorycharting CASCADE;
CREATE TABLE d_respiratorycharting AS
-- get percentiles
with t1 as
(
  select
      patientunitstayid
    , respcharttypecat
    , respchartvaluelabel
    , respchartvalue
    , case when respchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' and respchartvalue not in ('-','.')
          then cast(respchartvalue as numeric)
          else null end
        as respchartvaluenum
  from respiratorycharting
)
-- group together data
, tgrp as
(
  select
      respcharttypecat
    , respchartvaluelabel
    , count(respchartvalue) as n_obs
    , count(distinct patientunitstayid) as n_pat
    -- mean obs per patients
    , round((cast(count(respchartvalue) as numeric) / cast(count(distinct patientunitstayid) as numeric)),2) as n_obs_per_pat
    , count(distinct respchartvalue) as n_distinct_obs
    , MODE() WITHIN GROUP (ORDER BY respchartvalue) as string_mode
    , round(
        cast(count(respchartvaluenum) as numeric) / cast(count(respchartvalue) as numeric)
        ,4) as numeric_obs_percent
    -- averages
    , percentile_disc(0.05) WITHIN GROUP (ORDER BY respchartvaluenum) as value_p05
    , percentile_disc(0.5) WITHIN GROUP (ORDER BY respchartvaluenum) as value_p50
    , percentile_disc(0.95) WITHIN GROUP (ORDER BY respchartvaluenum) as value_p95

  from t1
  group by
    respcharttypecat, respchartvaluelabel
)
-- -- need to calculate percentiles w/o nulls/strings
-- , t2 as
-- (
--   select
--       respcharttypecat
--     , respchartvaluelabel
--     , respchartvaluenum
--     , ntile(10) over (order by respchartvaluenum) as nth_tile
--   from t1
--   where respchartvaluenum is not null
-- )
-- , t3 as
-- (
--   select
--       respcharttypecat
--     , respchartvaluelabel
--     , max(case when nth_tile = 1  then respchartvaluenum else null end) as value_q10
--     , avg(case when nth_tile = 5  then respchartvaluenum else null end) as value_q50
--     , min(case when nth_tile = 10 then respchartvaluenum else null end) as value_q90
--   from t2
--   group by respcharttypecat, respchartvaluelabel
-- )
select
    tgrp.respcharttypecat
  , tgrp.respchartvaluelabel
  , tgrp.n_obs
  , tgrp.n_pat
  -- mean obs per patients
  , tgrp.n_obs_per_pat
  , tgrp.n_distinct_obs
  , tgrp.string_mode
  , tgrp.numeric_obs_percent
  -- percentiles
  , tgrp.value_p05
  , tgrp.value_p50
  , tgrp.value_p95

  -- -- averages
  -- , tgrp.value_min
  -- , tgrp.value_avg
  -- , tgrp.value_max
from tgrp
-- left join t3
--   on tgrp.respcharttypecat = t3.respcharttypecat
--   and tgrp.respchartvaluelabel = t3.respchartvaluelabel
order by
  tgrp.respcharttypecat, tgrp.respchartvaluelabel;
