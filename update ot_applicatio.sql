update ot_application
 SET FINAL_STATUS = 'Pending', IS_APPROVED1 = 1, IS_APPROVED2 = 'Y'
 WHERE     OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                      AND TO_DATE ('12/31/2024', 'MM/DD/YYYY') and 
     refno||empcode in ( SELECT o.refno||o.empcode
  FROM att_emp a, ot_application o, ot_master om
 WHERE     a.empcode = o.empcode
       AND a.attdate = o.otdate
       AND o.IS_APPROVED1 IS NULL
       AND REMARK = 'Holiday'
       -- AND a.office_out_time < a.outtime
       AND o.et1 <= a.outtime
       --AND TO_CHAR (a.outtime, 'HH:MI:SS AM') NOT BETWEEN '08:30:00 PM' AND '11:59:00 PM'
       AND o.refno = om.refno
       AND A.ATTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                         AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
)  ;
