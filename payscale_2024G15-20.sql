/* Formatted on 11/19/2024 11:07:40 AM (QP5 v5.362) */
  SELECT EMPCODE,
         E_NAME,
         EMP_STATUS,
         SALARYGRADE,
         DEPARTMENT_NAME,
         DESIG_NAME,
         SALARYSCAL,
         SALARY_STATUS
    FROM emp
   WHERE SALARYGRADE BETWEEN 'GRADE-15' AND 'GRADE-20' AND EMP_STATUS = 'A'
ORDER BY SALARYGRADE;

CREATE TABLE HR_EMPSALSTRUCTURE_241024
AS
    SELECT * FROM HR_EMPSALSTRUCTURE;

CREATE TABLE HR_SALARYGRADE_241024
AS
    SELECT * FROM HR_SALARYGRADE;

CREATE TABLE emp_241024
AS
    SELECT * FROM emp;

DECLARE
    CURSOR dt IS
        SELECT e1.EMPCODE,
               GRADE,
               OLDBASIC,
               NEWBASIC,
               HOUSERENT,
               CONVA,
               MEDICALA,
               CPF,
               SPA,
               ALLOWANCE,
               ARREAR,
               OTHERS,
               GROSSNEW,
               NEWPAYSC
          FROM PAY24G15T20 e1;
BEGIN
    FOR x IN dt
    LOOP
        UPDATE EMP b
           SET b.SALARYSCAL = x.NEWPAYSC
         WHERE b.EMPCODE = x.empcode AND EMP_STATUS = 'A';
    END LOOP;

    COMMIT;
END;



DECLARE
    CURSOR dt IS
        SELECT e1.EMPCODE,
               GRADE,
               OLDBASIC,
               NEWBASIC,
               HOUSERENT,
               CONVA,
               MEDICALA,
               CPF,
               CPF * 2     pf,
               SPA,
               ALLOWANCE,
               ARREAR,
               OTHERS,
               GROSSNEW,
               NEWPAYSC
          FROM PAY24G15T20 e1;
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
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.HOUSERENT,
               b.SALPER = x.HOUSERENT
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 5;
    END LOOP;



    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.CONVA,
               b.SALPER = x.CONVA
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 7;
    END LOOP;

    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.MEDICALA,
               b.SALPER = x.MEDICALA
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 10;
    END LOOP;

    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.CPF,
               b.SALPER = x.CPF
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 13;
    END LOOP;


    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR, b.AMOUNTCUR = x.PF, b.SALPER = x.PF
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 57;
    END LOOP;


    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.SPA,
               b.SALPER = x.SPA
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 26;
    END LOOP;


    FOR x IN dt
    LOOP
        UPDATE HR_EMPSALSTRUCTURE b
           SET b.AMOUNTPRV = b.AMOUNTCUR,
               b.AMOUNTCUR = x.ALLOWANCE,
               b.SALPER = x.ALLOWANCE
         WHERE b.EMPCODE = x.empcode AND b.SLNO = 37;
    END LOOP;


    COMMIT;
END;



------DA------

MERGE INTO HR_EMPSALSTRUCTURE b
     USING (SELECT EMPCODE,
                   SALARYGRADE     AS DESIGCODE,
                   15              AS SLNO,
                   5000            AS SALPER,
                   5000            AS AMOUNTCUR,
                   2024            AS YEAROFSTRUC,
                   SYSDATE         AS EDATE,
                   1               AS PRTCLR_TYPE,
                   '015'           AS HEADCODE,
                   DEPARTMENT_NAME,
                   DESIG_NAME,
                   SALARYSCAL,
                   SALARY_STATUS
              FROM emp
             WHERE     SALARYGRADE BETWEEN 'GRADE-02' AND 'GRADE-05'
                   AND EMP_STATUS = 'A') x
        ON (b.EMPCODE = x.EMPCODE AND b.SLNO = 15)
WHEN MATCHED
THEN
    UPDATE SET b.DESIGCODE = x.DESIGCODE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.SALPER,
               b.AMOUNTCUR = x.AMOUNTCUR,
               b.YEAROFSTRUC = x.YEAROFSTRUC
WHEN NOT MATCHED
THEN
    INSERT     (EMPCODE,
                DESIGCODE,
                SLNO,
                SALPER,
                AMOUNTCUR,
                YEAROFSTRUC,
                EDATE,
                PRTCLR_TYPE,
                HEADCODE)
        VALUES (x.EMPCODE,
                x.DESIGCODE,
                x.SLNO,
                x.SALPER,
                x.AMOUNTCUR,
                x.YEAROFSTRUC,
                x.EDATE,
                x.PRTCLR_TYPE,
                x.HEADCODE);

COMMIT;


