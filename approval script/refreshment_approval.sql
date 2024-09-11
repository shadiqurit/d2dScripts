/* Formatted on 9/11/2024 10:33:49 AM (QP5 v5.362) */
-----Refreshment Approval NMD Factory------

UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'INM-000166'
       AND sl = 4
       AND MONTHWISESL <= 16
       AND REFRESHMENT_DATE BETWEEN '01-Jul-2024' AND '31-Jul-2024'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'FAC');
/

--- Refreshment Approval Pharma Factory ---

UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'IPI-000789'
       AND sl = 4
       AND MONTHWISESL <= 16
       AND REFRESHMENT_DATE BETWEEN '01-Jul-2024' AND '31-Jul-2024'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'FAC');
/

--- Refreshment Approval Head Office ---

UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'IPI-000789'
       AND sl = 4
       AND MONTHWISESL <= 4
       AND REFRESHMENT_DATE BETWEEN '01-Jul-2024' AND '31-Jul-2024'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'HDO');
/
