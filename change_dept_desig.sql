/* Formatted on 7/7/2025 1:25:41 PM (QP5 v5.362) */
--vo_review_history

CREATE TABLE hr_base_30_jun_2025
AS
    SELECT * FROM hr_base;

CREATE TABLE emp_30_jun_2025
AS
    SELECT * FROM emp;

CREATE TABLE hr_empchange_30_jun_2025
AS
    SELECT * FROM hr_empchange;

CREATE TABLE hr_review_history_30_jun_2025
AS
    SELECT * FROM hr_review_history;

CREATE TABLE hr_emp_review_30_jun_2025
AS
    SELECT * FROM hr_emp_review;



INSERT INTO hr_review_history (SLNO,
                               REFNO,
                               REFDATE,
                               EMPCODE,
                               DPCODE,
                               USERNAME,
                               CCODE,
                               AMOUNT,
                               EDATE,
                               EMP_HRCODE,
                               INCRTYPE,
                               DATASOURCE,
                               YEARMN,
                               SGRADE_BEFORE,
                               SGRADE_AFTER,
                               INCRRATE,
                               DEPT,
                               DESIG_NAME_BEFORE,
                               DESIG_NAME_AFTER,
                               CONSIDER_NEXT_REVIEW,
                               STOP_REFNO)
    SELECT SLNO,
           REFNO,
           REFDATE,
           EMPCODE,
           DP_CODE,
           USERNAME,
           CCODE,
           AMOUNT,
           EDATE,
           EMPCODE,
           INCRTYPE,
           'Auto'     DATASOURCE,
           YEARMN,
           SGRADE_BEFORE,
           SGRADE_AFTER,
           INCRRATE,
           DEPARTMENT_NAME,
           DESIG_NAME_BEFORE,
           DESIG_NAME_BEFORE,
           CONSIDER_NEXT_REVIEW,
           'N'
      FROM vo_review_history;

  SELECT *
    FROM hr_base
   WHERE PARENTNAME = 'Designation'
ORDER BY BASENAME;

-- AND 
--BASEID = 'DES-131'

UPDATE EMP ee
   SET DESIG_NAME_OLD = desig_name
 WHERE ee.emp_status = 'A' AND ee.CATA = 'OFFICER';


SELECT slno,
       refdate,
       empcode     empcode_s,
       ltype,
       sgrade_before,
       sgrade_after,
       incrtype,
       dpcode,
       -- DESIG_NAME_OLD,
       desig_name_after
  FROM hr_review_history
 WHERE incrtype IN ('Promotional', 'Accelerated Promotion', 'Renaming');

SELECT empcode,
       e_name,
       CONFIRM_ST,
       BIRTHDATE,
       salarygrade,
       REFRESHMENT_GRADE,
       desig_code,
       desig_name,
       CASE
           WHEN DESIG_NAME_OLD = 'SR. MANAGER'
           THEN
               'DEPUTY GENERAL MANAGER'
           WHEN DESIG_NAME_OLD = 'MANAGER'
           THEN
               'ASSISTANT GENERAL MANAGER'
           WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-1'
           THEN
               'SENIOR MANAGER'
           WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-2'
           THEN
               'MANAGER'
           WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-1'
           THEN
               'DEPUTY MANAGER'
           WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-2'
           THEN
               'ASSISTANT MANAGER'
           WHEN DESIG_NAME_OLD = 'SR. EXECUTIVE'
           THEN
               'SENIOR EXECUTIVE'
           WHEN DESIG_NAME_OLD = 'EXECUTIVE'
           THEN
               'EXECUTIVE'
           WHEN DESIG_NAME_OLD = 'SR. OFFICER'
           THEN
               'ASSISTANT EXECUTIVE'
           WHEN DESIG_NAME_OLD = 'OFFICER -1'
           THEN
               'SENIOR OFFICER'
           WHEN DESIG_NAME_OLD = 'OFFICER-2'
           THEN
               'OFFICER'
           WHEN DESIG_NAME_OLD = 'JR. OFFICER'
           THEN
               'JUNIOR OFFICER'
           WHEN DESIG_NAME_OLD = 'MANAGER' AND depARTMENT_NAME = 'Marketing'
           THEN
               'SENIOR SALES MANAGER'
           WHEN     DESIG_NAME_OLD = 'DEPUTY MANAGER'
                AND depARTMENT_NAME = 'Marketing'
           THEN
               'SALES MANAGER'
           WHEN DESIG_NAME_OLD = 'REGIONAL MANAGER'
           THEN
               'DEPUTY SALES MANAGER'
           WHEN DESIG_NAME_OLD = 'ZONAL MANAGER'
           THEN
               'REGIONAL SALES MANAGER'
           WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION EXECUTIVE'
           THEN
               'SR. MEDICAL PROMOTION EXECUTIVE'
           WHEN DESIG_NAME_OLD = 'SR. MEDICAL PROMOTION OFFICER'
           THEN
               'MEDICAL PROMOTION EXECUTIVE'
           WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-1'
           THEN
               'SR. MEDICAL PROMOTION OFFICER'
           WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-2'
           THEN
               'MEDICAL PROMOTION OFFICER'
       END    DESIG_AFTR,
       DESIG_NAME_OLD,
       DESIG_SL,
       salarystep,
       salaryscal,
       emp_status,
       WEB_PASSWORD,
       BLD_GROUP
  FROM emp ee
 WHERE ee.emp_status = 'A' AND ee.CATA = 'OFFICER';


