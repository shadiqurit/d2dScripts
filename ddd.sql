WITH Days AS (
  SELECT TO_DATE('01-JAN-2023', 'DD-MON-YYYY') + (LEVEL - 1) AS DayDate
  FROM DUAL
  CONNECT BY LEVEL <= 365
)
SELECT 
  TO_CHAR(DayDate, 'Day') AS DayName,
  TO_CHAR(DayDate, 'D') AS DayNumber
FROM Days;
