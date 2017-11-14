

DROP TABLE IF EXISTS VENTDURATIONS CASCADE;
CREATE TABLE ventdurations as
with vd0 as
(
  select
    patientunitstayid
    -- this carries over the previous chartoffset which had a mechanical ventilation event
    , case
        when MechVent=1 then
          LAG(chartoffset, 1) OVER (partition by patientunitstayid, MechVent order by chartoffset)
        else null
      end as chartoffset_lag
    , chartoffset
    , MechVent
    , OxygenTherapy
    , Extubated
  from ventsettings
)
, vd1 as
(
  select
      patientunitstayid
      , chartoffset_lag
      , chartoffset
      , MechVent
      , OxygenTherapy
      , Extubated

      -- if this is a mechanical ventilation event, we calculate the time since the last event
      , case
          -- if the current observation indicates mechanical ventilation is present
          -- calculate the time since the last vent event
          when MechVent=1 then
            (chartoffset - chartoffset_lag)/60
          else null
        end as ventduration

      , LAG(Extubated,1)
      OVER
      (
      partition by patientunitstayid, case when MechVent=1 or Extubated=1 then 1 else 0 end
      order by chartoffset
      ) as ExtubatedLag

      -- now we determine if the current mech vent event is a "new", i.e. they've just been intubated
      , case
        -- if there is an extubation flag, we mark any subsequent ventilation as a new ventilation event
          --when Extubated = 1 then 0 -- extubation is *not* a new ventilation event, the *subsequent* row is
          when
            LAG(Extubated,1)
            OVER
            (
            partition by patientunitstayid, case when MechVent=1 or Extubated=1 then 1 else 0 end
            order by chartoffset
            )
            = 1 then 1
          -- TODO: define an oxygen therapy flag that for sure means they switchted from MV to oxygen
          -- when MechVent = 0 and OxygenTherapy = 1 then 1
            -- if there is less than 8 hours between vent settings, we do not treat this as a new ventilation event
          when (chartoffset - chartoffset_lag) > 480 -- 8 hours
            then 1
        else 0
        end as newvent
  -- use the staging table with only vent settings from chart events
  FROM vd0 ventsettings
)
, vd2 as
(
  select vd1.*
  -- create a cumulative sum of the instances of new ventilation
  -- this results in a monotonic integer assigned to each instance of ventilation
  , case when MechVent=1 or Extubated = 1 then
      SUM( newvent )
      OVER ( partition by patientunitstayid order by chartoffset )
    else null end
    as ventnum
  --- now we convert chartoffset of ventilator settings into durations
  from vd1
)
-- create the durations for each mechanical ventilation instance
select patientunitstayid
  -- regenerate ventnum so it's sequential
  , ROW_NUMBER() over (partition by patientunitstayid order by ventnum) as ventnum
  , min(chartoffset) as starttime
  , max(chartoffset) as endtime
  , (max(chartoffset)-min(chartoffset))/60 AS duration_hours
from vd2
group by patientunitstayid, ventnum
having min(chartoffset) != max(chartoffset)
-- patient had to be mechanically ventilated at least once
-- i.e. max(mechvent) should be 1
-- this excludes a frequent situation of NIV/oxygen before intub
-- in these cases, ventnum=0 and max(mechvent)=0, so they are ignored
and max(mechvent) = 1
order by patientunitstayid, ventnum;
