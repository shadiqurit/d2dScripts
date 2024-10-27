/* Formatted on 27/Aug/24 11:52:48 AM (QP5 v5.362) */
--HR_EMP_MONTH_HEAD
--T_ARREAR_UP

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

                     
    --            UPDATE HR_EMP_MONTH_HEAD b
    --               SET b.YEARMN = x.YEARMN,
    --                   b.AMOUNTCUR = x.ARREAR_AMT,
    --                   b.SALPER = x.ARREAR_AMT,
    --                   b.REMARKS = x.REMARKS
    --             WHERE     b.EMPCODE = x.empcode
    --                   AND b.YEARMN = x.YEARMN
    --                   --AND b.PARTICULAR = x.PARTICULAR
    --                   AND b.SLNO = x.SLNO;

    END LOOP;


    COMMIT;
END;