/* Formatted on 12/19/2024 11:39:57 AM (QP5 v5.362) */
CREATE OR REPLACE VIEW v_transfer_details
AS
      SELECT hh.REFNO,
             ep.EMPCODE,
             ep.e_name,
             ep.JOIN_DATE,
             hh.REFDATE,
             ep.location,
             hh.DPCODE     AS fdepo,
             hh.DP_CODE    AS todepo,
             hh.DP_NAME,
             INCRTYPE,
             ep.CCODE,
             -- Duration Calculation
             CASE
                 WHEN hh.REFDATE IS NOT NULL
                 THEN
                     CASE
                         --JOIN_DATE to first REFDATE
                         WHEN LAG (hh.REFDATE)
                                  OVER (PARTITION BY hh.EMPCODE
                                        ORDER BY hh.REFDATE ASC)
                                  IS NULL
                         THEN
                             TRIM (
                                    TO_CHAR (
                                        TRUNC (
                                              MONTHS_BETWEEN (hh.REFDATE,
                                                              ep.JOIN_DATE)
                                            / 12))
                                 || ' Years '
                                 || TO_CHAR (
                                        MOD (
                                            TRUNC (
                                                MONTHS_BETWEEN (hh.REFDATE,
                                                                ep.JOIN_DATE)),
                                            12))
                                 || ' Months '
                                 || TO_CHAR (
                                        ROUND (
                                              hh.REFDATE
                                            - ADD_MONTHS (
                                                  ep.JOIN_DATE,
                                                  TRUNC (
                                                      MONTHS_BETWEEN (
                                                          hh.REFDATE,
                                                          ep.JOIN_DATE)))))
                                 || ' Days')
                         --REFDATE to REFDATE
                         WHEN     LAG (hh.REFDATE)
                                      OVER (PARTITION BY hh.EMPCODE
                                            ORDER BY hh.REFDATE ASC)
                                      IS NOT NULL
                              AND LEAD (hh.REFDATE)
                                      OVER (PARTITION BY hh.EMPCODE
                                            ORDER BY hh.REFDATE ASC)
                                      IS NOT NULL
                         THEN
                             TRIM (
                                    TO_CHAR (
                                        TRUNC (
                                              MONTHS_BETWEEN (
                                                  hh.REFDATE,
                                                  LAG (hh.REFDATE)
                                                      OVER (
                                                          PARTITION BY hh.EMPCODE
                                                          ORDER BY
                                                              hh.REFDATE ASC))
                                            / 12))
                                 || ' Years '
                                 || TO_CHAR (
                                        MOD (
                                            TRUNC (
                                                MONTHS_BETWEEN (
                                                    hh.REFDATE,
                                                    LAG (hh.REFDATE)
                                                        OVER (
                                                            PARTITION BY hh.EMPCODE
                                                            ORDER BY
                                                                hh.REFDATE ASC))),
                                            12))
                                 || ' Months '
                                 || TO_CHAR (
                                        ROUND (
                                              hh.REFDATE
                                            - ADD_MONTHS (
                                                  LAG (hh.REFDATE)
                                                      OVER (
                                                          PARTITION BY hh.EMPCODE
                                                          ORDER BY
                                                              hh.REFDATE ASC),
                                                  TRUNC (
                                                      MONTHS_BETWEEN (
                                                          hh.REFDATE,
                                                          LAG (hh.REFDATE)
                                                              OVER (
                                                                  PARTITION BY hh.EMPCODE
                                                                  ORDER BY
                                                                      hh.REFDATE ASC))))))
                                 || ' Days')
                         --REFDATE to SYSDATE
                         WHEN LEAD (hh.REFDATE)
                                  OVER (PARTITION BY hh.EMPCODE
                                        ORDER BY hh.REFDATE ASC)
                                  IS NULL
                         THEN
                             TRIM (
                                    TO_CHAR (
                                        TRUNC (
                                              MONTHS_BETWEEN (SYSDATE,
                                                              hh.REFDATE)
                                            / 12))
                                 || ' Years '
                                 || TO_CHAR (
                                        MOD (
                                            TRUNC (
                                                MONTHS_BETWEEN (SYSDATE,
                                                                hh.REFDATE)),
                                            12))
                                 || ' Months '
                                 || TO_CHAR (
                                        ROUND (
                                              SYSDATE
                                            - ADD_MONTHS (
                                                  hh.REFDATE,
                                                  TRUNC (
                                                      MONTHS_BETWEEN (
                                                          SYSDATE,
                                                          hh.REFDATE)))))
                                 || ' Days')
                     END
                 WHEN hh.REFDATE IS NULL
                 THEN
                     TRIM (
                            TO_CHAR (
                                TRUNC (
                                    MONTHS_BETWEEN (SYSDATE, ep.JOIN_DATE) / 12))
                         || ' Years '
                         || TO_CHAR (
                                MOD (
                                    TRUNC (
                                        MONTHS_BETWEEN (SYSDATE, ep.JOIN_DATE)),
                                    12))
                         || ' Months '
                         || TO_CHAR (
                                ROUND (
                                      SYSDATE
                                    - ADD_MONTHS (
                                          ep.JOIN_DATE,
                                          TRUNC (
                                              MONTHS_BETWEEN (SYSDATE,
                                                              ep.JOIN_DATE)))))
                         || ' Days')
             END           AS duration,
             CASE
                 WHEN LAG (hh.REFDATE)
                          OVER (PARTITION BY hh.EMPCODE
                                ORDER BY hh.REFDATE ASC)
                          IS NULL
                 THEN
                     'Newly Appointed'
                 ELSE
                     'Transfer'
             END           AS posting
        FROM HR_REVIEW_HISTORY hh, emp ep
       WHERE     ep.EMPCODE = hh.EMPCODE(+)
             AND INCRTYPE IS NULL
             AND ep.emp_status = 'A'
             --AND ep.EMPCODE = 'IPI-000514'
    ORDER BY REFDATE ASC;