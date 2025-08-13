--this query has defined level 3 employee
SELECT ra.id,
       ra.rep_id,
       ra.name,
       ra.rep_category,
       ra.area_id,
       ra.area_name,
       ra.created_on,
       ra.created_by,
       ra.updated_on,
       ra.updated_by,
       ra.orc_insert_date,
       ra.cid
  FROM rep_area ra;

--this query define level 0, 1, 2 employe
SELECT sa.id,
       sa.sup_id,
       sa.name,
       sa.area_id,
       sa.area_name,
       sa.level_depth_no,
       sa.created_on,
       sa.created_by,
       sa.updated_on,
       sa.updated_by,
       sa.orc_insert_date,
       sa.cid
  FROM sup_area sa;

--area structure showed level wise 
SELECT ar.ID,
       ar.AREA_ID,
       ar.AREA_NAME,
       ar.PARENT_LEVEL_ID,
       ar.PARENT_LEVEL_NAME,
       ar.LEVEL0_ID,
       ar.LEVEL0_NAME,
       ar.LEVEL1_ID,
       ar.LEVEL1_NAME,
       ar.LEVEL2_ID,
       ar.LEVEL2_NAME,
       ar.LEVEL3_ID,
       ar.LEVEL3_NAME,
       ar.CREATED_ON,
       ar.CREATED_BY,
       ar.UPDATED_ON,
       ar.UPDATED_BY,
       ar.ORC_INSERT_DATE,
       ar.CID,
       ar.DEPTH,
       ar.IS_LEAF,
       ar.SPECIAL_TERRITORY_CODE
  FROM area_structure ar;