UPDATE EMP
   SET desig_name =
           CASE
               WHEN DESIG_NAME_OLD = 'SR. MANAGER'
               THEN
                   'DEPUTY GENERAL MANAGER'
               WHEN DESIG_NAME_OLD = 'MANAGER'
               THEN
                   'ASSISTANT GENERAL MANAGER'
               WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-1'
               THEN
                   'SENIOR MANAGER'
               WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-2'
               THEN
                   'MANAGER'
               WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-1'
               THEN
                   'DEPUTY MANAGER'
               WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-2'
               THEN
                   'ASSISTANT MANAGER'
               WHEN DESIG_NAME_OLD = 'SR. EXECUTIVE'
               THEN
                   'SENIOR EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'EXECUTIVE'
               THEN
                   'EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'SR. OFFICER'
               THEN
                   'ASSISTANT EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'OFFICER -1'
               THEN
                   'SENIOR OFFICER'
               WHEN DESIG_NAME_OLD = 'OFFICER-2'
               THEN
                   'OFFICER'
               WHEN DESIG_NAME_OLD = 'JR. OFFICER'
               THEN
                   'JUNIOR OFFICER'
               WHEN     DESIG_NAME_OLD = 'MANAGER'
                    AND depARTMENT_NAME = 'Marketing'
               THEN
                   'SENIOR SALES MANAGER'
               WHEN     DESIG_NAME_OLD = 'DEPUTY MANAGER'
                    AND depARTMENT_NAME = 'Marketing'
               THEN
                   'SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'REGIONAL MANAGER'
               THEN
                   'DEPUTY SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'ZONAL MANAGER'
               THEN
                   'REGIONAL SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION EXECUTIVE'
               THEN
                   'SR. MEDICAL PROMOTION EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'SR. MEDICAL PROMOTION OFFICER'
               THEN
                   'MEDICAL PROMOTION EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-1'
               THEN
                   'SR. MEDICAL PROMOTION OFFICER'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-2'
               THEN
                   'MEDICAL PROMOTION OFFICER'
           END
 WHERE emp_status = 'A' AND CATA = 'OFFICER';


UPDATE EMP ee
   SET DEPARTMENT_NAME_OLD = DEPARTMENT_NAME
 WHERE ee.emp_status = 'A';


UPDATE EMP
   SET DEPARTMENT_NAME =
           CASE
               WHEN DEPARTMENT_NAME_OLD = 'STRATEGIC MARKETING'
               THEN
                   'Marketing'
               WHEN DEPARTMENT_NAME_OLD = 'Sales and Distribution'
               THEN
                   'Distribution'
               WHEN DEPARTMENT_NAME_OLD = 'Marketing'
               THEN
                   'Sales'
               ELSE
                   DEPARTMENT_NAME
           END
 WHERE emp_status = 'A';


UPDATE emp e
   SET desig_sl =
           (SELECT MIN (v.gsl)
              FROM v_gsl v
             WHERE v.empcode = e.empcode)
 WHERE EXISTS
           (SELECT 1
              FROM v_gsl v
             WHERE v.empcode = e.empcode);

UPDATE hr_review_history hr
   SET UPDATEDATE = SYSDATE,
       DESIG_NAME_BEFORE =
           (SELECT desig_name
              FROM emp ee
             WHERE hr.empcode = ee.empcode)
 WHERE hr.USERNAME = 'M-ORDER' AND hr.DESIG_NAME_BEFORE IS NULL;

CREATE OR REPLACE VIEW v_gsl
AS
      SELECT DISTINCT empcode, desig_sl, gsl
        FROM emp ee, desig_sl s
       WHERE ee.desig_name = s.desig_name(+) AND emp_status = 'A'
    ORDER BY gsl ASC;

SELECT EMPCODE, DESIG_SL, GSL FROM v_gsl;

UPDATE emp
   SET desig_sl = gsl
 WHERE empcode = empcode;



CREATE TABLE desig_sl_bk
AS
    SELECT * FROM desig_sl;

