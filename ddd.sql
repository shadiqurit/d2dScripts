/* Formatted on 11/25/2024 8:08:07 AM (QP5 v5.362) */
WITH
    Days
    AS
        (    SELECT TO_DATE ('01-JAN-2024', 'DD-MON-YYYY') + (LEVEL - 1)    AS DayDate
               FROM DUAL
         CONNECT BY LEVEL <= 1)
SELECT ROWNUM                               nthday,
       TO_CHAR (DayDate, 'DD-MON-YYYY')     dateinyear,
       TO_CHAR (DayDate, 'Day')             AS DayName,
       TO_CHAR (DayDate, 'D')               AS DayNumber
  FROM Days;