UPDATE dpuser.manual_att_approval x
       SET STATUS_L5 = 'Y',
           FINAL_STATUS_DETAIL_2 = 'Finally Approved By  HR Department',
           SL = '100',
           FINAL_APPROVAL_DATE = SYSDATE
     WHERE     empcode_5_hohr = 'IPI-007478'
          -- AND entry_date BETWEEN v_from_date AND v_to_date
           AND empcode NOT IN
                   (SELECT DISTINCT EMPCODE
                      FROM (  SELECT APPROVED_START_DATE, EMPCODE, COUNT (*)
                                FROM dpuser.manual_att_approval X
                               WHERE     empcode_5_hohr = 'IPI-007478'
                                     AND APPROVED_START_DATE IS NOT NULL
                                     AND EXISTS
                                             (SELECT 1
                                                FROM dpuser.manual_att_approval_1
                                                     y
                                               WHERE     a = UPPER ('IPI-007478')
                                                     AND x.ID = y.ID
                                                     AND y.c = x.sl)
                            GROUP BY APPROVED_START_DATE, EMPCODE
                              HAVING COUNT (*) > 1))
           AND EXISTS
                   (SELECT 1
                      FROM dpuser.manual_att_approval_1 y
                     WHERE     a = UPPER ('IPI-007478')
                           AND x.ID = y.ID
                           AND y.c = x.sl);