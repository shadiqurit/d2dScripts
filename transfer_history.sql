SELECT hh.REFNO,  
       hh.EMPCODE,
       ep.e_name,
       ep.JOIN_DATE,
       hh.REFDATE,
       ep.location,
       hh.DPCODE AS fdepo,
       hh.DP_CODE AS todepo,
       hh.DP_NAME,
       INCRTYPE,
       hh.CCODE,
       -- Duration Calculation
       case  WHEN hh.REFDATE IS not NULL THEN
       CASE
           -- First row: JOIN_DATE to first REFDATE
           WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE) / 12)) || ' years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE)), 12)) || ' months ' ||
                   TO_CHAR(ROUND(hh.REFDATE - ADD_MONTHS(ep.JOIN_DATE, 
                   TRUNC(MONTHS_BETWEEN(hh.REFDATE, ep.JOIN_DATE))))) || ' days'
               )
           -- Intermediate rows: REFDATE to REFDATE
           WHEN LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NOT NULL AND
                LEAD(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NOT NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                       LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC)) / 12)) || ' years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                       LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC))), 12)) || ' months ' ||
                   TO_CHAR(ROUND(hh.REFDATE - ADD_MONTHS(
                       LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC),
                       TRUNC(MONTHS_BETWEEN(hh.REFDATE, 
                       LAG(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC)))))) || ' days'
               )
           -- Last row: REFDATE to SYSDATE
           WHEN LEAD(hh.REFDATE) OVER (PARTITION BY hh.EMPCODE ORDER BY hh.REFDATE ASC) IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE) / 12)) || ' years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE)), 12)) || ' months ' ||
                   TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(hh.REFDATE, 
                   TRUNC(MONTHS_BETWEEN(SYSDATE, hh.REFDATE))))) || ' days'
               )
       END WHEN hh.REFDATE IS NULL THEN
               TRIM(
                   TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE) / 12)) || ' years ' ||
                   TO_CHAR(MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE)), 12)) || ' months ' ||
                   TO_CHAR(ROUND(SYSDATE - ADD_MONTHS(ep.JOIN_DATE, 
                   TRUNC(MONTHS_BETWEEN(SYSDATE, ep.JOIN_DATE))))) || ' days'
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
       AND ep.EMPCODE = 'IPI-007514'
ORDER BY REFDATE ASC;
