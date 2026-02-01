/* Formatted on 10/23/2025 12:47:31 PM (QP5 v5.362) */
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
           '116'                                    LTYPE,
           121                                      SLNO,
           kd.EMPCODE,
           2025,
           SYSDATE                                  EDATE,
           TO_DATE ('10/23/2025', 'MM/DD/YYYY')     TRNDATE,
           'Allowance for Special Achievement'      PARTICULAR,
           ''                                       DESIGCODE,
           0                                        AMOUNTPRV,
           TOTAL                                    AMOUNTCUR,
           TOTAL                                    SALPER,
           202510                                   YEARMN,
           1                                        PRTCLR_TYPE,
           '121'                                    HEADCODE
      FROM kpi_reward kd
     WHERE     EFFECTIVE_DATE = TO_DATE ('1/1/2025', 'MM/DD/YYYY')
           AND kd.EMPCODE NOT IN
                   (SELECT empcode
                      FROM HR_EMPINCR_DET
                     WHERE (    LTYPE = '116'
                            AND TRNDATE =
                                TO_DATE ('10/23/2025', 'MM/DD/YYYY')
                            AND slno = '121'))