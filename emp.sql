/* Formatted on 7/16/2025 4:44:52 PM (QP5 v5.362) */
SELECT empcode,
       e_name,
       CONFIRM_ST,
       BIRTHDATE,
       salarygrade,
       JOIN_DATE,
       TER_DATE,
       REFRESHMENT_GRADE,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD,
       BLD_GROUP
  FROM emp
 WHERE empcode IN ('IPI-003018');

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
         AND salarygrade BETWEEN 'GRADE-01' AND 'GRADE-06'
         AND depot IN ('Head Office') -- and department_name = 'Information Technology'
ORDER BY SALARYGRADE, join_date;

SELECT empcode                                "Employee ID",
       e_name                                 AS "Name",
       CONFIRM_ST                             "Confirmation Status",
       TO_CHAR (JOIN_DATE, 'DD-MON-YYYY')     "Join Date",
       desig_name                             "Designation",
       salarygrade                            "Grade",
       BLD_GROUP,
       PHONE                                  "Phone"
  FROM emp
 WHERE emp_status = 'A' AND EMPNO LIKE '%API-%';

SELECT empcode,
       e_name,
       CONFIRM_ST,
       BIRTHDATE,
       CASE
           WHEN FLOOR (MONTHS_BETWEEN (SYSDATE, BIRTHDATE) / 12) >= 60
           THEN
               'Age 60 / 60+'
           ELSE
               'Below 50'
       END    AS AGE_GROUP,
       salarygrade,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD
  FROM emp
 WHERE     emp_status = 'A'
       AND FLOOR (MONTHS_BETWEEN (SYSDATE, BIRTHDATE) / 12) >= 60;

 --WHERE empcode = 'IPI-007378';



SELECT EMPCODE,
       E_NAME,
       BIRTHDATE,
       AGE,
       CONFIRM_ST,
       AGE_GROUP,
       SALARYGRADE,
       DESIG_NAME
  FROM v_emp60plus;

--IPI-001630
--779120