--HR_EMPCHANGE_17042024
CREATE TABLE HR_EMPCHANGE_18072024 AS SELECT * FROM HR_EMPCHANGE_17042024;
--HR_EMPCHANGE
--HR_EMPINCR_DET_17042024
CREATE TABLE HR_EMPINCR_DET_18072024 AS SELECT * FROM HR_EMPINCR_DET_17042024;
--HR_EMPINCR_DET
--HR_REVIEW_HISTORY_17042024
CREATE TABLE HR_REVIEW_HISTORY_18072024 AS SELECT * FROM HR_REVIEW_HISTORY_17042024;
--HR_REVIEW_HISTORY
--HR_EMPSALSTRUCTURE
--HR_EMP_REVIEW
--EMP
--EMP_17042024

SELECT * FROM hr_empincr_det
WHERE EMPCODE IN ('IPI-005153','IPI-003767','IPI-003935','IPI-004336','IPI-004361','IPI-004369','IPI-004392','IPI-004600','IPI-004650','IPI-005145','IPI-005159','IPI-005162','IPI-005476','IPI-005515','IPI-005726','IPI-005742','IPI-005747','IPI-005765','IPI-006014','IPI-006201','IPI-006241','IPI-006250','IPI-006272','IPI-006276','IPI-006459','IPI-006463','IPI-006726','IPI-006744','IPI-006794','IPI-006822','IPI-006841','IPI-006859','IPI-006881','IPI-006894','IPI-006901','IPI-006903','IPI-006907','IPI-006911','IPI-006940','IPI-006978','IPI-006985','IPI-006991','IPI-006997','IPI-007001','IPI-007031','IPI-007042','IPI-007247','IPI-007313','IPI-007315','IPI-007329','IPI-007335','IPI-007343','IPI-007344','IPI-007350','IPI-007353','IPI-007355','IPI-007359','IPI-007363','IPI-007368','IPI-007370')
AND DESIGCODE = 'GRADE-12';

SELECT * FROM HR_REVIEW_HISTORY
where EMPCODE IN ('IPI-005153','IPI-003767','IPI-003935','IPI-004336','IPI-004361','IPI-004369','IPI-004392','IPI-004600','IPI-004650','IPI-005145','IPI-005159','IPI-005162','IPI-005476','IPI-005515','IPI-005726','IPI-005742','IPI-005747','IPI-005765','IPI-006014','IPI-006201','IPI-006241','IPI-006250','IPI-006272','IPI-006276','IPI-006459','IPI-006463','IPI-006726','IPI-006744','IPI-006794','IPI-006822','IPI-006841','IPI-006859','IPI-006881','IPI-006894','IPI-006901','IPI-006903','IPI-006907','IPI-006911','IPI-006940','IPI-006978','IPI-006985','IPI-006991','IPI-006997','IPI-007001','IPI-007031','IPI-007042','IPI-007247','IPI-007313','IPI-007315','IPI-007329','IPI-007335','IPI-007343','IPI-007344','IPI-007350','IPI-007353','IPI-007355','IPI-007359','IPI-007363','IPI-007368','IPI-007370')
AND INCRTYPE = 'Promotional' 
AND REFDATE = TO_DATE('01/Jul/24', 'DD/MON/YY');

SELECT * FROM  HR_EMPCHANGE
where EMPCODE IN ('IPI-005153','IPI-003767','IPI-003935','IPI-004336','IPI-004361','IPI-004369','IPI-004392','IPI-004600','IPI-004650','IPI-005145','IPI-005159','IPI-005162','IPI-005476','IPI-005515','IPI-005726','IPI-005742','IPI-005747','IPI-005765','IPI-006014','IPI-006201','IPI-006241','IPI-006250','IPI-006272','IPI-006276','IPI-006459','IPI-006463','IPI-006726','IPI-006744','IPI-006794','IPI-006822','IPI-006841','IPI-006859','IPI-006881','IPI-006894','IPI-006901','IPI-006903','IPI-006907','IPI-006911','IPI-006940','IPI-006978','IPI-006985','IPI-006991','IPI-006997','IPI-007001','IPI-007031','IPI-007042','IPI-007247','IPI-007313','IPI-007315','IPI-007329','IPI-007335','IPI-007343','IPI-007344','IPI-007350','IPI-007353','IPI-007355','IPI-007359','IPI-007363','IPI-007368','IPI-007370')
AND LTYPEDES = 'Promotion Letter';




SELECT distinct basename DESIG, baseid DESIG_CODE,sl 
FROM hr_base
where parentname='Designation'
AND baseid = 'DES-226'
OR basename LIKE '%MEDICAL PROMOTION OFFICER-2%'
order by basename;