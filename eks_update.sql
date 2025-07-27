/* Formatted on 5/28/2025 9:57:20 AM (QP5 v5.362) */
DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               PREV_TAX,
               CUR_TAX,
               SLNO,
               REFNO,
               HEADCODE
          FROM t_tax_up
         WHERE slno = 68;
BEGIN
    FOR x IN dt
    LOOP
        MERGE INTO hr_empsalstructure b
             USING (SELECT x.EMPCODE      AS EMPCODE,
                           x.SLNO         AS SLNO,
                           x.PREV_TAX     AS PREV_TAX,
                           x.CUR_TAX      AS CUR_TAX,
                           x.HEADCODE     AS HEADCODE,
                           x.REFNO        AS REFNO
                      FROM DUAL) src
                ON (b.EMPCODE = src.EMPCODE AND b.SLNO = src.SLNO)
        WHEN MATCHED
        THEN
            UPDATE SET b.YEARMN = 202507,
                       b.AMOUNTCUR = src.CUR_TAX,
                       b.SALPER = src.CUR_TAX,
                       b.TRNDATE = SYSDATE,
                       b.HEADCODE = src.HEADCODE,
                       b.REFNO = src.REFNO
        WHEN NOT MATCHED
        THEN
            INSERT     (SLNO,
                        EMPCODE,
                        YEARMN,
                        YEAROFSTRUC,
                        AMOUNTCUR,
                        SALPER,
                        TRNDATE,
                        PARTICULAR,
                        PRTCLR_TYPE,
                        HEADCODE,
                        REFNO,
                        SL)
                VALUES (src.SLNO,
                        src.EMPCODE,
                        202507,
                        2025,
                        src.CUR_TAX,
                        src.CUR_TAX,
                        SYSDATE,
                        'Emp. Kayalan Samity',
                        2,
                        src.HEADCODE,
                        src.REFNO,
                        68);
    END LOOP;

    COMMIT;
END;

SELECT *
  FROM hr_empsalstructure st
 WHERE     slno = 68
       AND empcode IN (SELECT EMPCODE
                         FROM t_tax_up tu);

UPDATE hr_empsalstructure st
   SET AMOUNTPRV = AMOUNTCUR
 WHERE     slno = 68
       AND empcode IN (SELECT EMPCODE
                         FROM t_tax_up tu);



DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               PREV_TAX,
               CUR_TAX,
               SLNO,
               REFNO,
               HEADCODE
          FROM t_tax_up
         WHERE empcode IN
                   (SELECT empcode
                      FROM hr_empsalstructure
                     WHERE     empcode IN (SELECT EMPCODE FROM t_tax_up)
                           AND slno = 68);
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
           SET b.YEARMN = 202507,
               b.AMOUNTCUR = x.CUR_TAX,
               b.SALPER = x.CUR_TAX
         WHERE b.EMPCODE = x.empcode AND b.SLNO = x.SLNO;
    END LOOP;

    COMMIT;
END;