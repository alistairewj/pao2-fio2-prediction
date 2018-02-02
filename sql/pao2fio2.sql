DROP TABLE IF EXISTS pf_pao2fio2;
CREATE TABLE pf_pao2fio2 AS
with t1 as
(
  select lab.patientunitstayid
    , lab.labresultoffset
    , min(case when labname = 'paO2' then labresult else null end) as PaO2
    , min(case when labname = 'FiO2' then
            -- input validation
            case
              when labresult < 0.209 then null
              when labresult <= 1.0 then labresult*100.0
              when labresult < 20.9 then null
              when labresult > 100 then null
            else labresult end
          else null end) as FiO2
  from lab
  where labname in ('paO2','FiO2')
  and labresult > 0
  group by lab.patientunitstayid, lab.labresultoffset
)
select
    t1.patientunitstayid
  , t1.labresultoffset as pfoffset
  , t1.pao2
  , t1.fio2
  , round(t1.pao2 / t1.fio2 * 100.0,2) as pao2fio2
from pf_cohort co
inner join t1
  on co.patientunitstayid = t1.patientunitstayid
where t1.fio2 is not null
and t1.pao2 is not null
and co.excluded = 0
order by t1.patientunitstayid, t1.labresultoffset;
