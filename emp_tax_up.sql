/* Formatted on 28/Aug/24 9:44:45 AM (QP5 v5.362) */
--HR_EMP_MONTH_HEAD
--T_ARREAR_UP

DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               PREV_TAX,
               CUR_TAX,
               SLNO,
               REFNO,
               HEADCODE
          FROM t_tax_up
         WHERE empcode NOT IN
                   (SELECT empcode
                      FROM hr_empsalstructure
                     WHERE     empcode IN (SELECT EMPCODE FROM t_tax_up)
                           AND slno = 55);
BEGIN
    FOR x IN dt
    LOOP
--        INSERT INTO hr_empsalstructure (SLNO,
--                                        EMPCODE,
--                                        YEARMN,
--                                        YEAROFSTRUC,
--                                        AMOUNTPRV,
--                                        AMOUNTCUR,
--                                        SALPER,
--                                        TRNDATE,
--                                        PARTICULAR,
--                                        HEADCODE,
--                                        REFNO,
--                                        sl)
--             VALUES (x.SLNO,
--                     x.EMPCODE,
--                     202408,
--                     2024,
--                     x.PREV_TAX,
--                     x.CUR_TAX,
--                     x.CUR_TAX,
--                     SYSDATE,
--                     'Income Tax',
--                     x.HEADCODE,
--                     x.REFNO,
--                     55);
            UPDATE hr_empsalstructure b
               SET b.YEARMN = 202408,
                   b.AMOUNTPRV = x.PREV_TAX,
                   b.AMOUNTCUR = x.CUR_TAX,
                   b.SALPER = x.CUR_TAX
             WHERE b.EMPCODE = x.empcode AND b.SLNO = x.SLNO;
    END LOOP;

    COMMIT;
END;



/* Formatted on 28/Aug/24 9:44:45 AM (QP5 v5.362) */
--HR_EMP_MONTH_HEAD
--T_ARREAR_UP

DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               PREV_TAX,
               CUR_TAX,
               SLNO,
               REFNO,
               HEADCODE
          FROM t_tax_up
         WHERE empcode NOT IN
                   (SELECT empcode
                      FROM hr_empsalstructure
                     WHERE     empcode IN (SELECT EMPCODE FROM t_tax_up)
                           AND slno = 120);
BEGIN
    FOR x IN dt
    LOOP
        INSERT INTO hr_empsalstructure (SLNO,
                                        EMPCODE,
                                        YEARMN,
                                        YEAROFSTRUC,
                                        AMOUNTPRV,
                                        AMOUNTCUR,
                                        SALPER,
                                        TRNDATE,
                                        PARTICULAR,
                                        HEADCODE,
                                        REFNO,
                                        sl,
                                        PRTCLR_TYPE)
             VALUES (x.SLNO,
                     x.EMPCODE,
                     202411,
                     2024,
                     x.PREV_TAX,
                     x.CUR_TAX,
                     x.CUR_TAX,
                     SYSDATE,
                     'MC Risk Compensation Ploicy',
                     x.HEADCODE,
                     x.REFNO,
                     120,
                     2);
    --        UPDATE hr_empsalstructure b
    --           SET b.YEARMN = 202408,
    --               b.AMOUNTPRV = x.PREV_TAX,
    --               b.AMOUNTCUR = x.CUR_TAX,
    --               b.SALPER = x.CUR_TAX
    --         WHERE b.EMPCODE = x.empcode AND b.SLNO = x.SLNO;
    END LOOP;

    COMMIT;
END;