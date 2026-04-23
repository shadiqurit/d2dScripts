/* Formatted on 4/22/2026 1:18:34 PM (QP5 v5.362) */
UPDATE t_sal_struc
   SET headcode = '001', REFNO = '001'                 ---Basic 'Basic Salary'
 WHERE slno = 1 AND status = 'P';

UPDATE t_sal_struc
   SET headcode = '025', REFNO = '025'              --Others 'Other Allowance'
 WHERE slno = 25 AND status = 'P';

DECLARE
    CURSOR dt IS
        SELECT empcode,
               prev_amt,
               cur_amt,
               slno,
               refno,
               headcode
          FROM t_sal_struc
         WHERE slno = 25 AND status = 'P';                           --pending
BEGIN
    FOR x IN dt
    LOOP
        MERGE INTO hr_empsalstructure b
             USING (SELECT x.empcode      AS empcode,
                           x.slno         AS slno,
                           x.prev_amt     AS prev_amt,
                           x.cur_amt      AS cur_amt,
                           x.headcode     AS headcode,
                           x.refno        AS refno
                      FROM DUAL) src
                ON (b.empcode = src.empcode AND b.slno = src.slno)
        WHEN MATCHED
        THEN
            UPDATE SET b.yearmn = 202510,
                       b.amountcur = src.cur_amt,
                       b.salper = src.cur_amt,
                       b.trndate = SYSDATE,
                       b.headcode = src.headcode,
                       b.refno = src.refno
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
                        202510,
                        2025,
                        src.prev_amt,
                        src.cur_amt,
                        src.cur_amt,
                        SYSDATE,
                        'Other Allowance',                  -- 'Basic Salary',
                        1,
                        src.headcode,
                        src.refno,
                        25);
    END LOOP;

    COMMIT;

    UPDATE t_sal_struc
       SET status = 'S'                                            --Submitted
     WHERE slno = 25 AND status = 'P';

    COMMIT;
END;
/