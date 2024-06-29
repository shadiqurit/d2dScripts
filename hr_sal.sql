/* Formatted on 29/Jun/24 10:07:27 AM (QP5 v5.362) */
SELECT SUM (salary) salary, SUM (DEDUCTION) ded, SUM (NET_AMOUNT) total
  FROM (  SELECT yearmn,
                 slno,
                 empcode,
                 headname,
                 CASE
                     WHEN SUM (NVL (salary, 0)) > 0 THEN SUM (NVL (salary, 0))
                     ELSE NULL
                 END                                     salary,
                 CASE
                     WHEN SUM (NVL (ded, 0)) > 0 THEN SUM (NVL (ded, 0))
                     ELSE NULL
                 END                                     deduction,
                 SUM (NVL (salary, 0) - NVL (ded, 0))    net_amount
            FROM (SELECT a.yearmn,
                         a.empcode,
                         a.slno,
                         b.headname,
                         a.salper     salary,
                         0            ded
                    FROM ipihr.hr_salary_d a, ipihr.hr_head b
                   WHERE a.slno = b.slno AND b.TYPE LIKE '1%'
                  UNION ALL
                  SELECT a.yearmn,
                         a.empcode,
                         a.slno,
                         b.headname,
                         0            salary,
                         a.salper     ded
                    FROM ipihr.hr_salary_d a, ipihr.hr_head b
                   WHERE a.slno = b.slno AND b.TYPE LIKE '2%')
           WHERE yearmn = :P392_YEARMN AND UPPER (empcode) = UPPER ( :app_user)
        GROUP BY yearmn,
                 empcode,
                 slno,
                 headname
          HAVING SUM (NVL (ded, 0) + NVL (salary, 0)) <> 0)