/* Formatted on 12/8/2024 12:27:25 PM (QP5 v5.362) */
-----Refreshment Approval NMD Factory------
UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'INM-000166'
       AND sl = 4
       AND MONTHWISESL <= 8
       AND REFRESHMENT_DATE BETWEEN '01-May-2025' AND '31-May-2025'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'FAC');
/

COMMIT;
/

--- Refreshment Approval Pharma Factory ---

UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'IPI-000789'
       AND sl = 4
       AND MONTHWISESL <= 8
       AND REFRESHMENT_DATE BETWEEN  '01-May-2025' AND '31-May-2025'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'FAC');
/

COMMIT;
/

--- Refreshment Approval Head Office ---

UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'IPI-000789'
       AND sl = 4
       AND MONTHWISESL <= 4
       AND REFRESHMENT_DATE BETWEEN '01-May-2025' AND '31-May-2025'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'HDO');
/


COMMIT;
/



UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'INM-000166'
       AND sl = 4
       AND MONTHWISESL <= 4
       AND REFRESHMENT_DATE BETWEEN '01-May-2025' AND '31-May-2025'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'HDO');
/


COMMIT;
/