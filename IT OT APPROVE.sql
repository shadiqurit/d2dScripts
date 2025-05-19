/* Formatted on 5/8/2025 4:25:10 PM (QP5 v5.362) */

update ot_application
set IS_APPROVED2 = 'Y',
FINAL_STATUS = 'Approved'
WHERE OTDATE between TO_DATE('4/1/2025', 'MM/DD/YYYY') and  TO_DATE('4/30/2025', 'MM/DD/YYYY')
AND EMPCODE in ('IPI-007514', 'IPI-002628');

UPDATE ot_master
   SET IS_APPROVAL = 'Y', OT_STATUS = 'Approved'
 WHERE     HEAD_EMPCODE = 'IPI-002760'
       AND OT_DATE BETWEEN TO_DATE ('4/1/2025', 'MM/DD/YYYY')
                       AND TO_DATE ('4/30/2025', 'MM/DD/YYYY')
       AND IS_APPROVAL = 'Pending';