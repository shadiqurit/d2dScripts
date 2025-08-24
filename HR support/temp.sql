/* Formatted on 8/24/2025 2:34:09 PM (QP5 v5.362) */
SELECT ''        REFNO,
       ''        LTYPE,
hd.SLNO,
hd.EMPCODE,
hd.YEAROFSTRUC,
hd.EDATE,
hd.TRNDATE,
hd.PARTICULAR,
hd.DESIGCODE,
hd.AMOUNTPRV,
hd.AMOUNTCUR,
hd.SALPER,
hd.YEARMN,
hd.PRTCLR_TYPE,
hd.REFNO     HEADCODE
  FROM hr_salary_d hd, HR_EMPCHANGE hc
 WHERE  hd.EMPCODE = hc.EMPCODE
       
 
 hd.YEARMN = 202507                       -- AND EMPCODE = 'IPI-001448'
       AND slno IN (1,
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