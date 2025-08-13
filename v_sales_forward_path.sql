/* Formatted on 8/13/2025 1:36:10 PM (QP5 v5.362) */
/*  EMPCODE,
    EMPCODE_MIO,
    TERI_CODE,
    EMPCODE_ASM,
    AREA_CODE,
    EMPCODE_RSM,
    REGION_CODE,
    LEVEL0_EMPCODE,
    LEVEL1_EMPCODE,
    LEVEL2_EMPCODE,
    LEVEL3_EMPCODE,
    UNIT,
    TERI_TYPE
    
 */



--CREATE OR REPLACE VIEW v_sales_forward_path
--AS

  SELECT ra.rep_id          EMPCODE,
         ra.name            AS rep_name,
         ra.area_id         AS terrytory_id,
         ar.LEVEL3_NAME     AS terrytory,
         --ar.LEVEL3_ID       AS terrytory_id,
         sa2.sup_id         AS EMPCODE_MIO,
         sa2.name           AS area_head,
         sa2.area_id        AS area_id,
         ar.LEVEL2_NAME     AS area_name,
         --   ar.LEVEL2_ID       AS area_id,
         sa1.sup_id         AS EMPCODE_ASM,
         sa1.name           AS zone_head,
         sa1.area_id        AS zone_id,
         ar.LEVEL1_NAME     AS zone_name,
         -- ar.LEVEL1_ID       AS zone_id,
         sa0.sup_id         AS EMPCODE_RSM,
         sa0.name           AS region_head,
         sa0.area_id        AS region_id,
         ar.LEVEL0_NAME     AS region_name
    -- ,         ar.LEVEL0_ID       AS region_id
    FROM v_rep_sup     ra,
         sup_area      sa2,
         sup_area      sa1,
         sup_area      sa0,
         area_structure ar
   WHERE     ra.area_id = ar.AREA_ID(+)
         AND ar.LEVEL2_ID = sa2.AREA_ID(+)
         AND ar.LEVEL1_ID = sa1.AREA_ID(+)
         AND ar.LEVEL0_ID = sa0.AREA_ID(+)
--and ra.rep_id = 'IPI-001415'
ORDER BY 4 NULLS FIRST,
         8 NULLS FIRST,
         12 NULLS FIRST,
         16 NULLS FIRST;