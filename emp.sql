/* Formatted on 15/Jul/24 5:01:50 PM (QP5 v5.362) */
SELECT salarygrade,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status 
  FROM emp
 WHERE empcode = :empcode;
 
 