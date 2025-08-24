/* Formatted on 8/24/2025 4:02:01 PM (QP5 v5.362) */
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
    SELECT kd.REFNO,
           '116'                                   LTYPE,
           31                                      SLNO,
           kd.EMPCODE,
           2025,
           SYSDATE                                 EDATE,
           TO_DATE ('8/24/2025', 'MM/DD/YYYY')     TRNDATE,
           'MCMA Allowance'                     PARTICULAR,
           ''                                      DESIGCODE,
           0                                       AMOUNTPRV,
           0                                       AMOUNTCUR,
           0                                       SALPER,
           202508                                  YEARMN,
           1                                       PRTCLR_TYPE,
           '031'                                   HEADCODE
      FROM kpi_reward kd
     WHERE     EFFECTIVE_DATE = TO_DATE ('1/1/2025', 'MM/DD/YYYY')
           AND kd.EMPCODE NOT IN
                   (SELECT empcode
                      FROM HR_EMPINCR_DET
                     WHERE (    LTYPE = '116'
                            AND TRNDATE = TO_DATE ('8/24/2025', 'MM/DD/YYYY')
                            AND slno = '31'))