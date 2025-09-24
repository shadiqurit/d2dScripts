/* Formatted on 8/24/2025 2:54:39 PM (QP5 v5.362) */
INSERT INTO HR_EMPINCR_DET (REFNO,
                            LTYPE,
                            SLNO,
                            EMPCODE,
                            YEAROFSTRUC,
                            EDATE,
                            TRNDATE,
                            PARTICULAR,
                            DESIGCODE,
                            AMOUNTPRV,
                            AMOUNTCUR,
                            SALPER,
                            YEARMN,
                            PRTCLR_TYPE,
                            HEADCODE)
    SELECT hc.REFNO,
           hc.LTYPE,
           hd.SLNO,
           hd.EMPCODE,
           hd.YEAROFSTRUC,
           SYSDATE                                 EDATE,
           TO_DATE ('9/24/2025', 'MM/DD/YYYY')     TRNDATE,
           hd.PARTICULAR,
           hd.DESIGCODE,
           hd.AMOUNTPRV,
           hd.AMOUNTCUR,
           hd.SALPER,
           hd.YEARMN,
           1,
           hd.REFNO                                HEADCODE
      FROM hr_salary_d hd, HR_EMPCHANGE hc
     WHERE     hd.EMPCODE = hc.EMPCODE(+)
           AND hc.LTYPE = '116'
           AND hc.REFDATE = TO_DATE ('1/1/2025', 'MM/DD/YYYY')
           and hc.EDATE = TO_DATE('9/24/2025 5:43:19 AM', 'MM/DD/YYYY HH:MI:SS AM')
           AND hd.YEARMN = 202508
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
                           121)