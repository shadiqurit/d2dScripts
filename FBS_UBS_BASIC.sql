/* Formatted on 6/15/2025 10:35:00 AM (QP5 v5.362) */
DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               PREV_AMT,
               AMOUNT,
               SALPER,
               SLNO,
               REFNO,
               HEADCODE
          FROM T_UBSFBS_BASIC
         WHERE SLNO = 1;
BEGIN
    FOR x IN dt
    LOOP
        MERGE INTO hr_empsalstructure b
             USING (SELECT x.EMPCODE      AS EMPCODE,
                           x.SLNO         AS SLNO,
                           x.PREV_AMT     AS AMOUNTPRV,
                           x.AMOUNT       AS AMOUNTCUR,
                           x.SALPER       AS SALPER,
                           x.HEADCODE     AS HEADCODE,
                           x.REFNO        AS REFNO
                      FROM DUAL) src
                ON (b.EMPCODE = src.EMPCODE AND b.SLNO = src.SLNO)
        WHEN MATCHED
        THEN
            UPDATE SET b.YEARMN = 202505,
                       b.AMOUNTPRV = src.AMOUNTPRV,
                       b.AMOUNTCUR = src.AMOUNTCUR,
                       b.SALPER = src.SALPER,
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
                        202506,
                        2025,
                        src.AMOUNTCUR,
                        src.SALPER,
                        SYSDATE,
                        'Basic Salary',
                        1,
                        src.HEADCODE,
                        src.REFNO,
                        1);
    END LOOP;

    COMMIT;
END;
/

SELECT EMPCODE,
       PREV_AMT,
       AMOUNT,
       SALPER,
       SLNO,
       REFNO,
       HEADCODE
  FROM T_UBSFBS_BASIC
 WHERE SLNO = 1;


SELECT *
  FROM hr_empsalstructure
 WHERE EMPCODE IN (SELECT EMPCODE
                     FROM T_UBSFBS_BASIC
                    WHERE SLNO = 1);