MERGE INTO HR_EMPSALSTRUCTURE b
     USING (SELECT EMPCODE,
                   SALARYGRADE     AS DESIGCODE,
                   15              AS SLNO,
                   4000            AS SALPER,
                   4000            AS AMOUNTCUR,
                   2024            AS YEAROFSTRUC,
                   SYSDATE         AS EDATE,
                   1               AS PRTCLR_TYPE,
                   '015'           AS HEADCODE,
                   DEPARTMENT_NAME,
                   DESIG_NAME,
                   SALARYSCAL,
                   SALARY_STATUS
              FROM emp
             WHERE     SALARYGRADE BETWEEN 'GRADE-06' AND 'GRADE-08'
                   AND EMP_STATUS = 'A') x
        ON (b.EMPCODE = x.EMPCODE AND b.SLNO = 15)
WHEN MATCHED
THEN
    UPDATE SET b.DESIGCODE = x.DESIGCODE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.SALPER,
               b.AMOUNTCUR = x.AMOUNTCUR,
               b.YEAROFSTRUC = x.YEAROFSTRUC
WHEN NOT MATCHED
THEN
    INSERT     (EMPCODE,
                DESIGCODE,
                SLNO,
                SALPER,
                AMOUNTCUR,
                YEAROFSTRUC,
                EDATE,
                PRTCLR_TYPE,
                HEADCODE)
        VALUES (x.EMPCODE,
                x.DESIGCODE,
                x.SLNO,
                x.SALPER,
                x.AMOUNTCUR,
                x.YEAROFSTRUC,
                x.EDATE,
                x.PRTCLR_TYPE,
                x.HEADCODE);

COMMIT;

MERGE INTO HR_EMPSALSTRUCTURE b
     USING (SELECT EMPCODE,
                   SALARYGRADE     AS DESIGCODE,
                   15              AS SLNO,
                   3000            AS SALPER,
                   3000            AS AMOUNTCUR,
                   2024            AS YEAROFSTRUC,
                   SYSDATE         AS EDATE,
                   1               AS PRTCLR_TYPE,
                   '015'           AS HEADCODE,
                   DEPARTMENT_NAME,
                   DESIG_NAME,
                   SALARYSCAL,
                   SALARY_STATUS
              FROM emp
             WHERE     SALARYGRADE BETWEEN 'GRADE-09' AND 'GRADE-11'
                   AND EMP_STATUS = 'A') x
        ON (b.EMPCODE = x.EMPCODE AND b.SLNO = 15)
WHEN MATCHED
THEN
    UPDATE SET b.DESIGCODE = x.DESIGCODE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.SALPER,
               b.AMOUNTCUR = x.AMOUNTCUR,
               b.YEAROFSTRUC = x.YEAROFSTRUC
WHEN NOT MATCHED
THEN
    INSERT     (EMPCODE,
                DESIGCODE,
                SLNO,
                SALPER,
                AMOUNTCUR,
                YEAROFSTRUC,
                EDATE,
                PRTCLR_TYPE,
                HEADCODE)
        VALUES (x.EMPCODE,
                x.DESIGCODE,
                x.SLNO,
                x.SALPER,
                x.AMOUNTCUR,
                x.YEAROFSTRUC,
                x.EDATE,
                x.PRTCLR_TYPE,
                x.HEADCODE);

COMMIT;


MERGE INTO HR_EMPSALSTRUCTURE b
     USING (SELECT EMPCODE,
                   SALARYGRADE     AS DESIGCODE,
                   15              AS SLNO,
                   2500            AS SALPER,
                   2500            AS AMOUNTCUR,
                   2024            AS YEAROFSTRUC,
                   SYSDATE         AS EDATE,
                   1               AS PRTCLR_TYPE,
                   '015'           AS HEADCODE,
                   DEPARTMENT_NAME,
                   DESIG_NAME,
                   SALARYSCAL,
                   SALARY_STATUS
              FROM emp
             WHERE     SALARYGRADE BETWEEN 'GRADE-12' AND 'GRADE-14'
                   AND EMP_STATUS = 'A') x
        ON (b.EMPCODE = x.EMPCODE AND b.SLNO = 15)
WHEN MATCHED
THEN
    UPDATE SET b.DESIGCODE = x.DESIGCODE,
               b.AMOUNTPRV = b.AMOUNTCUR,
               b.SALPER = x.SALPER,
               b.AMOUNTCUR = x.AMOUNTCUR,
               b.YEAROFSTRUC = x.YEAROFSTRUC
WHEN NOT MATCHED
THEN
    INSERT     (EMPCODE,
                DESIGCODE,
                SLNO,
                SALPER,
                AMOUNTCUR,
                YEAROFSTRUC,
                EDATE,
                PRTCLR_TYPE,
                HEADCODE)
        VALUES (x.EMPCODE,
                x.DESIGCODE,
                x.SLNO,
                x.SALPER,
                x.AMOUNTCUR,
                x.YEAROFSTRUC,
                x.EDATE,
                x.PRTCLR_TYPE,
                x.HEADCODE);

COMMIT;