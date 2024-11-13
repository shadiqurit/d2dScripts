/* Formatted on 11/10/2024 9:08:25 AM (QP5 v5.362) */
SELECT e_name,
       salarygrade,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD
  FROM emp
 WHERE empcode = 'IPI-002771';
 
 SELECT empcode, e_name,
       salarygrade,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD
  FROM emp
 WHERE e_name LIKE  '%MD. HUMAYUN KABIR%';
--IPI-001630
--779120