/* Formatted on 7/7/2025 1:25:49 PM (QP5 v5.362) */
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
 WHERE empcode IN ('IPI-008234');


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