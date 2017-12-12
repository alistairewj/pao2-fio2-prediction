-- This query extracts end of life details for patients

DROP MATERIALIZED VIEW IF EXISTS endoflife CASCADE;
CREATE MATERIALIZED VIEW endoflife AS
WITH status AS (
    SELECT c.patientunitstayid, c.activeupondischarge, c.cplgeneralid, 
           c.cplitemyear, c.cplitemtime24, c.cplitemtime, c.cplitemoffset, 
           c.cplgroup, c.cplitemvalue,
           CASE WHEN c.cplitemvalue LIKE 'Do not resuscitate%' THEN c.cplitemoffset
               ELSE NULL END AS dnr_offset,
           CASE WHEN c.cplitemvalue LIKE 'Comfort measures only%' THEN c.cplitemoffset
               ELSE NULL END AS cmo_offset,
           CASE WHEN c.cplitemvalue LIKE 'End of life%' THEN c.cplitemoffset
               ELSE NULL END AS endoflife_offset,
           CASE WHEN c.cplitemvalue LIKE 'Terminal%' THEN c.cplitemoffset
               ELSE NULL END AS terminal_offset,
           CASE WHEN c.cplitemvalue LIKE 'Wears glasses%' THEN 'yeah'
               ELSE '' END AS wears_glasses
    FROM careplangeneral c
    WHERE c.cplitemvalue LIKE 'Do not resuscitate%'
        OR c.cplitemvalue LIKE 'Comfort measures only%'
        OR c.cplitemvalue LIKE 'End of life%'
        OR c.cplitemvalue LIKE 'Terminal%'
        OR c.cplitemvalue LIKE 'Wears glasses%'
  )
SELECT s.patientunitstayid, s.dnr_offset, s.cmo_offset, s.endoflife_offset, 
       s.terminal_offset, s.wears_glasses
FROM status s;