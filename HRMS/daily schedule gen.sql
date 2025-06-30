/* Formatted on 6/24/2025 8:42:31 AM (QP5 v5.362) */
SELECT e.EMP_ID,
       e.BRANCH_ID,
       TO_TIMESTAMP (
           TO_CHAR (SYSDATE, 'MM/DD/YYYY') || ' ' || o.OFFICE_START,
           'MM/DD/YYYY HH:MI AM')              AS REGULAR_IN_TIME,
       TO_TIMESTAMP (TO_CHAR (SYSDATE, 'MM/DD/YYYY') || ' ' || o.OFFICE_END,
                     'MM/DD/YYYY HH:MI AM')    AS REGULAR_OUT_TIME
  FROM OFFICE_SCHEDULE o, employees e
 WHERE     o.LOCATION_ID = e.BRANCH_ID
       -- AND o.LOCATION_ID = 0
       AND TO_CHAR (SYSDATE, 'MM/DD/YYYY') BETWEEN TO_CHAR (
                                                       SCHEDULE_START_DATE,
                                                       'MM/DD/RRRR')
                                               AND TO_CHAR (
                                                       SCHEDULE_END_DATE,
                                                       'MM/DD/RRRR')
--  AND e.EMP_ID = :EMP_ID
;

SELECT e.EMP_ID,
       e.BRANCH_ID,
       TO_TIMESTAMP (
              TO_CHAR (TRUNC (SYSDATE, 'MM'), 'MM/DD/YYYY')
           || ' '
           || o.OFFICE_START,
           'MM/DD/YYYY HH:MI AM')    AS REGULAR_IN_TIME,
       TO_TIMESTAMP (
              TO_CHAR (TRUNC (SYSDATE, 'MM'), 'MM/DD/YYYY')
           || ' '
           || o.OFFICE_END,
           'MM/DD/YYYY HH:MI AM')    AS REGULAR_OUT_TIME
  FROM OFFICE_SCHEDULE o JOIN employees e ON o.LOCATION_ID = e.BRANCH_ID
 WHERE TO_CHAR (SYSDATE, 'MM/DD/YYYY') BETWEEN TO_CHAR (SCHEDULE_START_DATE,
                                                        'MM/DD/RRRR')
                                           AND TO_CHAR (SCHEDULE_END_DATE,
                                                        'MM/DD/RRRR')
                                                        AND e.EMP_ID = :EMP_ID;