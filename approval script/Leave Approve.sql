/* Formatted on 11/7/2024 4:53:02 PM (QP5 v5.362) */
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
       AND APPROVED_LEAVE_TYPE IN ('CL', 'SL')
       AND empcode IN (SELECT empcode FROM ipihr.emp);

COMMIT;