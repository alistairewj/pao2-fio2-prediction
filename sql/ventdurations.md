You may need to rename the empty column name "blank" in the raw data, if you update the files.

Run the following replacements in Atom:

* `      when \(respchartvaluelabel = '(Site-Airway|Cuff Pressure-Airway|Airway Type-Airway|Size-Airway)( [0-9]+/[0-9]+/[0-9][0-9])?( [0-9][0-9][0-9][0-9])?[ ]+(oral;endotracheal tube|oral|endotracheal tube|tracheostomy)([A-z0-9;,. -]*)'\) then 1\n`

Then add the following regular expression check to the ventsettings table under 'respFlowCareData'

`when respchartvaluelabel ~* '(Site-Airway|Cuff Pressure-Airway|Airway Type-Airway|Size-Airway)( [0-9]+/[0-9]+/[0-9][0-9])?( [0-9][0-9][0-9][0-9])?[ ]+(oral;endotracheal tube|oral|endotracheal tube|tracheostomy)([A-z0-9;,. -]*)' then 1`
