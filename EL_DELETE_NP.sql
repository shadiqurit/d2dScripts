/* Formatted on 15/Aug/24 11:28:24 AM (QP5 v5.362) */
--CREATE TABLE hr_leave_child_150824 AS SELECT * FROM hr_leave_child;


DELETE
  FROM hr_leave_child
 WHERE     LEAVE_TYPE = 'EL'
       AND YEAR = 2024
       AND LEAVEADTYPE = 'Opening'
       AND empcode IN
               (SELECT empcode
                  FROM emp
                 WHERE     emp_status = 'A'
                       AND JOIN_DATE < TO_DATE ('31/Aug/2022', 'DD/MON/YY')
                       AND CATA = 'NON OFFICER')