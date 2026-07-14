/* Formatted on 6/23/2026 4:48:45 PM (QP5 v5.362) */
CREATE OR REPLACE PROCEDURE IPIHR.sp_process_sal_struc (p_slno IN NUMBER)
IS
    CURSOR dt IS
        SELECT slno, empcode, amount
          FROM t_sal_up
         WHERE slno = p_slno AND status = 'P';

    v_particular    VARCHAR2 (100);
    v_refno         VARCHAR2 (100);
    v_headcode      VARCHAR2 (100);
    v_type          NUMBER;                    -- New variable for prtclr_type
    v_yearmn        NUMBER := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMM'));
    v_yearofstruc   NUMBER := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));
    v_count         NUMBER := 0;
BEGIN
    -- Map slno to particular / refno / headcode / type
    CASE p_slno
        WHEN 1
        THEN
            v_particular := 'Basic Salary';
            v_refno := '001';
            v_headcode := '001';
            v_type := 1;                                                -- Pay
        WHEN 25
        THEN
            v_particular := 'Other Allowance';
            v_refno := '025';
            v_headcode := '025';
            v_type := 1;                                                -- Pay
        WHEN 13
        THEN
            v_particular := 'Co''S  Con. To Pf';
            v_refno := '013';
            v_headcode := '013';
            v_type := 1;                                                -- Pay
        WHEN 57
        THEN
            v_particular := 'P.F. Contribution';
            v_refno := '057';
            v_headcode := '057';
            v_type := 2;                                          -- Deduction
        WHEN 55
        THEN
            v_particular := 'Income Tax';
            v_refno := '055';
            v_headcode := '055';
            v_type := 2;                                          -- Deduction
        WHEN 68
        THEN
            v_particular := 'Emp. Kayalan Samity';
            v_refno := '068';
            v_headcode := '068';
            v_type := 2;                                          -- Deduction
        WHEN 75
        THEN
            v_particular := 'Superannuation Fund';
            v_refno := '075';
            v_headcode := '075';
            v_type := 2;                                          -- Deduction
        ELSE
            RAISE_APPLICATION_ERROR (
                -20001,
                'Invalid slno ' || p_slno || '. No mapping defined.');
    END CASE;

    FOR x IN dt
    LOOP
        MERGE INTO hr_empsalstructure b
             USING (SELECT x.slno        AS slno,
                           x.empcode     AS empcode,
                           x.amount      AS amount
                      FROM DUAL) src
                ON (b.empcode = src.empcode AND b.slno = src.slno)
        WHEN MATCHED
        THEN
            UPDATE SET b.yearmn = v_yearmn,
                       b.amountcur = src.amount,
                       b.salper = src.amount,
                       b.trndate = SYSDATE,
                       b.headcode = v_headcode,
                       b.refno = v_refno,
                       b.prtclr_type = v_type
        WHEN NOT MATCHED
        THEN
            INSERT     (slno,
                        empcode,
                        yearmn,
                        yearofstruc,
                        amountprv,
                        amountcur,
                        salper,
                        trndate,
                        particular,
                        prtclr_type,
                        headcode,
                        refno,
                        sl)
                VALUES (src.slno,
                        src.empcode,
                        v_yearmn,
                        v_yearofstruc,
                        0,
                        src.amount,
                        src.amount,
                        SYSDATE,
                        v_particular,
                        v_type,
                        v_headcode,
                        v_refno,
                        p_slno);

        v_count := v_count + 1;
    END LOOP;

    UPDATE t_sal_up
       SET status = 'S'
     WHERE slno = p_slno AND status = 'P';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE (
        v_count || ' record(s) processed for slno ' || p_slno);
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        RAISE;
END sp_process_sal_struc;
/