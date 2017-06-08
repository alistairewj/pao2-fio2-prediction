
# Define patients with continuous drug recording info

First, we calculate a bunch of summary statistics on a hospital/year basis.

```sql
with t1 as
(
select pat.hospitalid, pat.hospitaldischargeyear
  , pat.patientunitstayid
  , pat.UNITDISCHARGEOFFSET / 60 as LOS_HOURS -- originally in minutes
  , max(case when id.patientunitstayid is not null then id.patientunitstayid else null end) as PatExists
  , count(id.patientunitstayid) as numobs
from patients pat
left join infusiondrug id
  on id.patientunitstayid = pat.patientunitstayid
where pat.UNITDISCHARGEOFFSET > (4*60)
group by pat.hospitalid, pat.hospitaldischargeyear
  , pat.patientunitstayid, pat.unitdischargeoffset
)
select
  hospitalid, hospitaldischargeyear
  , count(patientunitstayid) as NumPat
  , count(distinct PatExists) as NumPatWithObs
  , round(100*count(distinct PatExists) / count(patientunitstayid),2) as PatientCoverage
  , min(numobs) as MinNumObs
  , round(avg(numobs),2) as AvgNumObs
  , max(numobs) as MaxNumObs
  , round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) as AvgNumObsPerHour
from t1
group by hospitalid, hospitaldischargeyear
order by hospitalid, hospitaldischargeyear;
```

Our first rule is: eliminate hospitals who have < 75% of patients with *any* measurement in the infusion drug table.



```sql
with t1 as
(
select pat.hospitalid, pat.hospitaldischargeyear
  , pat.patientunitstayid
  , pat.UNITDISCHARGEOFFSET / 60 as LOS_HOURS -- originally in minutes
  , max(case when id.patientunitstayid is not null then id.patientunitstayid else null end) as PatExists
  , count(id.patientunitstayid) as numobs
from patients pat
left join infusiondrug id
  on id.patientunitstayid = pat.patientunitstayid
where pat.UNITDISCHARGEOFFSET > (4*60)
group by pat.hospitalid, pat.hospitaldischargeyear
  , pat.patientunitstayid, pat.unitdischargeoffset
)
select
  hospitalid, hospitaldischargeyear
  , count(patientunitstayid) as NumPat
  , count(distinct PatExists) as NumPatWithObs
  , round(100*count(distinct PatExists) / count(patientunitstayid),2) as PatientCoverage
  , min(numobs) as MinNumObs
  , round(avg(numobs),2) as AvgNumObs
  , max(numobs) as MaxNumObs
  , round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) as MedianNumObsPerHour
from t1
group by hospitalid, hospitaldischargeyear
having
  round(100*count(distinct PatExists) / count(patientunitstayid),2) >= 75
order by hospitalid, hospitaldischargeyear;
```

This chops it down from 1440 locations to 160 (ouch). Our next rule is that the median number of observations per hour across patients is >= 0.5. That requires at least half of the patients to have 1 observation every 2 hours.

```sql
with t1 as
(
select pat.hospitalid, pat.hospitaldischargeyear
, pat.patientunitstayid
, pat.UNITDISCHARGEOFFSET / 60 as LOS_HOURS -- originally in minutes
, max(case when id.patientunitstayid is not null then id.patientunitstayid else null end) as PatExists
, count(id.patientunitstayid) as numobs
from patients pat
left join infusiondrug id
on id.patientunitstayid = pat.patientunitstayid
where pat.UNITDISCHARGEOFFSET > (4*60)
group by pat.hospitalid, pat.hospitaldischargeyear
, pat.patientunitstayid, pat.unitdischargeoffset
)
select
hospitalid, hospitaldischargeyear
, count(patientunitstayid) as NumPat
, count(distinct PatExists) as NumPatWithObs
, round(100*count(distinct PatExists) / count(patientunitstayid),2) as PatientCoverage
, min(numobs) as MinNumObs
, round(avg(numobs),2) as AvgNumObs
, max(numobs) as MaxNumObs
, round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) as AvgNumObsPerHour
from t1
group by hospitalid, hospitaldischargeyear
having
    round(100*count(distinct PatExists) / count(patientunitstayid),2) >= 75
and round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) >= 0.5
order by hospitalid, hospitaldischargeyear;
```

Down to 58 hospital/year pairs. :(

Quantify how much sample size we lose doing this.

```sql

with t1 as
(
select pat.hospitalid, pat.hospitaldischargeyear
, pat.patientunitstayid
, pat.UNITDISCHARGEOFFSET / 60 as LOS_HOURS -- originally in minutes
, max(case when id.patientunitstayid is not null then id.patientunitstayid else null end) as PatExists
, count(id.patientunitstayid) as numobs
from patients pat
left join infusiondrug id
on id.patientunitstayid = pat.patientunitstayid
where pat.UNITDISCHARGEOFFSET > (4*60)
group by pat.hospitalid, pat.hospitaldischargeyear
, pat.patientunitstayid, pat.unitdischargeoffset
)
, t2 as
(
select
hospitalid, hospitaldischargeyear
, CASE
    WHEN round(100*count(distinct PatExists) / count(patientunitstayid),2) >= 75
      THEN 1
    ELSE 0
  END AS rule1
, CASE
    WHEN round(100*count(distinct PatExists) / count(patientunitstayid),2) >= 75
    AND  round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) >= 0.5
      THEN 1
    ELSE 0
  END AS rule2

, count(patientunitstayid) as NumPat
, count(distinct PatExists) as NumPatWithObs
, round(100*count(distinct PatExists) / count(patientunitstayid),2) as PatientCoverage
, min(numobs) as MinNumObs
, round(avg(numobs),2) as AvgNumObs
, max(numobs) as MaxNumObs
, round(median(case when LOS_HOURS = 0 then null else numobs / LOS_HOURS end),2) as AvgNumObsPerHour
from t1
group by hospitalid, hospitaldischargeyear
)
select
  count(distinct hospitalid) as NumHosp
  , count(hospitalid) as NumHospYearPairs
  , sum(NumPat) as NumPat
  , sum(NumPatWithObs) as NumPatWithObs
  , rule1
  , rule2
from t2
group by rule1, rule2
order by rule1, rule2;
```


Result:

Rule applied | Hospitals | Hospital/Year | Patients | Patients with obs
--- | --- | --- | --- | ---
Base | 339 | 1415 | 111537 | 38953
Fail rules | 285 (85%) | 1255 (88%) | 97932 (87%) | 26855 (68%)
Rule 1 | 54 (15.9%) | 160 (11.3%) | 13605 (12.2%) | 12098 (31.0%)
Rule 1 + 2 | 22 (6.4%) | 58 (4.1%) | 5925 (5.3%) | 5232 (13.4%)
