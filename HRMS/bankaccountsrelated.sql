/* Formatted on 7/13/2026 2:11:41 PM (QP5 v5.362) */
-----IPIHR BANK Start-----

SELECT BANK_ID,
       BANKACCNO,
       BANKNAME,
       BRANCH_NAME,
       BCODE,
       empcode
  FROM emp
 WHERE EMP_STATUS = 'A' AND BANKACCNO IS NOT NULL;



UPDATE EMP
   SET BANKNAME = 'Islami Bank Bangladesh PLC'
 WHERE BANKNAME = 'Islami Bank Bangladesh PLC.' AND EMP_STATUS = 'A';

-----IPIHR BANK End-----

INSERT INTO HR_EMP_BANK_INFO (EMP_ID,
                              BANK_ID,
                              ACCOUNT_NAME,
                              ACCOUNT_NO,
                              IS_ACTIVE,
                              IS_SALARY_ACCOUNT)
    SELECT v.EMP_ID,
           26           bankid,
           FULLNAME     accname,
           bi.BANKACCNO,
           --  bi.EMPCODE,
           'Y'          IS_ACTIVE,
           'Y'          IS_SALARY_ACCOUNT
      FROM BANK_INFO_IPIHR bi, v_emp v
     WHERE v.EMPCODE = bi.EMPCODE;

SELECT ms.total_earning, ms.total_deduction, ms.net_salary
  FROM monthly_salary ms
 WHERE ms.salary_month = :P_SALARY_MONTH;

SELECT NVL (EMPCODE, '')                               employeeid,
       NVL (EMPCODE, '')                               empcode,
       NVL (FULLNAME, '')                              empname,
       NVL (TO_CHAR (JOIN_DATE, 'DD/MM/YYYY'), '')     doj,
       NVL (JOBLOC, '')                                loc,
       NVL (GRADE, '')                                 grade,
       NVL (DEPARTMENT, '')                            dep,
       NVL (DESIGNATION, '')                           des,
       b.ACCOUNT_NO                                    bankacc,
       ms.net_salary                                   amount
  FROM v_emp v, monthly_salary ms, HR_EMP_BANK_INFO b
 WHERE     v.EMP_ID = ms.EMPLOYEE_ID
       AND v.EMP_ID = b.EMP_ID(+)
       AND SALARY_MONTH = :P478_YEARMN
       AND IS_SALARY_ACCOUNT = 'Y'
--   AND IS_ACTIVE = 'Y'