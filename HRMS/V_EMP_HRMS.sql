/* Formatted on 3/16/2025 12:32:16 PM (QP5 v5.362) */
CREATE OR REPLACE FORCE VIEW V_EMP_HRMS
AS
      SELECT empcode emp_id,EMPNO,VOTER_ID NID,PHONE, PHONE1,JOIN_DATE,
             CASE
                 WHEN department_name = 'Information Technology'
                 THEN
                     '555' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 --WHEN  department_name = 'Marketing' THEN '777' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)
                 WHEN department_name = 'Marketing' AND BUSINESSUNIT IN ('NMD', 'Herbal')
                 THEN
                     '187' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)

                 WHEN department_name = 'Marketing' AND EMPCODE LIKE '%IPIO%'
                 THEN
                     '420' || SUBSTR (EMPCODE, INSTR (EMPCODE, 'IPIO') + 5)
                 WHEN EMPCODE LIKE '%IPIO%'
                 THEN
                     '420' || SUBSTR (EMPCODE, INSTR (EMPCODE, 'O') + 1)
                 WHEN EMPCODE LIKE '%EMP-%'
                 THEN
                     '420' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 --EMP-
                 WHEN department_name = 'Marketing'
                 THEN
                     '787' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office', 'HEAD OFFICE', 'HDO')
                      AND department_name = 'Engineering'
                 THEN
                     '100' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office', 'HEAD OFFICE', 'HDO')
                      AND department_name = 'Accounts'
                 THEN
                     '111' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office', 'HEAD OFFICE', 'HDO')
                      AND department_name = 'Accounts'
                 THEN
                     '111' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name = 'Accounts'
                 THEN
                     '111' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name = 'Accounts'
                 THEN
                     '311' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name = 'Accounts'
                 THEN
                     '211' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office', 'HEAD OFFICE', 'HDO')
                      AND department_name = 'Administration'
                 THEN
                     '222' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name = 'Administration'
                 THEN
                     '122' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name = 'Administration'
                 THEN
                     '99' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name = 'Administration'
                 THEN
                     '322' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name = 'Store'
                 THEN
                     '166' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name = 'Store'
                 THEN
                     '266' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name = 'Store'
                 THEN
                     '366' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office', 'HEAD OFFICE', 'HDO')
                      AND department_name = 'Engineering'
                 THEN
                     '100' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office',
                                       'HEAD OFFICE',
                                       'HDO',
                                       'Factory',
                                       'FAC')
                      AND department_name = 'Sales and Distribution'
                 THEN
                     '200' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('Head Office',
                                       'HEAD OFFICE',
                                       'HDO',
                                       'Factory',
                                       'FAC')
                      AND department_name = 'Human Resource'
                 THEN
                     '200' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name = 'Engineering'
                 THEN
                     '144' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name = 'Engineering'
                 THEN
                     '244' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name = 'Engineering'
                 THEN
                     '344' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name = 'Production'
                 THEN
                     '133' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name = 'Production'
                 THEN
                     '233' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name = 'Production'
                 THEN
                     '333' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Pharma'
                      AND department_name IN
                              ('Quality Assurance',
                               'Product Development',
                               'Quality Control')
                 THEN
                     '155' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT IN ('NMD', 'Herbal')
                      AND department_name IN
                              ('Quality Assurance',
                               'Product Development',
                               'Quality Control')
                 THEN
                     '255' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('FAC', 'Factory')
                      AND BUSINESSUNIT = 'Cephalosporin'
                      AND department_name IN
                              ('Quality Assurance',
                               'Product Development',
                               'Quality Control')
                 THEN
                     '355' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'NOAKHALI'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '215' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'NARAYANGONJ'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '201' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'DHAKA'
                      AND department_name IN
                              ('Administration',
                               'Production',
                               'Sales and Distribution')
                 THEN
                     '200' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'JESSORE'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '210' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'COXS BAZAR'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '214' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION IN ('MYMENSINGH', 'MYMENSHINGH')
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '204' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'BOGRA'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '208' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'B. BARIA'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '202' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'CHITTAGONG'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '213' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'DINAJPUR'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '206' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'FARIDPUR'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '219' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'COMILLA'
                      AND department_name IN
                              ('Production',
                               'Administration',
                               'Sales and Distribution')
                 THEN
                     '205' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'RAJSHAHI'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '209' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'GAZIPUR DEPOT'
                      AND department_name IN
                              ('Administration',
                               'Sales and Distribution',
                               'Production')
                 THEN
                     '217' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'KHULNA'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '211' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'SYLHET'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '216' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'JESSORE'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '210' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'JESSORE'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '210' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 WHEN     LOCATION = 'JESSORE'
                      AND department_name IN
                              ('Administration', 'Sales and Distribution')
                 THEN
                     '210' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
                 ELSE
                     '000' || SUBSTR (EMPCODE, INSTR (EMPCODE, '-') + 1)
             END
                 AS EMPID,
             SUBSTR (E_NAME, 1, INSTR (E_NAME, ' ') - 1)
                 AS FIRST_NAMEp,
             SUBSTR (E_NAME, INSTR (E_NAME, ' ') + 1)
                 AS LAST_NAMEp,
             TRIM (SUBSTR (E_NAME, 1, INSTR (E_NAME, ' ', -1) - 1))
                 AS FIRST_NAME,
             SUBSTR (E_NAME, INSTR (E_NAME, ' ', -1) + 1)
                 AS LAST_NAME,
                 FNAME, MNAME, LNAME,EMAIL,
                 EMPSEX,MARITALST,FATHER_NAME,MOTHER_NAME,HEIGHT,WEIGHT,RELIGION,BLD_GROUP,
             department_name,
             location,
             BUSINESSUNIT,
             BUSINESSUNITID,
             ccode,
             add1, add2, add3, add4,
             p_add1,  p_add2,  p_add3,  p_add4
        FROM EMP
       WHERE emp_status = 'A'
    AND EMPCODE not like '%EMP%'
    --ORDER BY TO_NUMBER(EMP_ID) ASC;

    ORDER BY EMP_ID ASC;