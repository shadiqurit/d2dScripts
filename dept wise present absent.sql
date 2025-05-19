/* Formatted on 5/14/2025 12:20:59 PM (QP5 v5.362) */
  SELECT COUNT (status)     TOTAL_PRESENT,
         department_name,
         location_att,
         status
    FROM (  SELECT a.department_name,
                   a.sub_department_name,
                   a.location_att,
                   a.checkin_status,
                   a.checkout_status,
                   b.desig_sl,
                   a.attstatus,
                   a.attdate,
                   a.empcode,
                   a.yearmn,
                   a.overall_status,
                   status,
                   remark
              FROM ipihr.att_emp_v a, ipihr.emp b
             WHERE     TRUNC (attdate) =
                       NVL (TRUNC (TO_DATE ( :p_fdate, 'DD-MON-RR')),
                            TRUNC (attdate))
                   AND a.empcode = b.empcode
                   AND b.emp_status = 'A'
                   AND a.location_att = 'FAC'
          ORDER BY b.desig_sl, a.empcode, a.attdate)
GROUP BY department_name, status, location_att