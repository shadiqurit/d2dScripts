DECLARE
    CURSOR dt IS
          SELECT EMPCODE,
                 REFNO,
                 bsprv,
                 bscr,
                 bssal,
                 pfprv,
                 ROUND ((bsprv / 100 * 10), 2)     up_pf_prv,
                 pfcur,
                 ROUND ((bscr / 100 * 10), 2)      up_pf_cur,
                 pfsal,
                 ROUND ((bssal / 100 * 10), 2)     up_pf_sal
            FROM (SELECT e1.REFNO,
                         e1.EMPCODE,
                         e1.AMOUNTPRV     AS bsprv,
                         e1.AMOUNTCUR     AS bscr,
                         e1.SALPER        AS bssal,
                         e2.AMOUNTPRV     AS pfprv,
                         e2.AMOUNTCUR     AS pfcur,
                         e2.SALPER        AS pfsal
                    FROM hr_empincr_det e1
                         JOIN hr_empincr_det e2 ON e1.EMPCODE = e2.EMPCODE
                   WHERE e1.slno = 1 AND e2.slno = 13 AND e1.REFNO = e2.REFNO)
           WHERE     (bsprv / 100 * 10) != pfprv
                 AND (bscr / 100 * 10) = pfcur
                 AND (bssal / 100 * 10) = pfsal
        ORDER BY 1 ASC;
BEGIN
    FOR x IN dt
    LOOP
        UPDATE hr_empincr_det b
           SET b.AMOUNTPRV = x.up_pf_prv,
               b.AMOUNTCUR = x.up_pf_cur,
               b.SALPER = x.up_pf_sal
         WHERE b.EMPCODE = x.empcode AND slno = 13 AND b.refno = x.REFNO;
    END LOOP;

    COMMIT;
END;