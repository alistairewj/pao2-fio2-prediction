-- Create a table of exclusions for eICU patients in the gossis project
DROP TABLE IF EXISTS pf_cohort CASCADE;
CREATE TABLE pf_cohort as
select pt.PATIENTUNITSTAYID
-- EXCLUSION FLAGS --
, case when pt.age = '> 89' then 0
      when pt.age = '' then 0
      when cast(pt.age as numeric) < 16 then 1
    else 0 end as exclusion_non_adult
    
-- missing hospital death outcome
, case
    when coalesce(pt.hospitaldischargestatus,'') = '' then 1
    when pt.unitdischargestatus not in ('Expired','Alive') then 1
  else 0 end as exclusion_missingoutcome
, case
    when aiva.apachescore > 1 and aiva.predictedhospitalmortality = -1 then 1
    when apv.readmit = 1 then 1
    when ROW_NUMBER() over (PARTITION BY apv.patientunitstayid ORDER BY pt.hospitaldischargeoffset DESC)
      > 1 then 1
    else 0 end as exclusion_readmission

-- APACHE score only exists for first hospital stay
, case when aiva.apachescore > 1 then 0 else 1 end as exclusion_no_apache_score

-- excluded column aggregates all the above
, case
     when (pt.age = '> 89' or pt.age = '' or cast(pt.age as numeric) >= 16)
      and coalesce(pt.hospitaldischargestatus,'') != ''
      and pt.unitdischargestatus in ('Expired','Alive')
      and aiva.apachescore > 1
      and not aiva.apachescore = -1
      and not apv.readmit = 1
      and ROW_NUMBER() over (PARTITION BY apv.patientunitstayid ORDER BY pt.hospitaldischargeoffset DESC) = 1
    then 0
  else 1 end as excluded
from patient pt
-- check for apache values
left join (select patientunitstayid, max(apachescore) as apachescore, min(cast(predictedhospitalmortality as numeric)) as predictedhospitalmortality from APACHEPATIENTRESULT where apacheversion = 'IVa' group by patientunitstayid) aiva
  on pt.patientunitstayid = aiva.patientunitstayid
-- filter to first stay
left join apachepredvar apv
  on pt.patientunitstayid = apv.patientunitstayid
order by pt.patientunitstayid;
