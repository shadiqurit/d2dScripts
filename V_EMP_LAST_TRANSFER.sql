/* Formatted on 12/26/2024 2:28:26 PM (QP5 v5.362) */
CREATE OR REPLACE FORCE VIEW IPIHR.V_EMP_LAST_TRANSFER
AS
    SELECT REFNO,
           EMPCODE,
           e_name,
           DEPARTMENT_NAME,
           DESIG_CODE,
           desig_name,
           BUSINESSUNIT,
           JOIN_DATE,
           REFDATE,
           location,
           NULL                 workstation,
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
               || ' Days')      AS duration,
           'Current Posting'    AS posting
      FROM (SELECT hh.REFNO,
                   ep.EMPCODE,
                   ep.e_name,
                   ep.DEPARTMENT_NAME,
                   DESIG_CODE,
                   desig_name,
                   BUSINESSUNIT,
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
             WHERE hh.INCRTYPE IS NULL AND ep.emp_status = 'A' -- AND ep.EMPCODE = 'IPI-008090'
                                                              ) t
     WHERE rn = 1
    UNION ALL
    SELECT NULL                 REFNO,
           ep.EMPCODE,
           ep.e_name,
           ep.DEPARTMENT_NAME,
           DESIG_CODE,
           desig_name,
           BUSINESSUNIT,
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
    ORDER BY JOIN_DATE ASC, REFDATE DESC;


GRANT SELECT ON IPIHR.V_EMP_LAST_TRANSFER TO DPUSER;