DELETE FROM desig_sl
      WHERE sl BETWEEN 7 AND 40;


SELECT *
  FROM hr_base
 WHERE PARENTNAME = 'Designation';

SELECT DISTINCT desig_name_before
  FROM (SELECT slno,
               refdate,
               dept,
               empcode,
               ltype,
               sgrade_before,
               sgrade_after,
               incrtype,
               dpcode,
               desig_name_before,
               desig_name_after,
               ROW_NUMBER () OVER (PARTITION BY empcode ORDER BY slno DESC)    AS rn
          FROM hr_review_history
         WHERE incrtype IN ('Management Order'))
 WHERE rn = 1;



SELECT slno,
       refdate,
       empcode,
       ltype,
       sgrade_before,
       sgrade_after,
       incrtype,
       dpcode,
       desig_name_before,
       desig_name_after,
       CASE
           WHEN desig_name_before = 'SR. MANAGER'
           THEN
               'DEPUTY GENERAL MANAGER'
           WHEN desig_name_before = 'MANAGER'
           THEN
               'ASSISTANT GENERAL MANAGER'
           WHEN desig_name_before = 'DEPUTY MANAGER-1'
           THEN
               'SENIOR MANAGER'
           WHEN desig_name_before = 'DEPUTY MANAGER-2'
           THEN
               'MANAGER'
           WHEN desig_name_before = 'ASSISTANT MANAGER-1'
           THEN
               'DEPUTY MANAGER'
           WHEN desig_name_before = 'ASSISTANT MANAGER-2'
           THEN
               'ASSISTANT MANAGER'
           WHEN desig_name_before = 'SR. EXECUTIVE'
           THEN
               'SENIOR EXECUTIVE'
           WHEN desig_name_before = 'EXECUTIVE'
           THEN
               'EXECUTIVE'
           WHEN desig_name_before = 'SR. OFFICER'
           THEN
               'ASSISTANT EXECUTIVE'
           WHEN desig_name_before = 'OFFICER -1'
           THEN
               'SENIOR OFFICER'
           WHEN desig_name_before = 'OFFICER-2'
           THEN
               'OFFICER'
           WHEN desig_name_before = 'JR. OFFICER'
           THEN
               'JUNIOR OFFICER'
           WHEN desig_name_before = 'MANAGER' AND dept = 'Marketing'
           THEN
               'SENIOR SALES MANAGER'
           WHEN desig_name_before = 'DEPUTY MANAGER' AND dept = 'Marketing'
           THEN
               'SALES MANAGER'
           WHEN desig_name_before = 'REGIONAL MANAGER'
           THEN
               'DEPUTY SALES MANAGER'
           WHEN desig_name_before = 'ZONAL MANAGER'
           THEN
               'REGIONAL SALES MANAGER'
           WHEN desig_name_before = 'MEDICAL PROMOTION EXECUTIVE'
           THEN
               'SR. MEDICAL PROMOTION EXECUTIVE'
           WHEN desig_name_before = 'SR. MEDICAL PROMOTION OFFICER'
           THEN
               'MEDICAL PROMOTION EXECUTIVE'
           WHEN desig_name_before = 'MEDICAL PROMOTION OFFICER-1'
           THEN
               'SR. MEDICAL PROMOTION OFFICER'
           WHEN desig_name_before = 'MEDICAL PROMOTION OFFICER-2'
           THEN
               'MEDICAL PROMOTION OFFICER'
       END    AS desig_after
  FROM (SELECT slno,
               refdate,
               dept,
               empcode,
               ltype,
               sgrade_before,
               sgrade_after,
               incrtype,
               dpcode,
               desig_name_before,
               desig_name_after,
               ROW_NUMBER () OVER (PARTITION BY empcode ORDER BY slno DESC)    AS rn
          FROM hr_review_history
         WHERE incrtype IN ('Management Order'))
 WHERE rn = 1;


UPDATE hr_review_history
   SET REFDATE = TO_DATE ('7/01/2025', 'MM/DD/YYYY')
 WHERE     INCRTYPE = 'Renaming'
       AND USERNAME = 'M-ORDER'
       AND REFNO = '03/2025/34';

DELETE FROM hr_review_history
      WHERE USERNAME = 'M-ORDER' AND REFNO = '03/2025/34';



