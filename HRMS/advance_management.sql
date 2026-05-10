/* Formatted on 5/5/2026 1:10:13 PM (QP5 v5.362) */
--hr_adv_requests
--hr_adv_approvals
--hr_adv_approval_step_setup
--hr_adv_issues
--hr_adv_installments
--hr_adv_ledger
--hr_adv_action_log


--allowance_head
--v_mm_sal_top
--v_monthly_salary_Sheet


SELECT v.REFNO,
       ve.EMP_ID,
       DEPT_ID,
       DESIG_ID,
       v.ADV_TYPE       adv_head_id,
       v.ISSUE_DATE     aaplication_date,
       v.ISSUE_DATE,
       v.ADV_AMOUNT,
       v.ADV_AMOUNT,
       v.NO_OF_INSTALL,
       v.INSTALL_AMOUNT,
       v.ADV_STATUS,
       'ISSUED'
  FROM V_ADV_ISSUE v, v_emp ve
 WHERE v.EMPCODE = ve.EMPCODE;


SELECT REF_NO,
       EMP_ID,
       DEPARTMENT_ID,
       DESIGNATION_ID,
       ADV_HEAD_ID,
       APPLICATION_DATE,
       ISSUE_DATE,
       REQUESTED_AMOUNT,
       APPROVED_AMOUNT,
       NO_OF_INSTALLMENT,
       INSTALLMENT_AMOUNT,
       ADV_STATUS,
       STATUS
  FROM HR_ADV_REQUESTS;



SELECT YEARMN,                                            ---Salary Year Month
       ADV_ID,
       INSTALLMENT_NO,                                                     ---
       DUE_DATE,
       INSTALLMENT_AMOUNT,                                                  --
       PAID_AMOUNT,
       STATUS,                                                     ---  'PAID'
       PAID_DATE,                                           --Installment date
       REMARKS
  FROM HR_ADV_INSTALLMENTS;