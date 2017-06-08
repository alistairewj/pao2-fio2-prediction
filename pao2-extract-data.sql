-- These queries are used to export the data to csv through SQLDeveloper

-- ------------ --------- ------------ --
-- ------------ DATASET 1 ------------ --
-- ------------ --------- ------------ --

-- get patients from hospitals with continuous infusions
DROP MATERIALIZED VIEW IF EXISTS PAO2MODELDATA;
CREATE MATERIALIZED VIEW PAO2MODELDATA AS
with patlist as
(
  select patientunitstayid
  from C_PATIENTS_WITH_INFUSIONS
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
    select lab.patientunitstayid
      , LABRESULTOFFSET
      , min(case when labname = 'paO2' then labresult else null end) as PaO2
      , min(case when labname = 'FiO2' then labresult else null end) as FiO2
    from lab
    -- filter to only our patients for efficiency
    inner join patlist pl
    on lab.patientunitstayid = pl.patientunitstayid
    where labname in ('paO2','FiO2')
    group by lab.patientunitstayid, LABRESULTOFFSET
  ) l
  left join vitalperiodic vp
    on l.patientunitstayid = vp.patientunitstayid
    -- occurring up to 5 minutes after the vital sign measurement
    and l.labresultoffset between vp.observationoffset and vp.observationoffset+5
)
-- now let's get any existence of vasopressors in the 12 hours preceeding the blood gas
, t2 as
(
  select t1.patientunitstayid
    , labresultoffset, PaO2, FiO2, SaO2
    , infusionoffset
    , id.drugname
    -- *rarely* the drug rate is null, but other fields are non-null
    -- rarely as in ~20 rows out of all of the INFUSIONDRUG table
    , coalesce(drugrate, infusionrate, drugamount, volumeoffluid) as drugrate
    , dense_rank() over (partition by t1.patientunitstayid, t1.labresultoffset order by infusionoffset DESC) as lastInfusionDrug
  from t1
  left join infusiondrug id
    on  t1.patientunitstayid = id.patientunitstayid
    and id.infusionoffset between t1.labresultoffset - (24*60) and t1.labresultoffset
    and
    (
         lower(id.drugname) like '%norepinephrine%'
      or lower(id.drugname) like '%epinephrine%'
      or lower(id.drugname) like '%dopamine%'
      or lower(id.drugname) like '%phenylephrine%'
      or lower(id.drugname) like '%vasopressin%'
    )
  where rn = 1 -- closest SaO2 associated with the PaO2/FiO2
)
, t3 as
(
select
  patientunitstayid
  , labresultoffset
  , PaO2, FiO2, SaO2


  -- drug information
  , case when max(case when lastInfusionDrug = 1 then drugrate else null end) is not null then 1 else 0 end as vasopressor
  , max(case when lastInfusionDrug = 1 then infusionoffset else null end) as infusionOffset
  , max(case when lower(drugname) like '%norepinephrine%' and lastInfusionDrug = 1 then drugrate else null end) as norepinephrine
  , max(case when lower(drugname) like '%epinephrine%' and lastInfusionDrug = 1 then drugrate else null end) as epinephrine
  , max(case when lower(drugname) like '%dopamine%' and lastInfusionDrug = 1 then drugrate else null end) as dopamine
  , max(case when lower(drugname) like '%phenylephrine%' and lastInfusionDrug = 1 then drugrate else null end) as phenylephrine
  , max(case when lower(drugname) like '%vasopressin%' and lastInfusionDrug = 1 then drugrate else null end) as vasopressin
from t2
where SaO2 is not null and PaO2 is not null and FiO2 is not null
group by   patientunitstayid
  , labresultoffset
  , PaO2, FiO2, SaO2
)
-- first, extract the values from the respiratory table and convert them to numeric
, respobs_num as
(
  select
    patientunitstayid, RESPCHARTOFFSET
    , case
        when RESPCHARTVALUELABEL in ('Tidal Volume (set)','TV/kg IBW')
          then 'Tidal Volume'
        else RESPCHARTVALUELABEL
      end as RESPCHARTVALUELABEL

      , case when RESPCHARTVALUELABEL = 'O2 Admin Device' then
          case
            -- 'ra', 'drager', 'mq', 'maquet vent', 'vision', 'servo-i', 'servo i', 'servoi', 'atc', 'servo'
            -- 'pb 840', 'avea', 'pb840', 'drager xl', 'xl','vm','hhtc'
            -- 'mq vent','tc', 'drager e4', 'oxymizer', 'hhtp'
            when lower(RESPCHARTVALUE) in ('cannula','nasal cannula, high flow device','n/c', 'nasal cannula, ventilator',
              'nasal cannula','nc','naslcn','hfnc','high flow nasal cannula','high flow device') then 'NasalCannula'
            when lower(RESPCHARTVALUE) in ('mv', 'ventilator','vent',
                '840','840 vent','vent 840','840/vent') then 'Ventilator'
            when lower(RESPCHARTVALUE) in ('room air','none/room air','none (room air)') then 'NotVent'
            when lower(RESPCHARTVALUE) in ('nasal cannula, bipap', 'bipap') then 'bipap'
            when lower(RESPCHARTVALUE) in ('aerosol mask') then 'Mask'
            when lower(RESPCHARTVALUE) in ('ventimask') then 'VentiMask'
            when lower(RESPCHARTVALUE) in ('trach collar','tc','trach collar, ventilator') then 'TrachCollar'
            when lower(RESPCHARTVALUE) in ('trach mask') then 'TrachMask'
            when lower(RESPCHARTVALUE) in ('non-rebreather mask''nrb', 'nrm', 'nonrebreather mask') then 'nrb'
            when lower(RESPCHARTVALUE) in ('nasal cpap', 'cpap','cpap, ventilator','nvcpap') then 'cpap'
          else null end
        else null end as O2Device

      , cast(case when RESPCHARTVALUELABEL = 'FiO2' then
              case

                  when trim(lower(RESPCHARTVALUE)) = '.' or trim(lower(RESPCHARTVALUE)) = ''
                    then null
                  else
                    coalesce(
                        substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05
                      , substring( trim(lower(replace(lower(RESPCHARTVALUE),'%',''))) from '^[0-9]*\.?[0-9]*%$' ) -- percentage, e.g. 24%
                    )
              end
          else null end
          as NUMERIC) as FiO2

      , cast(case when RESPCHARTVALUELABEL = 'PEEP' then
              case
                  when trim(lower(RESPCHARTVALUE)) = '.' or trim(lower(RESPCHARTVALUE)) = ''
                    then null
                  else
                    coalesce(
                        substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05
                      , substring( trim(replace(replace(lower(RESPCHARTVALUE),' ',''),'cmh2','')) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05
                    )
              end
          else null end
          as NUMERIC) as PEEP

      , round(cast(case
          when RESPCHARTVALUELABEL = 'Tidal Volume (set)' then
            case
                  when trim(lower(RESPCHARTVALUE)) = '.' or trim(lower(RESPCHARTVALUE)) = ''
                    then null
                  else
                    coalesce(
                        substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05
                      , substring( trim(replace(replace(lower(RESPCHARTVALUE),' ',''),'cmh2','')) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05
                    )
              end
          -- recorded by kg ideal body weight.. need to convert using ideal body weight from another table
          when RESPCHARTVALUELABEL = 'TV/kg IBW' then
            case
              when trim(lower(RESPCHARTVALUE)) = '.' or trim(lower(RESPCHARTVALUE)) = ''
                then null
              -- data was input as actual tidal volume instead of per kg IBW... can use it directly
              when cast(substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' ) as numeric) >= 50 -- standard decimal, e.g. 24.05
               then substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' )

              -- TODO: when it's input correctly, scale it by body weight ( TV * weight )
            else null end
          else null end
          as NUMERIC),4) as TidalVolume

      , cast(case when RESPCHARTVALUELABEL = 'Peak Insp. Pressure' then
              case
                  when trim(lower(RESPCHARTVALUE)) = '.' or trim(lower(RESPCHARTVALUE)) = ''
                    then null
                  else

                        substring( trim(lower(RESPCHARTVALUE)) from '^[0-9]*\.?[0-9]*$' ) -- standard decimal, e.g. 24.05

              end
          else null end
          as NUMERIC) as PeakPressure
  from RESPIRATORYCHARTING re
  where respchartvaluelabel in
  (
    'FiO2', 'O2 Admin Device', 'PEEP'
    , 'Tidal Volume (set)', 'TV/kg IBW'
    , 'Peak Insp. Pressure'
  )

)
, respobs_filt as
(
  select
    patientunitstayid, RESPCHARTOFFSET, RESPCHARTVALUELABEL
  , O2Device

  -- physiologically plausible values filtered
  , case
      when FiO2 <= 1 and FiO2 > 0
        then FiO2
      when FiO2 >= 20 and FiO2 <= 100
        then FiO2 / 100.0
      else null
    end as FiO2

  , case
        when PEEP >= 0 and PEEP <= 50
          then PEEP
        else null
    end as PEEP

  , case
        when TidalVolume >= 0 and TidalVolume <= 5000
          then TidalVolume
        else null
    end as TidalVolume

  , case
        when PeakPressure >= 0 and PeakPressure <= 100
          then PeakPressure
        else null
    end as PeakPressure

  from respobs_num
)
-- now match the respiratory table with the labs table
, respobs as
(
  select
    re.patientunitstayid, t2.labresultoffset, re.RESPCHARTOFFSET
  , O2Device, re.FiO2, PEEP, TidalVolume, PeakPressure

  -- we join to the current dataset to get LABRESULTOFFSET
  -- then we can use ROW_NUMBER() to find the last occurring resp chart for the given lab value
  , ROW_NUMBER() over
    (
      partition by re.patientunitstayid, t2.labresultoffset, re.RESPCHARTVALUELABEL
      order by re.RESPCHARTOFFSET DESC
    ) as rn

  from respobs_filt re
  left join t2
    on re.patientunitstayid = t2.patientunitstayid
)
, respobs_grp as
(
  select
    patientunitstayid, labresultoffset
    , max(case when rn = 1 and PEEP is not null then RESPCHARTOFFSET else null end) as PEEPOffset
    , max(case when rn = 1 and FIO2 is not null then RESPCHARTOFFSET else null end) as FIO2Offset
    , max(case when rn = 1 and O2Device is not null then RESPCHARTOFFSET else null end) as O2DeviceOffset
    , max(case when rn = 1 and TidalVolume is not null then RESPCHARTOFFSET else null end) as TidalVolumeOffset
    , max(case when rn = 1 and PeakPressure is not null then RESPCHARTOFFSET else null end) as PeakPressureOffset

    , max(case when rn = 1 then PEEP  else null end) as PEEP
    , max(case when rn = 1 then FIO2 else null end) as FIO2
    , max(case when rn = 1 then O2Device else null end) as O2Device
    , max(case when rn = 1 then TidalVolume else null end) as TidalVolume
    , max(case when rn = 1 then PeakPressure else null end) as PeakPressure

  from respobs
  group by patientunitstayid, labresultoffset
)
select
  t3.patientunitstayid
  , t3.labresultoffset
  , t3.PaO2, t3.FiO2 as FiO2, t3.SaO2


  -- drug information
  , vasopressor
  , infusionOffset
  , norepinephrine
  , epinephrine
  , dopamine
  , phenylephrine
  , vasopressin

  -- resp information
  , re.PEEP, re.PEEPOffset
  , re.FiO2 as FiO2Resp
  , re.FiO2Offset as FiO2RespOffset
  , re.O2Device, re.O2DeviceOffset
  , re.TidalVolume, re.TidalVolumeOffset
  , re.PeakPressure, re.PeakPressureOffset
from t3
left join respobs_grp re
  on t3.patientunitstayid = re.patientunitstayid
  and t3.labresultoffset = re.labresultoffset;



-- ------------ --------- ------------ --
-- ------------ DATASET 2 ------------ --
-- ------------ --------- ------------ --

-- FiO2
-- PEEP
-- Tidal Volume
-- Peak pressure
-- Resp rate
-- O2 flow
-- type of device (non-rebreather, etc)
-- Cardiac output
-- Temperature
