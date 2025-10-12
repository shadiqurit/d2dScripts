create table hr_emp_shift_t as
select * from hr_emp_shift_v;
CREATE TABLE IPIHR.HR_EMP_SHIFT_T
(
  EMPCODE       VARCHAR2(50 BYTE),
  SHIFT_TYPE    VARCHAR2(100 BYTE),
  YEARMN        NUMBER,
  ATTDATE       DATE,
  SHIFT         VARCHAR2(30 BYTE),
  START_TIME    DATE,
  END_TIME      DATE,
  START_TIME_A  DATE,
  END_TIME_A    DATE,
  NEXT_DAYS     NUMBER
);
/

--CREATE OR REPLACE FORCE VIEW IPIHR.HR_EMP_SHIFT_V_002
--AS
      SELECT empcode,
             yearmn,
             attdate,
             MAX (start_time_g)      start_time_g,
             MAX (end_time_g)        end_time_g,
             MAX (start_time_ot)     start_time_ot,
             MAX (end_time_ot)       end_time_ot
        FROM (SELECT empcode,
                     yearmn,
                     attdate,
                     start_time         start_time_g,
                     end_time           end_time_g,
                     TO_DATE (NULL)     start_time_ot,
                     TO_DATE (NULL)     end_time_ot
                FROM hr_emp_shift_t
               WHERE     (start_time IS NOT NULL OR end_time IS NOT NULL)
                     AND shift_type = 'GENERAL'
              UNION ALL
              SELECT empcode,
                     yearmn,
                     attdate,
                     TO_DATE (NULL),
                     TO_DATE (NULL),
                     start_time,
                     end_time
                FROM hr_emp_shift_t
               WHERE     (start_time IS NOT NULL OR end_time IS NOT NULL)
                     AND shift_type = 'OT')
    GROUP BY empcode, yearmn, attdate;