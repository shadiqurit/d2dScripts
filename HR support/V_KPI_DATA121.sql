--/* Formatted on 9/24/2025 12:32:36 PM (QP5 v5.362) */
--CREATE OR REPLACE FORCE VIEW IPIHR.V_KPI_DATA121
--AS
    SELECT hc.REFNO,
           hc.LTYPE,
           hd.SLNO,
           hd.EMPCODE,
           hd.YEAROFSTRUC,
           SYSDATE                                 EDATE,
           TO_DATE ('10/23/2025', 'MM/DD/YYYY')     TRNDATE,
           hd.PARTICULAR,
           hd.DESIGCODE,
           hd.AMOUNTPRV,
           hd.AMOUNTCUR + kd.TOTAL                 AMOUNTCUR,
           hd.SALPER + kd.TOTAL                    SALPER,
           hd.YEARMN,
           hd.PRTCLR_TYPE,
           hd.REFNO                                HEADCODE
      FROM hr_salary_d hd, HR_EMPCHANGE hc, kpi_reward kd
     WHERE      hc.EMPCODE = hd.EMPCODE (+)
           AND KD.EMPCODE = hc.EMPCODE
           AND hc.LTYPE = '116'
           AND HD.SLNO = 121
           AND hc.REFDATE = TO_DATE ('1/1/2025', 'MM/DD/YYYY')
           AND hd.YEARMN = 202509