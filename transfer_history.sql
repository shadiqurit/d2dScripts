SELECT hh.REFNO,  
       hh.EMPCODE,
       ep.e_name,
       ep.JOIN_DATE,
       to_char(hh.REFDATE, 'DD-MON-YYYY'),
       ep.location,
       hh.DPCODE AS fdepo,
       hh.DP_CODE AS todepo,
       hh.DP_NAME,
       INCRTYPE,
       hh.CCODE,
       -- Duration Calculation
       case  WHEN hh.REFDATE IS not NULL THEN
       CASE
           --JOIN_DATE to first REFDATE
           WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE) / 12)) || ' Years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE)), 12)) || ' Months ' ||
                   TO_CHAR(ROUND(hh.REFDATE - ADD_MONTHS(ep.JOIN_DATE, 
                   TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE))))) || ' Days'
               )
           --REFDATE to REFDATE
           WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NOT NULL AND
                LEAD(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NOT NULL THEN
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
           --REFDATE to SYSDATE
           WHEN LEAD(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE) / 12)) || ' Years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE)), 12)) || ' Months ' ||
                   TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(hh.REFDATE, 
                   TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE))))) || ' Days'
               )
       END WHEN hh.REFDATE IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE) / 12)) || ' Years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE)), 12)) || ' Months ' ||
                   TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(ep.JOIN_DATE, 
                   TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE))))) || ' Days'
               )
       END AS duration,
        CASE
           WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN 'Newly Appointed'
           ELSE 'Transfer'
       END AS posting
  FROM HR_REVIEW_HISTORY hh, emp ep
 WHERE   ep.EMPCODE = hh.EMPCODE(+)
      AND INCRTYPE is null        
       AND ep.emp_status = 'A'
      AND ep.EMPCODE = 'IPI-000514'
ORDER BY REFDATE ASC;



SELECT REFNO,  
       EMPCODE,
       e_name,
       JOIN_DATE,
       REFDATE,
       location,
       fdepo,
       todepo,
       DP_NAME,
       INCRTYPE,
       CCODE,
       -- Duration Calculation
       TRIM(
           TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, REFDATE) / 12)) || ' Years ' ||
           TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, REFDATE)), 12)) || ' Months ' ||
           TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(REFDATE, TRUNC(MONTHS_BETWEEN(SYSDATE, REFDATE))))) || ' Days'
       ) AS duration
FROM (
    SELECT hh.REFNO,  
           hh.EMPCODE,
           ep.e_name,
           ep.JOIN_DATE,
           hh.REFDATE,
           ep.location,
           hh.DPCODE AS fdepo,
           hh.DP_CODE AS todepo,
           hh.DP_NAME,
           hh.INCRTYPE,
           hh.CCODE,
           ROW_NUMBER() OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE DESC) AS rn
    FROM HR_REVIEW_HISTORY hh
    JOIN emp ep ON ep.EMPCODE = hh.EMPCODE(+)
    WHERE hh.INCRTYPE IS NULL
      AND ep.emp_status = 'A'
      AND ep.EMPCODE = 'IPI-000514'
) t
WHERE rn = 1
ORDER BY REFDATE ASC;
