/* Formatted on 5/18/2025 4:38:57 PM (QP5 v5.362) */
--vo_review_history

CREATE TABLE hr_base_180525
AS
    SELECT * FROM hr_base;

CREATE TABLE emp_180525
AS
    SELECT * FROM emp;

CREATE TABLE hr_empchange_180525
AS
    SELECT * FROM hr_empchange;

CREATE TABLE hr_review_history_180525
AS
    SELECT * FROM hr_review_history;

CREATE TABLE hr_emp_review_180525
AS
    SELECT * FROM hr_emp_review;



  SELECT *
    FROM hr_base
   WHERE PARENTNAME = 'Designation'
ORDER BY BASENAME
-- AND 
--BASEID = 'DES-131'
;
UPDATE hr_base
   SET BASENAME = 'SENIOR MANAGER'
 WHERE BASEID = 'DES-162';



SELECT slno,
       refdate,
       empcode     empcode_s,
       ltype,
       sgrade_before,
       sgrade_after,
       incrtype,
       dpcode,
       DESIG_NAME_OLD,
       desig_name_after
  FROM hr_review_history
 WHERE incrtype IN
           ('Promotional', 'Accelerated Promotion', 'Management Order');

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
  FROM emp;


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
           END;