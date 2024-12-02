/* Formatted on 12/2/2024 5:26:37 PM (QP5 v5.362) */
  SELECT v.empcode             AS "Employee Code",
         b.e_name              AS "Employee Name",
         b.DESIG_NAME          AS "Designation",
         b.department_name     AS "Department",
         b.location            AS "Location",
         COUNT (attdate)       AS "Total Absent",
         ' '                   AS "Recommendation of HRD"
    FROM v_att_absent v, ipihr.emp b
   WHERE     v.empcode = b.empcode(+)
         AND EMP_STATUS = 'A'
         AND attdate BETWEEN :f_date AND :t_date
         AND NVL (b.empcode, -1) = NVL ( :p_empcode, NVL (b.empcode, -1))
GROUP BY v.empcode,
         b.e_name,
         b.DESIG_NAME,
         b.department_name,
         b.location
ORDER BY 6 DESC;


  SELECT v.empcode             AS "Employee Code",
         b.e_name              AS "Employee Name",
         b.DESIG_NAME          AS "Designation",
         b.department_name     AS "Department",
         b.location            AS "Location",
         (attdate)             AS "Total Absent",
         ' '                   AS "Recommendation of HRD"
    FROM v_att_absent v, ipihr.emp b
   WHERE     v.empcode = b.empcode(+)
         AND EMP_STATUS = 'A'
         AND attdate BETWEEN :f_date AND :t_date
         AND NVL (b.empcode, -1) = NVL ( :p_empcode, NVL (b.empcode, -1))
ORDER BY 6 DESC;