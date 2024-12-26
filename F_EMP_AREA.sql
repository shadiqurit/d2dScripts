/* Formatted on 12/23/2024 8:49:54 AM (QP5 v5.362) */
CREATE OR REPLACE FUNCTION IPIHR.f_emp_area (p_empcode IN VARCHAR2)
    RETURN VARCHAR2
IS
    v_workstation   VARCHAR2 (4000);
BEGIN
    SELECT    'Region : '
           || LEVEL0_NAME
           || '; Zone : '
           || LEVEL1_NAME
           || '; Area : '
           || LEVEL2_NAME
           || '; Territory : '
           || AREA_NAME    AS WORKSTATION
      INTO v_workstation
      FROM area_structure
     WHERE area_id IN
               (SELECT CASE
                           WHEN REP_CATEGORY IN ('A', 'B', 'Z')
                           THEN
                               AREA_ID
                           WHEN REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%'
                           THEN
                               AREA_ID
                           ELSE
                               NULL
                       END
                  FROM rep_area
                 WHERE     rep_id = p_empcode
                       AND (   (REP_CATEGORY IN ('A', 'B'))
                            OR (REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%'))
                UNION ALL
                SELECT AREA_ID
                  FROM sup_area
                 WHERE sup_id = p_empcode);

    RETURN v_workstation;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN null;
    WHEN OTHERS
    THEN
        RETURN null;   -- You can customize this exception handling if needed.
END f_emp_area;
/