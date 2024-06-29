SELECT APPROVED_START_DATE, EMPCODE, COUNT (*)
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
                            GROUP BY  APPROVED_START_DATE, EMPCODE
                              HAVING COUNT (*) > 1