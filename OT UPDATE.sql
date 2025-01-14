/* Formatted on 1/9/2025 3:55:24 PM (QP5 v5.362) */
BEGIN
    P_OT_APPLICATION_TRNS;
END;

create table OT_APPLICATION_13012025
as select * from OT_APPLICATION;

SELECT *
  FROM IPIHR.OT_MASTER
 WHERE                                            -- ot_status = 'Pending' and
       refno IN
           (SELECT refno
              FROM ot_application
             WHERE OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                              AND TO_DATE ('12/31/2024', 'MM/DD/YYYY'));


UPDATE ot_application
   SET FINAL_STATUS = 'Approved', IS_APPROVED1 = 2, IS_APPROVED2 = 'Y'
 WHERE     OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                      AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
       AND IS_APPROVED2 IS NULL;


UPDATE IPIHR.OT_MASTER
   SET IS_APPROVAL = 'Y', OT_STATUS = 'Approved'
 WHERE     OT_STATUS = 'Pending'
       AND refno IN
               (SELECT DISTINCT refno
                  FROM ot_application
                 WHERE     OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                                      AND TO_DATE ('12/31/2024',
                                                   'MM/DD/YYYY')
                       AND FINAL_STATUS = 'Pending');