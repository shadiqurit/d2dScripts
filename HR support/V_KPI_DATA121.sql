--CREATE OR REPLACE FORCE VIEW IPIHR.V_KPI_DATA121
--AS
    SELECT hc.REFNO,
           hc.LTYPE,
           hd.SLNO,
           hd.EMPCODE,
           hd.YEAROFSTRUC,
           SYSDATE                                 EDATE,
           TO_DATE ('8/24/2025', 'MM/DD/YYYY')     TRNDATE,
           hd.PARTICULAR,
           hd.DESIGCODE,
           hd.AMOUNTPRV,
           hd.AMOUNTCUR + kd.TOTAL                 AMOUNTCUR,
           hd.SALPER + kd.TOTAL                    SALPER,
           hd.YEARMN,
           hd.PRTCLR_TYPE,
           hd.REFNO                                HEADCODE
      FROM hr_salary_d hd, HR_EMPCHANGE hc, kpi_reward kd
     WHERE     hd.EMPCODE = hc.EMPCODE(+)
           AND hc.EMPCODE = KD.EMPCODE
           AND hc.LTYPE = '116'
           AND HD.SLNO = 121
           AND hc.REFDATE = TO_DATE ('1/1/2025', 'MM/DD/YYYY')
           AND hd.YEARMN = 202507
           AND hd.EMPCODE != 'IPI-001448'
           AND hd.slno IN (1,
                           5,
                           7,
                           10,
                           13,
                           15,
                           26,
                           31,
                           36,
                           37,
                           121);
