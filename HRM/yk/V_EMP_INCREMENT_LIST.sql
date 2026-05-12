SELECT emp_id,
            card_no,
            emp_f_name,
            basic_salary,
            gross_salary,
            emp_joining_date,
            increment_month,
            TO_CHAR (increment_month, 'Mon-YYYY') incryearmonth,
            ROUND (basic_salary * 1.09) AS newbasic,
            ROUND ( (basic_salary * 1.09 * 1.5) + 2450) AS newgross
       FROM (    SELECT emp_id,
                        emp_code AS card_no,
                        emp_f_name,
                        basic_salary,
                        gross_salary,
                        emp_joining_date,
                        -- ?? Generate yearly increments
                        ADD_MONTHS (first_increment_month, (LEVEL - 1) * 12)
                           AS increment_month
                   FROM (SELECT emp_id,
                                emp_code,
                                emp_f_name,
                                basic_salary,
                                gross_salary,
                                emp_joining_date,
                                -- First increment month (after 1 year + cycle)
                                TRUNC (
                                   ADD_MONTHS (
                                      ADD_MONTHS (emp_joining_date, 12),
                                      CASE
                                         WHEN EXTRACT (
                                                 DAY FROM ADD_MONTHS (
                                                             emp_joining_date,
                                                             12)) >= 26
                                         THEN
                                            1
                                         ELSE
                                            0
                                      END),
                                   'MM')
                                   AS first_increment_month
                           FROM pr_employee_list
                          WHERE     emp_status = 'A'
                                AND emp_joining_date > DATE '2023-12-31')
             CONNECT BY     LEVEL <= 5                -- generate next 5 years
                        AND PRIOR emp_id = emp_id
                        AND PRIOR SYS_GUID () IS NOT NULL)
      WHERE increment_month BETWEEN DATE '2026-01-26' AND DATE '2026-02-25'
   ORDER BY emp_id;
