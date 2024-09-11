/* Formatted on 24/Jun/24 4:40:31 PM (QP5 v5.362) */
WITH
    cte
    AS
        (SELECT id,
                EMPCODE,
                APPROVED_START_DATE,
                APPROVED_END_DATE,
                ROW_NUMBER ()
                    OVER (PARTITION BY EMPCODE
                          ORDER BY APPROVED_START_DATE, EMPCODE)    AS rn
           FROM dpuser.manual_att_approval x
          WHERE     empcode_5_hohr = 'IPI-007478'
                AND EXISTS
                        (SELECT 1
                           FROM dpuser.manual_att_approval_1 y
                          WHERE     a = UPPER ('IPI-007478')
                                AND x.ID = y.ID
                                AND y.c = x.sl))
SELECT *
  FROM cte
 WHERE rn >= 0 AND empcode IN ('IPI-001360');


 SELECT APPROVED_START_DATE, EMPCODE, COUNT (*)
            FROM dpuser.manual_att_approval X
           WHERE     empcode_5_hohr = 'IPI-007478'
                 AND APPROVED_START_DATE IS NOT NULL
                 AND EXISTS
                         (SELECT 1
                            FROM dpuser.manual_att_approval_1 y
                           WHERE     a = UPPER ('IPI-007478')
                                 AND x.ID = y.ID
                                 AND y.c = x.sl)
        GROUP BY APPROVED_START_DATE, EMPCODE
          HAVING COUNT (*) > 1