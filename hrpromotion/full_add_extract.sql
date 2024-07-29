select EMPCODE, FULL_ADD 
from emp;

SELECT EMPCODE,
  SUBSTR(FULL_ADD, 7, INSTR(FULL_ADD, ', Post:') - 7) AS vill
FROM emp;

SELECT EMPCODE,
  SUBSTR(FULL_ADD, 7, INSTR(FULL_ADD, ', P.S:') - 7) AS post
FROM emp;

SELECT EMPCODE,
  SUBSTR(FULL_ADD, 7, INSTR(FULL_ADD, ', Post:') - 7) AS vill,
  SUBSTR(FULL_ADD, INSTR(FULL_ADD, ', Post: ') + LENGTH(', Post: '), INSTR(FULL_ADD, ', P.S:') - INSTR(FULL_ADD, ', Post: ') - LENGTH(', Post: ')) AS post,
  SUBSTR(FULL_ADD, INSTR(FULL_ADD, ', P.S: ') + LENGTH(', P.S: '), INSTR(FULL_ADD, ', District:') - INSTR(FULL_ADD, ', P.S: ') - LENGTH(', P.S: ')) AS ps,
  SUBSTR(FULL_ADD, INSTR(FULL_ADD, 'District:') + LENGTH(' District:')) AS district
FROM emp;
