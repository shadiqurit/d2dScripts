/* Formatted on 3/18/2025 11:28:09 AM (QP5 v5.362) */
SELECT salary_status, empcode FROM emp;
--12,339

SELECT empcode, SALSTATUS
  FROM (  SELECT MAX (slno)     sl,
                 EMPCODE,
                 SALSTATUS,
                 STOP_YEARMN
            FROM hr_emp_salary_status
           WHERE STOP_YEARMN BETWEEN 202407 AND 202504
        GROUP BY EMPCODE, SALSTATUS, STOP_YEARMN)


'IPI-006044', 
'IPI-006075', 
'IPI-001420', 
'IPI-001415', 
'IPI-001418', 
'IPI-001508', 
'IPI-001424'