/* Formatted on 12/19/2024 10:21:50 AM (QP5 v5.362) */
CREATE OR REPLACE VIEW v_emp_last_transfer
AS
    SELECT REFNO,
           EMPCODE,
           e_name,
           JOIN_DATE,
           REFDATE,
           location,
           NULL               workstation,
           fdepo,
           todepo,
           DP_NAME,
           INCRTYPE,
           CCODE,
           -- Duration Calculation
           TRIM (
                  TO_CHAR (
                      TRUNC (
                            MONTHS_BETWEEN (SYSDATE,
                                            NVL (REFDATE, JOIN_DATE))
                          / 12))
               || ' Years '
               || TO_CHAR (
                      MOD (
                          TRUNC (
                              MONTHS_BETWEEN (SYSDATE,
                                              NVL (REFDATE, JOIN_DATE))),
                          12))
               || ' Months '
               || TO_CHAR (
                      ROUND (
                            SYSDATE
                          - ADD_MONTHS (
                                NVL (REFDATE, JOIN_DATE),
                                TRUNC (
                                    MONTHS_BETWEEN (SYSDATE,
                                                    NVL (REFDATE, JOIN_DATE))))))
               || ' Days')    AS duration,
           'Last Transfer'    AS posting
      FROM (SELECT hh.REFNO,
                   ep.EMPCODE,
                   ep.e_name,
                   ep.JOIN_DATE,
                   hh.REFDATE,
                   ep.location,
                   hh.DPCODE                              AS fdepo,
                   hh.DP_CODE                             AS todepo,
                   hh.DP_NAME,
                   hh.INCRTYPE,
                   ep.ccode,
                   ROW_NUMBER ()
                       OVER (PARTITION BY EP.EMPCODE
                             ORDER BY hh.REFDATE DESC)    AS rn
              FROM HR_REVIEW_HISTORY  hh
                   JOIN emp ep ON ep.EMPCODE = hh.EMPCODE
             WHERE     hh.INCRTYPE IS NULL
                   AND ep.emp_status = 'A'
                  -- AND ep.EMPCODE = 'IPI-008090'
                   ) t
     WHERE rn = 1
    UNION ALL
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
           CCODE,
           CASE
               WHEN LEAD (JOIN_DATE)
                        OVER (PARTITION BY EMPCODE ORDER BY JOIN_DATE ASC)
                        IS NULL
               THEN
                   TRIM (
                          TO_CHAR (
                              TRUNC (
                                  MONTHS_BETWEEN (SYSDATE, JOIN_DATE) / 12))
                       || ' Years '
                       || TO_CHAR (
                              MOD (
                                  TRUNC (MONTHS_BETWEEN (SYSDATE, JOIN_DATE)),
                                  12))
                       || ' Months '
                       || TO_CHAR (
                              ROUND (
                                    SYSDATE
                                  - ADD_MONTHS (
                                        JOIN_DATE,
                                        TRUNC (
                                            MONTHS_BETWEEN (SYSDATE,
                                                            JOIN_DATE)))))
                       || ' Days')
           END                  AS duration,
           'Newly Appointed'    AS posting
      FROM emp ep
     WHERE     EMPCODE NOT IN (SELECT empcode
                                 FROM HR_REVIEW_HISTORY
                                WHERE incrtype IS NULL)
           AND ep.emp_status = 'A'
          -- AND ep.EMPCODE = 'IPI-008090'
    ORDER BY JOIN_DATE ASC, REFDATE DESC