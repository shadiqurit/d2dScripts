/* Formatted on 10/16/2025 3:43:35 PM (QP5 v5.362) */

--first update emp gender
UPDATE up_emp
   SET MARITAL_STATUS = 'M'
 WHERE MARITAL_STATUS = 'Married';
UPDATE up_emp
   SET MARITAL_STATUS = 'U'
 WHERE MARITAL_STATUS = 'Unmarried';
 
 UPDATE up_emp
   SET MARITAL_STATUS = 'M'
 WHERE MARITAL_STATUS = 'Married';
 
 
  
 UPDATE up_emp
   SET RELIGION = 'I'
 WHERE RELIGION = 'Islam';  
 
 
COMMIT;

--merge 
MERGE INTO emp t
     USING up_emp s
        ON (t.empcode = s.ipi)
WHEN MATCHED
THEN
    UPDATE SET --t.e_name = s.name,
               t.birthdate = s.birthdate,
               t.bld_group = s.bld_group,
             --  t.empsex = s.gender,
               t.religion = s.religion,
               t.nationality = s.nationality,
               t.maritalst = s.marital_status,
               t.email = s.email,
               t.phone = s.phone,
               t.phone1 = s.phone1,
               t.height = s.height,
               t.weight = s.weight,
               t.nid = s.nid,
               t.voter_id = s.nid,
               t.p_add1 = s.permanent_village,
               t.p_add2 = s.permanent_post,
               t.p_add3 = s.permanent_thana,
               t.p_add4 = s.permanent_district,
               t.add1 = s.present_village,
               t.add2 = s.present_post,
               t.add3 = s.present_thana,
               t.add4 = s.present_district,
               t.emgrcny_person = s.emgrcny_person,
               t.emgrcny_relation = s.emgrcny_relation,
               t.emgrcny_address = s.emgrcny_address,
               t.emgrcny_phone = s.emgrcny_phone,
               t.father_name = s.father_name,
               t.father_phone = s.father_phone,
               t.mother_name = s.mother_name,
               t.mother_phone = s.mother_phone,
               t.spouse_name = s.spouse_name,
               t.spose_marriage_date = s.spose_marriage_date,
               t.spose_occupation = s.spose_occupation,
               t.spouse_phone = s.spouse_phone,
               t.GRNT_NM = s.grnt_name,
               t.grnt_rele = s.grnt_rele,
               t.grnt_father = s.grnt_father,
               t.GRNT_ADD1 = s.grnt_present_add,
               t.GRNT_ADD2 = s.grnt_permanet_add,
               t.grnt_nationality = s.grnt_nationality,
               t.grnt_proffession = s.grnt_proffession,
               t.grnt_nid = s.grnt_nid,
               t.grnt_mobile = s.grnt_mobile;
               
               
/* Formatted on 10/16/2025 3:45:19 PM (QP5 v5.362) */
--SOURCE DATE up_emp TO UPDATE EMP WRITE A MERGE OR UPDATE PROCEDURE

SELECT empcode       ipi,
       e_name        name,
       birthdate,
       bld_group,
       empsex        gender,
       religion,
       nationality,
       maritalst     marital_status,
       email,
       phone,
       phone1,
       height,
       weight,
       nid,
       p_add1        permanent_village,
       p_add2        permanent_post,
       p_add3        permanent_thana,
       p_add4        permanent_district,
       add1          present_village,
       add2          present_post,
       add3          present_thana,
       add4          present_district,
       emgrcny_person,
       emgrcny_relation,
       emgrcny_address,
       emgrcny_phone,
       father_name,
       father_phone,
       mother_name,
       mother_phone,
       spouse_name,
       spose_marriage_date,
       spose_occupation,
       spouse_phone,
       GRNT_NM       grnt_name,
       grnt_rele,
       grnt_father,
       GRNT_ADD1     grnt_present_add,
       GRNT_ADD2     grnt_permanet_add,
       grnt_nationality,
       grnt_proffession,
       grnt_nid,
       grnt_mobile
  FROM emp
 WHERE empcode IN (SELECT ipi FROM up_emp);               
 
 
-- HR_EMPEXAMDET