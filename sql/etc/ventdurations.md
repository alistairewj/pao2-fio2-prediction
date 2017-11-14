You may need to rename the empty column name "blank" in the raw data, if you update the files.

Run the following replacements in Atom:

* `      when \(respchartvaluelabel = '(Site-Airway|Cuff Pressure-Airway|Airway Type-Airway|Size-Airway)( [0-9]+/[0-9]+/[0-9][0-9])?( [0-9][0-9][0-9][0-9])?[ ]+(oral;endotracheal tube|oral|endotracheal tube|tracheostomy)([A-z0-9;,. -]*)'\) then 1\n`

Then add the following regular expression check to the ventsettings table under 'respFlowCareData'

`when respchartvaluelabel ~* '(Site-Airway|Cuff Pressure-Airway|Airway Type-Airway|Size-Airway)( [0-9]+/[0-9]+/[0-9][0-9])?( [0-9][0-9][0-9][0-9])?[ ]+(oral;endotracheal tube|oral|endotracheal tube|tracheostomy)([A-z0-9;,. -]*)' then 1`



# Custom rules

Generate tables for modes // admin devices

```
\copy (select nursingchartcelltypecat, nursingchartcelltypevallabel, nursingchartcelltypevalname, nursingchartvalue, count(*) as numobs from nursecharting where nursingchartcelltypevallabel in ('Vent Mode','Ventilator Mode','Mode of Delivery','A1. Vent: Mode/Rate','A1: Vent: Mode/Rate','VENT MODE','VENT: Mode') group by nursingchartcelltypecat, nursingchartcelltypevallabel, nursingchartcelltypevalname, nursingchartvalue order by nursingchartcelltypevallabel, nursingchartcelltypevalname, numobs DESC ) to 'nurseventmode.csv' CSV HEADER;

\copy (select respcharttypecat, respchartvaluelabel, respchartvalue, count(*) as numobs from respiratorycharting where respchartvaluelabel = 'O2 Admin Device' group by respcharttypecat, respchartvaluelabel, respchartvalue order by numobs desc) to 'o2admindevice.csv' CSV HEADER;

\copy (select respcharttypecat, respchartvaluelabel, respchartvalue, count(*) as numobs from respiratorycharting where respchartvaluelabel = 'Mode of Ventilation' group by respcharttypecat, respchartvaluelabel, respchartvalue order by numobs desc) to 'ventmode.csv' CSV HEADER;

```

These tables were annotated and are now loaded in by the notebook for the generation of vent-settings.sql.

# Rules we could build

## nurseventmode.csv

A1. Vent: Mode/Rate

* CPAP alone == NIV
* SIMV == MV
* CPAP/PSV == NIV
* AC##/PC## == MV
* PC##/RR## == MV
* Pressure Control / Rate == MV

Mode of Delivery
-> all NIV

Ventilator Mode
