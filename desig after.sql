/* Formatted on 5/18/2025 3:16:04 PM (QP5 v5.362) */
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
       END        AS desig_after
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
 
 
 update  hr_review_history
set INCRTYPE = 'Renaming'
WHERE INCRTYPE = 'Management Order'
and  USERNAME = 'M-ORDER'
AND REFNO = '03/2025/34';

delete from  hr_review_history

WHERE USERNAME = 'M-ORDER'
AND REFNO = '03/2025/34';


/* Formatted on 5/18/2025 3:19:29 PM (QP5 v5.362) */
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
 WHERE INCRTYPE = 'Management Order';