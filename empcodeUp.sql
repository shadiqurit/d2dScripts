ALTER TABLE HRMS.EMPLOYEES
 ADD CONSTRAINT EMPLOYEES_U02
  UNIQUE (EMPID);


SELECT  EMPID, COUNT(*) 
FROM HRMS.EMPLOYEES
GROUP BY EMPID
HAVING COUNT(*) > 1;

select id, emp_id, empid, mc_id, EMPNO, f_name, l_name
from employees
where id between 140 and 9915;


update employees
set id = empid
where id between 100 and 9915;

delete from LEAVE_ALLOCATION
where empid between 100 and 9915;

