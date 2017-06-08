
ALTER SESSION SET CURRENT_SCHEMA = EICU_ADM;

-- How many patients have a PaO2?
select p.patientunitstayid
  , l.*
from PATIENTS p
left join LAB l
  on p.patientunitstayid = l.patientunitstayid;
  

-- pao2 always in mmhg
-- fio2 always in %

-- number of PaO2 FiO2
select 
  --patientunitstayid, labresultoffset, PaO2, FiO2
  count(patientunitstayid) as NumObs, count(PaO2) as PaO2, count(FiO2) as FiO2, count(case when PaO2 is not null and FiO2 is not null then 1 else null end) as PaO2FiO2
from
(
  select patientunitstayid
    , LABRESULTOFFSET
    , min(case when labname = 'paO2' then labresult else null end) as PaO2
    , min(case when labname = 'FiO2' then labresult else null end) as FiO2
  from lab
  where labname in ('paO2','FiO2')
  group by patientunitstayid, LABRESULTOFFSET
);

-- here we see we have:
--  301694 observations
--  270699 PaO2 values
--  216949 FiO2 values
--  189088 PaO2/FiO2 at the same time


-- next question: how often do we have an spo2 for these values?
select
  --l.patientunitstayid, l.labresultoffset, l.PaO2, l.FiO2, vp.SaO2
  count(l.patientunitstayid) as NumObs
  , count(PaO2) as PaO2, count(FiO2) as FiO2
  , count(case when PaO2 is not null and FiO2 is not null then 1 else null end) as PaO2FiO2
  , count(case when PaO2 is not null and FiO2 is not null and vp.SaO2 is not null then 1 else null end) as PaO2FiO2SpO2
from
(
  select patientunitstayid
    , LABRESULTOFFSET
    , min(case when labname = 'paO2' then labresult else null end) as PaO2
    , min(case when labname = 'FiO2' then labresult else null end) as FiO2
  from lab
  where labname in ('paO2','FiO2')
  group by patientunitstayid, LABRESULTOFFSET
) l
left join vitalperiodic vp
  on l.patientunitstayid = vp.patientunitstayid
  and l.labresultoffset = vp.observationoffset;
-- here we see:
--  301696 observations (we seem to have duplicated 2 observations from before)
--  270701 PaO2 values
--  216951 FiO2 values
--  189090 PaO2 and FiO2
--  10417 PaO2, FiO2, and SpO2 at exact same time

-- next question: how often do we have an spo2 up to 5 minutes before these values?
with t1 as
(
select
  l.patientunitstayid, l.labresultoffset, l.PaO2, l.FiO2
  -- average should be the average of only 1 value, so no errors here.
  -- if paranoid, check vital signs can only occur once every 5 minutes
  , SaO2
  , ROW_NUMBER() over 
  (
    partition by l.patientunitstayid, l.labresultoffset
    order by vp.observationoffset DESC
  ) as rn
from
(
  select patientunitstayid
    , LABRESULTOFFSET
    , min(case when labname = 'paO2' then labresult else null end) as PaO2
    , min(case when labname = 'FiO2' then labresult else null end) as FiO2
  from lab
  where labname in ('paO2','FiO2')
  group by patientunitstayid, LABRESULTOFFSET
) l
left join vitalperiodic vp
  on l.patientunitstayid = vp.patientunitstayid
  -- occurring up to 5 minutes after the vital sign measurement
  and l.labresultoffset between vp.observationoffset and vp.observationoffset+5
)
select 
  count(patientunitstayid) as NumObs
  , count(PaO2) as PaO2, count(FiO2) as FiO2
  , count(case when PaO2 is not null and FiO2 is not null then 1 else null end) as PaO2FiO2
  , count(case when PaO2 is not null and FiO2 is not null and SaO2 is not null then 1 else null end) as PaO2FiO2SpO2
from t1
where rn = 1; -- closest SpO2


-- here we see we have:
--  301694 observations
--  270699 PaO2 values
--  216949 FiO2 values
--  189088 PaO2/FiO2 at the same time
--   51610 PaO2/FiO2, and SpO2 within 5 min




-- can we find vasopressors?

-- add in a filter: hospitals with >95% of patients with infusion drug entries
with validhosp as
(
select pat.hospitalid, pat.hospitaldischargeyear
--  , count(distinct pat.patientunitstayid) as numpat
--  , count(pat.patientunitstayid) as numobs, count(id.patientunitstayid) as numinfusdrug
--  , count(id.patientunitstayid) / count(pat.patientunitstayid) * 100 as frac
from patients pat
left join infusiondrug id
  on id.patientunitstayid = pat.patientunitstayid
group by pat.hospitalid, pat.hospitaldischargeyear
-- at least 95% of the patients in this hospital/year have an infusion drug record
having ( count(id.patientunitstayid) / count(pat.patientunitstayid) ) > .95
)
, t1 as
(
select
  l.patientunitstayid, l.labresultoffset, l.PaO2, l.FiO2
  -- average should be the average of only 1 value, so no errors here.
  -- if paranoid, check vital signs can only occur once every 5 minutes
  , SaO2
  , ROW_NUMBER() over 
  (
    partition by l.patientunitstayid, l.labresultoffset
    order by vp.observationoffset DESC
  ) as rn
from
(
  select patientunitstayid
    , LABRESULTOFFSET
    , min(case when labname = 'paO2' then labresult else null end) as PaO2
    , min(case when labname = 'FiO2' then labresult else null end) as FiO2
  from lab
  where labname in ('paO2','FiO2')
  group by patientunitstayid, LABRESULTOFFSET
) l
left join vitalperiodic vp
  on l.patientunitstayid = vp.patientunitstayid
  -- occurring up to 5 minutes after the vital sign measurement
  and l.labresultoffset between vp.observationoffset and vp.observationoffset+5
)
select 
  count(patientunitstayid) as NumObs
  , count(PaO2) as PaO2, count(FiO2) as FiO2
  , count(case when PaO2 is not null and FiO2 is not null then 1 else null end) as PaO2FiO2
  , count(case when PaO2 is not null and FiO2 is not null and SaO2 is not null then 1 else null end) as PaO2FiO2SpO2
  , count(distinct case when PaO2 is not null and FiO2 is not null and SaO2 is not null then patientunitstayid else null end) as PaO2FiO2SpO2_uniqpat
from t1
where patientunitstayid in
(
select patientunitstayid 
from patients pat
inner join validhosp vh
on pat.hospitalid = vh.hospitalid
and pat.hospitaldischargeyear = vh.hospitaldischargeyear
);

-- here we see we have:
--  172556 observations
--  156638 PaO2 values
--  123322 FiO2 values
--  108897 PaO2/FiO2 at the same time
--   33647 PaO2/FiO2, and SpO2 within 5 min
--   12153 PaO2/FiO2, and SpO2 within 5 min - unique patients.
				
-- the same numbers in the full dataset, eicu_v1
--  3387427 obs
--  3090249 pao2
--  2401772 fio2
--  2135979 pao2/fio2
--   655139 pao2/fio2 + spo2 within 5 min
--   237623 pao2/fio2/spo2 unique icu stays


--------- SANITY CHECK QUERIES ----------

select *
from infusiondrug
where patientunitstayid = 75732
order by infusionoffset;

-- below confirms that fio2 only occurs once per labresultoffset
-- you can easily show the same for pao2
select patientunitstayid
  , LABRESULTOFFSET
  , count(distinct LABRESULT) as numdistinctobs -- numeric field
from lab
where labname = 'fio2'
group by patientunitstayid, LABRESULTOFFSET
having count(distinct LABRESULT) > 1;