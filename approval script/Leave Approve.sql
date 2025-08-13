/* Formatted on 12/8/2024 12:32:09 PM (QP5 v5.362) */
---Department Wise Leave Approve---
UPDATE leave_approval
   SET STATUS_L5 = 'Y', FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_5_hohr = 'IPI-007478'
       AND sl = 5
       AND APPROVED_LEAVE_TYPE IN ('CL', 'SL')
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE department_name = 'Marketing');
/


---Leave approval aalll--
UPDATE leave_approval
   SET STATUS_L5 = 'Y', FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_5_hohr = 'IPI-007478'
       AND sl = 5
       AND APPROVED_DAYS <= 3
       AND APPROVED_LEAVE_TYPE IN ('SL', 'CL')
       AND empcode IN (SELECT empcode FROM ipihr.emp);
COMMIT;


---Leave approval MD-- 

UPDATE leave_approval
   SET STATUS_L5 = 'Y', FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_4_MD = 'IPI-000789'
       AND sl = 4
       AND APPROVED_DAYS <= 3
       AND APPROVED_LEAVE_TYPE IN ('CL', 'SL', 'EL')
       AND empcode IN (SELECT empcode FROM ipihr.emp);
COMMIT;



---short Leave  approval aalll--
UPDATE shortleave_approval
   SET STATUS_L5 = 'Y', FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_5_hohr = 'IPI-007478'
       AND sl = 5
       AND APPROVED_DAYS <= 3
       AND TYPE = 'Short Leave'
       AND empcode IN (SELECT empcode FROM ipihr.emp);

COMMIT;