/* Formatted on 1/6/2025 3:54:27 PM (QP5 v5.362) */
  select count (*), ids
    from (  select empcode,
                   emp_id,
                   to_number (emp_id)     ids,
                   length (emp_id),
                   first_namep,
                   last_namep,
                   first_name,
                   last_name,
                   department_name,
                   location,
                   businessunit,
                   businessunitid,
                   ccode
              from v_emp_hrms
          order by 2 asc)
  having count (*) > 1
group by ids;


--CREATE OR REPLACE VIEW V_EMP_HRMS AS 
select empcode,
    case 
        when  department_name = 'Information Technology' then '555' || substr(empcode, instr(empcode, '-') + 1)  
        --WHEN  department_name = 'Marketing' THEN '777' || SUBSTR(EMPCODE, INSTR(EMPCODE, '-') + 1)  
        
        when department_name = 'Marketing' and empcode like '%IPIO%' then '420' || substr(empcode, instr(empcode, 'IPIO') + 5)       
        when empcode like '%IPIO%' then '420' || substr(empcode, instr(empcode, 'O') + 1)
        when empcode like '%EMP-%' then '420' || substr(empcode, instr(empcode, '-') + 1)
        --EMP-
        when  department_name = 'Marketing' then '787' || substr(empcode, instr(empcode, '-') + 1)
        when location in ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Engineering' then '100' || substr(empcode, instr(empcode, '-') + 1)
        when location in ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Accounts' then '111' || substr(empcode, instr(empcode, '-') + 1)
        when location in ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Accounts' then '111' || substr(empcode, instr(empcode, '-') + 1)
               
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name = 'Accounts' then '111' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name = 'Accounts' then '311' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name = 'Accounts' then '211' || substr(empcode, instr(empcode, '-') + 1)
         
         when location in ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Administration' then '222' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name = 'Administration' then '122' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name = 'Administration' then '222' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name = 'Administration' then '322' || substr(empcode, instr(empcode, '-') + 1)
         
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name = 'Store' then '166' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name = 'Store' then '266' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name = 'Store' then '366' || substr(empcode, instr(empcode, '-') + 1)
         
         when location in ( 'Head Office', 'HEAD OFFICE', 'HDO') and department_name = 'Engineering' then '100' || substr(empcode, instr(empcode, '-') + 1)
         
         when location in ( 'Head Office', 'HEAD OFFICE', 'HDO', 'Factory', 'FAC') and department_name = 'Sales and Distribution' then '200' || substr(empcode, instr(empcode, '-') + 1)
         
         when location in ( 'Head Office', 'HEAD OFFICE', 'HDO', 'Factory', 'FAC') and department_name = 'Human Resource' then '200' || substr(empcode, instr(empcode, '-') + 1)
         
         
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name = 'Engineering' then '144' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name = 'Engineering' then '244' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name = 'Engineering' then '344' || substr(empcode, instr(empcode, '-') + 1)
         
         
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name = 'Production' then '133' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name = 'Production' then '233' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name = 'Production' then '333' || substr(empcode, instr(empcode, '-') + 1)
         
         
         
         when location in ('FAC', 'Factory') and businessunit = 'Pharma' and department_name in ('Quality Assurance', 'Product Development', 'Quality Control') then '155' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit in ( 'NMD', 'Herbal') and department_name in ('Quality Assurance', 'Product Development', 'Quality Control') then '255' || substr(empcode, instr(empcode, '-') + 1)
         when location in ('FAC', 'Factory') and businessunit = 'Cephalosporin' and department_name in ('Quality Assurance', 'Product Development', 'Quality Control') then '355' || substr(empcode, instr(empcode, '-') + 1)
         
         
         when location = 'NOAKHALI' and department_name in ('Administration', 'Sales and Distribution') then '215' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'NARAYANGONJ' and department_name in ('Administration', 'Sales and Distribution') then '201' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'DHAKA' and department_name in ('Administration','Production', 'Sales and Distribution') then '200' || substr(empcode, instr(empcode, '-') + 1)         
         when location = 'JESSORE' and department_name in ('Administration', 'Sales and Distribution') then '210' || substr(empcode, instr(empcode, '-') + 1)         
         when location = 'COXS BAZAR' and department_name in ('Administration', 'Sales and Distribution') then '214' || substr(empcode, instr(empcode, '-') + 1)
         when location in ( 'MYMENSINGH', 'MYMENSHINGH') and department_name in ('Administration', 'Sales and Distribution') then '204' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'BOGRA' and department_name in ('Administration', 'Sales and Distribution') then '208' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'B. BARIA' and department_name in ('Administration', 'Sales and Distribution') then '202' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'CHITTAGONG' and department_name in ('Administration', 'Sales and Distribution') then '213' || substr(empcode, instr(empcode, '-') + 1)         
         when location = 'DINAJPUR' and department_name in ('Administration', 'Sales and Distribution') then '206' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'FARIDPUR' and department_name in ('Administration', 'Sales and Distribution') then '219' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'COMILLA' and department_name in ('Production', 'Administration', 'Sales and Distribution') then '205' || substr(empcode, instr(empcode, '-') + 1)
         
         when location = 'RAJSHAHI' and department_name in ('Administration', 'Sales and Distribution') then '209' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'GAZIPUR DEPOT' and department_name in ('Administration', 'Sales and Distribution', 'Production') then '217' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'KHULNA' and department_name in ('Administration', 'Sales and Distribution') then '211' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'SYLHET' and department_name in ('Administration', 'Sales and Distribution') then '216' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'JESSORE' and department_name in ('Administration', 'Sales and Distribution') then '210' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'JESSORE' and department_name in ('Administration', 'Sales and Distribution') then '210' || substr(empcode, instr(empcode, '-') + 1)
         when location = 'JESSORE' and department_name in ('Administration', 'Sales and Distribution') then '210' || substr(empcode, instr(empcode, '-') + 1)
          
        else '000' || substr(empcode, instr(empcode, '-') + 1) 
    end as emp_id,
    substr(e_name, 1, instr(e_name, ' ') - 1) as first_namep,
    substr(e_name, instr(e_name, ' ') + 1) as last_namep,
    trim(substr(e_name, 1, instr(e_name, ' ', -1) - 1)) as first_name,
    substr(e_name, instr(e_name, ' ', -1) + 1) as last_name,
    department_name,
    location,
    businessunit,
    businessunitid,
    ccode
from emp
where emp_status = 'A'
--AND EMPCODE = 'IPI-000212'
--ORDER BY TO_NUMBER(EMP_ID) ASC;

order by emp_id asc;