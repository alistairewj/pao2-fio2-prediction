DROP TABLE IF EXISTS ventsettings CASCADE;
CREATE TABLE ventsettings AS
select
  patientunitstayid, nursingchartoffset as chartoffset
  -- case statement determining whether it is an instance of mech vent
  , max( case

  when nursingchartcelltypecat = 'Invasive' then
    case
      when (nursingchartcelltypevallabel = 'PA' and nursingchartcelltypevalname = 'PA Systolic') then 1
    else 0 end
  when nursingchartcelltypecat = 'Other Vital Signs and Infusions' then
    case
      when (nursingchartcelltypevallabel = 'Sputum Characteristics' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Minute Ventilation Total (L/min)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RASS' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Peak Airway Pressure' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Pasero Opioid-Induced Sedation Scale (POSS)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Sputum Amount' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Sputum Color' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Sputum Consistency' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'A4: PEEP/PSV' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RLL Anterior' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Richmond Agitation Sedation Scale (RASS)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Oral Care' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Weaning Start Time' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Plateau Pressure' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Tidal Volume Set' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Mode of Delivery' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RASS Sedation Scale' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'BMI Ranking' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Mechanically Ventilated (Nutrition)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Weaning Mode' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Rate Set' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Apnea (secs)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Vt exhaled' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Plateau Pressure (cm H2O)' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'SBT Method' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RASS: Richmond Agitation-Sedation Scale' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RASS Assessment' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Sedation Level' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Minute Volume' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Resp Rate Low Alarm' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Resp Rate High Alarm' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'HOB> 30 Degrees' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'VAP Prevention' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Rate Total' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Daily Assessment of Readiness to Wean' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Peak Inspiratory Pressure' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'RASS Score' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Trigger/Sensitivity' and nursingchartcelltypevalname = 'Value') then 1
    else 0 end
  when nursingchartcelltypecat = 'Vital Signs' then
    case
      when (nursingchartcelltypevallabel = 'End Tidal CO2' and nursingchartcelltypevalname = 'End Tidal CO2') then 1
    else 0 end
  when nursingchartcelltypecat = 'Vital Signs and Infusions' then
    case
      when (nursingchartcelltypevallabel = 'Oral Care' and nursingchartcelltypevalname = 'Oral Care') then 1
      when (nursingchartcelltypevallabel = 'HOB > 30°' and nursingchartcelltypevalname = 'HOB > 30°') then 1
  else 0 end

  when nursingchartcelltypecat = 'Other Vital Signs and Infusions' then
    case
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PRVC/AC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'A/C;VC+') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC/AC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'VC/AC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC;A/C') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'A/C;PC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PCV') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV + PS') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'VC;A/C') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV/PRVC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'A/C - VC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV/VC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SBT') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'VC+') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'A/C;VC') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'Pressure release volume control') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'APRV') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'ACV') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'CMV') then 1
      when (nursingchartcelltypevallabel = 'Vent Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'VC+;A/C') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC/CMV Volume') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV Volume') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'APV CMV') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'Bi-Level/DuoPAP/APRV') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'A/C (Assist/Control Ventilation)') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'HFOV') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV Pressure') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PRVC (Pressure Regulated Volume Control)') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC Pressure') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'APV SIMV') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'Other: PCV+') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC/CMV Volume, Other:') then 1
      when (nursingchartcelltypevallabel = 'Ventilator Mode' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV / IMV (Intermittent Mandatory Ventilation)') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SBT') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC 28/PC 24') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC 20/18') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC 21/RR 28') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC 12/Rate 22') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV 20') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC 18/ AC 22') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV12') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC16/PC18') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC12/AC10') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC 22/PC 12') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC20/AC20') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'RATE 18    PC 20') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC/15-AC/22') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC26/PC12') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC 20/PC 24') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC 25/ PC 26') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC 20 /PC 15 ') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC 30 / AC 28') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC20 AC24') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'PC20/AC10') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'Bilevel') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'AC26/PC18') then 1
      when (nursingchartcelltypevallabel = 'A1: Vent: Mode/Rate' and nursingchartcelltypevalname = 'Value' and nursingchartvalue = 'SIMV 12') then 1
  else 0 end
