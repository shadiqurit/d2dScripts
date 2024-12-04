/* Formatted on 12/4/2024 12:05:58 PM (QP5 v5.362) */
---Report Query Updated---

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
         AND v.attdate > b.join_date
         AND NVL (b.department_name, -1) =
             NVL ( :P555_DEPT, NVL (b.department_name, -1))
         AND attdate BETWEEN :P555_F_DATE AND :P555_T_DATE
         --      AND attdate > TO_DATE('01-NOV-2024', 'DD-MON-RRRR')
         AND NVL (b.empcode, -1) = NVL ( :P555_EMPCODE, NVL (b.empcode, -1))
GROUP BY v.empcode,
         b.e_name,
         b.DESIG_NAME,
         b.department_name,
         b.location
ORDER BY 6 DESC;

---Specific Date wise absent---

  SELECT v.empcode                            AS "Employee Code",
         b.e_name                             AS "Employee Name",
         b.DESIG_NAME                         AS "Designation",
         b.department_name                    AS "Department",
         b.location                           AS "Location",
         (attdate)                            AS "Total Absent",
         TO_CHAR (attdate, 'DD-MON-YYYY')     AS "Date",
         ' '                                  AS "Recommendation of HRD"
    FROM v_att_absent v, ipihr.emp b
   WHERE     v.empcode = b.empcode(+)
         AND EMP_STATUS = 'A'
         AND v.attdate > b.join_date
         AND NVL (b.department_name, -1) =
             NVL ( :P555_DEPT, NVL (b.department_name, -1))
         AND attdate BETWEEN :P555_F_DATE AND :P555_T_DATE
         AND NVL (b.empcode, -1) = NVL ( :P555_EMPCODE, NVL (b.empcode, -1))
ORDER BY 6 ASC;