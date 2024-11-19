/* Formatted on 11/19/2024 11:04:35 AM (QP5 v5.362) */
SELECT * FROM HR_SALARYGRADE;

UPDATE HR_SALARYGRADE
   SET RATE_REGULAR = NULL, RATE_HOLIDAY = NULL
 WHERE SGRADE BETWEEN 'GRADE-01' AND 'GRADE-04';
 COMMIT;

UPDATE HR_SALARYGRADE
   SET RATE_REGULAR = 700, RATE_HOLIDAY = 1500
 WHERE SGRADE BETWEEN 'GRADE-05' AND 'GRADE-06';

UPDATE HR_SALARYGRADE
   SET RATE_REGULAR = 600, RATE_HOLIDAY = 1100
 WHERE SGRADE BETWEEN 'GRADE-07' AND 'GRADE-10';

UPDATE HR_SALARYGRADE
   SET RATE_REGULAR = 500, RATE_HOLIDAY = 900
 WHERE SGRADE BETWEEN 'GRADE-11' AND 'GRADE-14';
 
 
 COMMIT;