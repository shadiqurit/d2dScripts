/* Formatted on 6/30/2025 6:28:36 PM (QP5 v5.362) */
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
   SET REFDATE = TO_DATE('7/01/2025', 'MM/DD/YYYY')
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