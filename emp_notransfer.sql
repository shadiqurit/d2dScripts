/* Formatted on 12/18/2024 5:17:21 PM (QP5 v5.362) */
  SELECT NULL                 REFNO,
         ep.EMPCODE,
         ep.e_name,
         ep.JOIN_DATE,
         NULL                 REFDATE,
         ep.location,
         NULL                 workstation,
         NULL                 fdepo,
         NULL                 todepo,
         NULL                 DP_NAME,
         NULL                 INCRTYPE,
         NULL                 CCODE,
         CASE
             WHEN LEAD (JOIN_DATE)
                      OVER (PARTITION BY EMPCODE ORDER BY JOIN_DATE ASC)
                      IS NULL
             THEN
                 TRIM (
                        TO_CHAR (
                            TRUNC (MONTHS_BETWEEN (SYSDATE, JOIN_DATE) / 12))
                     || ' Years '
                     || TO_CHAR (
                            MOD (TRUNC (MONTHS_BETWEEN (SYSDATE, JOIN_DATE)),
                                 12))
                     || ' Months '
                     || TO_CHAR (
                            ROUND (
                                  SYSDATE
                                - ADD_MONTHS (
                                      JOIN_DATE,
                                      TRUNC (
                                          MONTHS_BETWEEN (SYSDATE, JOIN_DATE)))))
                     || ' Days')
         END                  AS duration,
         'Newly Appointed'    AS posting
    FROM emp ep
   WHERE     EMPCODE NOT IN (SELECT empcode
                               FROM HR_REVIEW_HISTORY
                              WHERE incrtype IS NULL)
         AND ep.emp_status = 'A'
    AND ep.EMPCODE = 'IPI-007514'
ORDER BY JOIN_DATE ASC