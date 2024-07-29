/* Formatted on 08/Jul/24 10:18:25 AM (QP5 v5.362) */
UPDATE dpuser.manual_att_approval x
   SET STATUS_L2 = 'Y',
       FINAL_STATUS_DETAIL_2 = 'Wating for HR Department  approval',
       SL = '2',
       FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_2_HOD = 'IPI-002760'
       AND TOUR_PURPOSE LIKE '%Refreshment%'
       -- AND entry_date BETWEEN v_from_date AND v_to_date
       AND empcode NOT IN
               (SELECT DISTINCT EMPCODE
                  FROM (  SELECT APPROVED_START_DATE, EMPCODE, COUNT (*)
                            FROM dpuser.manual_att_approval X
                           WHERE     EMPCODE_2_HOD = 'IPI-002760'
                                 AND APPROVED_START_DATE IS NOT NULL
                                 AND EXISTS
                                         (SELECT 1
                                            FROM dpuser.manual_att_approval_1 y
                                           WHERE     a = UPPER ('IPI-002760')
                                                 AND x.ID = y.ID
                                                 AND y.c = x.sl)
                        GROUP BY APPROVED_START_DATE, EMPCODE
                          HAVING COUNT (*) > 1))
       AND EXISTS
               (SELECT 1
                  FROM dpuser.manual_att_approval_1 y
                 WHERE     a = UPPER ('IPI-002760')
                       AND x.ID = y.ID
                       AND y.c = x.sl);