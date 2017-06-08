
DROP TABLE IF EXISTS C_PATIENTS_WITH_INFUSIONS;
CREATE TABLE C_PATIENTS_WITH_INFUSIONS as

with id0 as
(
  select patientunitstayid
    , case when drugname = '' then null else drugname end as drugname
    , infusionoffset
    , case when drugamount = '' then null else drugamount end as drugamount
    , case when volumeoffluid = '' then null else volumeoffluid end as volumeoffluid
    , case when drugrate = '' then null else drugrate end as drugrate
    , case when infusionrate = '' then null else infusionrate end as infusionrate
  from infusiondrug
)
, id1 as
(
select patientunitstayid
, drugname
, infusionoffset
, drugamount, volumeoffluid
, drugrate as drugrate_text
-- merge drugrate and infusionrate
, case
        when drugrate = '' then null
        when drugrate similar to '%[A-z]%' then null
        when drugrate similar to '%[0-9]+/[0-9]+%' then
            cast(substring(drugrate,'([0-9]+)/') as numeric) / cast(substring(drugrate,'/([0-9]+)') as numeric)
        when drugrate is not null then cast(drugrate as numeric)
        when infusionrate != '' and infusionrate is not null then cast(infusionrate as numeric)
        else null
    end as drugrate
, case
  when lower(drugrate) in ('dced','dc''d','ff','paused',
    'completed','complete','done')
    or drugrate like '%off%' then 1
  else 0 end as STOPPED
from infusiondrug
)
-- merge infusionrate/drugrate if infusionrate=0 and drugrate is not 0
--UPDATE: now merged in id1

