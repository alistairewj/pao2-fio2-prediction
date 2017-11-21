DROP TABLE IF EXISTS rc_manually_labelled;
CREATE TABLE rc_manually_labelled
(
  respchartvaluelabel varchar(255) not null,
  respcharttypecat varchar(100) not null,
  n_obs int,
  n_pat int,
  n_obs_per_pat numeric,
  n_distinct_obs int,
  string_mode text,
  numeric_obs_percent numeric,
  value_p05 numeric,
  value_p50 numeric,
  value_p95 numeric,
  grp varchar(100),
  new_label varchar(255),
  addition numeric,
  multiplication numeric
);

\copy rc_manually_labelled from 'respiratorycharting_labelled.csv' CSV HEADER;
