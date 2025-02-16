/* Formatted on 2/10/2025 5:28:38 PM (QP5 v5.362) */
MERGE INTO HR_OVERTIME_DET d
     USING (SELECT hd.EMPCODE,
                   hd.YEARMN,
                   CASE
                       WHEN TRUNC (MONTHS_BETWEEN (hd.REFDATE, d.JOIN_DATE)) >=
                            6
                       THEN
                           50
                       ELSE
                           45
                   END            AS upotrate,
                     round(CASE
                         WHEN TRUNC (
                                  MONTHS_BETWEEN (hd.REFDATE, d.JOIN_DATE)) >=
                              6
                         THEN
                             50
                         ELSE
                             45
                     END
                   * hd.OTHOUR )  AS upotamount
              FROM HR_OVERTIME_DET hd JOIN EMP d ON hd.empcode = d.empcode
             WHERE     DECODE (SUBSTR (hd.empcode, 1, 3),
                               'EMP', 'Casual',
                               'Regular') =
                       'Casual'
                   AND hd.YEARNO = 2025
                   AND hd.YEARMN = 202501) src
        ON (d.EMPCODE = src.EMPCODE AND d.YEARMN = src.YEARMN)
WHEN MATCHED
THEN
    UPDATE SET d.otamount = src.upotamount, d.otrate = src.upotrate;
/



  SELECT empcode,
         JOIN_DATE,
         CEIL (
             MONTHS_BETWEEN (
                 TO_DATE ('01' || LPAD ( :monthno, 2, 0) || :yearno,
                          'ddmmyyyy'),
                 JOIN_DATE))    MON
    FROM emp
   WHERE emp_status = 'A' AND SUBSTR (EMPCODE, 1, 3) IN ('EMP')
ORDER BY 3