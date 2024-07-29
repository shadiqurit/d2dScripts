-----manual att_approve------


update manual_att_approval
set FINAL_STATUS = 'Y',
FINAL_STATUS_DETAIL = 'APPROVED',
STATUS_L5 = = 'Y',
FINAL_STATUS_DETAIL_2 = 'Finally Approved By  HR Department',
SL = '100',
FINAL_APPROVAL_DATE =  SYSDATE
--WHERE EMPCODE_5_HOHR = 'IPI-007478';
UPPER ( 'IPI-007478') IN (empcode_1_rp,
                                    empcode_2_hod,
                                    empcode_3_gm,
                                    empcode_4_md,
                                    empcode_5_hohr)
         AND EXISTS
                 (SELECT 1
                    FROM dpuser.manual_att_approval_1 y
                   WHERE a = UPPER ('IPI-007478') AND x.ID = y.ID AND y.c = x.sl);






UPDATE refreshment_approval
   SET FINAL_APPROVAL_DATE = SYSDATE, STATUS_L4 = 'Y'
 WHERE     EMPCODE_4_MD = 'INM-000166'
       AND sl = 4
       AND REFRESHMENT_DATE BETWEEN '01-Sep-2023' AND '30-Sep-2023'
       AND empcode IN (SELECT empcode
                         FROM ipihr.emp
                        WHERE dp_code = 'FAC')

select count(*) from refreshment_approval
where EMPCODE_4_MD='IPI-000789'
and sl=4

and REFRESHMENT_DATE between '01-Sep-2023' and '30-Sep-2023'
and empcode in (select empcode from ipihr.emp where dp_code='FAC')




UPDATE leave_approval
   SET STATUS_L5 = 'Y', FINAL_APPROVAL_DATE = SYSDATE
 WHERE     EMPCODE_5_hohr = 'IPI-007478'
       AND sl = 5
       AND APPROVED_DAYS <= 3
       AND APPROVED_LEAVE_TYPE IN ('CL', 'SL')
       AND empcode IN (SELECT empcode FROM ipihr.emp);
       commit;
