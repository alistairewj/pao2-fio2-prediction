-- based off create-vent-query-process
select rc.patientunitstayid, respchartoffset as chartoffset, respchartentryoffset as entryoffset
-- case statement for creating a column with only one type of value
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Auto PEEP' THEN respchartvalue
--   ELSE NULL END) AS AUTO_PEEP
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'CPAP' THEN respchartvalue
--   ELSE NULL END) AS CPAP
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent ETCO2' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent ETCO2_' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'End Tidal CO2 (mmHg)' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'EtCO2' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'ETCO2' THEN respchartvalue
--   ELSE NULL END) AS ETCO2
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Position at lip' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ET Tube Repositioned' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Sedation Vacation' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Rotation' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Postion at Lip' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Endotracheal Tube Placement Checked' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Endotracheal Tube Placement' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Endotracheal Tube Moved to' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Endotracheal Position at Lip' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Peptic Ulcer Prophylaxis' THEN respchartvalue
--   ELSE NULL END) AS ETT
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Insertion date' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Insertion Date' THEN respchartvalue
--   ELSE NULL END) AS ETT_insertion_date
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Insertion time' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'ETT Insertion Time' THEN respchartvalue
--   ELSE NULL END) AS ETT_insertion_time
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Extubation Date' THEN respchartvalue
--   ELSE NULL END) AS EXTUBATION_DATE
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Set Fraction of Inspired Oxygen (FIO2)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'O2 Percentage' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'FIO2 (%)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'FiO2' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'FiO2' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'FiO2' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'FiO2' THEN respchartvalue
  ELSE NULL END) AS FiO2
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent IBW in Kg' THEN respchartvalue
--   ELSE NULL END) AS IDEAL_BODY_WEIGHT
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Inspiratory Flow Rate' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Insp Flow (l/min)' THEN respchartvalue
--   ELSE NULL END) AS INSP_FLOW__L_min_
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'I:E Ratio' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'PD I:E RATIO' THEN respchartvalue
--   ELSE NULL END) AS I_E_RATIO_DELIVERED
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Setting Set I:E' THEN respchartvalue
--   ELSE NULL END) AS I_E_RATIO_SET
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Inspiratory Time' THEN respchartvalue
--   ELSE NULL END) AS Inspiratory_Time
, max(CASE
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Mean Airway Pressure' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Mean Airway Pressure' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Mean Airway Pressure' THEN respchartvalue
  ELSE NULL END) AS MEAN_AIRWAY_PRESSURE
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'MVe' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Minute Volume' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Minute Ventilation Set(L/min)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Minute Volume, Spontaneous' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Exhaled MV' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent MinuteVentil' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Measured Ve' THEN respchartvalue
  ELSE NULL END) AS mve
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Mechanical Ventilator Mode' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Mode of Ventilation' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Ventilator Support Mode' THEN respchartvalue
  ELSE NULL END) AS MV_MODE
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'IPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'IPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'IPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'ipap' THEN respchartvalue
--   ELSE NULL END) AS NIV__IPAP
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Setting Set_RR' THEN respchartvalue
--   ELSE NULL END) AS NIV__RESP_RATE_SET
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'B2: EPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'EPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'EPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'EPAP' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'epap' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Setting EPAP' THEN respchartvalue
--   ELSE NULL END) AS NIV___EPAP
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'B1: IPAP' THEN respchartvalue
--   ELSE NULL END) AS NIV___IPAP
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Pt/Vent Spont_Rate' THEN respchartvalue
--   ELSE NULL END) AS NIV___RESP_RATE_SPONT
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Setting Total RR_5' THEN respchartvalue
--   ELSE NULL END) AS NIV___RESP_RATE_TOTAL
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Setting Spont Exp Vt_5' THEN respchartvalue
--   ELSE NULL END) AS NIV___TIDAL_VOLUME__mL_
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Oxygen Delivery Method' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'O2 Device' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'O2 Admin Device 2' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'O2 Admin Device' THEN respchartvalue
--   ELSE NULL END) AS OXYGEN_DELIVERY_METHOD
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'LPM O2' THEN respchartvalue
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Oxygen Flow Rate' THEN respchartvalue
--   ELSE NULL END) AS OXYGEN_FLOW__L_
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Peak Flow' THEN respchartvalue
--   ELSE NULL END) AS PEAK_FLOW
, max(CASE
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Peak Insp. Pressure' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Peak Pressure' THEN respchartvalue
  ELSE NULL END) AS PEAK_PRESSURE
, max(CASE
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'PEEP' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'PEEP/CPAP' THEN respchartvalue
  ELSE NULL END) AS PEEP
