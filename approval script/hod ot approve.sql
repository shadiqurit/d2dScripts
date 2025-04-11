/* Formatted on 3/6/2025 1:52:30 PM (QP5 v5.362) */
  SELECT *
    FROM IPIHR.Ot_Master
   WHERE HEAD_EMPCODE = 'IPI-002760' AND IS_APPROVAL = 'Pending'
ORDER BY refno;


SELECT *
  FROM ot_application
 WHERE refno IN
           (SELECT REFNO
              FROM IPIHR.Ot_Master
             WHERE HEAD_EMPCODE = 'IPI-002760' AND IS_APPROVAL = 'Pending');

UPDATE ot_application
   SET FINAL_STATUS = 'Approved', IS_APPROVED2 = 'Y'
 WHERE refno IN
           (SELECT REFNO
              FROM IPIHR.Ot_Master
             WHERE HEAD_EMPCODE = 'IPI-002760' AND IS_APPROVAL = 'Pending');

UPDATE IPIHR.Ot_Master
   SET IS_APPROVAL = 'Y', OT_STATUS = 'Approved'
 WHERE HEAD_EMPCODE = 'IPI-002760' AND IS_APPROVAL = 'Pending';