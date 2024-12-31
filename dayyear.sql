-- Input the year you want to check
SELECT 
    CASE 
        WHEN MOD(:input_year, 400) = 0 OR (MOD(:input_year, 4) = 0 AND MOD(:input_year, 100) != 0) THEN 366
        ELSE 365
    END AS days_in_year
FROM dual;


SELECT 
       ROUND(SYSDATE - TRUNC(SYSDATE, 'YEAR') + 1) AS INTO v_dayyear
FROM dual;
