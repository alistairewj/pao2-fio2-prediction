-- This query extracts the duration of mechanical ventilation
-- The main goal of the query is to aggregate sequential ventilator settings
-- into single mechanical ventilation "events". The start and end time of these
-- events can then be used for various purposes: calculating the total duration
-- of mechanical ventilation, cross-checking values (e.g. PaO2:FiO2 on vent), etc

-- The query's logic is roughly:
--    1) The presence of a mechanical ventilation setting starts a new ventilation event
--    2) Any instance of a setting in the next 8 hours continues the event
--    3) Certain elements end the current ventilation event
--        a) documented extubation ends the current ventilation
--        b) initiation of non-invasive vent and/or oxygen ends the current vent
-- The ventilation events are numbered consecutively by the `numseq` column.


-- First, identify mechvent, intubation and extubation etc;
DROP MATERIALIZED VIEW IF EXISTS ventevents CASCADE;
CREATE MATERIALIZED VIEW ventevents AS
WITH eventflags AS (
    SELECT v.*,
        -- add criteria for mech vent
        -- random criteria for now
        CASE WHEN mean_airway_pressure IS NOT NULL THEN 1
          WHEN peak_pressure IS NOT NULL THEN 1
          WHEN plateau_pressure IS NOT NULL THEN 1
          WHEN ps IS NOT NULL THEN 1
          WHEN rsbi IS NOT NULL THEN 1
          -- review these modes
          WHEN LOWER(mv_mode) LIKE '%prvc%' 
            OR LOWER(mv_mode) LIKE '%simv%'
            OR LOWER(mv_mode) LIKE '%bi-vent%'
            OR mv_mode LIKE 'AC%' THEN 1
            ELSE NULL END AS mechvent,
        -- add criteria for intubation
        CAST(NULL AS numeric) AS intubation,
        -- add criteria for extubation
        CAST(NULL AS numeric) AS extubation,
        -- add criteria for weaning trial
        CASE WHEN rsbi IS NOT NULL THEN 1
          ELSE NULL END AS weaningtrial
    FROM vent_unpivot v),
mechlag AS (
    SELECT f.*, 
        -- if mechvent event, find time of last mechvent event
        CASE WHEN mechvent = 1 
          THEN LAG(chartoffset, 1) OVER (partition by patientunitstayid, mechvent ORDER BY chartoffset)
          ELSE NULL END AS chartoffset_lag,
        -- if mechvent event, find time since last mechvent event
        CASE WHEN mechvent = 1 
          THEN chartoffset - LAG(chartoffset, 1) OVER (PARTITION BY patientunitstayid, mechvent ORDER BY chartoffset)
          ELSE NULL END AS ventduration, 
        -- if extubation event, find time since last mechvent/extubation event
        LAG(extubation,1) OVER (
          PARTITION BY patientunitstayid, CASE WHEN mechvent=1 or extubation=1 THEN 1 ELSE 0 END ORDER BY chartoffset
          ) as extubatedlag
    FROM eventflags f),
durations AS (
    SELECT *
    FROM mechlag)
SELECT m.*,
        -- determine if this is a new intubation event
        -- if there is an extubation flag, any subsequent ventilation is marked as a new ventilation event
        -- extubation = 1 *is not* a new ventilation event. The subsequent row *is*.
        CASE WHEN LAG(m.extubation,1) OVER
              (
              PARTITION BY m.patientunitstayid, case when m.mechvent=1 or m.extubation=1 THEN 1 ELSE 0 END
              ORDER BY m.chartoffset
              ) = 1 THEN 1
            -- if patient has initiated oxygen therapy, and is not currently vented, start a newvent
            -- WHEN mechvent = 0 and oxygentherapy = 1 THEN 1
            -- if <8 hours (8*60 minutes) between vent settings, do not treat as a new ventilation event
            WHEN (m.chartoffset - m.chartoffset_lag) > (60 * 8) THEN 1
            ELSE 0 END AS newvent
FROM mechlag m
ORDER BY patientunitstayid, chartoffset;

-- Next calculate the ventdurations
DROP MATERIALIZED VIEW IF EXISTS ventdurations CASCADE;
CREATE MATERIALIZED VIEW ventdurations AS
WITH ventevents_cumul AS (
    SELECT v.*,
        -- create a cumulative sum of the instances of new ventilation
        -- this results in a monotonic integer assigned to each instance of ventilation
        CASE WHEN mechvent=1 OR extubation=1 THEN SUM(newvent) 
            OVER (PARTITION BY patientunitstayid ORDER BY chartoffset)
            ELSE NULL END AS ventseq
    FROM ventevents v
)
-- create the durations for each mechanical ventilation instance
SELECT vc.patientunitstayid,
    -- regenerate ventseq so it is sequential
    ROW_NUMBER() OVER (PARTITION BY vc.patientunitstayid ORDER BY vc.ventseq) AS ventseq,
    MIN(vc.chartoffset) AS startoffset, MAX(vc.chartoffset) AS endoffset,
    MAX(vc.chartoffset) - MIN(vc.chartoffset) AS ventilation_minutes
FROM ventevents_cumul vc
GROUP BY vc.patientunitstayid, vc.ventseq
HAVING MIN(vc.chartoffset) != MAX(vc.chartoffset)
-- patient had to be mechanically ventilated at least once
-- i.e. max(mechvent) should be 1
-- this excludes a frequent situation of NIV/oxygen before intub
-- in these cases, ventseq=0 and max(mechvent)=0, so they are ignored
AND MAX(vc.mechvent) = 1
ORDER BY vc.patientunitstayid, vc.ventseq;

