/* Formatted on 1/11/2026 3:35:48 PM (QP5 v5.362) */
  SELECT e_name                                 "Name",
         TO_CHAR (JOIN_DATE, 'DD-MON-yyyy')     "Join Date",
         department_name                        AS "Department",
         desig_name                             "Designation",
         salarygrade                            "Grade",
         salarystep,
         salaryscal,
         DEPOT,
         emp_status,
         WEB_PASSWORD,
         BLD_GROUP
    FROM emp
   WHERE     emp_status = 'A'
         AND department_name = 'Material Management and Inventory Control'
ORDER BY SALARYGRADE, join_date;


UPDATE emp
   SET department_name = 'MMIC'
 WHERE department_name = 'Material Management and Inventory Control';

COMMIT;


select BASENAME r, BASENAME d from hr_base
where 
type='Sub Department'
and PARENTNAME=:p413_department_name
order by 1;


--REFRESHMENT_PRIOR_ENTRY