UPDATE hr_review_history
   SET DESIG_NAME_AFTER =
           CASE
               WHEN desig_name_before = 'SR. MANAGER'
               THEN
                   'DEPUTY GENERAL MANAGER'
               WHEN desig_name_before = 'MANAGER'
               THEN
                   'ASSISTANT GENERAL MANAGER'
               WHEN desig_name_before = 'DEPUTY MANAGER-1'
               THEN
                   'SENIOR MANAGER'
               WHEN desig_name_before = 'DEPUTY MANAGER-2'
               THEN
                   'MANAGER'
               WHEN desig_name_before = 'ASSISTANT MANAGER-1'
               THEN
                   'DEPUTY MANAGER'
               WHEN desig_name_before = 'ASSISTANT MANAGER-2'
               THEN
                   'ASSISTANT MANAGER'
               WHEN desig_name_before = 'SR. EXECUTIVE'
               THEN
                   'SENIOR EXECUTIVE'
               WHEN desig_name_before = 'EXECUTIVE'
               THEN
                   'EXECUTIVE'
               WHEN desig_name_before = 'SR. OFFICER'
               THEN
                   'ASSISTANT EXECUTIVE'
               WHEN desig_name_before = 'OFFICER -1'
               THEN
                   'SENIOR OFFICER'
               WHEN desig_name_before = 'OFFICER-2'
               THEN
                   'OFFICER'
               WHEN desig_name_before = 'JR. OFFICER'
               THEN
                   'JUNIOR OFFICER'
               WHEN desig_name_before = 'MANAGER' AND dept = 'Marketing'
               THEN
                   'SENIOR SALES MANAGER'
               WHEN     desig_name_before = 'DEPUTY MANAGER'
                    AND dept = 'Marketing'
               THEN
                   'SALES MANAGER'
               WHEN desig_name_before = 'REGIONAL MANAGER'
               THEN
                   'DEPUTY SALES MANAGER'
               WHEN desig_name_before = 'ZONAL MANAGER'
               THEN
                   'REGIONAL SALES MANAGER'
               WHEN desig_name_before = 'MEDICAL PROMOTION EXECUTIVE'
               THEN
                   'SR. MEDICAL PROMOTION EXECUTIVE'
               WHEN desig_name_before = 'SR. MEDICAL PROMOTION OFFICER'
               THEN
                   'MEDICAL PROMOTION EXECUTIVE'
               WHEN desig_name_before = 'MEDICAL PROMOTION OFFICER-1'
               THEN
                   'SR. MEDICAL PROMOTION OFFICER'
               WHEN desig_name_before = 'MEDICAL PROMOTION OFFICER-2'
               THEN
                   'MEDICAL PROMOTION OFFICER'
           END
 WHERE INCRTYPE = 'Renaming';


UPDATE EMP
   SET desig_name =
           CASE
               WHEN DESIG_NAME_OLD = 'SR. MANAGER'
               THEN
                   'DEPUTY GENERAL MANAGER'
               WHEN DESIG_NAME_OLD = 'MANAGER'
               THEN
                   'ASSISTANT GENERAL MANAGER'
               WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-1'
               THEN
                   'SENIOR MANAGER'
               WHEN DESIG_NAME_OLD = 'DEPUTY MANAGER-2'
               THEN
                   'MANAGER'
               WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-1'
               THEN
                   'DEPUTY MANAGER'
               WHEN DESIG_NAME_OLD = 'ASSISTANT MANAGER-2'
               THEN
                   'ASSISTANT MANAGER'
               WHEN DESIG_NAME_OLD = 'SR. EXECUTIVE'
               THEN
                   'SENIOR EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'EXECUTIVE'
               THEN
                   'EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'SR. OFFICER'
               THEN
                   'ASSISTANT EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'OFFICER -1'
               THEN
                   'SENIOR OFFICER'
               WHEN DESIG_NAME_OLD = 'OFFICER-2'
               THEN
                   'OFFICER'
               WHEN DESIG_NAME_OLD = 'JR. OFFICER'
               THEN
                   'JUNIOR OFFICER'
               WHEN     DESIG_NAME_OLD = 'MANAGER'
                    AND depARTMENT_NAME = 'Marketing'
               THEN
                   'SENIOR SALES MANAGER'
               WHEN     DESIG_NAME_OLD = 'DEPUTY MANAGER'
                    AND depARTMENT_NAME = 'Marketing'
               THEN
                   'SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'REGIONAL MANAGER'
               THEN
                   'DEPUTY SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'ZONAL MANAGER'
               THEN
                   'REGIONAL SALES MANAGER'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION EXECUTIVE'
               THEN
                   'SR. MEDICAL PROMOTION EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'SR. MEDICAL PROMOTION OFFICER'
               THEN
                   'MEDICAL PROMOTION EXECUTIVE'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-1'
               THEN
                   'SR. MEDICAL PROMOTION OFFICER'
               WHEN DESIG_NAME_OLD = 'MEDICAL PROMOTION OFFICER-2'
               THEN
                   'MEDICAL PROMOTION OFFICER'
           END
 WHERE emp_status = 'A' AND CATA = 'OFFICER';