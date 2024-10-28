/* Formatted on 10/28/2024 4:40:51 PM (QP5 v5.362) */
SELECT SUM (salper)     gros_all
  FROM hr_salary_d dd, hr_salary_m mm
 WHERE     mm.yearmn = dd.yearmn
       AND mm.employeecode = dd.empcode
       AND mm.paytype = dd.paytype
       AND slno = 100
       AND mm.yearmn = '202409'
       AND mm.companyid = 'IPI';


       --151447457
       --131652164