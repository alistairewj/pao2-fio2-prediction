DROP TABLE IF EXISTS rc_map;
CREATE TABLE rc_map AS
select
  rc.grp, rc.new_label, d.respchartvaluelabel, d.respcharttypecat
from d_respiratorycharting d
left join rc_manually_labelled rc
  on d.respchartvaluelabel = rc.respchartvaluelabel
  and d.respcharttypecat = rc.respcharttypecat
order by rc.new_label, d.respchartvaluelabel;
