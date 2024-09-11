SELECT empid,
         NAME,
         department,
         designation,
         join_date,
         sum (NO_OFACH)     special_allowance,
         SUM (NO_OFINCR)             NO_OFINCR,
                  sum (NO_OFACH+NO_OFINCR) total
    FROM (SELECT a.empcode             empid,
                 a.e_name              NAME,
                 a.department_name     department,
                 a.desig_name          designation,
                 a.join_date,
                 (case When to_number(To_Char(REFDATE,'RRRR'))<2023 Then NO_OFINCR else 0 end ) NO_OFINCR,
                 (case When to_number(To_Char(REFDATE,'RRRR'))>2022 Then NO_OFINCR else 0 end ) NO_OFACH
                 
            FROM emp a, HR_EMPCHANGE b
           WHERE     emp_status = 'A'
                 AND a.empcode = b.empcode
                 AND ltype In ( 110,116)
                 AND a.businessunitid = NVL ( :p_unitid, a.businessunitid)
                 AND REFDATE BETWEEN NVL ( :dt1, REFDATE)
                                 AND NVL ( :dt2, REFDATE)
                 AND a.d_code = NVL ( :p_d_code, a.d_code)
                 AND a.empcode = NVL ( :p_empcode, a.empcode))
GROUP BY empid,
         NAME,
         department,
         designation,
         join_date
