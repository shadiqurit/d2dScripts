WITH BaseData AS (
    SELECT 
        hh.REFNO,  
        hh.EMPCODE,
        ep.e_name,
        ep.JOIN_DATE,
        TO_CHAR(hh.REFDATE, 'DD-MON-YYYY') AS REFDATE,
        ep.location,
        hh.DPCODE AS fdepo,
        hh.DP_CODE AS todepo,
        hh.DP_NAME,
        INCRTYPE,
        hh.CCODE,
        -- Duration Calculation
        CASE  
            WHEN hh.REFDATE IS NOT NULL THEN
                CASE
                    -- JOIN_DATE to first REFDATE
                    WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN
                        TRIM(
                            TO_CHAR(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE) / 12)) || ' Years ' ||
                            TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE)), 12)) || ' Months ' ||
                            TO_CHAR(ROUND(hh.REFDATE - ADD_MONTHS(ep.JOIN_DATE, 
                            TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE))))) || ' Days'
                        )
                    -- REFDATE to REFDATE
                    WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NOT NULL THEN
                        TRIM(
                            TO_CHAR(TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                                LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC)) / 12)) || ' Years ' ||
                            TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                                LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC))), 12)) || ' Months ' ||
                            TO_CHAR(ROUND(hh.REFDATE - ADD_MONTHS(
                                LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC),
                                TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                                LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC)))))) || ' Days'
                        )
                END
            WHEN hh.REFDATE IS NULL THEN
                TRIM(
                    TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE) / 12)) || ' Years ' ||
                    TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE)), 12)) || ' Months ' ||
                    TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(ep.JOIN_DATE, 
                    TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE))))) || ' Days'
                )
        END AS duration,
        -- Posting Type
        CASE
            WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN 'Newly Appointed'
            ELSE 'Transfer'
        END AS posting
    FROM 
        HR_REVIEW_HISTORY hh
        LEFT JOIN emp ep ON ep.EMPCODE = hh.EMPCODE
    WHERE   
        INCRTYPE IS NULL        
        AND ep.emp_status = 'A'
        AND ep.EMPCODE = 'IPI-000250'
),
LastRow AS (
    SELECT
        NULL AS REFNO,
        ep.EMPCODE,
        e_name,
        JOIN_DATE,
        TO_CHAR(SYSDATE, 'DD-MON-YYYY') AS REFDATE,
        location,
        NULL AS fdepo,
        NULL AS todepo,
        NULL AS DP_NAME,
        NULL AS INCRTYPE,
        NULL AS CCODE,
        TRIM(
            TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, MAX(REFDATE)) / 12)) || ' Years ' ||
            TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, MAX(REFDATE))), 12)) || ' Months ' ||
            TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(MAX(REFDATE), 
            TRUNC(MONTHS_BETWEEN(SYSDATE, MAX(REFDATE)))))) || ' Days'
        ) AS duration,
        'Current Position' AS posting
    FROM 
        HR_REVIEW_HISTORY hh
        JOIN emp ep ON ep.EMPCODE = hh.EMPCODE
    WHERE   
        INCRTYPE IS NULL        
        AND ep.emp_status = 'A'
        AND ep.EMPCODE = 'IPI-000250'
    GROUP BY 
        EP.EMPCODE, ep.e_name, JOIN_DATE, location
)
SELECT * FROM BaseData
UNION ALL
SELECT * FROM LastRow
;
