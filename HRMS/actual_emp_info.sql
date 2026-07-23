CREATE TABLE empinfo_update (
    empcode         VARCHAR2(50),
    Empno           VARCHAR2(50),
    Employeename    VARCHAR2(100),
    Businessunit    VARCHAR2(30),
    GRADE           VARCHAR2(30),
    Costcenter      VARCHAR2(100),
    Designation     VARCHAR2(100),
    Department      VARCHAR2(100),
    Paymenttype     VARCHAR2(100),
    Paysliplocation VARCHAR2(100),
    LocationName    VARCHAR2(100)
);

/* Formatted on 7/14/2026 1:12:47 PM (QP5 v5.362) */
CREATE TABLE empinfo_update
(
    empcode            VARCHAR2 (50),
    Empno              VARCHAR2 (50),
    Employeename       VARCHAR2 (100),
    Businessunit       VARCHAR2 (30),
    GRADE              VARCHAR2 (30),
    Costcenter         VARCHAR2 (100),
    Designation        VARCHAR2 (100),
    Department         VARCHAR2 (100),
    Paymenttype        VARCHAR2 (100),
    Paysliplocation    VARCHAR2 (100),
    LocationName       VARCHAR2 (100)
);

SELECT EMP_ID, STATUS, COM_ID
  FROM employees  
 WHERE  DEPT_ID IS NULL;
 
 UPDATE EMPLOYEES
 SET STATUS = 2, EMP_TYPE = 2
 WHERE  DEPT_ID IS NULL;
  SELECT  *
    FROM empinfo_update
   WHERE empcode IN (SELECT EMP_ID
                       FROM employees
                      WHERE JOB_ID IS NULL)
ORDER BY 1;

SELECT *
  FROM empinfo_update
 WHERE GRADE = 'DIR';

--cOMPANY job_grades

UPDATE EMPLOYEES
   SET JOB_ID = 21
 WHERE EMP_ID IN (SELECT EMPCODE
                    FROM empinfo_update
                   WHERE GRADE = 'DIR');

COMMIT;



--                   COM_UNIT