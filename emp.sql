/* Formatted on 4/24/2025 1:57:16 PM (QP5 v5.362) */
SELECT empcode,
       e_name,
       CONFIRM_ST,
       BIRTHDATE,
       salarygrade,
       REFRESHMENT_GRADE,
       desig_code,
       desig_name,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD,
       BLD_GROUP
  FROM emp
 WHERE empcode IN ('IPI-000789');

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