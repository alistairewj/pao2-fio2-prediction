from __future__ import print_function

import pandas as pd
import numpy as np
import psycopg2
import getpass
import os
import socket

# limit to a single hospital
HOSPITAL = 458

def conn_to_db():
    # connection info
    hostname=socket.gethostname()

    if (hostname=='alistair-pc70') | (hostname=='mit-lcps-MacBook-Pro.local'):
        sqluser = 'alistairewj'
    else:
        sqluser = 'postgres'
    sqlport = 5647
    sqlhost = 'localhost'

    dbname = 'eicu'

    # Connect to postgres
    if sqluser == 'alistairewj':
        con = psycopg2.connect(dbname=dbname, user=sqluser, port=sqlport, host=sqlhost)
    else:
        # prompt for password
        print('Username: {}'.format(sqluser))
        con = psycopg2.connect(dbname=dbname, user=sqluser, port=sqlport, host=sqlhost, password=getpass.getpass('Password: '))

    return con

# create a query which uses the above
def print_query(df,col,col_other,tbl='nc'):
    query = '\n'
    if tbl == 'nc':
        catname = 'nursingchartcelltypecat'
        lblname = 'nursingchartcelltypevallabel'
        valname = 'nursingchartcelltypevalname'
        value   = None
    elif tbl == 'ncv':
        catname = 'nursingchartcelltypecat'
        lblname = 'nursingchartcelltypevallabel'
        valname = 'nursingchartcelltypevalname'
        value   = 'nursingchartvalue'
    elif tbl == 'rc':
        catname = 'respcharttypecat'
        lblname = 'respchartvaluelabel'
        valname = None
        value   = None
    elif tbl == 'rcv':
        catname = 'respcharttypecat'
        lblname = 'respchartvaluelabel'
        valname = None
        value   = 'respchartvalue'


    curr_category = ''
    for row in df.sort_values(catname,axis=0).iterrows():
        r = row[1]

        # only include those for sure mechanical ventilation
        if r[col] != 1:
            continue

        # if any other flags are 1, skip
        if any(r[col_other].values == 1):
            continue

        # if any other flags are 2, skip
        if any(r[col_other].values == 2):
            continue

        # check if this is a new category
        if r[catname] != curr_category:
            if curr_category != '':
                # end the previous case
                query += '    else 0 end\n'

            curr_category = r[catname]
            query += "  when " + catname + " = '" + curr_category + "' then \n    case\n"

        query += "      when (" + lblname + " = '" + r[lblname].replace("'","''") + "'"
        # add another condition if valname is not empty
        if valname:
            query += " and " + valname + " = '" + r[valname].replace("'","''") + "'"

        # add another condition if value is not empty
        if value:
            query += " and " + value + " = '" + r[value].replace("'","''") + "'"

        query += ") then 1\n"

    query += '  else 0 end\n'
    return query


if __name__ == '__main__':
    # get the examine vent setting table
    con = conn_to_db()

    schema_name = 'eicu_crd_phi'
    query_schema = 'SET search_path to public,' + schema_name + ';'

    df_resp = pd.read_sql_query(query_schema + "select respcharttypecat, respchartvaluelabel, new_label from rc_map", con)

    # drop rows with no new label
    idxNull = df_resp['new_label'].isnull()
    print('Dropping {} of {} rows which have not been classified.'.format(np.sum(idxNull), df_resp.shape[0]))
    df_resp = df_resp.loc[~idxNull, :]

    # modify label to make it a valid column name
    df_resp['new_label'] = df_resp['new_label'].map(lambda x: x.replace(' ','_').replace('(','_').replace(')','_'))
    df_resp['new_label'] = df_resp['new_label'].map(lambda x: x.replace('/','_').replace('-','_').replace('\\','_'))
    df_resp['new_label'] = df_resp['new_label'].map(lambda x: x.replace(':','_'))

    # sort df_resp by reclassification
    df_resp.sort_values('new_label', ascending=True, inplace=True)

    # create the query
    query = query_schema
    query += "\nselect rc.patientunitstayid, respchartoffset as chartoffset, respchartentryoffset as entryoffset"
    query += "\n-- case statement for creating a column with only one type of value"

    new_columns = df_resp['new_label'].unique()

    cols = ["respcharttypecat", "respchartvaluelabel"]
    value_col = "respchartvalue"
    query += "\n, max(CASE"
    for i, row in df_resp.iterrows():
        if i>0:
            if new_label != row['new_label']:
                # it's a new concept
                query += "\n  ELSE NULL END) AS " + new_label.replace(' ','_')
                # check if row is over
                query += "\n, max(CASE"

        # update new_label to match current row
        new_label = row['new_label']

        query += "\n    WHEN "

        # create the "AND" statements
        # e.g. respcharttypecat = 'respFlowCareData' AND respchartvaluelabel ...
        for n, c in enumerate(cols):
            if n>0:
                query += " AND "
            query += c + " = '" + row[c].replace("'","''") + "'"
        query += " THEN " + value_col

    # end the final case statement
    query += "\n  ELSE NULL END) AS " + new_label.replace(' ','_')

    query += "\nfrom respiratorycharting rc"
    query += "\ninner join patient pt on rc.patientunitstayid = pt.patientunitstayid"
    query += "\nwhere rc.respchartvalue is not null"
    query += "\nand pt.hospitalid = {}".format(HOSPITAL)
    query += "\ngroup by rc.patientunitstayid, respchartoffset, respchartentryoffset"
    query += ";"

    with open('vent-query.sql','w') as fp:
        fp.write(query)

    # finally, create the ventdurations table
    QUERY_TODO = """
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
        , SelfExtubated
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
          , SelfExtubated

          -- if this is a mechanical ventilation event, we calculate the time since the last event
          , case
              -- if the current observation indicates mechanical ventilation is present
              -- calculate the time since the last vent event
              when MechVent=1 then
                chartoffset - chartoffset_lag
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
              -- if patient has initiated oxygen therapy, and is not currently vented, start a newvent
              when MechVent = 0 and OxygenTherapy = 1 then 1
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

    """
