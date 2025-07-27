/* Formatted on 7/24/2025 3:42:11 PM (QP5 v5.362) */
CREATE TABLE hr_salary_d_july_2025
AS
    SELECT * FROM hr_salary_d;

CREATE TABLE HR_SALARYGRADE_july2025
AS
    SELECT * FROM HR_SALARYGRADE;

CREATE TABLE emp_july2025
AS
    SELECT * FROM emp;

CREATE TABLE hr_salary_m_july25
AS
    SELECT * FROM hr_salary_m;

CREATE TABLE hr_empsalstructure_july25
AS
    SELECT * FROM hr_empsalstructure;

--    hr_salarygrade_b4_fix24g15to20


SELECT empcode, SALARYSCAL, SALARYGRADE
  FROM emp
 WHERE emp_status = 'A' AND SALARYGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';

SELECT GRADEDES, SGRADE
  FROM hr_salarygrade
 WHERE SGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';

--CREATE OR REPLACE VIEW v_emp_scale
--AS

SELECT e.empcode,
       e.SALARYGRADE,
       hg.SGRADE,
       e.SALARYSCAL,
       hg.GRADEDES     newscale
  FROM emp e, hr_salarygrade hg
 WHERE     e.SALARYGRADE = hg.SGRADE
       AND emp_status = 'A'
       AND SALARYGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';

UPDATE emp e
   SET SALARYSCAL =
           (SELECT newscale
              FROM v_emp_scale v
             WHERE e.EMPCODE = v.EMPCODE)
 WHERE emp_status = 'A' AND SALARYGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';



DECLARE
    CURSOR dt IS
        SELECT e1.EMPCODE,
               e1.GRADE,
               e1.OLDBASIC,
               e1.NEWBASIC,
               e1.HOUSERENT,
               e1.CONVA,
               e1.MEDICALA,
               CASE
                   WHEN e.CONFIRM_ST = 'CONFIRMED' THEN e1.NEWBASIC * 0.10
                   ELSE 0
               END    AS CPF,
               CASE
                   WHEN e.CONFIRM_ST = 'CONFIRMED'
                   THEN
                       ROUND (e1.NEWBASIC * 0.20)
                   ELSE
                       0
               END    AS pf,
               e1.SPA,
               e1.ALLOWANCE,
               e1.ARREAR,
               e1.OTHERS,
               e1.GROSSNEW,
               e1.NEWPAYSC
          FROM PAY25G1TO14 e1, EMP e
         WHERE     e1.EMPCODE = e.EMPCODE
               AND cata = 'OFFICER'
               AND CONFIRM_ST = 'CONFIRMED'
               AND EMP_STATUS = 'A'
               AND SALARYGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';
BEGIN
    FOR x IN dt
    LOOP
        ---BASIC---
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.NEWBASIC,
               b.AMOUNTCUR = x.NEWBASIC
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 1;
    END LOOP;


    ---HOUSE RENT--
    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.HOUSERENT,
               b.SALPER = x.HOUSERENT
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 5;
    END LOOP;



    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.CONVA,
               b.SALPER = x.CONVA
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 7;
    END LOOP;

    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.MEDICALA,
               b.SALPER = x.MEDICALA
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 10;
    END LOOP;

    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.CPF,
               b.SALPER = x.CPF
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 13;
    END LOOP;


    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.PF,
               b.SALPER = x.PF
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 57;
    END LOOP;


    --    FOR x IN dt
    --    LOOP
    --        UPDATE HR_EMPSALSTRUCTURE b
    --           SET b.DESIGCODE = x.GRADE,
    --               b.AMOUNTPRV = b.AMOUNTCUR,
    --               b.AMOUNTCUR = x.OTHERS,
    --               b.SALPER = x.OTHERS
    --         WHERE b.EMPCODE = x.empcode AND b.SLNO = 25;
    --    END LOOP;


    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.ALLOWANCE,
               b.SALPER = x.ALLOWANCE
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 37;
    END LOOP;


    COMMIT;
END;
/


DECLARE
    CURSOR dt IS
        SELECT e1.EMPCODE,
               e1.GRADE,
               e1.OLDBASIC,
               e1.NEWBASIC,
               e1.HOUSERENT,
               e1.CONVA,
               e1.MEDICALA,
               CASE
                   WHEN e.CONFIRM_ST = 'CONFIRMED' THEN e1.NEWBASIC * 0.10
                   ELSE 0
               END    AS CPF,
               CASE
                   WHEN e.CONFIRM_ST = 'CONFIRMED'
                   THEN
                       ROUND (e1.NEWBASIC * 0.20)
                   ELSE
                       0
               END    AS pf,
               e1.SPA,
               e1.ALLOWANCE,
               e1.ARREAR,
               e1.OTHERS,
               e1.GROSSNEW,
               e1.NEWPAYSC
          FROM PAY25G1TO14 e1, EMP e
         WHERE     e1.EMPCODE = e.EMPCODE
               AND cata = 'OFFICER'
               AND CONFIRM_ST != 'CONFIRMED'
               AND EMP_STATUS = 'A'
               AND SALARYGRADE BETWEEN 'GRADE-01' AND 'GRADE-14';
BEGIN
    FOR x IN dt
    LOOP
        ---BASIC---
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.NEWBASIC,
               b.AMOUNTCUR = x.NEWBASIC
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 1;
    END LOOP;

    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.DESIGCODE = x.GRADE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.OTHERS,
               b.SALPER = x.OTHERS
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 25;
    END LOOP;



    COMMIT;
END;