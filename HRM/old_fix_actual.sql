/* Formatted on 2/18/2026 10:31:07 AM (QP5 v5.362) */
  SELECT ma.emp_code,
         ma.NAME,
         des.DESIG_NAME,
         dep.SEC_NAME,
         emp.GRADE_ID,
         emp.JOIN_DATE,
         ABASIC,
         ((agross - 2450) / 3)
             HR,
         750
             MA,
         450
             TA,
         1250
             FA,
         agross
             Gross,
         ma.TOT_ATT,
         ma.att + NVL (ma.other_day, 0)
             att,
         ma.leave
             cl,
         ma.sl,
         ma.el,
         (NVL (ma.leave, 0) + NVL (ma.sl, 0) + NVL (ma.el, 0))
             tot_leave,
         ma.p_h_day,
         ma.wk,
         (  NVL (ma.att, 0)
          + NVL (ma.leave, 0)
          + NVL (ma.sl, 0)
          + NVL (ma.el, 0)
          + NVL (ma.p_h_day, 0)
          + NVL (ma.other_day, 0)
          + NVL (ma.wk, 0))
             total_days,
         (  NVL (ma.TOT_ATT, 0)
          - (  NVL (ma.att, 0)
             + NVL (ma.leave, 0)
             + NVL (ma.sl, 0)
             + NVL (ma.el, 0)
             + NVL (ma.other_day, 0)
             + NVL (ma.p_h_day, 0)
             + NVL (ma.wk, 0)))
             absent_days,
        round (  ((NVL (ABASIC, 0) + ((agross - 2450) / 3) + 2450) / ma.TOT_ATT)
          * (  NVL (ma.TOT_ATT, 0)
             - (  NVL (ma.att, 0)
                + NVL (ma.leave, 0)
                + NVL (ma.other_day, 0)
                + NVL (ma.sl, 0)
                + NVL (ma.el, 0)
                + NVL (ma.p_h_day, 0)
                + NVL (ma.wk, 0))))
             absent_amt,
        round (  (NVL (ABASIC, 0) + ((agross - 2450) / 3) + 2450)
          - round(((NVL (ABASIC, 0) + ((agross - 2450) / 3) + 2450) / ma.TOT_ATT)
             * (  NVL (ma.TOT_ATT, 0)
                - (  NVL (ma.att, 0)
                   + NVL (ma.leave, 0)
                   + NVL (ma.sl, 0)
                   + NVL (ma.other_day, 0)
                   + NVL (ma.el, 0)
                   + NVL (ma.p_h_day, 0)
                   + NVL (ma.wk, 0)))))
             pay_wages,
         (  ((NVL (ABASIC, 0) + ((agross - 2450) / 3) + 2450) / ma.TOT_ATT)
          * (NVL (ma.wrk_h_day, 0)))
             working_holid_amt,
         ma.wrk_h_day,
         ma.ot,
         10
             stmp,
         ma.REWORD,
         ma.EID_BONUS,
         ma.LESS_ADV,
         ma.bot,
         ma.bwk
    FROM hrm.menual_attendance   ma,
         hrm.EMPLOYEE_INFORMATION emp,
         hrm.DESIGNATION         des,
         hrm.PR_SECTION          dep
   WHERE     ma.SAL_YEAR = :P_year
         AND ma.SAL_MONTH = :P_month
         AND ma.DPT_ID = :P_dpt_id
         AND ma.emp_id = emp.eid
          
         AND emp.DESIG_ID = des.DESIG_ID
         AND ma.DPT_ID = dep.SEC_ID
        -- and ma.emp_code = :epm_code
ORDER BY ma.emp_code ASC