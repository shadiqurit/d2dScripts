/* Formatted on 11/26/2024 7:19:32 PM (QP5 v5.362) */
--HR_EMP_MONTH_HEAD
--T_ARREAR_UP

DELETE FROM T_ARREAR_UP;

COMMIT;

DECLARE
    CURSOR dt IS
        SELECT SLNO,
               YEARMN,
               ARREAR_AMT,
               GRADE,
               EMPCODE,
               PARTICULAR,
               HEADCODE,
               REFNO,
               REMARKS
          FROM T_ARREAR_UP;
BEGIN
    FOR x IN dt
    LOOP
        INSERT INTO HR_EMP_MONTH_HEAD (SLNO,
                                       YEARMN,
                                       AMOUNTCUR,
                                       SALPER,
                                       DESIGCODE,
                                       EMPCODE,
                                       PARTICULAR,
                                       HEADCODE,
                                       REFNO,
                                       REMARKS)
             VALUES (x.SLNO,
                     x.YEARMN,
                     x.ARREAR_AMT,
                     x.ARREAR_AMT,
                     x.GRADE,
                     x.EMPCODE,
                     x.PARTICULAR,
                     x.HEADCODE,
                     x.REFNO,
                     x.REMARKS);


        UPDATE HR_EMP_MONTH_HEAD b
           SET b.YEARMN = x.YEARMN,
               b.AMOUNTCUR = x.ARREAR_AMT,
               b.SALPER = x.ARREAR_AMT,
               b.REMARKS = x.REMARKS
         WHERE     b.EMPCODE = x.empcode
               AND b.YEARMN = x.YEARMN
               AND b.SLNO = x.SLNO;
    END LOOP;


    COMMIT;
END;


-- Check for duplicates in T_ARREAR_UP

  SELECT EMPCODE,
         YEARMN,
         SLNO,
         COUNT (*)
    FROM T_ARREAR_UP
GROUP BY EMPCODE, YEARMN, SLNO
  HAVING COUNT (*) > 1;

-- Check for conflicting rows in HR_EMP_MONTH_HEAD

  SELECT EMPCODE,
         YEARMN,
         SLNO,
         COUNT (*)
    FROM HR_EMP_MONTH_HEAD
GROUP BY EMPCODE, YEARMN, SLNO
  HAVING COUNT (*) > 1;



DECLARE
BEGIN
    MERGE INTO HR_EMP_MONTH_HEAD b
         USING T_ARREAR_UP x
            ON (    b.EMPCODE = x.EMPCODE
                AND b.YEARMN = x.YEARMN
                AND b.SLNO = x.SLNO)
    WHEN MATCHED
    THEN
        UPDATE SET
            b.AMOUNTCUR = x.ARREAR_AMT,
            b.SALPER = x.ARREAR_AMT,
            b.REMARKS = x.REMARKS
    WHEN NOT MATCHED
    THEN
        INSERT     (SLNO,
                    YEARMN,
                    AMOUNTCUR,
                    SALPER,
                    DESIGCODE,
                    EMPCODE,
                    PARTICULAR,
                    HEADCODE,
                    REFNO,
                    REMARKS)
            VALUES (x.SLNO,
                    x.YEARMN,
                    x.ARREAR_AMT,
                    x.ARREAR_AMT,
                    x.GRADE,
                    x.EMPCODE,
                    x.PARTICULAR,
                    x.HEADCODE,
                    x.REFNO,
                    x.REMARKS);

    COMMIT;
END;