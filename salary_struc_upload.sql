/* Formatted on 4/22/2026 1:17:25 PM (QP5 v5.362) */


GRANT SELECT ON IPIHR.T_SAL_UP TO DPUSER;
CREATE TABLE T_SAL_UP
(
    SLNO       NUMBER,
    EMPCODE    VARCHAR2 (30),
    AMOUNT     NUMBER,
    STATUS     VARCHAR2 (3) DEFAULT 'P'
);

CREATE OR REPLACE PROCEDURE sp_process_sal_struc (p_slno IN NUMBER)
IS
    CURSOR dt IS
        SELECT slno, empcode, amount
          FROM t_sal_up
         WHERE slno = p_slno
           AND status = 'P';

    v_particular  VARCHAR2(100);
    v_refno       VARCHAR2(100);
    v_headcode    VARCHAR2(100);
    v_yearmn      NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));
    v_yearofstruc NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
    v_count       NUMBER := 0;
BEGIN
    -- Map slno to particular / refno / headcode
    CASE p_slno
        WHEN 1 THEN
            v_particular := 'Basic Salary';
            v_refno      := '001';
            v_headcode   := '001';
        WHEN 25 THEN
            v_particular := 'Other Allowance';
            v_refno      := '025';
            v_headcode   := '025';
        ELSE
            RAISE_APPLICATION_ERROR(-20001,
                'Invalid slno ' || p_slno || '. No mapping defined.');
    END CASE;

    FOR x IN dt
    LOOP
        MERGE INTO hr_empsalstructure b
             USING (SELECT x.slno    AS slno,
                           x.empcode AS empcode,
                           x.amount  AS amount
                      FROM DUAL) src
                ON (b.empcode = src.empcode AND b.slno = src.slno)
        WHEN MATCHED THEN
            UPDATE SET b.yearmn    = v_yearmn,
                       b.amountcur = src.amount,
                       b.salper    = src.amount,
                       b.trndate   = SYSDATE,
                       b.headcode  = v_headcode,
                       b.refno     = v_refno
        WHEN NOT MATCHED THEN
            INSERT (slno, empcode, yearmn, yearofstruc,
                    amountprv, amountcur, salper, trndate,
                    particular, prtclr_type, headcode, refno, sl)
            VALUES (src.slno, src.empcode, v_yearmn, v_yearofstruc,
                    0, src.amount, src.amount, SYSDATE,
                    v_particular, 1, v_headcode, v_refno, p_slno);

        v_count := v_count + 1;
    END LOOP;

    UPDATE t_sal_up
       SET status = 'S'
     WHERE slno = p_slno
       AND status = 'P';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(v_count || ' record(s) processed for slno ' || p_slno);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_process_sal_struc;
/