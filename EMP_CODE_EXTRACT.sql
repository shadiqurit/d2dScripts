SELECT empcode,
    CASE 
        WHEN  department_name = 'Information Technology' THEN '555' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)        
        WHEN  department_name = 'Marketing' THEN '777' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
        WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Engineering' THEN '100' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
        WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Accounts' THEN '111' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
        WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Accounts' THEN '111' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
               
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name = 'Accounts' THEN '111' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name = 'Accounts' THEN '311' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name = 'Accounts' THEN '211' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Administration' THEN '222' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name = 'Administration' THEN '122' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name = 'Administration' THEN '222' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name = 'Administration' THEN '322' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name = 'Store' THEN '166' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name = 'Store' THEN '266' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name = 'Store' THEN '366' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Engineering' THEN '100' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO', 'Factory', 'FAC') and department_name = 'Sales and Distribution' THEN '200' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION IN ( 'Head Office', 'HEAD OFFICE', 'HDO', 'Factory', 'FAC') and department_name = 'Human Resource' THEN '200' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name = 'Engineering' THEN '144' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name = 'Engineering' THEN '244' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name = 'Engineering' THEN '344' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name = 'Production' THEN '133' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name = 'Production' THEN '233' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name = 'Production' THEN '333' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         
         
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Pharma' and department_name IN ('Quality Assurance', 'Product Development', 'Quality Control') THEN '155' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT in ( 'NMD', 'Herbal') and department_name IN ('Quality Assurance', 'Product Development', 'Quality Control') THEN '255' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ('FAC', 'Factory') and BUSINESSUNIT = 'Cephalosporin' and department_name IN ('Quality Assurance', 'Product Development', 'Quality Control') THEN '355' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         
         WHEN LOCATION = 'NOAKHALI' and department_name IN ('Administration', 'Sales and Distribution') THEN '215' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'NARAYANGONJ' and department_name IN ('Administration', 'Sales and Distribution') THEN '201' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'DHAKA' and department_name IN ('Administration','Production', 'Sales and Distribution') THEN '200' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)         
         WHEN LOCATION = 'JESSORE' and department_name IN ('Administration', 'Sales and Distribution') THEN '210' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)         
         WHEN LOCATION = 'COXS BAZAR' and department_name IN ('Administration', 'Sales and Distribution') THEN '214' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION IN ( 'MYMENSINGH', 'MYMENSHINGH') and department_name IN ('Administration', 'Sales and Distribution') THEN '204' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'BOGRA' and department_name IN ('Administration', 'Sales and Distribution') THEN '208' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'B. BARIA' and department_name IN ('Administration', 'Sales and Distribution') THEN '202' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'CHITTAGONG' and department_name IN ('Administration', 'Sales and Distribution') THEN '213' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)         
         WHEN LOCATION = 'DINAJPUR' and department_name IN ('Administration', 'Sales and Distribution') THEN '206' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'FARIDPUR' and department_name IN ('Administration', 'Sales and Distribution') THEN '219' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'COMILLA' and department_name IN ('Production', 'Administration', 'Sales and Distribution') THEN '205' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         WHEN LOCATION = 'RAJSHAHI' and department_name IN ('Administration', 'Sales and Distribution') THEN '209' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'GAZIPUR DEPOT' and department_name IN ('Administration', 'Sales and Distribution', 'Production') THEN '217' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'KHULNA' and department_name IN ('Administration', 'Sales and Distribution') THEN '211' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'JESSORE' and department_name IN ('Administration', 'Sales and Distribution') THEN '210' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'JESSORE' and department_name IN ('Administration', 'Sales and Distribution') THEN '210' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'JESSORE' and department_name IN ('Administration', 'Sales and Distribution') THEN '210' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         WHEN LOCATION = 'JESSORE' and department_name IN ('Administration', 'Sales and Distribution') THEN '210' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
         
         
         
         
         
         
        ELSE '000' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1) 
    END AS EMP_ID,
    SUBSTR(E_NAME, 1, INSTR(E_NAME, ' ') - 1) AS FIRST_NAMEp,
    SUBSTR(E_NAME, INSTR(E_NAME, ' ') + 1) AS LAST_NAMEp,
    TRIM(SUBSTR(E_NAME, 1, INSTR(E_NAME, ' ', -1) - 1)) AS FIRST_NAME,
    SUBSTR(E_NAME, INSTR(E_NAME, ' ', -1) + 1) AS LAST_NAME,
    department_name,
    location,
    BUSINESSUNIT,
    BUSINESSUNITID,
    ccode
FROM EMP
where emp_status = 'A'
--AND EMPCODE = 'IPI-000212'
ORDER BY EMP_ID ASC;