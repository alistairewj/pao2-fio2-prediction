DROP TABLE IF EXISTS pf_pao2fio2;
CREATE TABLE pf_pao2fio2 AS
select lab.patientunitstayid
  , labresultoffset
  , min(case when labname = 'paO2' then labresult else null end) as PaO2
  , min(case when labname = 'FiO2' then labresult else null end) as FiO2
from lab
where labname in ('paO2','FiO2')
group by lab.patientunitstayid, labresultoffset;
