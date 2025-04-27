/* Formatted on 4/27/2025 6:08:56 PM (QP5 v5.362) */
  SELECT DISTINCT EXAMNAME, '''' || EXAMNAME || ''','
    FROM emp_education
   WHERE EXAMNAME NOT IN ('1994',
                          '2.75',
                          '2005',
                          '2015',
                          '2020',
                          'BIRAMPUR DEGREE COLLEGE',
                          '3.20',
                          '5.00')
ORDER BY EXAMNAME DESC;


  SELECT *
    FROM emp_education EXAMNAME
   WHERE EXAMNAME IN ('M.T.IS', 'M.T.I.S')
ORDER BY EXAMNAME;

UPDATE emp_education
   SET EXAMNAME = 'H.S.C'
 WHERE EXAMNAME IN ('HSC');


--EXAMS

  SELECT DISTINCT BOARD_N, '''' || BOARD_N || ''','
    FROM emp_education
-- WHERE initcap (BOARD_N) LIKE '%Rajshahi Education Board%'
ORDER BY 1;

UPDATE emp_education
   SET CLAS = 'Pass'
 WHERE clas IN ('PASS', 'PASSED', 'pass');


SELECT ee.id,
       ee.F_NAME || '' || ee.l_name     ename,
       ee.emp_id                        emcode,
       edu.EMPCODE,
       edu.EMP_ID
  FROM employees ee, emp_education edu
 WHERE ee.EMP_ID = edu.EMPCODE;


UPDATE emp_education edu
   SET edu.emp_id =
           (SELECT id
              FROM employees ee
             WHERE ee.EMP_ID = edu.EMPCODE);


--     UPDATE emp_education edu
--   SET edu.id = s_empid.nextval;


SELECT DISTINCT CLAS
  FROM emp_education;

UPDATE emp_education
   SET CGPA = CLAS;



SELECT edu.id,
       edu.emp_id,
       edu.EXAMNAME,
       EX.ID     EXAMID,
       edu.EXAM
  FROM emp_education edu, EXAMS EX
 WHERE edu.EXAMNAME = EX.NAME;

UPDATE emp_education edu
   SET edu.EXAM =
           (SELECT id
              FROM EXAMS EX
             WHERE edu.EXAMNAME = EX.NAME);


SELECT * FROM emp_education;

SELECT * FROM BOARD_UNIVERSITY;

SELECT * FROM emp_education;

  SELECT DISTINCT BOARD_N, '''' || BOARD_N || ''','
    FROM emp_education
   WHERE board_n NOT IN (' N/A')
ORDER BY 1 DESC;


UPDATE emp_education edu
   SET BOARD_N = 'Technical'
 WHERE board_n IN ('Technical Education Board',
                   'TECNICAL',
                   'TECHNICAL',
                   'BETB',
                   'B.T.E.B DHAKA',
                   'B.T.E.B',
                   'B TEB',
                   'BTEB, DHAKA',
                   'BTEB, DHAKA',
                   'BTEB',
                   'Technical');



SELECT edu.id,
       edu.emp_id,
       edu.BOARD_N,
       EX.ID     EXAMID,
       BOARD     BOARDID
  FROM emp_education edu, BOARD_UNIVERSITY EX
 WHERE LOWER (edu.BOARD_N) = LOWER (EX.NAME);

UPDATE emp_education edu
   SET edu.BOARD =
           (SELECT id
              FROM BOARD_UNIVERSITY EX
             WHERE LOWER (edu.BOARD_N) = LOWER (EX.NAME));