--hr_yearly_appraisal
--auto_incr_salary


SELECT   empcode, SYSDATE refdate, staffid empno, e_name, desig_code,
               desig_name, d_code dept_code, department_name dept_name,
               refno lr_refno, last_review_date lr_refdate, edate lr_edate,
               ltype lr_type, ltypedes lr_typename, next_review_date nr_date,
               'Y' review_qualify, businessunitid, dp_code, depot dp_name
          FROM v$hr_emp_review
         WHERE next_review_date <= NVL (   TO_DATE('1/28/2026', 'MM/DD/YYYY'), TRUNC (SYSDATE))
         AND EMPCODE = 'IPI-006939'
      ORDER BY next_review_date, e_name;
      
      
      /* Formatted on 4/13/2026 12:32:18 PM (QP5 v5.362) */
CREATE TABLE HR_REVIEW_DET2604
AS
    SELECT * FROM HR_REVIEW_DET;

delete from HR_REVIEW_DET
where YEARMN = 202605;
commit;

UPDATE HR_REVIEW_DET
   SET REVIEW_QUALIFY = 'N'
 WHERE     YEARMN = 202604
       AND EMPCODE IN (SELECT EMPCODE
                         FROM HR_REVIEW_DET2604
                        WHERE REVIEW_QUALIFY = 'N' AND YEARMN = 202604);

COMMIT;