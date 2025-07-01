/* Formatted on 6/30/2025 5:58:19 PM (QP5 v5.362) */
SELECT empcode,
       empno,
       e_name,
       desig_name,
       department_name,
       salarygrade,
       birthdate,
       ADD_MONTHS (birthdate, 720)                                                retire_date,
       phone,
       depot                                                                      LOCATION,
       join_date,
          TRUNC (MONTHS_BETWEEN (SYSDATE, join_date) / 12)
       || ' Year '
       || MOD (TRUNC (MONTHS_BETWEEN (SYSDATE, join_date)), 12)
       || ' Months '
       || (  TO_DATE (SYSDATE)
           - ADD_MONTHS (join_date,
                         TRUNC (MONTHS_BETWEEN (SYSDATE, join_date))))
       || ' Days '                                                                service_length,
       CONFIRM_ST,
       CONFIRM_DATE,
       SALARYSCAL,
       (SELECT SUM (SALPER)
          FROM HR_EMPSALSTRUCTURE B
         WHERE A.EMPCODE = B.EMPCODE AND SLNO = 1)                                BASIC,
       (SELECT SUM (SALPER)
          FROM HR_EMPSALSTRUCTURE B, hr_head c
         WHERE A.EMPCODE = B.EMPCODE AND b.SLNO = c.slno AND c.TYPE = '1-Pay')    GROSS
  FROM emp A
 WHERE empcode = :p_empcode AND NVL (emp_status, '#') = 'A';

SELECT slno,
       refdate,
       empcode     empcode_s,
       ltype,
       sgrade_before,
       sgrade_after,
       incrtype,
       dpcode,
       desig_name_before,
       desig_name_after
  FROM hr_review_history
 WHERE     empcode = :p_empcode
       AND incrtype IN ('Promotional', 'Accelerated Promotion', 'Renaming');


--2986

SELECT NVL (last_sl, 0) + 1     newsl,
       last_sl,
       'Management Order'       AS incrtype,
       last_promotion_date,
       empcode,
       DESIG_NAME
  FROM (  SELECT MAX (slno)     last_sl,
                 -- MAX (REFDATE)
                 NULL           last_promotion_date,
                 hr.empcode,
                 EE.DESIG_NAME
            FROM hr_review_history hr, EMP ee
           WHERE     ee.empcode = hr.empcode
                 AND ee.CATA = 'OFFICER'
                 AND ee.emp_status = 'A'
                 AND incrtype IN
                         ('Promotional',
                          'Accelerated Promotion',
                          'Management Order')
        GROUP BY hr.empcode, EE.DESIG_NAME);

  SELECT DISTINCT (desig_name), desig_code
    FROM emp ee
   WHERE ee.emp_status = 'A' AND ee.CATA = 'OFFICER'
ORDER BY 1;


  SELECT DISTINCT (CATA)
    FROM emp ee
   WHERE ee.emp_status = 'A'
ORDER BY 1;



SELECT desig_name, desig_code, empcode
  FROM emp ee
 WHERE ee.emp_status = 'A' AND ee.desig_name = 'AREA MANAGER';

-- hr_base


UPDATE emp ee
   SET desig_code = 'DES-227'
 WHERE ee.emp_status = 'A' AND ee.desig_name = 'AREA-IN-CHARGE';



INSERT INTO hr_review_history (SLNO,
                               REFNO,
                               REFDATE,
                               EMPCODE,
                               DPCODE,
                               USERNAME,
                               CCODE,
                               AMOUNT,
                               EDATE,
                               EMP_HRCODE,
                               INCRTYPE,
                               DATASOURCE,
                               YEARMN,
                               SGRADE_BEFORE,
                               SGRADE_AFTER,
                               INCRRATE,
                               DEPT,
                               DESIG_NAME_BEFORE,
                               DESIG_NAME_AFTER,
                               CONSIDER_NEXT_REVIEW,
                               STOP_REFNO)
    SELECT SLNO,
           REFNO,
           REFDATE,
           EMPCODE,
           DP_CODE,
           USERNAME,
           CCODE,
           AMOUNT,
           EDATE,
           EMPCODE,
           INCRTYPE,
           'Auto'     DATASOURCE,
           YEARMN,
           SGRADE_BEFORE,
           SGRADE_AFTER,
           INCRRATE,
           DEPARTMENT_NAME,
           DESIG_NAME_BEFORE,
           DESIG_NAME_BEFORE,
           CONSIDER_NEXT_REVIEW,
           'N'
      FROM vo_review_history;


SELECT DISTINCT desig_name_before
  FROM (SELECT slno,
               refdate,
               dept,
               empcode,
               ltype,
               sgrade_before,
               sgrade_after,
               incrtype,
               dpcode,
               desig_name_before,
               desig_name_after,
               ROW_NUMBER () OVER (PARTITION BY empcode ORDER BY slno DESC)    AS rn
          FROM hr_review_history
         WHERE incrtype IN ('Renaming'))
 WHERE rn = 1;


DELETE FROM hr_review_history
      WHERE REFNO = '03/2025/34' AND USERNAME = 'M-ORDER';