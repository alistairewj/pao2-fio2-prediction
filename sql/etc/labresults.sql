SET SEARCH_PATH TO eicu_crd_phi;
DROP TABLE IF EXISTS public.pfratio_labresults CASCADE;
CREATE TABLE public.pfratio_labresults as
--patients with 1 or less lab results
with lr as(
SELECT
distinct lab.patientunitstayid,
count(*)
FROM
  eicu_crd_phi.lab
GROUP BY
  lab.patientunitstayid,
  lab.labname,
  lab.labresultoffset,
  lab.labresultrevisedoffset
HAVING
count(*)  <=1 )
, nc as
(
select
  patientunitstayid
  , nursingchartoffset
  , avg(case
      when nursingchartcelltypevallabel = 'Heart Rate'
       and nursingchartcelltypevalname = 'Heart Rate'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as heartrate
  , avg(case
      when nursingchartcelltypevallabel = 'Respiratory Rate'
       and nursingchartcelltypevalname = 'Respiratory Rate'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as RespiratoryRate
  , avg(case
      when nursingchartcelltypevallabel = 'O2 Saturation'
       and nursingchartcelltypevalname = 'O2 Saturation'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as o2saturation
  , avg(case
      when nursingchartcelltypevallabel = 'Non-Invasive BP'
       and nursingchartcelltypevalname = 'Non-Invasive BP Systolic'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as nibp_systolic
  , avg(case
      when nursingchartcelltypevallabel = 'Non-Invasive BP'
       and nursingchartcelltypevalname = 'Non-Invasive BP Diastolic'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as nibp_diastolic
  , avg(case
      when nursingchartcelltypevallabel = 'Non-Invasive BP'
       and nursingchartcelltypevalname = 'Non-Invasive BP Mean'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as nibp_mean
  , avg(case
      when nursingchartcelltypevallabel = 'Temperature'
       and nursingchartcelltypevalname = 'Temperature (C)'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as temperature
  , max(case
      when nursingchartcelltypevallabel = 'Temperature'
       and nursingchartcelltypevalname = 'Temperature Location'
          then nursingchartvalue
      else null end)
    as TemperatureLocation
  , avg(case
      when nursingchartcelltypevallabel = 'Invasive BP'
       and nursingchartcelltypevalname = 'Invasive BP Systolic'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as ibp_systolic
  , avg(case
      when nursingchartcelltypevallabel = 'Invasive BP'
       and nursingchartcelltypevalname = 'Invasive BP Diastolic'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as ibp_diastolic
  , avg(case
      when nursingchartcelltypevallabel = 'Invasive BP'
       and nursingchartcelltypevalname = 'Invasive BP Mean'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as ibp_mean
  , avg(case
      when nursingchartcelltypevallabel = 'Glasgow coma score'
       and nursingchartcelltypevalname = 'GCS Total'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      when nursingchartcelltypevallabel = 'Score (Glasgow Coma Scale)'
       and nursingchartcelltypevalname = 'Value'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as gcs

  -- other map fields
  , avg(case
      when nursingchartcelltypevallabel = 'MAP (mmHg)'
       and nursingchartcelltypevalname = 'Value'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      when nursingchartcelltypevallabel = 'Arterial Line MAP (mmHg)'
       and nursingchartcelltypevalname = 'Value'
       and nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
       and nursingchartvalue not in ('-','.')
          then cast(nursingchartvalue as numeric)
      else null end)
    as map
  from nursecharting
  -- speed up by only looking at a subset of charted data
  where nursingchartcelltypecat in
  (
    'Vital Signs','Scores','Other Vital Signs and Infusions'
  )
  and nursingchartoffset > -60
  and nursingchartoffset < (60*24)
  group by patientunitstayid, nursingchartoffset
)


-- apply some preprocessing to fields
, ncproc as
(
  select
    patientunitstayid
  , nursingchartoffset
  , case when heartrate > 0 and heartrate < 400 then heartrate else null end as heartrate
  , case when RespiratoryRate > 0 and RespiratoryRate < 80 then RespiratoryRate else null end as RespiratoryRate
  , case when o2saturation > 0 and o2saturation <= 100 then o2saturation else null end as o2saturation
  , case when nibp_systolic > 0 and nibp_systolic < 400 then nibp_systolic else null end as nibp_systolic
  , case when nibp_diastolic > 0 and nibp_diastolic < 400 then nibp_diastolic else null end as nibp_diastolic
  , case when nibp_mean > 0 and nibp_mean < 400 then nibp_mean else null end as nibp_mean
  , case when temperature > 20 and temperature < 50 then temperature else null end as temperature
  , TemperatureLocation
  , case when ibp_systolic > 0 and ibp_systolic < 400 then ibp_systolic else null end as ibp_systolic
  , case when ibp_diastolic > 0 and ibp_diastolic < 400 then ibp_diastolic else null end as ibp_diastolic
  , case when ibp_mean > 0 and ibp_mean < 400 then ibp_mean else null end as ibp_mean
  , case when gcs > 2 and gcs < 16 then gcs else null end as gcs
  -- other map fields
  , case when map > 0 and map < 400 then map else null end as map
  from nc
)

select
  ncproc.patientunitstayid
-- , min(heartrate) as heartrate_min
, max(heartrate) as heartrate_max
-- , min(RespiratoryRate) as respiratoryrate_min
, max(RespiratoryRate) as respiratoryrate_max
, min(o2saturation) as o2saturation_min
, min(nibp_systolic) as nibp_systolic_min
, min(nibp_diastolic) as nibp_diastolic_min
, min(nibp_mean) as nibp_mean_min
, min(ibp_systolic) as ibp_systolic_min
, min(ibp_diastolic) as ibp_diastolic_min
, min(coalesce(ibp_mean,map)) as ibp_mean_min

, min(case when coalesce(ibp_mean,map) < nibp_mean then coalesce(ibp_mean,map)
      when nibp_mean < coalesce(ibp_mean,map) then nibp_mean
    else coalesce(coalesce(ibp_mean,map),nibp_mean)
  end) as mbp_min
, min(case when ibp_systolic < nibp_systolic then ibp_systolic
      when nibp_systolic < ibp_systolic then nibp_systolic
    else coalesce(ibp_systolic,nibp_systolic)
  end) as sbp_min

, min(temperature) as temperature_min
, max(temperature) as temperature_max
-- , TemperatureLocation
, min(gcs) as gcs_min
from ncproc, lr
where ncproc.patientunitstayid = lr.patientunitstayid
group by ncproc.patientunitstayid;
