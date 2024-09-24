/* Formatted on 9/12/2024 12:32:58 PM (QP5 v5.362) */
WITH
    cte
    AS
        (SELECT BASEDES     s
           FROM hr_base
          WHERE PARENTNAME = 'Designation' AND TYPE = 'Designation')
SELECT REGEXP_REPLACE (INITCAP (s), '([[:lower:]]| )') short
  FROM cte;