-- group together the drugs on infusionoffset
, id3 as
(
select
    patientunitstayid, infusionoffset, drugname
    , max(stopped) as stopped
    , max(drugrate) as rate
    , max(case when drugrate is not null then 1 else 0 end) as rate_is_null
from id1
group by patientunitstayid, infusionoffset, drugname
)
, id4 as
(
select
    patientunitstayid, infusionoffset, drugname
    , stopped, rate, rate_is_null
    , sum(rate_is_null) over
        (
            partition by patientunitstayid, drugname
            order by infusionoffset
        ) as drug_partition
from id3
)
, id5 as
(
select
    patientunitstayid, infusionoffset, drugname
    , stopped, rate, rate_is_null
    , drug_partition
    , first_value(rate) over
        (
            partition by patientunitstayid, drugname, drug_partition
            order by infusionoffset
        ) as drug_prevrate_ifnull
from id4
)
, id6 as
(
select
    patientunitstayid, infusionoffset, drugname
    , stopped, rate, rate_is_null
    , drug_partition
    , drug_prevrate_ifnull

    -- We define start time here
    , case
        -- if this is the first instance of the drug
        when rate > 0 and
          LAG(drug_prevrate_ifnull,1)
          OVER
          (
          partition by patientunitstayid, drugname, rate_is_null
          order by infusionoffset
          )
          is null
          then 1

        -- you often get a string of 0s
        -- each zero would be assigned a monotonically increasing integer
        -- we decide not to set these as 1, just because it makes the eventual drugnum sequential
        when rate = 0 and
          LAG(drug_prevrate_ifnull,1)
          OVER
          (
          partition by patientunitstayid, drugname
          order by infusionoffset
          )
          = 0
          then 0

        -- sometimes you get a string of NULL, associated with 0 volumes
        -- same reason as before, we decide not to set these as 1
        -- drug_prevrate_ifnull is equal to the previous value *iff* the current value is null
        when drug_prevrate_ifnull = 0 and
          LAG(drug_prevrate_ifnull,1)
          OVER
          (
          partition by patientunitstayid, drugname
          order by infusionoffset
          )
          = 0
          then 0

        -- If the last recorded rate was 0, newvaso = 1
        when LAG(drug_prevrate_ifnull,1)
          OVER
          (
          partition by patientunitstayid, drugname
          order by infusionoffset
          ) = 0
          then 1

        -- If the last recorded vaso was D/C'd, newvaso = 1
        when
          LAG(stopped,1)
          OVER
          (
          partition by patientunitstayid, drugname
          order by infusionoffset
          )
          = 1 then 1

        -- ** not sure if the below is needed
        --when (infusionoffset - (LAG(infusionoffset, 1) OVER (partition by patientunitstayid order by infusionoffset))) > (interval '4 hours') then 1
      else null
      end as drug_start
    FROM
      id5
)
, id7 as
(
select
    patientunitstayid, infusionoffset, drugname
    , stopped, rate, rate_is_null
    , drug_partition
    , drug_prevrate_ifnull
    , drug_start
    , SUM(drug_start) OVER
        (
            partition by patientunitstayid, drugname
            order by infusionoffset
        ) as drug_first
from id6
)
, id8 as
(
select
    patientunitstayid, infusionoffset, drugname
    , stopped, rate, rate_is_null
    , drug_partition
    , drug_prevrate_ifnull
    , drug_start
    , drug_first
    , case
        -- If the recorded vaso was D/C'd, this is an end time
        when stopped = 1
          then drug_first

        -- If the rate is zero, this is the end time
        when rate = 0
          then drug_first

        -- the last row in the table is always a potential end time
        -- this captures patients who die/are discharged while on a drug
        -- in principle, this could add an extra end time for the drug
        -- however, since we later group on drug_start, any extra end times are ignored
        when LEAD(infusionoffset,1)
          OVER
          (
          partition by patientunitstayid, drugname
          order by infusionoffset
          ) is null
          then drug_first

        else null
    end as drug_stop
from id7
)
, id_dur as
(
-- below groups together drug administrations into durations (starttime/endtime)
select
  patientunitstayid
  , drugname
  , count(rate) as NumObs
  -- the first non-null rate is considered the starttime
  , min(case when rate is not null then infusionoffset else null end) as starttime
  -- the *first* time the first/last flags agree is the stop time for this duration
  , min(case when drug_first = drug_stop then infusionoffset else null end) as endtime
from id8
where
  drug_first is not null -- bogus data
and
  drug_first != 0 -- sometimes *only* a rate of 0 appears, i.e. the drug is never actually delivered
and
  patientunitstayid is not null -- there are data for "floating" admissions, we don't worry about these
group by patientunitstayid, drugname, drug_first
having
  max(rate) > 0 -- if the rate was always 0 or null, we consider it not a real drug delivery
)
, id_final as
(
select
  patientunitstayid
  , sum(NumObs) as NumObs
  , sum(endtime - starttime) / 60.0 as hrs
  , case
      when sum(endtime-starttime) = 0 then 0
    else (cast(sum(NumObs) as numeric)-1) / sum(endtime - starttime) * 60.0
    end as NumObsPerHour
from
  id_dur
group by patientunitstayid
order by patientunitstayid
)
, hospgrp as
(
    select pat.hospitalid, pat.hospitaldischargeyear
    , count(pat.patientunitstayid) as numpat
    , avg(idf.NumObsPerHour) as AvgNumObsPerHr
    , count(distinct idf.patientunitstayid) / count(distinct pat.patientunitstayid)
        as FracPatientWithInfusions
    from patient pat
    left join
    ( select patientunitstayid, count(patientunitstayid) as numobs
      from infusiondrug
      group by patientunitstayid
    ) id
      on id.patientunitstayid = pat.patientunitstayid
    left join
    ( select patientunitstayid, count(patientunitstayid) as numobs
      from intakeoutput
      group by patientunitstayid
    ) io
      on io.patientunitstayid = pat.patientunitstayid
    left join id_final idf
      on pat.patientunitstayid = idf.patientunitstayid
    where pat.UNITDISCHARGEOFFSET > (4*60) -- patient stayed at least 4 hours
    group by pat.hospitalid, pat.hospitaldischargeyear
    having count(id.patientunitstayid) > 0
    and avg(idf.NumObsPerHour) >= 0.8
    and count(distinct idf.patientunitstayid) / count(distinct pat.patientunitstayid) >= 0.1
)
select patientunitstayid
    , hg.hospitalid, hg.hospitaldischargeyear
    , hg.AvgNumObsPerHr
from patient pat
inner join hospgrp hg
    on pat.hospitalid = hg.hospitalid
    and pat.hospitaldischargeyear = hg.hospitaldischargeyear
order by patientunitstayid
