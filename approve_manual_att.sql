/* Formatted on 11/7/2024 4:54:18 PM (QP5 v5.362) */
UPDATE dpuser.manual_att_approval x
   SET STATUS_L5 = 'Y',
       FINAL_STATUS_DETAIL_2 = 'Finally Approved By  HR Department',
       SL = '100',
       FINAL_APPROVAL_DATE = SYSDATE
 WHERE     empcode_5_hohr = :P_APP_USER
       AND APPROVED_START_DATE BETWEEN :P_FROM_DATE AND :P_TO_DATE
       AND empcode NOT IN
               (SELECT DISTINCT EMPCODE
                  FROM (  SELECT APPROVED_START_DATE, EMPCODE, COUNT (*)
                            FROM dpuser.manual_att_approval X
                           WHERE     empcode_5_hohr = :P_APP_USER
                                 AND APPROVED_START_DATE IS NOT NULL
                                 AND EXISTS
                                         (SELECT 1
                                            FROM dpuser.manual_att_approval_1 y
                                           WHERE     a = UPPER ( :P_APP_USER)
                                                 AND x.ID = y.ID
                                                 AND y.c = x.sl)
                        GROUP BY APPROVED_START_DATE, EMPCODE
                          HAVING COUNT (*) > 1))
       AND EXISTS
               (SELECT 1
                  FROM dpuser.manual_att_approval_1 y
                 WHERE     a = UPPER ( :P_APP_USER)
                       AND x.ID = y.ID
                       AND y.c = x.sl);