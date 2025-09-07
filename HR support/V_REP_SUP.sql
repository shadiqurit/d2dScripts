/* Formatted on 9/2/2025 9:30:51 AM (QP5 v5.362) */
CREATE OR REPLACE FORCE VIEW V_REP_SUP
AS
    SELECT id,
           rep_id,
           name,
           area_id,
           area_name
      FROM rep_area ra
     WHERE AREA_ID <> 'DEMO'
    UNION ALL
    SELECT id,
           sup_id,
           name,
           area_id,
           area_name
      FROM sup_area sa
     WHERE AREA_ID <> 'DEMO';