, max(CASE
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Plateau Pressure' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Plateau Pressure' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Plateau Pressure' THEN respchartvalue
  ELSE NULL END) AS PLATEAU_PRESSURE
, max(CASE
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Pressure Control' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Pressure Support' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'PS' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'PS above PEEP' THEN respchartvalue
  ELSE NULL END) AS PS
-- , max(CASE
--   WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = '3. PaO2/FiO2 Ratio' THEN respchartvalue
-- ELSE NULL END) AS P_F_RATIO
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'WUA Patient Response/RASS Score' THEN respchartvalue
--   ELSE NULL END) AS RASS_score
, max(CASE
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Vent Rate' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Setting Set RR' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Setting Set RR' THEN respchartvalue
  ELSE NULL END) AS RESP_RATE_SET
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent Spont Rate' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'RR (patient)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'RR Spont' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Spontaneous Respiratory Rate' THEN respchartvalue
  ELSE NULL END) AS RESP_RATE_SPONT
, max(CASE
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Total RR' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'f Total' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Resp Rate Total' THEN respchartvalue
  ELSE NULL END) AS RESP_RATE_TOTAL
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Total RSBI' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = '4. RSBI (RR/Vt)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Rapid Shallow Breathing Index' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'RSBI' THEN respchartvalue
  ELSE NULL END) AS RSBI
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'SET INSP TIME' THEN respchartvalue
--   ELSE NULL END) AS SET_INSP_TIME
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent SpO2' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Pt/Vent SpO2_5' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'PULSE OX RESULTS VT' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'SaO2' THEN respchartvalue
  ELSE NULL END) AS SpO2
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Reason SBT Terminated' THEN respchartvalue
--   ELSE NULL END) AS Reason_SBT_Termited
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'SBT Method' THEN respchartvalue
--   ELSE NULL END) AS SBT_METHOD
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Wake up assessment interventions' THEN respchartvalue
--   ELSE NULL END) AS Wake_up_assessment_interventions
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Wake up assessment outcome' THEN respchartvalue
--   ELSE NULL END) AS Wake_up_assessment_outcome
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Wake up assessment performed' THEN respchartvalue
--   ELSE NULL END) AS Wake_up_assessment_performed
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Weaning Negative Inspiratory Force' THEN respchartvalue
--   ELSE NULL END) AS Weaning_Negative_Inspiratory_Force
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Weaning Performed' THEN respchartvalue
--   ELSE NULL END) AS Weaning_Performed
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Weaning Respiratory Rate' THEN respchartvalue
--   ELSE NULL END) AS Weaning_Respiratory_Rate
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Weaning Start Time' THEN respchartvalue
--   ELSE NULL END) AS Weaning_Start_Time
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Weaning Vital Capacity' THEN respchartvalue
--   ELSE NULL END) AS Weaning_Vital_Capacity__L_

-- , max(CASE
--   WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'TV/kg IBW' THEN respchartvalue
-- ELSE NULL END) AS TV_kg_IBW
-- , max(CASE
--     WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'A1: High Exhaled Vt' THEN respchartvalue
--   ELSE NULL END) AS tidal_volume_alarm
, max(CASE
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Exhaled TV (machine)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'Exhaled TV (patient)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Exhaled Vt' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Tidal Volume Observed (VT)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Tidal Volume (sigh)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Vti' THEN respchartvalue
  ELSE NULL END) AS tidal_volume_observed
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Pt/Vent InspiratorTV' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Setting Set Vt' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowSettings' AND respchartvaluelabel = 'Tidal Volume (set)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Tidal Volume, Delivered' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Set Vt (Servo,LTV)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Set Vt (Drager)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowPtVentData' AND respchartvaluelabel = 'SBT VT' THEN respchartvalue
  ELSE NULL END) AS tidal_volume_set
, max(CASE
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Vt Spontaneous (mL)' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'NIV Pt/Vent Spont_TidalV' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Adult Con Setting Spont Exp Vt' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Spont TV' THEN respchartvalue
    WHEN respcharttypecat = 'respFlowCareData' AND respchartvaluelabel = 'Tidal Volume, Spontaneous' THEN respchartvalue
  ELSE NULL END) AS tidal_volume_spontaneous
from respiratorycharting rc
inner join patient pt on rc.patientunitstayid = pt.patientunitstayid
where rc.respchartvalue is not null
and pt.hospitalid = 243
group by rc.patientunitstayid, respchartoffset, respchartentryoffset
order by patientunitstayid, chartoffset, entryoffset;
