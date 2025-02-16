/* Formatted on 2/7/2025 5:04:45 PM (QP5 v5.362) */
DECLARE
    v_rows_updated    NUMBER := 0;
    v_rows_inserted   NUMBER := 0;
BEGIN
    MERGE INTO hr_empsalstructure b
         USING (SELECT AMOUNTCUR, EMPCODE FROM IPIHR.T_BADLI_BASIC) x
            ON (b.EMPCODE = x.EMPCODE AND b.SLNO = 1)
    WHEN MATCHED
    THEN
        UPDATE SET b.AMOUNTCUR = x.AMOUNTCUR, b.SALPER = x.AMOUNTCUR
    WHEN NOT MATCHED
    THEN
        INSERT     (EMPCODE,
                    AMOUNTCUR,
                    AMOUNTPRV,
                    SALPER,
                    SLNO,
                    YEAROFSTRUC,
                    TRNDATE,
                    EDATE,
                    PARTICULAR,
                    PRTCLR_TYPE,
                    HEADCODE,
                    REFNO,
                    ADDEDBY)
            VALUES (x.EMPCODE,
                    x.AMOUNTCUR,
                    NULL,
                    x.AMOUNTCUR,
                    1,
                    2025,
                    SYSDATE,
                    SYSDATE,
                    'Basic Salary',
                    1,
                    '001',
                    '001',
                    'IPI-009129');

    v_rows_updated := SQL%ROWCOUNT;

    -- Capture the number of rows inserted separately
    SELECT COUNT (*)
      INTO v_rows_inserted
      FROM hr_empsalstructure
     WHERE EMPCODE IN (SELECT EMPCODE FROM IPIHR.T_BADLI_BASIC) AND SLNO = 1;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE ('Total rows updated: ' || v_rows_updated);
    DBMS_OUTPUT.PUT_LINE ('Total rows inserted: ' || v_rows_inserted);
END;
/