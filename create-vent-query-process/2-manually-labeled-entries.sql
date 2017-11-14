DROP TABLE IF EXISTS rc_manually_labelled;
CREATE TABLE rc_manually_labelled
(
  respchartvaluelabel varchar(255) not null,
  respcharttypecat varchar(100) not null,
  grp varchar(100),
  new_label varchar(255),
  addition numeric,
  multiplication numeric
);

\copy rc_manually_labelled from 'respiratorycharting_labelled.csv' CSV HEADER;
