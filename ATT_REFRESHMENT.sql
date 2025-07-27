CREATE OR REPLACE PROCEDURE IPIHR.att_refreshment (p_fdate         DATE,
                                                   p_tdate         DATE,
                                                   p_empcode       VARCHAR2,
                                                   p_dp_code       VARCHAR2,
                                                   o_msg       OUT VARCHAR2)
AS
    p_fdaten        NUMBER := TO_NUMBER (TO_CHAR (p_fdate, 'rrrrmmdd'));
    p_tdaten        NUMBER := TO_NUMBER (TO_CHAR (p_tdate, 'rrrrmmdd'));
    tmpvar          NUMBER;
    -- o_msg    VARCHAR2 (500);
    v_date          DATE := SYSDATE;
    p_dp_code_att   VARCHAR2 (500);
    v_status        VARCHAR2 (100);
    v_remarks       VARCHAR2 (100);
-----------------------------------------
/*
01. Pharma division: (8:00AM - 5:30PM)
02. NMD division: (8:30AM - 4:30PM)
03. Chepalosphorin Division: (8:00AM - 5:30PM)
*/
---------------------------------------------
BEGIN
    ------ access  table  data (userinfo  ,checkinout ) exported using dblink (acc)  int oracle table (  userinfo_01,checkinout_01)

    --444444 ===========================================================
    --punch_data_merge_main (p_fdate, p_tdate);
    punch_data_merge_cloud (p_fdate, p_tdate);

    COMMIT;


    --5555555---------------------------------------------------------
    DELETE FROM holiday_info_t2;

    INSERT INTO holiday_info_t2
        SELECT *
          FROM holiday_info
         WHERE tran_date BETWEEN p_fdate AND p_tdate;

    DELETE FROM att_data;

    INSERT INTO att_data (attenteryid,
                          attdatetime,
                          cardnumber,
                          empcode,
                          punchcardno,
                          userid,
                          badgenumber,
                          machine_id)
        SELECT DISTINCT
               NULL                          attenteryid,
               TO_DATE (TO_CHAR (a.checktime, 'RRRRMMDDHHMIAM'),
                        'RRRRMMDDHHMIAM')    attdatetime,
               NULL                          cardnumber,
               b.empcode,
               NULL                          punchcardno,
               userid,
               a.badgenumber,
               a.sensorid                    machine_id
          FROM transaction_access_db a, emp_all_v b
         WHERE     TRUNC (checktime) BETWEEN p_fdate AND p_tdate
               /* and not exists (select 1 from att_dup_list c
                where to_number ( SUBSTR (a.userid, -4)) = to_number(c.empcode ) )*/
               -- AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)
               AND CASE
                       WHEN LENGTH (a.userid) = 7
                       THEN
                           'EMP-' || SUBSTR (a.userid, -6)
                       WHEN LENGTH (a.userid) = 8
                       THEN
                           'INM-' || SUBSTR (a.userid, -6)
                       ELSE
                           'IPI-' || SUBSTR (a.userid, -6)
                   END =
                   b.empcode
               AND NOT EXISTS
                       (SELECT 1
                          FROM emp c
                         WHERE b.empcode = c.employeecode)
        UNION ALL
        SELECT DISTINCT
               NULL                          attenteryid,
               TO_DATE (TO_CHAR (a.checktime, 'RRRRMMDDHHMIAM'),
                        'RRRRMMDDHHMIAM')    attdatetime,
               NULL                          cardnumber,
               b.empcode,
               NULL                          punchcardno,
               userid,
               a.badgenumber,
               a.sensorid                    machine_id
          FROM transaction_access_db a, emp_all_v b
         WHERE     TRUNC (checktime) BETWEEN p_fdate AND p_tdate
               /* and not exists (select 1 from att_dup_list c
                where to_number ( SUBSTR (a.userid, -4)) = to_number(c.empcode ) )*/
               -- AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)
               AND CASE
                       WHEN LENGTH (a.userid) = 7
                       THEN
                           'EMP-' || SUBSTR (a.userid, -6)
                       WHEN LENGTH (a.userid) = 8
                       THEN
                           'INM-' || SUBSTR (a.userid, -6)
                       ELSE
                           NULL
                   END =
                   b.empcode
               AND EXISTS
                       (SELECT 1
                          FROM emp c
                         WHERE b.empcode = c.employeecode);

    DELETE FROM att_data
          WHERE ROWID NOT IN (  SELECT MAX (ROWID)
                                  FROM att_data
                              GROUP BY empcode, attdatetime);

    DELETE FROM att_data_2;

    INSERT INTO att_data_2 (attdate, empcode)
        SELECT DISTINCT c.tran_date, b.empcode
          FROM userinfo_access_db a, emp_all_v b, holiday_info_t2 c
         WHERE SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6);

    DELETE FROM att_data_empcode;

    INSERT INTO att_data_empcode (empcode)
        SELECT DISTINCT empcode
          FROM (SELECT DISTINCT empcode
                  FROM att_data_2
                UNION ALL
                SELECT DISTINCT empcode
                  FROM att_data);

    ---888

    -------------------
    DELETE FROM att_manual_t_2;

    INSERT INTO att_manual_t_2 (empcode,
                                attdate,
                                intime,
                                outtime,
                                remark,
                                att_type,
                                user_name)
          SELECT empcode,
                 attdate,
                 MIN (intime),
                 MAX (outtime),
                 MAX (remark),
                 MAX (att_type),
                 MAX (user_name)
            FROM (SELECT a.empcode,
                         TRUNC (b.tran_date)     attdate,
                         a.intime,
                         a.outtime,
                         a.remark,
                         a.att_type,
                         a.user_name
                    FROM att_manual a, holiday_info_t2 b
                   WHERE     (TRUNC (b.tran_date) BETWEEN TRUNC (a.attdate)
                                                      AND TRUNC (a.attdate_2))
                         AND TRUNC (a.attdate) BETWEEN p_fdate AND p_tdate
                         AND empcode = NVL (p_empcode, empcode)
                  UNION ALL
                  SELECT a.empcode,
                         TRUNC (b.tran_date)     attdate,
                         a.starttime             intime,
                         a.endtime               outtime,
                         NULL                    remark,
                         '1'                     att_type,
                         'j'                     user_name
                    FROM shortleave a, holiday_info_t2 b
                   WHERE     (TRUNC (b.tran_date) BETWEEN TRUNC (a.starttime)
                                                      AND TRUNC (a.endtime))
                         AND TRUNC (a.starttime) BETWEEN p_fdate AND p_tdate
                         AND a.TYPE = 'Short Tour'
                         AND empcode = NVL (p_empcode, empcode) -- and dp_code_att =nvl(p_dp_code_att ,dp_code_att )
                                                               )
        GROUP BY empcode, attdate;

    -----
    DELETE FROM emp_refreshment_t01;

    DELETE FROM emp_refreshment_t01;

    DELETE FROM emp_refreshment;

    ----
    DELETE FROM att_temp_01;

    INSERT INTO att_temp_01 (empcode,
                             attdate,
                             emp_in_time,
                             emp_out_time,
                             no_of_total_punch)
        (  SELECT empcode,
                  attdate,
                  MIN (attdatetime)     emp_in_time,
                  MAX (attdatetime)     emp_out_time,
                  COUNT (*)             no_of_total_punch
             FROM (SELECT DISTINCT
                          TRUNC (attdatetime) attdate, attdatetime, empcode
                     FROM att_data
                    WHERE (TRUNC (attdatetime) BETWEEN p_fdate AND p_tdate)
                   -----------------------------
                   UNION ALL
                   SELECT attdate,
                          TO_DATE (
                                 TO_CHAR (attdate, 'RRRRMMDD')
                              || TO_CHAR (intime, 'HHMI AM'),
                              'RRRRMMDDHHMI AM'),
                          empcode
                     FROM att_manual_t_2
                    WHERE     intime IS NOT NULL
                          AND (attdate BETWEEN p_fdate AND p_tdate)
                   ---------------------------------------------------------------------------------------
                   UNION ALL
                   SELECT attdate,
                          TO_DATE (
                                 TO_CHAR (attdate, 'RRRRMMDD')
                              || TO_CHAR (outtime, 'HHMI AM'),
                              'RRRRMMDDHHMI AM'),
                          empcode
                     FROM att_manual_t_2
                    WHERE     outtime IS NOT NULL
                          AND (attdate BETWEEN p_fdate AND p_tdate))
         GROUP BY empcode, attdate);

    INSERT INTO emp_refreshment_t01 (empcode,
                                     intime,
                                     outtime,
                                     attdate,
                                     office_in_time,
                                     office_out_time,
                                     no_of_punch,
                                     is_present,
                                     is_late,
                                     late_minute,
                                     status,
                                     dp_code,
                                     dp_code_att,
                                     location_att,
                                     dp_name,
                                     LOCATION)
        SELECT empcode,
               intime,
               outtime,
               TRUNC (attdate),
               office_in_time,
               office_out_time,
               no_of_total_punch,
               is_present,
               is_late,
               late_minute,
               NULL     status,
               dp_code,
               dp_code_att,
               NULL,
               NVL (dp_code, 'all'),
               (SELECT CASE
                           WHEN z.dp_code = 'FAC'
                           THEN
                               'FAC'
                           WHEN UPPER (z.dp_code) IN ('HDO',
                                                      'Head Ofifice',
                                                      'DHAKA-H.O',
                                                      'Head Office',
                                                      'HEAD OFFICE')
                           THEN
                               'HDO'
                           ELSE
                               z.dp_code
                       END
                  FROM emp z
                 WHERE z.empcode = a.empcode)
          FROM (SELECT empcode,
                       dp_code,
                       dp_code_att,
                       emp_in_time      intime,
                       emp_out_time     outtime,
                       trans_date       attdate,
                       off_in_time      office_in_time,
                       off_out_time     office_out_time,
                       no_of_total_punch,
                       is_present,
                       NULL             is_late,
                       NULL             late_minute
                  FROM (SELECT a.empcode,
                               a.dp_code,
                               a.dp_code_att,
                               CASE
                                   WHEN     no_of_total_punch = 1
                                        AND TRIM (
                                                TO_CHAR (a.emp_in_time, 'PM')) =
                                            'PM'
                                   THEN
                                       NULL
                                   ELSE
                                       a.emp_in_time
                               END     emp_in_time,
                               CASE
                                   WHEN     no_of_total_punch = 1
                                        AND TRIM (
                                                TO_CHAR (emp_out_time, 'AM')) =
                                            'AM'
                                   THEN
                                       NULL
                                   ELSE
                                       a.emp_out_time
                               END     emp_out_time,
                               a.trans_date,
                               NULL    off_in_time,
                               NULL    off_out_time,
                               no_of_total_punch,
                               CASE
                                   WHEN no_of_total_punch = 0 THEN 0
                                   ELSE 1
                               END     is_present
                          FROM (  SELECT empcode,
                                         dp_code,
                                         dp_code_att,
                                         trans_date,
                                         off_in_time,
                                         duty_hr,
                                         MIN (emp_in_time)          emp_in_time,
                                         MAX (emp_out_time)         emp_out_time,
                                         MAX (no_of_total_punch)    no_of_total_punch
                                    FROM (SELECT a.empcode,
                                                 NULL          dp_code,
                                                 NULL          dp_code_att,
                                                 b.attdate     trans_date,
                                                 NULL          off_in_time,
                                                 NULL          duty_hr,
                                                 b.emp_in_time,
                                                 b.emp_out_time,
                                                 b.no_of_total_punch
                                            FROM att_data_empcode a,
                                                 -------------------------------------------------

                                                 -----------------------------------------------------------------                                                ----------------------------------
                                                 att_temp_01     b
                                           WHERE     b.attdate BETWEEN p_fdate
                                                                   AND p_tdate
                                                 AND a.empcode =
                                                     NVL (p_empcode, a.empcode)
                                                 AND a.empcode = b.empcode
                                          UNION ALL
                                          ------------attmanual
                                          SELECT a.empcode,
                                                 NULL          dp_code,
                                                 NULL          dp_code_att,
                                                 b.attdate     trans_date,
                                                 NULL          off_in_time,
                                                 NULL          duty_hr,
                                                 b.emp_in_time,
                                                 b.emp_out_time,
                                                 b.no_of_total_punch
                                            FROM att_manual_t_2 a, -------------------------------------------------
                                                 -----------------------------------------------------------------                                                ----------------------------------
                                                 att_temp_01   b
                                           WHERE     b.attdate BETWEEN p_fdate
                                                                   AND p_tdate
                                                 AND a.empcode =
                                                     NVL (p_empcode, a.empcode)
                                                 AND a.empcode = b.empcode)
                                GROUP BY empcode,
                                         dp_code,
                                         dp_code_att,
                                         trans_date,
                                         off_in_time,
                                         duty_hr) a)) a;

    ----------- holiday insert
    UPDATE emp_refreshment_t01 a
       SET (intime, outtime) =
               (SELECT b.intime, b.outtime
                  FROM att_emp b
                 WHERE a.empcode = b.empcode AND a.attdate = b.attdate);

    DELETE FROM att_leave_t01;

    --LEAVE ----------LEAVE------------------LEAVE -------------LEAVE
    DELETE FROM att_leave_t01;

    INSERT INTO att_leave_t01 (empcode, attdate)
        SELECT DISTINCT empcode, attdate
          FROM (SELECT empcode, TRUNC (tran_date) attdate
                  FROM (SELECT *
                          FROM hr_leave_child
                         WHERE     (    date_from >= p_fdate
                                    AND date_from <= p_tdate)
                               AND (date_to >= p_fdate AND date_to <= p_tdate))
                       a,
                       holiday_info  b
                 WHERE     NVL (is_holiday, 0) <> 1
                       AND NVL (a.leaveadtype, '#') <> 'Encashment'
                       AND NVL (a.leaveadtype, '#') <> 'Opening'
                       --  AND NVL (a.entry_type, 'M') <> 'A'
                       AND (b.tran_date BETWEEN date_from AND date_to)
                       AND (b.tran_date BETWEEN p_fdate AND p_tdate));

    --   RETURN;

    ---  leave
    UPDATE (SELECT a.status, a.remark, a.is_leave
              FROM emp_refreshment_t01 a, att_leave_t01 b
             WHERE a.attdate = b.attdate AND a.empcode = b.empcode)
       SET is_leave = 1, status = 'L', remark = 'Leave';

    --------- OUT OF OFFICE
    UPDATE (SELECT a.status, a.remark
              FROM emp_refreshment_t01 a, att_manual_t_2 b
             WHERE     a.empcode = b.empcode
                   AND a.attdate = b.attdate
                   AND b.att_type = 1)
       SET status = 'OF', remark = 'out of office';

    ------------------------ TYPE ---------------------------------

    ------------------------------------ UPDATE  TYPE ---------------------------
    UPDATE emp_refreshment_t01 a
       SET (unitid,
            dp_code,
            grade,
            desig_name) =
               (SELECT b.businessunitid,
                       UPPER (b.dp_code),
                       NVL (b.refreshment_grade, b.salarygrade),
                       b.desig_name
                  FROM emp b
                 WHERE a.empcode = b.empcode);

    UPDATE emp_refreshment_t01 a
       SET TYPE = NULL
     WHERE TO_CHAR (attdate, 'rrrrmm') >= 201704;

    MERGE INTO emp_refreshment_t01 a
         USING (SELECT z.empcode,
                       z.attdate,
                       z.intime,
                       z.outtime
                  FROM att_view_short_tour_leave_1 z) b
            ON (a.attdate = b.attdate AND a.empcode = b.empcode)
    WHEN MATCHED
    THEN
        UPDATE SET a.intime = b.intime, a.outtime = b.outtime;

    --------------------------
    UPDATE emp_refreshment_t01 a
       SET TYPE = 'OT'
     WHERE     (   (    a.grade IN ('GRADE-15',
                                    'GRADE-16',
                                    'GRADE-17',
                                    'GRADE-18',
                                    'GRADE-19',
                                    'GRADE-20')
                    AND a.attdate BETWEEN '01-feb-2017' AND '31-dec-2029'   --
                                                                         )
                OR (                                                        --
                        a.grade IN ('GRADE-12',
                                    'GRADE-13',
                                    'GRADE-14',
                                    'GRADE-15',
                                    'GRADE-16',
                                    'GRADE-17',
                                    'GRADE-18',
                                    'GRADE-19',
                                    'GRADE-20')
                    AND a.attdate BETWEEN '01-jan-2017' AND '31-jan-2017'   --
                                                                         )
                ---
                OR (                                                        --
                    (   LOWER (a.desig_name) LIKE '%driver%'
                     OR LOWER (a.desig_name) LIKE '%guard%'
                     OR LOWER (a.desig_name) LIKE '%cleaner%')              --
                                                              ))
           AND TO_CHAR (attdate, 'rrrrmm') >= 201704;

    UPDATE emp_refreshment_t01 a
       SET TYPE = 'REFRESHMENT'
     WHERE TO_CHAR (attdate, 'rrrrmm') >= 201704 AND TYPE IS NULL;

    -- select distinct dp_code from emp_refreshment_t01
    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 0
     WHERE TO_CHAR (attdate, 'rrrrmm') >= 201704;

    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 1
     WHERE TO_CHAR (attdate, 'rrrrmm') >= 201704 --  AND UPPER (dp_code) <> UPPER ('FAC')
                                                --   AND UPPER (dp_code) <> UPPER ('FAC')
                                                ;

    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 0
     WHERE     TO_CHAR (attdate, 'rrrrmm') >= 201704
           AND (   LOWER (a.desig_name) LIKE '%driver%'
                OR LOWER (a.desig_name) LIKE '%cleaner%'
                OR LOWER (a.desig_name) LIKE '%guard%'
                OR LOWER (a.desig_name) LIKE '%cook%'
                OR LOWER (a.desig_name) LIKE '%gardener%'
                OR LOWER (a.desig_name) LIKE '%washing%'
                OR LOWER (a.desig_name) LIKE '%peon%'
                OR LOWER (a.desig_name) LIKE '%messenger%'
                OR LOWER (a.desig_name) LIKE '%dispatch clerk%') --AND is_accurate_time = 1
                                                                 ;

    -----------------------------------------------

    --emp_refreshment
    ------ refreshment
    UPDATE emp_refreshment_t01 a
       SET (is_holiday, remark_long) =
               (SELECT 1, 'Govt Holiday'
                  FROM holiday_info b
                 WHERE     TRUNC (a.attdate) = TRUNC (b.tran_date)
                       AND NVL (NVL (b.is_govt_holiday, b.is_other_holiday),
                                0) =
                           1)
     WHERE EXISTS
               (SELECT 1
                  FROM holiday_info c
                 WHERE     TRUNC (a.attdate) = TRUNC (c.tran_date)
                       AND NVL (NVL (c.is_govt_holiday, c.is_other_holiday),
                                0) =
                           1);

    MERGE INTO emp_refreshment_t01 x
         USING (SELECT c.empcode,
                       b.tran_date,
                       CASE
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                1
                           THEN
                               dt_mix (b.tran_date,
                                       get_default_schedule (c.empcode, 'S'))
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                0
                           THEN
                               dt_mix (b.tran_date, b.tran_date)
                           ELSE
                               dt_mix (b.tran_date, office_start_time)
                       END    office_in_time,
                       CASE
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                1
                           THEN
                               dt_mix (b.tran_date,
                                       get_default_schedule (c.empcode, 'E'))
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                0
                           THEN
                               dt_mix (b.tran_date, b.tran_date)
                           ELSE
                               dt_mix (b.tran_date, office_end_time)
                       END    office_out_time,
                       --
                       CASE
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                1
                           THEN
                               0
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                0
                           THEN
                               1
                           ELSE
                               DECODE (b.TYPE, 'HOLIDAY', 1, 0)
                       END    is_holiday,
                       CASE
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                1
                           THEN
                               'REGULARDAY'
                           WHEN is_alternative_office_day (b.tran_date,
                                                           c.empcode) =
                                0
                           THEN
                               'HOLIDAY'
                           ELSE
                               b.TYPE
                       END    remark_long
                  FROM locationwise_schedule_2_v2 b, emp c
                 WHERE     (CASE
                                WHEN     UPPER (c.dp_code) = 'FAC'
                                     AND c.businessunit = 'Pharma'
                                THEN
                                    'FACTORY PHARMA'
                                WHEN     UPPER (c.dp_code) = 'FAC'
                                     AND c.businessunit = 'Cephalosporin'
                                THEN
                                    'FACTORY CEPHA'
                                WHEN     UPPER (c.dp_code) = 'FAC'
                                     AND UPPER (c.businessunit) IN
                                             ('NMD', 'HERBAL')
                                THEN
                                    'FACTORY NMD'
                                WHEN UPPER (c.dp_code) IN ('HDO',
                                                           'HO',
                                                           'Head Ofifice',
                                                           'DHAKA-H.O',
                                                           'Head Office',
                                                           'HEAD OFFICE')
                                -- AND c.department_name <> 'Sales and Distribution'
                                THEN
                                    'HO'
                                ELSE
                                    'DEPO'
                            END) =
                           b.LOCATION
                       AND b.tran_date BETWEEN p_fdate AND p_tdate
                       AND c.empcode = NVL (p_empcode, c.empcode)) y
            ON (x.attdate = y.tran_date AND x.empcode = y.empcode)
    WHEN MATCHED
    THEN
        UPDATE SET x.office_in_time = y.office_in_time,
                   x.office_out_time = y.office_out_time,
                   x.is_holiday = y.is_holiday,
                   x.remark_long = y.remark_long;

      /*


MERGE INTO emp_refreshment_t01 a
   USING (SELECT b.tran_date attdate, c.empcode,
                 dt_mix (b.tran_date, office_start_time) office_in_time,
                 dt_mix (b.tran_date, office_end_time) office_out_time,
                 DECODE (b.TYPE, 'HOLIDAY', 1, 0) is_holiday,
                 b.TYPE remark_long, b.TYPE day_type,
                 UPPER (c.dp_code) LOCATION, UPPER (c.dp_code) dp_code
            FROM locationwise_schedule_2_v2 b, emp c
           WHERE (CASE
                     WHEN UPPER (c.dp_code) = 'FAC'
                     AND c.businessunit = 'Pharma'
                        THEN 'FACTORY PHARMA'
                     WHEN UPPER (c.dp_code) = 'FAC'
                     AND c.businessunit = 'Cephalosporin'
                        THEN 'FACTORY CEPHA'
                     WHEN UPPER (c.dp_code) = 'FAC'
                     AND c.businessunit = 'NMD'
                        THEN 'FACTORY NMD'
                     WHEN UPPER (c.dp_code) = 'HDO'
                        THEN 'HO'
                     ELSE 'DEPO'
                  END
                 ) = b.LOCATION) b
   ON (a.empcode = b.empcode AND a.attdate = b.attdate)
   WHEN MATCHED THEN
      UPDATE
         SET office_in_time = b.office_in_time,
             office_out_time = b.office_out_time,
             is_holiday = b.is_holiday, remark_long = b.remark_long,
             day_type = b.day_type, LOCATION = b.LOCATION,
             dp_code = b.dp_code
      ;


*/

    --------------------
    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 0
     WHERE NVL (is_holiday, 0) = 1;

    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 1
     WHERE NVL (is_holiday, 0) = 0;

    UPDATE emp_refreshment_t01 a
       SET is_accurate_time = 0
     WHERE     TO_CHAR (attdate, 'rrrrmm') >= 201704
           AND (   LOWER (a.desig_name) LIKE '%driver%'
                OR LOWER (a.desig_name) LIKE '%cleaner%'
                OR LOWER (a.desig_name) LIKE '%guard%'
                OR LOWER (a.desig_name) LIKE '%cook%'
                OR LOWER (a.desig_name) LIKE '%gardener%'
                OR LOWER (a.desig_name) LIKE '%washing%'
                OR LOWER (a.desig_name) LIKE '%peon%'
                OR LOWER (a.desig_name) LIKE '%messenger%'
                OR LOWER (a.desig_name) LIKE '%dispatch clerk%')
           AND is_accurate_time = 1;

    --------------------------
    UPDATE emp_refreshment_t01 a
       SET (grade) =
               (SELECT NVL (b.refreshment_grade, b.salarygrade)
                  FROM emp b
                 WHERE a.empcode = b.empcode);

    UPDATE emp_refreshment_t01 c
       SET (refreshment_rate, rate_holiday, rate_regular) =
               (SELECT NULL refreshment_rate, a.rate_holiday, a.rate_regular
                  FROM hr_salarygrade a, emp b
                 WHERE     a.sgrade =
                           NVL (b.refreshment_grade, b.salarygrade)
                       AND c.empcode = b.empcode)
     WHERE TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET total_working_hours = ROUND ((outtime - intime) * 24, 2)
     WHERE     intime IS NOT NULL
           AND outtime IS NOT NULL
           AND TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01 a
       SET (minimum_regular_time, minimum_holiday_time) =
               (SELECT b.time_regular, b.time_holiday
                  FROM refreshment_time b
                 WHERE TO_CHAR (a.attdate, 'rrrrmm') =
                       b.YEAR || LPAD (b.MONTH, 2, 0))
     WHERE TYPE = 'REFRESHMENT';

    --- jumma settings
    UPDATE emp_refreshment_t01 a
       SET friday_deduction_hour = TO_NUMBER (TO_CHAR (outtime, 'mi')) / 60
     WHERE     TO_NUMBER (TO_CHAR (outtime, 'hh24mi')) BETWEEN 1301 AND 1344
           AND UPPER (TRIM (TO_CHAR (attdate, 'day'))) = 'FRIDAY';

    UPDATE emp_refreshment_t01 a
       SET friday_deduction_hour = 45 / 60
     WHERE     TO_NUMBER (TO_CHAR (outtime, 'hh24mi')) >= 1345
           AND TO_NUMBER (TO_CHAR (intime, 'hh24mi')) <= 1301
           AND UPPER (TRIM (TO_CHAR (attdate, 'day'))) = 'FRIDAY';

    UPDATE emp_refreshment_t01 a
       SET late_deduction_hour = NVL ((intime - office_in_time), 0)
     WHERE     (intime - office_in_time) > 0
           AND intime IS NOT NULL
           AND outtime IS NOT NULL
           AND NVL (is_holiday, 0) = 0
           AND is_accurate_time = 1;

    UPDATE emp_refreshment_t01
       SET late_deduction_hour = NVL (late_deduction_hour, 0);

    UPDATE emp_refreshment_t01
       SET extra_working_hours =
               ROUND (
                   CASE
                       ------------
                       WHEN     NVL (is_holiday, 0) = 1
                            AND ROUND (
                                      ((outtime - intime) * 24)
                                    + (10 / 60)
                                    - NVL (friday_deduction_hour, 0),
                                    2)                                      --
                                       --
                                       >=
                                minimum_holiday_time
                       THEN
                           ROUND (
                                 ((outtime - intime) * 24)
                               + (10 / 60)
                               - NVL (friday_deduction_hour, 0),
                               2)
                       ---------------
                       WHEN     NVL (is_holiday, 0) = 0
                            AND ROUND (
                                      (  (  (outtime - intime)
                                          - (office_out_time - office_in_time))
                                       * 24)
                                    + (10 / 60)
                                    - NVL (friday_deduction_hour, 0),
                                    2) >=
                                minimum_regular_time
                       THEN
                           ROUND (
                                 (  (  (outtime - intime)
                                     - (office_out_time - office_in_time))
                                  * 24)
                               + (10 / 60)
                               - NVL (friday_deduction_hour, 0),
                               2)
                       ELSE
                           NULL
                   END,
                   2)
     WHERE     intime IS NOT NULL
           AND outtime IS NOT NULL
           AND TYPE = 'REFRESHMENT';

    ---- from end time (accurate time )
    UPDATE emp_refreshment_t01 a
       SET extra_working_hours =
               ROUND (
                   CASE
                       WHEN     NVL (is_holiday, 0) = 0
                            AND ROUND (
                                      (  (  (outtime - office_out_time)
                                          - NVL (late_deduction_hour, 0))
                                       * 24)
                                    + (10 / 60)
                                    - NVL (friday_deduction_hour, 0),
                                    2) >=
                                minimum_regular_time
                       THEN
                           ROUND (
                                 (  (  (outtime - office_out_time)
                                     - NVL (late_deduction_hour, 0))
                                  * 24)
                               + (10 / 60)
                               - NVL (friday_deduction_hour, 0),
                               2)
                       ELSE
                           NULL
                   END,
                   2)
     WHERE     intime IS NOT NULL
           AND outtime IS NOT NULL
           AND TYPE = 'REFRESHMENT'
           AND is_accurate_time = 1
           AND NVL (is_holiday, 0) = 0;

    ------------------0007
    UPDATE emp_refreshment_t01
       SET extra_working_hours = extra_working_hours
     WHERE     intime IS NOT NULL
           AND outtime IS NOT NULL
           AND TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET refreshment_rate =
               DECODE (NVL (is_holiday, 0), 1, rate_holiday, rate_regular)
     WHERE TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET total_amount = 0
     WHERE TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET total_amount = refreshment_rate
     WHERE NVL (extra_working_hours, 0) > 0 AND TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET status = 'P'
     WHERE intime IS NOT NULL;

    UPDATE emp_refreshment_t01
       SET extra_working_hours_text =
               TO_CHAR (TRUNC (SYSDATE) + (extra_working_hours / 24),
                        'HH24:MI')
     WHERE extra_working_hours IS NOT NULL AND TYPE = 'REFRESHMENT';

    UPDATE emp_refreshment_t01
       SET total_working_hours_text =
               TO_CHAR (TRUNC (SYSDATE) + (total_working_hours / 24),
                        'HH24:MI')
     WHERE total_working_hours IS NOT NULL AND TYPE = 'REFRESHMENT';

    --- otrate-------------------------------------------otrate --------------------------------------------
    UPDATE emp_refreshment_t01 a
       SET otrate =
               (SELECT ROUND ((b.salper / 208) * 2, 2)
                  FROM hr_empsalstructure b, emp c
                 WHERE     b.empcode = c.empcode
                       AND b.slno = 1
                       AND a.empcode = c.empcode)
     WHERE TYPE = 'OT' AND SUBSTR (EMPCODE, 1, 3) IN ('IPI', 'INM');



    --   UPDATE emp_refreshment_t01 a
    --      SET otrate =
    --             (SELECT CASE WHEN YEARS >= 4 THEN 40 ELSE 35 END
    --                FROM (SELECT (p_tdate - C.JOIN_DATE) / 365 YEARS
    --                        FROM emp c
    --                       WHERE a.empcode = c.empcode))
    --    WHERE TYPE = 'OT' AND SUBSTR (EMPCODE, 1, 3) IN ('EMP');

    UPDATE emp_refreshment_t01 a
       SET otrate =
               (SELECT CASE WHEN MON >= 6 THEN 50 ELSE 45 END
                  FROM (SELECT TRUNC (MONTHS_BETWEEN (p_tdate, C.JOIN_DATE))    AS MON
                          FROM emp c
                         WHERE a.empcode = c.empcode))
     WHERE TYPE = 'OT' AND SUBSTR (EMPCODE, 1, 3) IN ('EMP');

    -----------

    --- othour
    UPDATE emp_refreshment_t01 a
       SET othours =
               DECODE (
                   SIGN (
                       ROUND (
                             (  (outtime - intime)
                              - (office_out_time - office_in_time))
                           * 24)),
                   1,                                                       --
                      ROUND (
                            (  (outtime - intime)
                             - (office_out_time - office_in_time))
                          * 24,
                          2),
                   0)
     WHERE     TYPE = 'OT'
           AND intime IS NOT NULL
           AND outtime IS NOT NULL
           AND NVL (is_holiday, 0) = 0;

    UPDATE emp_refreshment_t01 a
       SET othours =
               DECODE (SIGN (ROUND (((outtime - intime)) * 24)),
                       1,                                                   --
                          ROUND (((outtime - intime)) * 24, 2),
                       0)
     WHERE     TYPE = 'OT'
           AND intime IS NOT NULL
           AND outtime IS NOT NULL
           AND NVL (is_holiday, 0) = 1;

    ---------- OT CALC FROM  OFFICE ENDING TIME
    UPDATE emp_refreshment_t01 a
       SET othours =
               DECODE (
                   SIGN (
                       ROUND (
                             (  (outtime - office_out_time)
                              - NVL (late_deduction_hour, 0))
                           * 24)),
                   1,                                                       --
                      ROUND (
                            (  (outtime - office_out_time)
                             - NVL (late_deduction_hour, 0))
                          * 24,
                          2),
                   0)
     WHERE     intime IS NOT NULL
           AND outtime IS NOT NULL
           AND TYPE = 'OT'
           AND NVL (is_accurate_time, 0) = 1
           AND NVL (is_holiday, 0) = 0;

    UPDATE emp_refreshment_t01 a
       SET othours_actual = othours
     WHERE TYPE = 'OT';

    UPDATE emp_refreshment_t01 a
       SET othours =
               ROUND (othours + (10 / 60) - NVL (friday_deduction_hour, 0),
                      2)
     WHERE TYPE = 'OT' AND NVL (is_holiday, 0) = 0;

    UPDATE emp_refreshment_t01 a
       SET othours =
                 DECODE (TO_CHAR (office_in_time, 'HH24:MI'),
                         '08:30', 2.5,
                         2)
               +                                                            --
                 -- ot_round_hours
                 --        (
                 DECODE (
                     SIGN (
                         ROUND (
                               (  (outtime - office_out_time)
                                - NVL (late_deduction_hour, 0))
                             * 24)),
                     1,                                                     --
                        ROUND (
                              (  (outtime - office_out_time)
                               - NVL (late_deduction_hour, 0))
                            * 24,
                            2),
                     0)
     -- )
     --
     WHERE     (empcode, attdate) IN
                   (SELECT b.empcode, c.attdate
                      FROM emp_refreshment_t01 c, emp b
                     WHERE     TO_CHAR (c.intime, 'hh24mi') BETWEEN 500
                                                                AND 610
                           AND c.empcode = b.empcode
                           AND TRUNC (c.intime) BETWEEN p_fdate AND p_tdate
                           --   AND b.emp_status = 'A'
                           AND (c.outtime - c.intime) * 24 >=
                                 ((c.office_out_time - c.office_in_time) * 24)
                               + 1.5
                           AND c.LOCATION = 'FAC'
                           AND TYPE = 'OT'
                           AND NVL (c.is_holiday, 0) = 0)
           AND NOT EXISTS
                   (SELECT 1
                      FROM emp z
                     WHERE     (   LOWER (z.desig_name) LIKE '%driver%'
                                OR LOWER (z.desig_name) LIKE '%cleaner%'
                                OR LOWER (z.desig_name) LIKE '%guard%'
                                OR LOWER (z.desig_name) LIKE '%cook%'
                                OR LOWER (z.desig_name) LIKE '%gardener%'
                                OR LOWER (z.desig_name) LIKE '%washing%'
                                OR LOWER (z.desig_name) LIKE '%peon%'
                                OR LOWER (z.desig_name) LIKE '%messenger%'
                                OR LOWER (z.desig_name) LIKE
                                       '%dispatch clerk%')
                           AND a.empcode = z.empcode)
           AND NVL (is_holiday, 0) = 0;

    UPDATE emp_refreshment_t01 a
       SET othours =
               CASE
                   WHEN othours BETWEEN 0 AND 1.99 AND a.LOCATION = 'FAC'
                   THEN
                       0
                   WHEN othours BETWEEN 1 AND 1.49 AND a.LOCATION <> 'FAC'
                   THEN
                       1
                   WHEN othours BETWEEN 1.50 AND 1.99 AND a.LOCATION <> 'FAC'
                   THEN
                       1.50
                   WHEN othours BETWEEN 2 AND 2.49
                   THEN
                       2
                   WHEN othours BETWEEN 2.50 AND 2.99
                   THEN
                       2.50
                   --
                   WHEN othours BETWEEN 3 AND 3.49
                   THEN
                       3
                   WHEN othours BETWEEN 3.50 AND 3.99
                   THEN
                       3.50
                   --
                   WHEN othours BETWEEN 4 AND 4.49
                   THEN
                       4
                   WHEN othours BETWEEN 4.50 AND 4.99
                   THEN
                       4.50
                   --5
                   WHEN othours BETWEEN 5 AND 5.49
                   THEN
                       5
                   WHEN othours BETWEEN 5.50 AND 5.99
                   THEN
                       5.50
                   --6
                   WHEN othours BETWEEN 6 AND 6.49
                   THEN
                       6
                   WHEN othours BETWEEN 6.50 AND 6.99
                   THEN
                       6.50
                   --7
                   WHEN othours BETWEEN 7 AND 7.49
                   THEN
                       7
                   WHEN othours BETWEEN 7.50 AND 7.99
                   THEN
                       7.50
                   --8
                   WHEN othours BETWEEN 8 AND 8.49
                   THEN
                       8
                   WHEN othours BETWEEN 8.50 AND 8.99
                   THEN
                       8.50
                   --9
                   WHEN othours BETWEEN 9 AND 9.49
                   THEN
                       9
                   WHEN othours BETWEEN 9.50 AND 9.99
                   THEN
                       9.50
                   --10
                   WHEN othours BETWEEN 10 AND 10.49
                   THEN
                       10
                   WHEN othours BETWEEN 10.50 AND 10.99
                   THEN
                       10.50
                   --11
                   WHEN othours BETWEEN 11 AND 11.49
                   THEN
                       11
                   WHEN othours BETWEEN 11.50 AND 11.99
                   THEN
                       11.50
                   --12
                   WHEN othours BETWEEN 12 AND 12.49
                   THEN
                       12
                   WHEN othours BETWEEN 12.50 AND 12.99
                   THEN
                       12.50
                   --13
                   WHEN othours BETWEEN 13 AND 13.49
                   THEN
                       13
                   WHEN othours BETWEEN 13.50 AND 13.99
                   THEN
                       13.50
                   --14
                   WHEN othours BETWEEN 14 AND 14.49
                   THEN
                       14
                   WHEN othours BETWEEN 14.50 AND 14.99
                   THEN
                       14.50
                   --15
                   WHEN othours BETWEEN 15 AND 15.49
                   THEN
                       15
                   WHEN othours BETWEEN 15.50 AND 15.99
                   THEN
                       15.50
                   --16
                   WHEN othours BETWEEN 16 AND 16.49
                   THEN
                       16
                   WHEN othours BETWEEN 16.50 AND 16.99
                   THEN
                       16.50
                   --17
                   WHEN othours BETWEEN 17 AND 17.49
                   THEN
                       17
                   WHEN othours BETWEEN 17.50 AND 17.99
                   THEN
                       17.50
                   --18
                   WHEN othours BETWEEN 18 AND 18.49
                   THEN
                       18
                   WHEN othours BETWEEN 18.50 AND 18.99
                   THEN
                       18.50
                   --19
                   WHEN othours BETWEEN 19 AND 19.49
                   THEN
                       19
                   WHEN othours BETWEEN 19.50 AND 19.99
                   THEN
                       19.50
                   --19
                   WHEN othours BETWEEN 20 AND 20.49
                   THEN
                       20
                   WHEN othours BETWEEN 20.50 AND 20.99
                   THEN
                       20.50
                   --21
                   WHEN othours BETWEEN 21 AND 21.49
                   THEN
                       21
                   WHEN othours BETWEEN 21.50 AND 21.99
                   THEN
                       21.50
                   --22
                   WHEN othours BETWEEN 22 AND 22.49
                   THEN
                       22
                   WHEN othours BETWEEN 22.50 AND 22.99
                   THEN
                       22.50
                   --23
                   WHEN othours BETWEEN 23 AND 23.49
                   THEN
                       23
                   WHEN othours BETWEEN 23.50 AND 23.99
                   THEN
                       23.50
                   ELSE
                       0
               END
     WHERE TYPE = 'OT';

    UPDATE emp_refreshment_t01 a
       SET otamount = ROUND (NVL (othours, 0) * NVL (otrate, 0), 2)
     WHERE TYPE = 'OT';

    UPDATE emp_refreshment_t01 a
       SET othours_text = NULL
     WHERE TYPE = 'OT';

    UPDATE emp_refreshment_t01 a
       SET othours_text =
               TO_CHAR (TRUNC (SYSDATE) + (othours / 24), 'HH24:MI')
     WHERE TYPE = 'OT' AND NVL (othours, 0) > 0;

    ----- BEFORE DUTY HOUR  OT  AND REFRESHMENT

    -- REFRESHMENT factory early REFRESHMENT
    UPDATE emp_refreshment_t01 a
       SET total_amount = refreshment_rate,
           extra_working_hours_text =
               DECODE (TO_CHAR (office_in_time, 'HH24:MI'),
                       '08:30', '02:30',
                       '02:00'),
           extra_working_hours =
               DECODE (TO_CHAR (office_in_time, 'HH24:MI'), '08:30', 2.5, 2)
     WHERE     (empcode, attdate) IN
                   (SELECT b.empcode, c.attdate
                      FROM emp_refreshment_t01 c, emp b
                     WHERE     TO_CHAR (c.intime, 'hh24mi') BETWEEN 500
                                                                AND 610
                           AND c.empcode = b.empcode
                           AND TRUNC (c.intime) BETWEEN p_fdate AND p_tdate
                           AND (c.outtime - c.intime) * 24 >=
                                 ((c.office_out_time - c.office_in_time) * 24)
                               + 1.5
                           --  AND b.emp_status = 'A'
                           AND c.LOCATION = 'FAC'
                           AND c.TYPE = 'REFRESHMENT'
                           AND NVL (c.is_holiday, 0) = 0)
           AND NOT EXISTS
                   (SELECT 1
                      FROM emp z
                     WHERE     (   LOWER (z.desig_name) LIKE '%driver%'
                                OR LOWER (z.desig_name) LIKE '%cleaner%'
                                OR LOWER (z.desig_name) LIKE '%guard%'
                                OR LOWER (z.desig_name) LIKE '%cook%'
                                OR LOWER (z.desig_name) LIKE '%gardener%'
                                OR LOWER (z.desig_name) LIKE '%washing%'
                                OR LOWER (z.desig_name) LIKE '%peon%'
                                OR LOWER (z.desig_name) LIKE '%messenger%'
                                OR LOWER (z.desig_name) LIKE
                                       '%dispatch clerk%')
                           AND a.empcode = z.empcode);

    --- end factory early REFRESHMENT

    ---OT  factory early ot

    -- end factory early ot
    UPDATE emp_refreshment_t01 a
       SET total_amount = 0, otamount = 0
     WHERE a.empcode IN
               (SELECT b.empcode
                  FROM emp b
                 WHERE    (b.department_name IN
                               ('Market Survey and Research'))
                       OR (    b.department_name IN ('Marketing')
                           AND b.desig_name IN
                                   ('AREA MANAGER',
                                    'AREA-IN-CHARGE',
                                    'MEDICAL PROMOTION EXECUTIVE',
                                    'MEDICAL PROMOTION OFFICER',
                                    'MEDICAL PROMOTION OFFICER-1',
                                    'MEDICAL PROMOTION OFFICER-2',
                                    'REGIONAL IN CHARGE',
                                    'REGIONAL IN CHARGE',
                                    'REGIONAL MANAGER',
                                    'SR. AREA MANAGER',
                                    'SR. MEDICAL PROMOTION OFFICER',
                                    'ZONAL MANAGER',
                                    'ZONAL-IN-CHARGE'))
                       OR (    b.department_name IN
                                   ('Distribution')
                           AND (   b.desig_name IN
                                       ('SALES REP.', 'SR. SALES REP.')
                                OR b.desig_name LIKE 'DEPOT MANAGER%')));

    -----------------------------
    DELETE FROM emp_refreshment_t01
          WHERE attdate = '03-apr-2017' AND UPPER (dp_code) = 'FAC';

    ----------------------
    DELETE FROM emp_refreshment;

    INSERT INTO emp_refreshment
        SELECT * FROM emp_refreshment_t01;

    COMMIT;

    DELETE FROM
        emp_refreshment_revised
          WHERE     TRUNC (attdate) BETWEEN p_fdate AND p_tdate
                AND NVL (is_manual, 0) = 0;

    DELETE FROM
        emp_refreshment a
          WHERE (a.empcode, TRUNC (a.attdate)) IN
                    (SELECT b.empcode, TRUNC (b.attdate)
                       FROM emp_refreshment_revised b
                      WHERE     TRUNC (b.attdate) BETWEEN p_fdate AND p_tdate
                            AND NVL (b.is_manual, 0) = 1);

    ----- revised



    ot_hour_calculation (p_fdate, p_tdate);

    UPDATE emp_refreshment a
       SET (OTHOURS,
            OTAMOUNT,
            OTHOURS_ACTUAL,
            othours_text) =
               (SELECT b.TOTAL_HOUR,
                       b.TOTAL_HOUR * a.otrate
                           OTAMOUNT,
                       b.TOTAL_HOUR,
                       TO_CHAR (TRUNC (SYSDATE) + (b.TOTAL_HOUR / 24),
                                'HH24:MI')
                  FROM ot_time b
                 WHERE A.EMPCODE = b.empcode AND b.otdate = a.attdate)
     WHERE     TYPE = 'OT'
           AND attdate BETWEEN p_fdate AND p_tdate
           AND EXISTS
                   (SELECT 1
                      FROM ot_time b
                     WHERE A.EMPCODE = b.empcode AND b.otdate = a.attdate);



    UPDATE emp_refreshment a
       SET (OTHOURS,
            OTAMOUNT,
            OTHOURS_ACTUAL,
            othours_text) =
               (SELECT 0,
                       0,
                       0,
                       NULL
                  FROM DUAL b)
     WHERE     TYPE = 'OT'
           AND attdate BETWEEN p_fdate AND p_tdate
           AND NOT EXISTS
                   (SELECT 1
                      FROM ot_time b
                     WHERE A.EMPCODE = b.empcode AND b.otdate = a.attdate);



    --alter table emp_refreshment_revised add refreshment_amount_revised  number
    MERGE INTO emp_refreshment_revised a
         USING (SELECT *
                  FROM emp_refreshment
                 WHERE TRUNC (attdate) BETWEEN p_fdate AND p_tdate) b
            ON (    TRUNC (a.attdate) = TRUNC (b.attdate)
                AND a.empcode = b.empcode)
    --WHEN MATCHED THEN
    -- update set
    WHEN NOT MATCHED
    THEN
        INSERT     (a.empcode,
                    a.attdate,
                    a.intime,
                    a.outtime,
                    a.attstatus,
                    a.remark,
                    a.office_in_time,
                    a.office_out_time,
                    a.no_of_punch,
                    a.is_present,
                    a.is_late,
                    a.late_minute,
                    a.status,
                    a.is_leave,
                    a.remark_long,
                    a.dp_code,
                    a.dp_code_att,
                    a.location_att,
                    a.is_govt_holiday,
                    a.is_weekend_holiday,
                    a.is_present_in_time,
                    a.is_out_of_office,
                    a.is_absent,
                    a.is_late_el_force,
                    a.is_present_but_late,
                    a.is_present_in_govt_holiday,
                    a.is_present_in_weekend_holiday,
                    a.is_present_in_holiday,
                    a.leave_type,
                    a.leave_type_2,
                    a.dp_name,
                    a.office_late_time,
                    a.latein,
                    a.earlyout,
                    a.unitid,
                    a.in_deviceid,
                    a.out_deviceid,
                    a.in_location,
                    a.out_location,
                    a.is_holiday,
                    a.total_working_hours,
                    a.extra_working_hours,
                    a.refreshment_rate,
                    a.grade,
                    a.total_amount,
                    a.rate_holiday,
                    a.rate_regular,
                    a.total_working_hours_text,
                    a.extra_working_hours_text,
                    a.minimum_regular_time,
                    a.minimum_holiday_time,
                    a.othours,
                    a.otrate,
                    a.otamount,
                    a.othours_text,
                    a.othours_text_revised,
                    a.otamount_revised,
                    a.othour_revised,
                    a.otminute_revised,
                    a.refreshment_amount_revised,
                    a.othours_actual)
            VALUES (b.empcode,
                    b.attdate,
                    b.intime,
                    b.outtime,
                    b.attstatus,
                    b.remark,
                    b.office_in_time,
                    b.office_out_time,
                    b.no_of_punch,
                    b.is_present,
                    b.is_late,
                    b.late_minute,
                    b.status,
                    b.is_leave,
                    b.remark_long,
                    b.dp_code,
                    b.dp_code_att,
                    b.location_att,
                    b.is_govt_holiday,
                    b.is_weekend_holiday,
                    b.is_present_in_time,
                    b.is_out_of_office,
                    b.is_absent,
                    b.is_late_el_force,
                    b.is_present_but_late,
                    b.is_present_in_govt_holiday,
                    b.is_present_in_weekend_holiday,
                    b.is_present_in_holiday,
                    b.leave_type,
                    b.leave_type_2,
                    b.dp_name,
                    b.office_late_time,
                    b.latein,
                    b.earlyout,
                    b.unitid,
                    b.in_deviceid,
                    b.out_deviceid,
                    b.in_location,
                    b.out_location,
                    b.is_holiday,
                    b.total_working_hours,
                    b.extra_working_hours,
                    b.refreshment_rate,
                    b.grade,
                    b.total_amount,
                    b.rate_holiday,
                    b.rate_regular,
                    b.total_working_hours_text,
                    b.extra_working_hours_text,
                    b.minimum_regular_time,
                    b.minimum_holiday_time,
                    b.othours,
                    b.otrate,
                    b.otamount,
                    b.othours_text,
                    --
                    b.othours_text,
                    b.otamount,
                    SUBSTR (b.othours_text, 1, 2),
                    SUBSTR (b.othours_text, 4, 2),
                    b.total_amount,
                    b.othours_actual);

    --   select * from dpuser.refreshment_approval

    -- select proposed_start_date  from dpuser.refreshment_approval
    IF p_fdate >= '01-jul-18'
    THEN
        DELETE FROM
            emp_refreshment_revised a
              WHERE     (empcode, attdate) IN
                            (SELECT z.empcode, TRUNC (b.tran_date)
                               FROM (SELECT DISTINCT c.empcode
                                       FROM emp_refreshment_revised c
                                      WHERE TRUNC (c.attdate) BETWEEN p_fdate
                                                                  AND p_tdate)
                                    z,
                                    holiday_info  b
                              WHERE b.tran_date BETWEEN p_fdate AND p_tdate
                             MINUS
                             SELECT empcode, TRUNC (b.proposed_start_date)
                               FROM dpuser.refreshment_approval b
                              WHERE     TRUNC (b.proposed_start_date) BETWEEN p_fdate
                                                                          AND p_tdate
                                    AND final_status = 'Y')
                    AND a.attdate BETWEEN p_fdate AND p_tdate
                    AND a.total_amount >= 0;
    END IF;

    DELETE FROM
        emp_refreshment_revised a
          WHERE     a.empcode IN
                        (SELECT DISTINCT b.empcode
                           FROM hr_overtime_det b
                          WHERE     (b.refdate BETWEEN p_fdate AND p_tdate)
                                AND b.trntype = 'OT')
                AND a.attdate BETWEEN p_fdate AND p_tdate;

    DELETE FROM
        emp_refreshment_revised a
          WHERE     dp_code = 'FAC'
                AND a.attdate BETWEEN p_fdate AND p_tdate
                AND attdate IN ('06-jul-18')
                AND unitid IN ('Unit-01', 'Unit-02', 'Unit-04');

    DELETE FROM
        emp_refreshment_revised a
          WHERE     dp_code = 'FAC'
                AND a.attdate BETWEEN p_fdate AND p_tdate
                AND attdate IN ('12-jul-18')
                AND unitid IN ('Unit-01');

    DELETE FROM
        emp_refreshment_revised a
          WHERE     dp_code = 'FAC'
                AND a.attdate BETWEEN p_fdate AND p_tdate
                AND attdate IN ('12-jul-18')
                AND unitid IN ('Unit-01');

    DELETE FROM emp_refreshment_revised a
          WHERE     TRUNC (a.attdate) >= '01-sep-18'
                AND empcode IN (SELECT b.empcode
                                  FROM emp b
                                 WHERE b.salarygrade IN ('GRADE-01',
                                                         'GRADE-02',
                                                         'GRADE-03',
                                                         'GRADE-04'));

    IF p_fdate = '01-aug-18'
    THEN
        refresh_upto10 (p_fdate, p_tdate);
    END IF;

    IF p_fdate >= '01-sep-18'
    THEN
        refresh_upto10 (p_fdate, p_tdate);
    END IF;

    COMMIT;

    /* delete from emp_refreshment_revised_onoff
     where rownum<=10*/
    UPDATE emp_refreshment_revised
       SET remark_long = NULL
     WHERE remark_long = 'REGULARDAY';

    --delete from emp_refreshment_revised
    --where ATTDATE='03-apr-2017' and location ='Factory';
    COMMIT;
END;
/
