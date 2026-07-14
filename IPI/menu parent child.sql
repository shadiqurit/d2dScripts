/* Formatted on 7/13/2026 5:20:11 PM (QP5 v5.362) */
           SELECT CASE WHEN LEVEL = 1 THEN MENUNAME END
                      AS "Level 1: Parent Menu",
                  CASE WHEN LEVEL = 2 THEN MENUNAME END
                      AS "Level 2: Child Menu",
                  CASE WHEN LEVEL = 3 THEN MENUNAME END
                      AS "Level 3: Child-Child Menu",
                  CASE WHEN LEVEL = 4 THEN MENUNAME END
                      AS "Level 4: Deep Child Menu",
                  LEVEL
                      AS "Menu Depth",
                  MENUID
                      AS "Menu ID",
                  RUNFILE
                      AS "Run File / Action",
                  MENUSTATUS
                      AS "Status"
             FROM MENUMASTER
            WHERE MENUNAME IS NOT NULL
       START WITH MENUPARENT IS NULL OR MENUPARENT = 0
       CONNECT BY PRIOR MENUID = MENUPARENT
ORDER SIBLINGS BY MENUSL;