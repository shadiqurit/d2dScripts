/* Formatted on 7/21/2026 12:53:04 PM (QP5 v5.362) */
  SELECT a.empcode,
         a.desig_name,
         a.department_name,
         a.sub_department_name,
         a.location_att,
         a.checkin_status,
         a.checkout_status,
         b.desig_sl,
         a.office_out_time,
         a.office_in_time,
         a.remark,
         a.attstatus,
         a.out_time_wdate,
         a.in_time_wdate,
         a.attdate,
         a.empcode,
         a.e_name,
         a.join_date,
         a.empcodehr,
         a.base_month,
         a.base_year,
         a.yearmn,
         a.total_hours,
         a.total_hours_short,
         a.overall_status,
         status,
         remark,
         a.outtime,
         a.intime,
         TO_CHAR (outtime, 'hh:mi AM')
             outtime_a,
         TO_CHAR (intime, 'hh:mi AM')
             intime_a,
         earlyout,
         latein,
         NVL (DECODE (status, 'P', 1, 0), 0)
             present_b,
         NVL (DECODE (status, 'P', DECODE (SIGN (latein), 1, 1, 0), 0), 0)
             latein_b,
         NVL (DECODE (status, 'P', DECODE (SIGN (earlyout), 1, 1, 0), 0), 0)
             earlyout_b,
         NVL (DECODE (status, 'L', 1, 0), 0)
             leave_b,
         NVL (DECODE (status, 'A', 1, 0), 0)
             absent_b,
         NVL (DECODE (status, 'OF', 1, 0), 0)
             tour_b,
         NVL (DECODE (status, 'H', 1, 0) + DECODE (status, 'W', 1, 0), 0)
             holiday_b,
         a.in_location,
         a.out_location
    FROM ipihr.att_emp_v a, ipihr.emp b
   WHERE     NVL (b.businessunitid, '#') =
             NVL ( :p_unitid, NVL (b.businessunitid, '#'))
         AND TRUNC (attdate) =
             NVL (TRUNC (TO_DATE ( :p_fdate, 'DD-MON-RR')), TRUNC (attdate))
         AND a.empcode = b.empcode
         AND b.emp_status = 'A'
         AND NVL (a.department_name, '#') =
             NVL ( :p_d_code, NVL (a.department_name, '#'))
         AND NVL (a.LOCATION, '#') = NVL ( :p_dp_code, NVL (a.LOCATION, '#'))
         AND DECODE (
                 :p_status,
                 'LATEIN', DECODE (
                               a.status,
                               'P', DECODE (SIGN (latein),
                                            1, 'LATEIN',
                                            a.status),
                               a.status),
                 'EARLYOUT', DECODE (
                                 a.status,
                                 'P', DECODE (SIGN (earlyout),
                                              1, 'EARLYOUT',
                                              a.status),
                                 a.status),
                 NVL (a.status, '#')) =
             NVL ( :p_status, NVL (a.status, '#'))
         AND NVL (b.section_name, '#') =
             NVL ( :p_section_name, NVL (b.section_name, '#'))
ORDER BY b.desig_sl, a.empcode, a.attdate