CREATE OR REPLACE FORCE VIEW IPIHR.V_TRANSFER_DETAILS
AS
    WITH
        BaseData
        AS
            (SELECT hh.REFNO,
                    ep.EMPCODE,
                    ep.e_name,
                    ep.JOIN_DATE,
                    TO_CHAR (hh.REFDATE, 'DD-MON-YYYY')    AS REFDATE,
                    ep.location,
                    NULL                                   workstation,
                    hh.DPCODE                              AS fdepo,
                    hh.DP_CODE                             AS todepo,
                    hh.DP_NAME,
                    INCRTYPE,
                    hh.CCODE,
                    -- Duration Calculation
                    CASE
                        WHEN hh.REFDATE IS NOT NULL
                        THEN
                            CASE
                                -- JOIN_DATE to first REFDATE
                                WHEN LAG (hh.REFDATE)
                                         OVER (PARTITION BY hh.EMPCODE
                                               ORDER BY hh.REFDATE ASC)
                                         IS NULL
                                THEN
                                    TRIM (
                                           TO_CHAR (
                                               TRUNC (
                                                     MONTHS_BETWEEN (
                                                         hh.REFDATE,
                                                         ep.JOIN_DATE)
                                                   / 12))
                                        || ' Years '
                                        || TO_CHAR (
                                               MOD (
                                                   TRUNC (
                                                       MONTHS_BETWEEN (
                                                           hh.REFDATE,
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
                                -- REFDATE to REFDATE
                                WHEN LAG (hh.REFDATE)
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
                                                                 LAG (
                                                                     hh.REFDATE)
                                                                     OVER (
                                                                         PARTITION BY hh.EMPCODE
                                                                         ORDER BY
                                                                             hh.REFDATE ASC))))))
                                        || ' Days')
                            END
                        WHEN hh.REFDATE IS NULL
                        THEN
                            TRIM (
                                   TO_CHAR (
                                       TRUNC (
                                             MONTHS_BETWEEN (SYSDATE,
                                                             ep.JOIN_DATE)
                                           / 12))
                                || ' Years '
                                || TO_CHAR (
                                       MOD (
                                           TRUNC (
                                               MONTHS_BETWEEN (SYSDATE,
                                                               ep.JOIN_DATE)),
                                           12))
                                || ' Months '
                                || TO_CHAR (
                                       ROUND (
                                             SYSDATE
                                           - ADD_MONTHS (
                                                 ep.JOIN_DATE,
                                                 TRUNC (
                                                     MONTHS_BETWEEN (
                                                         SYSDATE,
                                                         ep.JOIN_DATE)))))
                                || ' Days')
                    END                                    AS duration,
                    -- Posting Type
                    CASE
                        WHEN LAG (hh.REFDATE)
                                 OVER (PARTITION BY hh.EMPCODE
                                       ORDER BY hh.REFDATE ASC)
                                 IS NULL
                        THEN
                            'Newly Appointed'
                        ELSE
                            'Transfer'
                    END                                    AS posting
               FROM HR_REVIEW_HISTORY  hh
                    LEFT JOIN emp ep ON ep.EMPCODE = hh.EMPCODE
              WHERE INCRTYPE IS NULL AND ep.emp_status = 'A'
             --  AND ep.EMPCODE = 'IPI-000514'
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
                                 OVER (PARTITION BY EMPCODE
                                       ORDER BY JOIN_DATE ASC)
                                 IS NULL
                        THEN
                            TRIM (
                                   TO_CHAR (
                                       TRUNC (
                                             MONTHS_BETWEEN (SYSDATE,
                                                             JOIN_DATE)
                                           / 12))
                                || ' Years '
                                || TO_CHAR (
                                       MOD (
                                           TRUNC (
                                               MONTHS_BETWEEN (SYSDATE,
                                                               JOIN_DATE)),
                                           12))
                                || ' Months '
                                || TO_CHAR (
                                       ROUND (
                                             SYSDATE
                                           - ADD_MONTHS (
                                                 JOIN_DATE,
                                                 TRUNC (
                                                     MONTHS_BETWEEN (
                                                         SYSDATE,
                                                         JOIN_DATE)))))
                                || ' Days')
                    END                  AS duration,
                    'Newly Appointed'    AS posting
               FROM emp ep
              WHERE     EMPCODE NOT IN (SELECT empcode
                                          FROM HR_REVIEW_HISTORY
                                         WHERE incrtype IS NULL)
                    AND ep.emp_status = 'A'),
        LastRow
        AS
            (  SELECT NULL                  AS REFNO,
                      ep.EMPCODE,
                      e_name,
                      JOIN_DATE,
                      'SYSDATE'             AS REFDATE,
                      NVL(ep.DEPOT,ep.location) location,
                      NULL                  AS fdepo,
                      NULL                  AS todepo,
                      NULL                  AS DP_NAME,
                      NULL                  AS INCRTYPE,
                      NULL                  AS CCODE,
                      TRIM (
                             TO_CHAR (
                                 TRUNC (
                                       MONTHS_BETWEEN (SYSDATE, MAX (REFDATE))
                                     / 12))
                          || ' Years '
                          || TO_CHAR (
                                 MOD (
                                     TRUNC (
                                         MONTHS_BETWEEN (SYSDATE,
                                                         MAX (REFDATE))),
                                     12))
                          || ' Months '
                          || TO_CHAR (
                                 ROUND (
                                       SYSDATE
                                     - ADD_MONTHS (
                                           MAX (REFDATE),
                                           TRUNC (
                                               MONTHS_BETWEEN (SYSDATE,
                                                               MAX (REFDATE))))))
                          || ' Days')       AS duration,
                      'Current Position'    AS posting
                 FROM HR_REVIEW_HISTORY hh
                      JOIN emp ep ON ep.EMPCODE = hh.EMPCODE
                WHERE INCRTYPE IS NULL AND ep.emp_status = 'A'
             --AND ep.EMPCODE = 'IPI-000514'
             GROUP BY ep.EMPCODE,
                      e_name,
                      JOIN_DATE,
                       NVL(ep.DEPOT,ep.location))
    SELECT "REFNO",
           "EMPCODE",
           "E_NAME",
           "JOIN_DATE",
           "REFDATE",
           "LOCATION",
           "FDEPO",
           "TODEPO",
           "DP_NAME",
           "INCRTYPE",
           "CCODE",
           "DURATION",
           "POSTING"
      FROM BaseData
    UNION ALL
    SELECT "REFNO",
           "EMPCODE",
           "E_NAME",
           "JOIN_DATE",
           "REFDATE",
           "LOCATION",
           "FDEPO",
           "TODEPO",
           "DP_NAME",
           "INCRTYPE",
           "CCODE",
           "DURATION",
           "POSTING"
      FROM LastRow;
