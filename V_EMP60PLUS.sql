CREATE OR REPLACE FORCE VIEW IPIHR.V_EMP60PLUS
AS
    SELECT empcode,
           e_name,
           ter_date,
           join_date,
           cata,
           birthdate,
           FLOOR (MONTHS_BETWEEN (SYSDATE, birthdate) / 12)    age,
           confirm_st,
           --TO_CHAR (birthdate, 'DD-MON-YYYY')                  "Date of Birth",
           CASE
               WHEN FLOOR (MONTHS_BETWEEN (SYSDATE, birthdate) / 12) >= 60
               THEN
                   'Age 60 / 60+'
               ELSE
                   'Below 50'
           END                                                 AS age_group,
           salarygrade,
           desig_name
      FROM emp
     WHERE     emp_status = 'A'
           AND FLOOR (MONTHS_BETWEEN (SYSDATE, birthdate) / 12) >= 60
           AND confirm_st = 'CONTRACT'
           AND NVL (SALARYGRADE, ' ') NOT BETWEEN 'GRADE-01' AND 'GRADE-20';
