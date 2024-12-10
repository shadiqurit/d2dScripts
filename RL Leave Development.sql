/* Formatted on 12/10/2024 12:28:23 PM (QP5 v5.362) */
SELECT DPUSER.get_leave_balance (TRIM (UPPER ( :APP_USER)),
                                 UPPER ( :P145_LEAVE_TYPE))    A
  FROM DUAL;

--V_EMP60MINUS
--leave_policy_web
--LEAVEPOLICY_LINK_V
--V_EMP60PLUS
--emp_service_02_rl
---emp_service_02_v

UPDATE hr_leave_child
   SET DURATION = 0
 WHERE     EMPCODE IN ('IPI-004157',
                       'IPI-001371',
                       'IPI-000831',
                       'IPI-000789',
                       'IPI-000790',
                       'IPI-002135',
                       'IPI-005078',
                       'IPI-002106',
                       'INM-000157',
                       'INM-000002',
                       'IPI-007377',
                       'IPI-007378',
                       'INM-000166',
                       'IPI-008117')
       AND LEAVEADTYPE = 'Opening'
       AND YEAR = 2024
       AND LEAVE_TYPE = 'EL';

BEGIN
    ipi_leave_calc_2;
--   ipi_leave_calc_2_rl;
-- ipi_leave_calc_2_rl;
END;

  SELECT leavetypename d, leave_type r
    FROM ipihr.leavetype_ipi
   WHERE    (    UPPER ( :P145_GENDER_D) = 'M'
             AND :P145_AGE < 60
             AND leave_type IN ('EL',
                                'CL',
                                'SL',
                                'LWP',
                                'EC'))
         OR (    (UPPER ( :P145_GENDER_D) = 'M' AND :P145_AGE >= 60)
             AND leave_type IN ('RL',
                                'CL',
                                'SL',
                                'LWP'))
         OR (    UPPER ( :P145_GENDER_D) = 'F'
             AND :P145_AGE < 60
             AND leave_type IN ('EL',
                                'CL',
                                'SL',
                                'LWP',
                                'ML',
                                'EC'))
ORDER BY LEAVETYPEID;



  SELECT leavetypename a, leave_type b
    FROM ipihr.leavetype_ipi
   WHERE    (    UPPER ( :p148_gender) = 'M'
             AND leave_type IN ('EL',
                                'CL',
                                'SL',
                                'LWP',
                                'EC'))
         OR (    UPPER ( :p148_gender) = 'F'
             AND leave_type IN ('EL',
                                'CL',
                                'SL',
                                'LWP',
                                'ML',
                                'EC'))
ORDER BY LEAVETYPEID