else 0 end) as MechVent
    -- oxygen therapy
    , max( case

  when nursingchartcelltypecat = 'Other Vital Signs and Infusions' then
    case
      when (nursingchartcelltypevallabel = 'O2 Device' and nursingchartcelltypevalname = 'Value') then 1
      when (nursingchartcelltypevallabel = 'Treatment (Inhaler)' and nursingchartcelltypevalname = 'Value') then 1
  else 0 end
else 0 end) as OxygenTherapy
  , 0 as Extubated

from nursecharting nc
where nc.nursingchartvalue is not null
group by patientunitstayid, nursingchartoffset

UNION
select
  patientunitstayid, respchartoffset as chartoffset
  -- case statement determining whether it is an instance of mech vent
  , max( case

  when respcharttypecat = 'respFlowCareData' then
    case
      when (respchartvaluelabel = 'post bs') then 1
      when (respchartvaluelabel = 'INO') then 1
      when (respchartvaluelabel = 'Wake up assessment status') then 1
      when (respchartvaluelabel = 'VS MODE OF RESP') then 1
      when (respchartvaluelabel = 'VS PLATEAU') then 1
      when (respchartvaluelabel = 'OETT/ROTATION') then 1
      when (respchartvaluelabel = 'Tube Rotation') then 1
      when (respchartvaluelabel = 'Bi-Vent I:E') then 1
      when (respchartvaluelabel = 'Pre HR') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Set RR_') then 1
      when (respchartvaluelabel = 'Pre BS') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Insertion Time') then 1
      when (respchartvaluelabel = 'post hr') then 1
      when (respchartvaluelabel = 'Cuff check') then 1
      when (respchartvaluelabel = 'POST HR') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting PS above P High') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting T PEEP (sec)') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Heliox_4') then 1
      when (respchartvaluelabel = 'etco2') then 1
      when (respchartvaluelabel = 'EtCO2') then 1
      when (respchartvaluelabel = 'OETT Rotation') then 1
      when (respchartvaluelabel = 'Bi-Vent Alarm Hi Press Alarm_4') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting INO_4') then 1
      when (respchartvaluelabel = 'Peak Flow Zone') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent Nitric Oxide') then 1
      when (respchartvaluelabel = 'Peak Expiratory Flow Volume') then 1
      when (respchartvaluelabel = 'Ventilator Heater Setting') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Circuit T_4') then 1
      when (respchartvaluelabel = 'ETT position') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Moved') then 1
      when (respchartvaluelabel = 'HR Post') then 1
      when (respchartvaluelabel = 'BS Post') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Set I:E_') then 1
      when (respchartvaluelabel = 'OETT rotation') then 1
      when (respchartvaluelabel = 'Bi-Vent Pt/Vent ETCO2_4') then 1
      when (respchartvaluelabel = 'EtCo2') then 1
      when (respchartvaluelabel = 'ETT ROTATION') then 1
      when (respchartvaluelabel = 'etCo2') then 1
      when (respchartvaluelabel = 'ET tube') then 1
      when (respchartvaluelabel = 'Weaning Duration') then 1
      when (respchartvaluelabel = 'ET Tube') then 1
      when (respchartvaluelabel = 'HR Pre') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting T High (sec)') then 1
      when (respchartvaluelabel = 'HR PRE') then 1
      when (respchartvaluelabel = 'PS above P High') then 1
      when (respchartvaluelabel = 'Sigh') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Placement Checked') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator Mode') then 1
      when (respchartvaluelabel = 'Minute Volume, Spontaneous') then 1
      when (respchartvaluelabel = 'Weaning SBT Readiness Add''l Info') then 1
      when (respchartvaluelabel = 'Secured at-ETT') then 1
      when (respchartvaluelabel = 'HOB Elevated 30-45 Degrees at All Times') then 1
      when (respchartvaluelabel = 'Endotracheal Position at Lip') then 1
      when (respchartvaluelabel = 'Oral Care Complete Every 2 Hours') then 1
      when (respchartvaluelabel = 'Ventilator Heater Temperature') then 1
      when (respchartvaluelabel = 'Rise T') then 1
      when (respchartvaluelabel = 'Type-ETT') then 1
      when (respchartvaluelabel = 'ETT Peptic Ulcer Prophylaxis') then 1
      when (respchartvaluelabel = 'Auto Release') then 1
      when (respchartvaluelabel = 'Set Vt (Drager)') then 1
      when (respchartvaluelabel = 'Ventilator set up date') then 1
      when (respchartvaluelabel = 'Wake up assessment performed') then 1
      when (respchartvaluelabel = 'Weaning Respiratory Rate') then 1
      when (respchartvaluelabel = 'Automatic Tube Compensation') then 1
      when (respchartvaluelabel = 'Inspiratory Flow Rate') then 1
      when (respchartvaluelabel = 'Mechanical Ventilation Slope') then 1
      when (respchartvaluelabel = 'Minute Volume Leak') then 1
      when (respchartvaluelabel = 'Heat Moisture Exchanger') then 1
      when (respchartvaluelabel = 'Set Vt (Servo,LTV)') then 1
      when (respchartvaluelabel = 'Reason SBT Terminated') then 1
      when (respchartvaluelabel = 'Weaning Assessment Criteria Collaboration') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Moved to') then 1
      when (respchartvaluelabel = 'CCU Ventilator Weaning Protocol Started') then 1
      when (respchartvaluelabel = 'Additional ET Tube Comments') then 1
      when (respchartvaluelabel = 'End Tidal CO2 Status') then 1
      when (respchartvaluelabel = 'AIRWAY TEMPERATURE') then 1
      when (respchartvaluelabel = 'Sedation Wean') then 1
      when (respchartvaluelabel = 'Tidal Volume, Spontaneous') then 1
      when (respchartvaluelabel = 'Adult Con Alarms Backup I:E') then 1
      when (respchartvaluelabel = 'Sedation Scoring Ventilation Depth') then 1
      when (respchartvaluelabel = 'PD I:E RATIO') then 1
      when (respchartvaluelabel = 'Weaning Minute Volume') then 1
      when (respchartvaluelabel = 'Unable to Obtain PEEPi and Vtrap') then 1
      when (respchartvaluelabel = 'Insp Time (%)') then 1
      when (respchartvaluelabel = 'Trapped Volume') then 1
      when (respchartvaluelabel = 'Adult Con Setting Heliox_') then 1
      when (respchartvaluelabel = 'Adult Con Setting INO') then 1
      when (respchartvaluelabel = 'ETT Sedation Vacation') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent ETCO2_') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent ETCO2') then 1
      when (respchartvaluelabel = 'Wake up assessment outcome') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator Resistance') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator Compliance') then 1
      when (respchartvaluelabel = 'Weaning Performed') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Spont Exp Vt_4') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent IBW in Kg') then 1
      when (respchartvaluelabel = 'Head of Bed Elevated') then 1
      when (respchartvaluelabel = 'Mean Airway Pressure') then 1
      when (respchartvaluelabel = 'ETT Rotation') then 1
      when (respchartvaluelabel = 'Head of Bed Elevation') then 1
      when (respchartvaluelabel = 'Plateau Pressure') then 1
      when (respchartvaluelabel = 'Total RSBI') then 1
      when (respchartvaluelabel = 'SBT Method') then 1
      when (respchartvaluelabel = 'Minute Ventilation Set(L/min)') then 1
      when (respchartvaluelabel = 'Secured at-ETT') then 1
      when (respchartvaluelabel = 'Adult Con Setting Set I:E') then 1
      when (respchartvaluelabel = 'Inspiratory Pressure, Set') then 1
      when (respchartvaluelabel = 'Sputum Amount') then 1
      when (respchartvaluelabel = 'Adult Con Alarms Circuit T (Celsius)') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator ID Number') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator High Tidal Volume Alarm') then 1
      when (respchartvaluelabel = 'Tube Size-ETT') then 1
      when (respchartvaluelabel = 'Insp Cycle Off (%)') then 1
      when (respchartvaluelabel = 'Sputum Color') then 1
      when (respchartvaluelabel = 'Sedation outcome') then 1
      when (respchartvaluelabel = 'Insp Flow (l/min)') then 1
      when (respchartvaluelabel = 'Wake up assessment interventions') then 1
      when (respchartvaluelabel = 'Spont TV') then 1
      when (respchartvaluelabel = 'Tidal Volume, Delivered') then 1
      when (respchartvaluelabel = 'Adult Con Setting Sensitivity') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent Spont Rate') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent MinuteVentil') then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent InspiratorTV') then 1
      when (respchartvaluelabel = 'WUA Patient Response/RASS Score') then 1
      when (respchartvaluelabel = 'Weaning Start Time') then 1
      when (respchartvaluelabel = 'Cough Description') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Placement') then 1
      when (respchartvaluelabel = 'Sputum Consistency') then 1
      when (respchartvaluelabel = 'T Peep') then 1
      when (respchartvaluelabel = 'Weaning Negative Inspiratory Force') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting P High_') then 1
      when (respchartvaluelabel = 'Bi-Vent Alarm Hi Press Alarm_4') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Sensitivity_') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Set I:E_') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Set RR_') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting T High (sec)') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting T PEEP (sec)') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting PS above P High') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting PS above PEEP') then 1
      when (respchartvaluelabel = 'Time Low, Bi-Level') then 1
      when (respchartvaluelabel = 'Pulse Oximetry/End Tidal CO2 Comments') then 1
      when (respchartvaluelabel = 'Set Pressure Control') then 1
      when (respchartvaluelabel = 'Bi-Vent Pt/Vent SpO2_4') then 1
      when (respchartvaluelabel = 'EtC02') then 1
      when (respchartvaluelabel = 'Minute Volume, Set') then 1
      when (respchartvaluelabel = 'ETCO2') then 1
      when (respchartvaluelabel = 'M1:  Mouth Care') then 1
      when (respchartvaluelabel = 'post BS') then 1
      when (respchartvaluelabel = 'HR Pre') then 1
      when (respchartvaluelabel = 'PEEP Low, Bi-Level') then 1
      when (respchartvaluelabel = 'Bi-Vent RR') then 1
      when (respchartvaluelabel = 'Time High, Bi-Level') then 1
      when (respchartvaluelabel = 'ETT POSITION') then 1
      when (respchartvaluelabel = 'ETT rotation') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Measured At') then 1
      when (respchartvaluelabel = 'ETT DVT Prophylaxis') then 1
      when (respchartvaluelabel = 'Weaning Tidal Volume') then 1
      when (respchartvaluelabel = 'BS post') then 1
      when (respchartvaluelabel = 'Inspiratory Time %') then 1
      when (respchartvaluelabel = 'Weaning Vital Capacity') then 1
      when (respchartvaluelabel = 'MOUTH CARE') then 1
      when (respchartvaluelabel = 'Set Inspiratory Pressure') then 1
      when (respchartvaluelabel = 'VS TIDAL VOL') then 1
      when (respchartvaluelabel = 'HR post') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting Sensitivity_') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting PEEP Total') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Repositioned Per Order') then 1
      when (respchartvaluelabel = 'Mechanical Ventilator ID number') then 1
      when (respchartvaluelabel = 'ET Tube Repositioned') then 1
      when (respchartvaluelabel = 'CCU Ventilator Weaning Protocol Started') then 1
      when (respchartvaluelabel = 'Humidity') then 1
      when (respchartvaluelabel = 'Trigger') then 1
      when (respchartvaluelabel = 'Position at lip') then 1
      when (respchartvaluelabel = 'Backup Vent Active') then 1
      when (respchartvaluelabel = 'Suctioned patient') then 1
      when (respchartvaluelabel = 'Static Compliance') then 1
      when (respchartvaluelabel = 'ETT Insertion Date') then 1
      when (respchartvaluelabel = 'Ventilator Type') then 1
      when (respchartvaluelabel = 'Postion at Lip') then 1
      when (respchartvaluelabel = 'ETT Insertion time') then 1
      when (respchartvaluelabel = 'ETT Insertion date') then 1
      when (respchartvaluelabel = 'ETT Insertion date') then 1
      when (respchartvaluelabel = 'Peak Pressure') then 1
      when (respchartvaluelabel = 'Weaning Vital Capacity') then 1
      when (respchartvaluelabel = 'SET INSP TIME') then 1
      when (respchartvaluelabel = 'Chest Tube Insertion Status') then 1
      when (respchartvaluelabel = 'Weaning SBT Readiness Criteria') then 1
      when (respchartvaluelabel = 'Extubation Date') then 1
      when (respchartvaluelabel = 'Spontaneous Breathing Trial With Pressure Support') then 1
      when (respchartvaluelabel = 'End Tidal CO2 (mmHg)') then 1
      when (respchartvaluelabel = 'Weaning Trials Additional Comments') then 1
      when (respchartvaluelabel = 'Ventilator Checks') then 1
      when (respchartvaluelabel = 'ETT Insertion Time') then 1
      when (respchartvaluelabel = 'Ramp') then 1
      when (respchartvaluelabel = 'Pause Time') then 1
      when (respchartvaluelabel = 'Pretx HR') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting P High_') then 1
      when (respchartvaluelabel = 'Post HR') then 1
      when (respchartvaluelabel = 'Flow-by Sensitivity') then 1
      when (respchartvaluelabel = 'Endotracheal Tube Moved To') then 1
      when (respchartvaluelabel = 'Negative Inspiratory Force') then 1
      when (respchartvaluelabel = 'Post BS') then 1
      when (respchartvaluelabel = 'Rapid Shallow Breathing Index') then 1
      when (respchartvaluelabel = 'Suctioned per') then 1
    else 0 end
  when respcharttypecat = 'respFlowPtVentData' then
    case
      when (respchartvaluelabel = 'Post BS') then 1
      when (respchartvaluelabel = 'BS PRE') then 1
      when (respchartvaluelabel = 'BS Pre') then 1
      when (respchartvaluelabel = 'B/S pre') then 1
      when (respchartvaluelabel = 'EtCo2') then 1
      when (respchartvaluelabel = 'Post  HR') then 1
      when (respchartvaluelabel = 'A1: High exhaled VT') then 1
      when (respchartvaluelabel = 'Pre Breath Sounds') then 1
      when (respchartvaluelabel = 'SBT RR') then 1
      when (respchartvaluelabel = 'EtC02') then 1
      when (respchartvaluelabel = 'WP-VC') then 1
      when (respchartvaluelabel = 'WP-RSBI') then 1
      when (respchartvaluelabel = 'WP-MV') then 1
      when (respchartvaluelabel = 'SBT VT') then 1
      when (respchartvaluelabel = 'SBT MV') then 1
      when (respchartvaluelabel = 'SBT-NIF') then 1
      when (respchartvaluelabel = 'SBT-RSBI') then 1
      when (respchartvaluelabel = 'NIF') then 1
      when (respchartvaluelabel = 'HR post') then 1
      when (respchartvaluelabel = 'ETCO2') then 1
      when (respchartvaluelabel = 'TC-VC') then 1
      when (respchartvaluelabel = 'TC-RR') then 1
      when (respchartvaluelabel = 'P/F ratio') then 1
      when (respchartvaluelabel = 'EST MV') then 1
      when (respchartvaluelabel = 'SBT VC') then 1
      when (respchartvaluelabel = 'RSBI') then 1
      when (respchartvaluelabel = 'EtCO2') then 1
      when (respchartvaluelabel = 'B3: EST MV') then 1
      when (respchartvaluelabel = 'A1: High Exhaled Vt') then 1
      when (respchartvaluelabel = 'TC NIF') then 1
      when (respchartvaluelabel = 'VC') then 1
      when (respchartvaluelabel = 'F4:  IBW') then 1
      when (respchartvaluelabel = 'TC RR') then 1
      when (respchartvaluelabel = 'pre hr') then 1
      when (respchartvaluelabel = 'Pre BS') then 1
      when (respchartvaluelabel = 'TC VT') then 1
      when (respchartvaluelabel = 'TC RSBI') then 1
      when (respchartvaluelabel = 'TC MV') then 1
      when (respchartvaluelabel = 'ETT Rotation') then 1
      when (respchartvaluelabel = 'SBT-Vt') then 1
      when (respchartvaluelabel = 'ETC02') then 1
      when (respchartvaluelabel = 'WP-VT') then 1
      when (respchartvaluelabel = 'WP-RR') then 1
      when (respchartvaluelabel = 'WP-NIF') then 1
      when (respchartvaluelabel = 'Pre HR') then 1
      when (respchartvaluelabel = 'pre BS') then 1
      when (respchartvaluelabel = 'Mean Airway Pressure') then 1
      when (respchartvaluelabel = 'Exhaled MV') then 1
      when (respchartvaluelabel = 'Plateau Pressure') then 1
      when (respchartvaluelabel = 'Exhaled TV (patient)') then 1
      when (respchartvaluelabel = 'Peak Insp. Pressure') then 1
      when (respchartvaluelabel = 'F6:  PaO2/FiO2 Ratio') then 1
      when (respchartvaluelabel = 'SBT-MV') then 1
      when (respchartvaluelabel = 'Exhaled TV (machine)') then 1
      when (respchartvaluelabel = 'Humidifier Temp') then 1
      when (respchartvaluelabel = 'Compliance') then 1
      when (respchartvaluelabel = 'MOUTH CARE') then 1
      when (respchartvaluelabel = 'TC - RR') then 1
      when (respchartvaluelabel = 'HR pre') then 1
      when (respchartvaluelabel = 'TC-RSBi') then 1
      when (respchartvaluelabel = 'BS pre') then 1
      when (respchartvaluelabel = 'P/F Ratio') then 1
      when (respchartvaluelabel = 'SBT-RR') then 1
      when (respchartvaluelabel = 'E. Sens.%') then 1
      when (respchartvaluelabel = 'PEAKFLOW WAVEFORM') then 1
      when (respchartvaluelabel = 'PEAK FLOW WAVEFORM') then 1
      when (respchartvaluelabel = 'etc02') then 1
      when (respchartvaluelabel = 'b/s') then 1
      when (respchartvaluelabel = 'TC VC') then 1
      when (respchartvaluelabel = 'TC - RSBI') then 1
      when (respchartvaluelabel = 'TC - VT') then 1
      when (respchartvaluelabel = 'TC - MV') then 1
      when (respchartvaluelabel = 'TC-VT') then 1
      when (respchartvaluelabel = 'TC-Nif') then 1
      when (respchartvaluelabel = 'TC-MV') then 1
      when (respchartvaluelabel = 'SBT-VC') then 1
      when (respchartvaluelabel = 'Auto PEEP') then 1
      when (respchartvaluelabel = 'Resistance') then 1
      when (respchartvaluelabel = 'pre HR') then 1
      when (respchartvaluelabel = 'E. Sens. %') then 1
      when (respchartvaluelabel = 'HR Pre') then 1
    else 0 end
  when respcharttypecat = 'respFlowSettings' then
    case
      when (respchartvaluelabel = 'TC/MV') then 1
      when (respchartvaluelabel = 'TC/VT') then 1
      when (respchartvaluelabel = 'TC/RR') then 1
      when (respchartvaluelabel = 'weaning vt') then 1
      when (respchartvaluelabel = 'Pressure to Trigger PS') then 1
      when (respchartvaluelabel = 'Peak Flow') then 1
      when (respchartvaluelabel = 'Flow Sensitivity') then 1
      when (respchartvaluelabel = 'I:E Ratio') then 1
      when (respchartvaluelabel = 'Vent Rate') then 1
      when (respchartvaluelabel = 'TV/kg IBW') then 1
      when (respchartvaluelabel = 'Tidal Volume (set)') then 1
      when (respchartvaluelabel = 'Pressure Control') then 1
      when (respchartvaluelabel = '1. PEEP High/Low') then 1
      when (respchartvaluelabel = 'Bi-Vent Setting PS above PEEP') then 1
      when (respchartvaluelabel = 'Sigh Rate') then 1
      when (respchartvaluelabel = 'NIF') then 1
      when (respchartvaluelabel = 'RSBI') then 1
      when (respchartvaluelabel = 'Tidal Volume (sigh)') then 1
      when (respchartvaluelabel = 'Sedation Scoring Ventilation Depth') then 1
      when (respchartvaluelabel = '3. PaO2/FiO2 Ratio') then 1
      when (respchartvaluelabel = 'TC/RSBI') then 1
      when (respchartvaluelabel = 'TC MV') then 1
      when (respchartvaluelabel = 'VC') then 1
      when (respchartvaluelabel = 'tcrsbi') then 1
      when (respchartvaluelabel = 'wp/vt') then 1
      when (respchartvaluelabel = 'wp/rsbi') then 1
      when (respchartvaluelabel = 'wp/rr') then 1
      when (respchartvaluelabel = 'wp/nif') then 1
      when (respchartvaluelabel = 'wp/mv') then 1
      when (respchartvaluelabel = 'TUBE POSITION') then 1
      when (respchartvaluelabel = 'tcvc') then 1
      when (respchartvaluelabel = 'weaning rr') then 1
      when (respchartvaluelabel = 'weaning mv') then 1
      when (respchartvaluelabel = 'rsbi') then 1
      when (respchartvaluelabel = 'nif') then 1
      when (respchartvaluelabel = 'tcnif') then 1
      when (respchartvaluelabel = 'PEEP HIGH') then 1
      when (respchartvaluelabel = 'TC VT') then 1
      when (respchartvaluelabel = 'TC RR') then 1
      when (respchartvaluelabel = 'I time') then 1
      when (respchartvaluelabel = 'ETCO2') then 1
      when (respchartvaluelabel = 'MV') then 1
      when (respchartvaluelabel = 'TC/NIF') then 1
      when (respchartvaluelabel = 'Est. VT') then 1
      when (respchartvaluelabel = 'ET-CO2') then 1
      when (respchartvaluelabel = 'AUTO FLOW') then 1
      when (respchartvaluelabel = 'TC/VC') then 1
      when (respchartvaluelabel = 'TC VC') then 1
      when (respchartvaluelabel = 'tcrr') then 1
      when (respchartvaluelabel = 'tcmv') then 1
      when (respchartvaluelabel = 'tcvt') then 1
  else 0 end

  when respcharttypecat = 'respFlowSettings' then
    case
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'P-CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Ac/Vc') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV;PRVC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'APRV/BILEVEL') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC A/C') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Assist control, Pressure support') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PCV+ Assist') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRESSURE REG VOL CTRL') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC;Assist control') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV, Pressure support, VC +') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC/VC+') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV (PRVC)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC+;AC;Auto-Flow') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC+;AC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Assist control, PCV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C - VC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV / IMV (Intermittent Mandatory Ventilation)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'APRV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = '(S)CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/TC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PCV+') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'CMV (Continuous Mandatory Ventilation)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'simv') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Pressure SIMV+PS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC;VC+') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC+;AC;Auto-Flow;Auto tube compensation') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC;PRVC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Volume SIMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'MMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/PC/PS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC;SIMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PC-APRV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'ac/vc') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SBT') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = '0.38') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Simv/prvc') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = '670') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C Pressure Control (Assist/Control, Pressure Control)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Volume control;AC;Auto-Flow') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Other: VC+') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'NIV/PS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Adaptive Pressure Ventilation Synchronized Intermittent Mechanical Ventilation (APV (SIMV))') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = '270') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SPN-CPAP/VS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C - PC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/PRVC (Pressure Regulated') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC/CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC;AC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC (Pressure Regulated Volume Control)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Other (Comment)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'NC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV Volume') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = '640') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC +') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC / VC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C Volume') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Synchronized Volume Controlled Mechanical Ventilation (S(CMV))') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV + PS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV, Pressure support') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'ASV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PCV-VG') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Pressure release volume control') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'simv/prvc') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C Volume Control (Assist/Control, Volume Control)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Assist Control or CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Adaptive Support Ventilation (ASV)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Pressure Controlled Mechanical Ventilation (P(CMV))') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC/PC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC/AC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV / IMV (Intermittent Manda') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV;Pressure support') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PC-AC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Cmv') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PCV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C (Assist/Control Ventilatio') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'prvc') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'AC/VC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C (Assist/Control Ventilation)') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Volume SIMV+PS') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/VC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'A/C Pressure') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/PRVC') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Adaptive Pressure Ventilation Controlled Mechanical Ventilation (APV (CMV))') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'SIMV/PRVC+PRESSURE SUPPORT') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'PRVC (Pressure Regulated Volum') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'Assist control, VC +') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'APV-CMV') then 1
      when (respchartvaluelabel = 'Mode of Ventilation' and respchartvalue = 'VC+') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'servoi') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'T piece, Trach collar') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'SERVO-I') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Ventilator, Other: Ecmo 100%') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Hiflnc') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Mask') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Trach collar, Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'ETT') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'T piece') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Mechanical ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'T-piece') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'vent') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Vent') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'VENT') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'iNO, Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'servo-i') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Nasal cannula, Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'CPAP, Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'servo') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'SERVO I VENT') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Other: HFOV') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'T-Piece') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Servo-i') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Transtracheal (TTO), Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Room air, Ventilator') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Ventilator, Other: ECMO') then 1
      when (respchartvaluelabel = 'O2 Admin Device' and respchartvalue = 'Ventilator, Other: ECMO 100%') then 1
  else 0 end
else 0 end) as MechVent
    -- oxygen therapy
    , max( case

  when respcharttypecat = 'respFlowCareData' then
    case
      when respchartvaluelabel ~* '(Site-Airway|Cuff Pressure-Airway|Airway Type-Airway|Size-Airway)( [0-9]+/[0-9]+/[0-9][0-9])?( [0-9][0-9][0-9][0-9])?[ ]+(oral;endotracheal tube|oral|endotracheal tube|tracheostomy)([A-z0-9;,. -]*)' then 1
      when (respchartvaluelabel = 'Adult Con Pt/Vent O2  flow') then 1
      when (respchartvaluelabel = 'Oxygen Delivery Comments') then 1
      when (respchartvaluelabel = 'Bag/Mask (attached to O2)') then 1
      when (respchartvaluelabel = 'RETIRED O2 Device') then 1
    else 0 end
  when respcharttypecat = 'respFlowPtVentData' then
    case
      when (respchartvaluelabel = 'Mask Size') then 1
      when (respchartvaluelabel = 'MASK') then 1
  else 0 end
else 0 end) as OxygenTherapy
  , 0 as Extubated

from respiratorycharting rc
where rc.respchartvalue is not null
group by patientunitstayid, respchartoffset;
