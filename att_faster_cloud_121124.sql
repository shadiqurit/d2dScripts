CREATE OR REPLACE PROCEDURE IPIHR.att_faster_cloud (p_fdate         DATE,
                                                    p_tdate         DATE,
                                                    p_empcode       VARCHAR2,
                                                    p_dp_code       VARCHAR2,
                                                    o_msg       OUT VARCHAR2)
AS
   p_fdaten           NUMBER := TO_NUMBER (TO_CHAR (p_fdate, 'rrrrmmdd')) - 1;
   p_tdaten           NUMBER := TO_NUMBER (TO_CHAR (p_tdate, 'rrrrmmdd'));
   tmpvar             NUMBER;
   -- o_msg    VARCHAR2 (500);
   v_date             DATE := SYSDATE;
   -- p_fdate            DATE;
   -- p_tdate            DATE;
   -- p_empcode          VARCHAR2 (500);
   p_dp_code_att      VARCHAR2 (500);
   v_status           VARCHAR2 (1000);
   v_remarks          VARCHAR2 (1000);
   vtimeseven         DATE;
   vtimenine          DATE;
   vtimeninefifteen   DATE;
   vtimeeleven        DATE;
   vtimefinish        DATE;
   v_intime           DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0830AM',
                  'RRRRMMDDHHMIAM');
   v_late_time        DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0840AM',
                  'RRRRMMDDHHMIAM');
   v_out_time         DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0500PM',
                  'RRRRMMDDHHMIAM');
   v_out_time2        DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0100PM',
                  'RRRRMMDDHHMIAM');
   -----ramadan setup
   ramadan            ramadan_date%ROWTYPE;
   v_intime_r         DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0900AM',
                  'RRRRMMDDHHMIAM');
   v_late_time_r      DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0910AM',
                  'RRRRMMDDHHMIAM');
   v_out_time_r       DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0330PM',
                  'RRRRMMDDHHMIAM');
   v_out_time2_r      DATE
      := TO_DATE (TO_CHAR (SYSDATE, 'RRRRMMDD') || '0100PM',
                  'RRRRMMDDHHMIAM');
   ----

   /*
         01. Pharma division: (8:00AM - 5:30PM)
   02. NMD division: (8:30AM - 4:30PM)
   03. Chepalosphorin Division: (8:00AM - 5:30PM)
   */
   v1_status          NUMBER;
   vn                 NUMBER := 0;
BEGIN
   --GOTO GOT;



   SELECT COUNT (*)
     INTO v1_status
     FROM att_running
    WHERE status = 'RUNNING';

   IF v1_status = 1
   THEN
      -- RETURN;

      NULL;
   ELSE
      UPDATE att_running
         SET status = 'RUNNING';

      COMMIT;
   END IF;

   BEGIN
      punch_data_merge_cloud (p_fdate, p_tdate);

      COMMIT;
   END;

   --   return;


   ------ access  table  data (userinfo  ,checkinout ) exported using dblink (acc)  int oracle table (  userinfo_01,checkinout_01)
   -- DELETE FROM userinfo_01;
   EXECUTE IMMEDIATE ('truncate table userinfo_01');

   COMMIT;

   --  DELETE FROM checkinout_01;
   EXECUTE IMMEDIATE ('truncate table checkinout_01');

   COMMIT;

   --  DELETE FROM checkinout_02;
   EXECUTE IMMEDIATE ('truncate table checkinout_02');

   COMMIT;

   --222222----   backup  of access table (userinfo and  checkinout ) in oracle ( userinfo_access_db and  checkinout_access_db )  without any change

   -----------------------

   ---deviceid
   /*
   MERGE INTO transaction_access_db a
USING (SELECT badgenumber, userid, checktime, checktype, verifycode,
              sensorid, workcode, sn,deviceid
         FROM checkinout_02) b
ON (a.checktime = b.checktime AND a.userid = b.userid)
  WHEN  MATCHED THEN
  update set a.deviceid=b.deviceid;
  */

   --333333----   backup  of access  data  avoiding  duplicate

   --444444 ===========================================================

   --5555555---------------------------------------------------------
   EXECUTE IMMEDIATE ('truncate table holiday_info_t2');

   COMMIT;

   INSERT INTO holiday_info_t2
      SELECT *
        FROM holiday_info
       WHERE tran_date BETWEEN p_fdate AND p_tdate;

   COMMIT;

   --  DELETE FROM att_data;
   EXECUTE IMMEDIATE ('truncate table att_data');

   COMMIT;

   INSERT INTO att_data (attenteryid,
                         attdatetime,
                         cardnumber,
                         empcode,
                         punchcardno,
                         userid,
                         badgenumber,
                         machine_id)
      SELECT DISTINCT
             NULL attenteryid,
             TO_DATE (TO_CHAR (a.checktime, 'RRRRMMDDHHMIAM'),
                      'RRRRMMDDHHMIAM')
                attdatetime,
             NULL cardnumber,
             b.empcode,
             NULL punchcardno,
             userid,
             a.badgenumber,
             a.sensorid machine_id
        FROM transaction_access_db a, emp_all_v b
       WHERE     TRUNC (checktime) BETWEEN p_fdate AND p_tdate
             /* and not exists (select 1 from att_dup_list c
              where to_number ( SUBSTR (a.userid, -4)) = to_number(c.empcode ) )*/
             AND CASE
                    WHEN LENGTH (a.userid) = 7
                    THEN
                       'EMP-' || SUBSTR (a.userid, -6)
                    WHEN LENGTH (a.userid) = 8
                    THEN
                       'INM-' || SUBSTR (a.userid, -6)
                    ELSE
                       'IPI-' || SUBSTR (a.userid, -6)
                 END = b.empcode
             AND NOT EXISTS
                    (SELECT 1
                       FROM emp c
                      WHERE b.empcode = c.employeecode)
             AND empcode = NVL (p_empcode, empcode)
      UNION ALL
      SELECT DISTINCT
             NULL attenteryid,
             TO_DATE (TO_CHAR (a.checktime, 'RRRRMMDDHHMIAM'),
                      'RRRRMMDDHHMIAM')
                attdatetime,
             NULL cardnumber,
             b.empcode,
             NULL punchcardno,
             userid,
             a.badgenumber,
             a.sensorid machine_id
        FROM transaction_access_db a, emp_all_v b
       WHERE     TRUNC (checktime) BETWEEN p_fdate AND p_tdate
             /* and not exists (select 1 from att_dup_list c
              where to_number ( SUBSTR (a.userid, -4)) = to_number(c.empcode ) )*/
             AND CASE
                    WHEN LENGTH (a.userid) = 7
                    THEN
                       'EMP-' || SUBSTR (a.userid, -6)
                    WHEN LENGTH (a.userid) = 8
                    THEN
                       'INM-' || SUBSTR (a.userid, -6)
                    ELSE
                       'IPI-' || SUBSTR (a.userid, -6)
                 END = b.empcode
             AND EXISTS
                    (SELECT 1
                       FROM emp c
                      WHERE b.empcode = c.employeecode)
             AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   DELETE FROM att_data
         WHERE ROWID NOT IN (  SELECT MAX (ROWID)
                                 FROM att_data
                             GROUP BY empcode, attdatetime);

   COMMIT;

   /*

   DELETE FROM att_data
         WHERE (empcode, attdatetime) IN (
                  SELECT b.empcode, b.checktime
                    FROM checkinout_04 b
                   WHERE b.deviceid = '244'
                     AND TRUNC (checktime) BETWEEN '14-mar-18' AND '25-mar-18');



   COMMIT;

   */



   -- DELETE FROM att_data_2;
   EXECUTE IMMEDIATE ('truncate table att_data_2');

   COMMIT;

   INSERT INTO att_data_2 (attdate, empcode)
      SELECT DISTINCT c.tran_date, b.empcode
        FROM userinfo_access_db a, emp_all_v b, holiday_info_t2 c
       WHERE     CASE
                    WHEN LENGTH (a.userid) = 7
                    THEN
                       'EMP-' || SUBSTR (a.userid, -6)
                    WHEN LENGTH (a.userid) = 8
                    THEN
                       'INM-' || SUBSTR (a.userid, -6)
                    ELSE
                       'IPI-' || SUBSTR (a.userid, -6)
                 END = b.empcode
             AND NOT EXISTS
                    (SELECT 1
                       FROM emp c
                      WHERE b.empcode = c.employeecode)
             AND empcode = NVL (p_empcode, empcode)
      UNION ALL
      SELECT DISTINCT c.tran_date, b.empcode
        FROM userinfo_access_db a, emp_all_v b, holiday_info_t2 c
       WHERE     CASE
                    WHEN LENGTH (a.userid) = 7
                    THEN
                       'EMP-' || SUBSTR (a.userid, -6)
                    WHEN LENGTH (a.userid) = 8
                    THEN
                       'INM-' || SUBSTR (a.userid, -6)
                    ELSE
                       'INM-' || SUBSTR (a.userid, -6)
                 END = b.empcode
             AND EXISTS
                    (SELECT 1
                       FROM emp c
                      WHERE b.empcode = c.employeecode)
             AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   --DELETE FROM att_data_empcode;
   EXECUTE IMMEDIATE ('truncate table att_data_empcode');

   COMMIT;

   INSERT INTO att_data_empcode (empcode)
      SELECT DISTINCT empcode
        FROM (SELECT DISTINCT empcode FROM att_data_2
              UNION ALL
              SELECT DISTINCT empcode FROM att_data);

   COMMIT;

   ---888
   --DELETE FROM att_manual_t_99;
   EXECUTE IMMEDIATE ('truncate table att_manual_t_99');

   COMMIT;

   INSERT INTO att_manual_t_99 (empcode,
                                attdate,
                                intime,
                                outtime,
                                remark,
                                att_type,
                                user_name)
      (SELECT a.empcode,
              b.tran_date attdate,
              a.intime,
              a.outtime,
              a.remark,
              a.att_type,
              a.user_name
         FROM att_manual a, holiday_info_t2 b
        WHERE     (TRUNC (b.tran_date) BETWEEN TRUNC (a.attdate)
                                           AND TRUNC (a.attdate_2))
              AND TRUNC (a.attdate) BETWEEN p_fdate AND p_tdate
              AND empcode = NVL (p_empcode, empcode)-- and dp_code_att =nvl(p_dp_code_att ,dp_code_att )
      );

   COMMIT;

   DELETE FROM att_manual_t_99 a
         WHERE ROWID NOT IN (  SELECT MAX (b.ROWID)
                                 FROM att_manual_t_99 b
                             GROUP BY b.empcode, b.attdate);

   COMMIT;

   --DELETE FROM att_manual_t_1;
   EXECUTE IMMEDIATE ('truncate table att_manual_t_1');

   COMMIT;

   INSERT INTO att_manual_t_1 (empcode,
                               attdate,
                               intime,
                               outtime,
                               remark,
                               att_type,
                               user_name)
      SELECT empcode,
             attdate,
             intime,
             outtime,
             remark,
             att_type,
             user_name
        FROM att_manual_t_99;

   -------------------
   -- DELETE FROM att_manual_t_2;
   EXECUTE IMMEDIATE ('truncate table att_manual_t_2');

   COMMIT;

   INSERT INTO att_manual_t_2 (empcode,
                               attdate,
                               intime,
                               outtime,
                               remark,
                               att_type,
                               user_name)
      SELECT empcode,
             attdate,
             intime,
             outtime,
             remark,
             att_type,
             user_name
        FROM att_manual_t_1-- and dp_code_att =nvl(p_dp_code_att ,dp_code_att )
   ;

   COMMIT;

   -----
   --  DELETE FROM att_emp_t01;

   ----
   --  DELETE FROM att_temp_01;
   EXECUTE IMMEDIATE ('truncate table att_temp_01');

   COMMIT;

   INSERT INTO att_temp_01 (empcode,
                            attdate,
                            emp_in_time,
                            emp_out_time,
                            no_of_total_punch)
      (  SELECT empcode,
                attdate,
                MIN (attdatetime) emp_in_time,
                MAX (attdatetime) emp_out_time,
                COUNT (*) no_of_total_punch
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
                        AND empcode = NVL (p_empcode, empcode)
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
                        AND (attdate BETWEEN p_fdate AND p_tdate)
                        AND empcode = NVL (p_empcode, empcode))
       GROUP BY empcode, attdate);

   COMMIT;

   EXECUTE IMMEDIATE ('truncate table att_emp_t01');

   COMMIT;
   --31032019
   att_emp_t01_ins (p_fdate, p_tdate, p_empcode);


   ----------- holiday insert
   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT a.empcode,
                      TRUNC (b.tran_date) attdate,
                      NVL (is_other_holiday, 0) is_other_holiday
                 FROM att_data_empcode a, holiday_info_t2 b
                WHERE empcode = NVL (p_empcode, empcode)) y
           ON (x.attdate = y.attdate AND x.empcode = y.empcode)
   WHEN NOT MATCHED
   THEN
      INSERT     (x.empcode, x.attdate, x.is_govt_holiday)
          VALUES (y.empcode, y.attdate, y.is_other_holiday);


   MERGE INTO att_emp_t01 x
        USING (SELECT b.empcode, b.businessunitid unitid, b.dp_code
                 FROM emp b) y
           ON (x.empcode = y.empcode)
   WHEN MATCHED
   THEN
      UPDATE SET x.unitid = y.unitid, x.dp_code = y.dp_code;

   COMMIT;

   -- DELETE FROM att_leave_t01;
   EXECUTE IMMEDIATE ('truncate table att_leave_t01');

   COMMIT;

   INSERT INTO att_leave_t01 (empcode, attdate)
      SELECT DISTINCT empcode, attdate
        FROM (SELECT empcode, TRUNC (tran_date) attdate
                FROM (SELECT *
                        FROM hr_leave_child
                       WHERE     NVL (leaveadtype, '#') <> 'Encashment'
                             AND NVL (leaveadtype, '#') <> 'Opening'
                             AND empcode = NVL (p_empcode, empcode)) a,
                     holiday_info b
               WHERE     NVL (is_holiday, 0) <> 1
                     AND NVL (a.leaveadtype, '#') <> 'Encashment'
                     AND NVL (a.leaveadtype, '#') <> 'Opening'
                     --  AND NVL (a.entry_type, 'M') <> 'A'
                     AND (b.tran_date BETWEEN date_from AND date_to)
                     AND (b.tran_date BETWEEN p_fdate AND p_tdate)
                     AND empcode = NVL (p_empcode, empcode));

   COMMIT;

   --   RETURN;

   ---  leave

   /*
   UPDATE att_emp_t01 a
      SET is_leave = 1,
          status = 'L',
          remark = 'Leave'
    WHERE EXISTS (SELECT 1
                    FROM att_leave_t01 b
                   WHERE a.attdate = b.attdate AND a.empcode = b.empcode)
      AND empcode = NVL (p_empcode, empcode);

      */
   UPDATE (SELECT a.status, a.remark, a.is_leave
             FROM att_emp_t01 a, att_leave_t01 b
            WHERE     a.attdate = b.attdate
                  AND a.empcode = b.empcode
                  AND a.empcode = NVL (p_empcode, a.empcode))
      SET is_leave = 1, status = 'L', remark = 'Leave';

   COMMIT;

   --------- OUT OF OFFICE
   UPDATE (SELECT a.status, a.remark, b.remark remarkb
             FROM att_emp_t01 a, att_manual_t_2 b
            WHERE     a.empcode = b.empcode
                  AND a.attdate = b.attdate
                  AND b.att_type = 1
                  AND a.empcode = NVL (p_empcode, a.empcode))
      SET status = 'OF', remark = NVL (remarkb, 'out of office');

   COMMIT;

   ------ status update  31032019
   UPDATE att_emp_t01
      SET office_in_time = dt_mix (attdate, v_intime),
          office_late_time = dt_mix (attdate, v_late_time),
          office_out_time = dt_mix (attdate, v_out_time),
          intime = dt_mix (intime, intime),
          outtime = dt_mix (outtime, outtime)
    WHERE intime IS NOT NULL               -- NVL (dp_code, '##') <> 'FACTORY'
                            ;

   COMMIT;

   UPDATE att_emp_t01
      SET office_out_time = dt_mix (attdate, v_out_time2)
    WHERE UPPER (TRIM (TO_CHAR (attdate, 'day'))) = 'THURSDAY'--   AND NVL (dp_code, '##') <> 'FACTORY'
   ;

   COMMIT;

   UPDATE att_emp_t01
      SET status = 'P'
    WHERE intime IS NOT NULL--AND NVL (dp_code, '##') <> 'FACTORY'
   ;

   COMMIT;

   /*

  UPDATE att_emp_t01
     SET latein =
            ROUND (DECODE (SIGN (intime - office_in_time),
                           1, (intime - office_in_time) * 24 * 60,
                           NULL
                          )
                  )
   WHERE intime IS NOT NULL AND SIGN (intime - office_late_time) = 1;

  UPDATE att_emp_t01
     SET earlyout =
            ROUND (DECODE (SIGN (office_out_time - outtime),
                           1, (office_out_time - outtime) * 24 * 60,
                           NULL
                          )
                  )
   WHERE outtime IS NOT NULL;

   */

   ------ ramadan time  change update

   --   return;

   -------------------
   --att_factory_process;


   IF SYSDATE >= '01-apr-2017'
   THEN
      /* SELECT b.*, c.empcode
                  FROM holiday_locationwise b, emp c
                 WHERE trandate IS NOT NULL
                   AND NVL (b.dp_code, NVL (c.dp_code, '#')) =
                                                             NVL (c.dp_code, '#')
                   AND NVL (b.department_name, NVL (c.department_name, '#')) =
                                                     NVL (c.department_name, '#')
                   AND NVL (b.unit, NVL (c.businessunit, '#')) =
                                                        NVL (c.businessunit, '#')
                   AND trandate BETWEEN p_fdate AND p_tdate*/



      MERGE INTO att_emp_t01 x
           USING (SELECT c.empcode,
                         b.tran_date,
                         CASE
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 1
                            THEN
                               dt_mix (b.tran_date,
                                       get_default_schedule (c.empcode, 'S'))
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 0
                            THEN
                               dt_mix (b.tran_date, b.tran_date)
                            ELSE
                               dt_mix (b.tran_date, office_start_time)
                         END
                            office_in_time,
                         CASE
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 1
                            THEN
                               dt_mix (b.tran_date,
                                       get_default_schedule (c.empcode, 'S'))
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 0
                            THEN
                               dt_mix (b.tran_date, b.tran_date)
                            ELSE
                               dt_mix (b.tran_date, office_end_time)
                         END
                            office_out_time,
                         --


                         CASE
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 1
                            THEN
                               0
                            WHEN IS_ALTERNATIVE_OFFICE_DAY (b.tran_date,
                                                            C.EMPCODE) = 0
                            THEN
                               1
                            ELSE
                               DECODE (b.TYPE, 'HOLIDAY', 1, 0)
                         END
                            is_holiday,
                         b.TYPE remark_long
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
                                      AND UPPER (c.businessunit) IN ('NMD',
                                                                     'HERBAL')
                                 THEN
                                    'FACTORY NMD'
                                 WHEN UPPER (c.dp_code) IN ('HDO',
                                                            'Head Ofifice',
                                                            'DHAKA-H.O',
                                                            'Head Office',
                                                            'HEAD OFFICE')
                                 -- AND c.department_name <> 'Sales and Distribution'
                                 THEN
                                    'HO'
                                 ELSE
                                    'DEPO'
                              END) = b.LOCATION
                         AND b.tran_date BETWEEN p_fdate AND p_tdate
                         AND c.empcode = NVL (p_empcode, c.empcode)) y
              ON (x.attdate = y.tran_date AND x.empcode = y.empcode)
      WHEN MATCHED
      THEN
         UPDATE SET x.office_in_time = y.office_in_time,
                    x.office_out_time = y.office_out_time,
                    x.is_holiday = y.is_holiday,
                    x.remark_long = y.remark_long;
   END IF;


   --<<GOT>>
   COMMIT;

   MERGE INTO att_emp_t01 a
        USING (SELECT b.*, c.empcode
                 FROM holiday_locationwise b, emp c
                WHERE     trandate IS NOT NULL
                and type ='HOLIDAY'
                      AND NVL (b.dp_code, NVL (c.dp_code, '#')) =
                             NVL (c.dp_code, '#')
                      AND NVL (b.department_name,
                               NVL (c.department_name, '#')) =
                             NVL (c.department_name, '#')
                      AND NVL (b.unit, NVL (c.businessunit, '#')) =
                             NVL (c.businessunit, '#')
                      AND trandate BETWEEN p_fdate AND p_tdate) b
           ON (    a.attdate = b.trandate
               AND a.empcode = b.empcode
               AND a.empcode = NVL (p_empcode, a.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET
         is_holiday = DECODE (b.TYPE, 'HOLIDAY', 1, 0),
         is_govt_holiday = DECODE (b.TYPE, 'HOLIDAY', 1, 0);
         
         
          MERGE INTO att_emp_t01 a
        USING (  SELECT b.*, c.empcode
                 FROM holiday_locationwise b, emp c
                WHERE     trandate IS NOT NULL
                and type <> 'HOLIDAY'
                      AND NVL (b.dp_code, NVL (c.dp_code, '#')) =
                             NVL (c.dp_code, '#')
                      AND NVL (b.department_name,
                               NVL (c.department_name, '#')) =
                             NVL (c.department_name, '#')
                      AND NVL (b.unit, NVL (c.businessunit, '#')) =
                             NVL (c.businessunit, '#')
                      AND trandate BETWEEN p_fdate AND p_tdate   ) b
           ON (    a.attdate = b.trandate
               AND a.empcode = b.empcode
               AND a.empcode = NVL (p_empcode, a.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET
         is_holiday = DECODE (b.TYPE, 'HOLIDAY', 1, 0),
         is_govt_holiday = DECODE (b.TYPE, 'HOLIDAY', 1, 0),
         remark =null, remark_long =null;

   COMMIT;

   /*
 WHEN NOT MATCHED THEN
   INSERT (id, address)
   VALUES (h.emp_id, h.address);
   */
   -- DELETE FROM hr_shift_temp;
   EXECUTE IMMEDIATE ('truncate table hr_shift_temp');

   COMMIT;

   INSERT INTO hr_shift_temp
      SELECT *
        FROM hr_emp_shift_v_002
       WHERE     empcode = NVL (p_empcode, empcode)
             AND attdate BETWEEN p_fdate AND p_tdate;

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT b.empcode,
                      b.start_time_g office_in_time,
                      b.end_time_g office_out_time,
                      1 is_shift,
                      b.attdate
                 FROM hr_shift_temp b
                WHERE     b.start_time_g IS NOT NULL
                      AND b.end_time_g IS NOT NULL
                      AND TRUNC (b.attdate) BETWEEN p_fdate AND p_tdate) y
           ON (    TRUNC (y.attdate) = TRUNC (x.attdate)
               AND y.empcode = x.empcode)
   WHEN MATCHED
   THEN
      UPDATE SET
         x.office_in_time = y.office_in_time,
         x.office_out_time = y.office_out_time,
         x.is_shift = y.is_shift;

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT b.empcode,
                      b.start_time_ot office_in_time,
                      b.end_time_ot office_out_time,
                      1 is_shift,
                      b.attdate
                 FROM hr_shift_temp b
                WHERE     b.start_time_ot IS NOT NULL
                      AND b.end_time_ot IS NOT NULL
                      AND TRUNC (b.attdate) BETWEEN p_fdate AND p_tdate) y
           ON (    TRUNC (y.attdate) = TRUNC (x.attdate)
               AND x.empcode = y.empcode)
   WHEN MATCHED
   THEN
      UPDATE SET
         x.office_in_time = y.office_in_time,
         x.office_out_time = y.office_out_time,
         x.is_shift = y.is_shift;

   COMMIT;
   holiday_process_att (p_fdate, p_tdate, p_empcode);
   COMMIT;

   --  att_emp

   /*

   -------is next day
   UPDATE att_emp_t01
      SET is_next_day = 1
    WHERE TO_CHAR (office_in_time + (8 / 24), 'rrrrmmdd') <>
                                          TO_CHAR (office_in_time, 'rrrrmmdd')
      AND office_in_time IS NOT NULL
      AND attdate BETWEEN p_fdate AND p_tdate
      AND is_shift = 1
      AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   ----office out time
   UPDATE att_emp_t01
      SET office_out_time = office_out_time + 1
    WHERE office_out_time IS NOT NULL
      AND attdate BETWEEN p_fdate AND p_tdate
      AND is_next_day = 1
      AND is_shift = 1
      AND empcode = NVL (p_empcode, empcode);

   COMMIT;
   ----- update intime and outtime
   MERGE INTO att_emp_t01 x
      USING (SELECT   a.empcode, a.attdate, MIN (attdatetime) date1,
                      MAX (attdatetime) date2
                 FROM (SELECT *
                         FROM att_emp_t01
                        WHERE office_out_time IS NOT NULL
                          AND office_in_time IS NOT NULL
                          AND attdate BETWEEN p_fdate AND p_tdate
                          AND is_next_day = 1
                          AND is_shift = 1) a,
                      (SELECT DISTINCT TRUNC (attdatetime) attdate,
                                       attdatetime, empcode
                                  FROM att_data
                                 WHERE (TRUNC (attdatetime) BETWEEN p_fdate
                                                                AND p_tdate
                                       )
                                   AND empcode = NVL (p_empcode, empcode)
-----------------------------
                       UNION ALL
                       SELECT attdate,
                              TO_DATE (   TO_CHAR (attdate, 'RRRRMMDD')
                                       || TO_CHAR (intime, 'HHMI AM'),
                                       'RRRRMMDDHHMI AM'
                                      ),
                              empcode
                         FROM att_manual_t_2
                        WHERE intime IS NOT NULL
                          AND (attdate BETWEEN p_fdate AND p_tdate)
                          AND empcode = NVL (p_empcode, empcode)
---------------------------------------------------------------------------------------
                       UNION ALL
                       SELECT attdate,
                              TO_DATE (   TO_CHAR (attdate, 'RRRRMMDD')
                                       || TO_CHAR (outtime, 'HHMI AM'),
                                       'RRRRMMDDHHMI AM'
                                      ),
                              empcode
                         FROM att_manual_t_2
                        WHERE outtime IS NOT NULL
                          AND (attdate BETWEEN p_fdate AND p_tdate)) b
                WHERE attdatetime BETWEEN (office_in_time - (2.5 / 24))
                                      AND (office_out_time + (2.5 / 24))
                  AND a.empcode = b.empcode
                  AND a.empcode = NVL (p_empcode, a.empcode)
             GROUP BY a.empcode, a.attdate) y
      ON (    x.empcode = y.empcode
          AND x.attdate = y.attdate
          AND x.empcode = NVL (p_empcode, x.empcode))
      WHEN MATCHED THEN
         UPDATE
            SET x.intime = y.date1, x.outtime = y.date2
         ;
  -- COMMIT;

   */

   -------------------- next day

   MERGE INTO att_emp_t01 x
        USING (  SELECT a.empcode,
                        a.attdate,
                        MIN (attdatetime) date1,
                        MAX (attdatetime) date2
                   FROM (SELECT *
                           FROM HR_EMP_SHIFT_V_N
                          WHERE     dt1 IS NOT NULL
                                -- and yearmn
                                AND dt2 IS NOT NULL
                                AND attdate BETWEEN p_fdate AND p_tdate--  AND is_next_day = 1
                                                                       --   AND is_shift = 1


                        ) a,
                        (SELECT DISTINCT
                                TRUNC (attdatetime) attdate,
                                attdatetime,
                                empcode
                           FROM att_data
                          WHERE     (TRUNC (attdatetime) BETWEEN p_fdate
                                                             AND p_tdate)
                                AND empcode = NVL (p_empcode, empcode)
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
                                AND empcode = NVL (p_empcode, empcode)
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
                                AND (attdate BETWEEN p_fdate AND p_tdate)) b
                  WHERE     attdatetime BETWEEN dt1 AND dt2
                        AND a.empcode = b.empcode
                        AND a.empcode = NVL (p_empcode, a.empcode)
               GROUP BY a.empcode, a.attdate) y
           ON (    x.empcode = y.empcode
               AND x.attdate = y.attdate
               AND x.empcode = NVL (p_empcode, x.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET x.intime = y.date1, x.outtime = y.date2;

   COMMIT;


   /*
 WHEN NOT MATCHED THEN
   INSERT (id, address)
   VALUES (h.emp_id, h.address);
   */

   --------- holiday from roaster
   UPDATE att_emp_t01
      SET status = DECODE (is_holiday, 1, 'W'),
          remark =
             DECODE (is_holiday,
                     1, DECODE (is_shift, 1, 'Shifting Holiday', 'Holiday'))
    WHERE     is_holiday = 1
          AND attdate BETWEEN p_fdate AND p_tdate
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET status = DECODE (is_govt_holiday, 1, 'H'),
          remark =
             DECODE (is_govt_holiday,
                     1, DECODE (is_shift, 1, 'Shifting Holiday', 'Holiday'))
    WHERE     is_govt_holiday = 1
          AND attdate BETWEEN p_fdate AND p_tdate
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET remark = 'Shifting Duty'
    WHERE     status = 'P'
          AND is_shift = 1
          --  AND (NVL (is_govt_holiday, 0) <> 1 OR NVL (is_holiday, 0) <> 1)
          AND attdate BETWEEN p_fdate AND p_tdate
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET status = 'A', remark = 'Absent'
    WHERE     status IS NULL
          AND (NVL (is_govt_holiday, 0) <> 1 OR NVL (is_holiday, 0) <> 1)
          AND attdate BETWEEN p_fdate AND p_tdate
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET latein =
             ROUND (
                DECODE (SIGN (intime - office_in_time),
                        1, (intime - (office_in_time)) * 24 * 60,
                        NULL))
    WHERE     intime IS NOT NULL
          AND SIGN (intime - (office_in_time + (10 / (24 * 60)))) = 1
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET earlyout =
             ROUND (
                DECODE (SIGN (office_out_time - outtime),
                        1, (office_out_time - outtime) * 24 * 60,
                        NULL))
    WHERE outtime IS NOT NULL AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01
      SET latein = NULL, earlyout = NULL, is_late = NULL
    WHERE NVL (is_holiday, 0) = 1 AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT b.tran_date attdate
                 FROM holiday_info b
                WHERE     b.is_other_holiday = 1
                      AND b.tran_date BETWEEN p_fdate AND p_tdate) y
           ON (    x.attdate = y.attdate
               AND x.empcode = NVL (p_empcode, x.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET latein = NULL, is_late = NULL, earlyout = NULL;

   COMMIT;

   -----------------------------
   --   LINK96
   ----------------------
   UPDATE att_emp_t01
      SET remark_long = remark
    WHERE empcode = NVL (p_empcode, empcode);

   COMMIT;


   --  truncate table transaction_99
   --  DELETE FROM transaction_99;
   EXECUTE IMMEDIATE ('truncate table transaction_99');

   INSERT INTO transaction_99 (userid,
                               empcode,
                               attdate,
                               datetime,
                               devid)
        SELECT userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI')
                  atttime,
               MAX (deviceid) deviceidmax
          FROM transaction_access_db a, emp_all_v b
         WHERE                                           --LENGTH (userid) = 9
                   --   AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
                   --  AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)


                   CASE
                      WHEN LENGTH (a.userid) = 8
                      THEN
                         'INM-' || SUBSTR (a.userid, -6)
                      ELSE
                         'IPI-' || SUBSTR (a.userid, -6)
                   END = b.empcode
               AND NOT EXISTS
                      (SELECT 1
                         FROM emp c
                        WHERE b.empcode = c.employeecode)
               -- AND SUBSTR (a.userid, 1, 1) <> '0'
               AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
               AND a.checktime IS NOT NULL
      GROUP BY a.userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (a.checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI')
      UNION ALL
        SELECT userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI')
                  atttime,
               MAX (deviceid) deviceidmax
          FROM transaction_access_db a, emp_all_v b
         WHERE                                           --LENGTH (userid) = 9
                   --   AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
                   --  AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)


                   CASE
                      WHEN LENGTH (a.userid) = 8
                      THEN
                         'INM-' || SUBSTR (a.userid, -6)
                      ELSE
                         'INM-' || SUBSTR (a.userid, -6)
                   END = b.empcode
               AND EXISTS
                      (SELECT 1
                         FROM emp c
                        WHERE b.empcode = c.employeecode)
               -- AND SUBSTR (a.userid, 1, 1) <> '0'
               AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
               AND a.checktime IS NOT NULL
      GROUP BY a.userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (a.checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI');

   DELETE FROM transaction_99
         WHERE ROWID NOT IN (  SELECT MAX (c.ROWID)
                                 FROM transaction_99 c
                             GROUP BY c.empcode, c.attdate, datetime);



   --  DELETE FROM transaction_100;
   EXECUTE IMMEDIATE ('truncate table transaction_100');

   INSERT INTO transaction_100
      SELECT * FROM transaction_99;

   UPDATE (SELECT out_deviceid deviceid_a, devid deviceid_b
             FROM att_emp_t01 a, transaction_100 b
            WHERE     b.datetime = a.outtime
                  AND a.attdate = b.attdate
                  AND a.empcode = b.empcode
                  AND a.empcode = NVL (p_empcode, a.empcode))
      SET deviceid_a = deviceid_b;

   COMMIT;

   UPDATE (SELECT in_deviceid deviceid_a, devid deviceid_b
             FROM att_emp_t01 a, transaction_100 b
            WHERE     b.datetime = a.intime
                  AND a.attdate = b.attdate
                  AND a.empcode = b.empcode
                  AND a.empcode = NVL (p_empcode, a.empcode))
      SET deviceid_a = deviceid_b;

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT * FROM att_device_location) y
           ON (    x.in_deviceid = y.deviceid
               AND x.empcode = NVL (p_empcode, x.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET x.in_location = y.LOCATION;

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT * FROM att_device_location) y
           ON (    x.out_deviceid = y.deviceid
               AND x.empcode = NVL (p_empcode, x.empcode))
   WHEN MATCHED
   THEN
      UPDATE SET x.out_location = y.LOCATION;

   COMMIT;

   ----latein +shortleave
   UPDATE att_emp_t01 a
      SET latein = NULL, status = 'P'
    WHERE     EXISTS
                 (SELECT 1
                    FROM shortleave b
                   WHERE     a.office_in_time BETWEEN b.starttime
                                                  AND b.endtime
                         AND a.empcode = b.empcode)
          AND NVL (is_holiday, 0) = 0
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   -- earlyout+shortleave
   UPDATE att_emp_t01 a
      SET earlyout = NULL
    WHERE     EXISTS
                 (SELECT 1
                    FROM shortleave b
                   WHERE     a.office_out_time BETWEEN b.starttime
                                                   AND b.endtime
                         AND a.empcode = b.empcode)
          AND NVL (is_holiday, 0) = 0
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   -- remarks +shortleave
   UPDATE att_emp_t01 a
      SET remark = shortleavelist (a.empcode, TRUNC (a.attdate)),
          remark_long = shortleavelist (a.empcode, TRUNC (a.attdate))
    WHERE     EXISTS
                 (SELECT 1
                    FROM shortleave b
                   WHERE     TRUNC (a.attdate) = TRUNC (b.starttime)
                         AND a.empcode = b.empcode)
          AND NVL (is_holiday, 0) = 0
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   UPDATE att_emp_t01 a
      SET remark = 'Holiday', remark_long = 'Holiday'
    WHERE  is_holiday =1 and    (attdate BETWEEN p_fdate AND p_tdate)
          AND EXISTS
                 (SELECT 1
                    FROM holiday_info b
                   WHERE b.is_other_holiday = 1 AND a.attdate = b.tran_date)
          AND empcode = NVL (p_empcode, empcode);

   DELETE FROM att_emp a
         WHERE     (a.attdate BETWEEN p_fdate AND p_tdate)
               AND empcode = NVL (p_empcode, empcode)-- AND dp_code_att = NVL (p_dp_code_att, dp_code_att)
   ;

   COMMIT;

   UPDATE att_emp_t01
      SET latein = NULL, earlyout = NULL
    WHERE     NVL (is_shift, 0) <> 1
          AND UPPER (TRIM (TO_CHAR (attdate, 'day'))) = 'FRIDAY'
          AND attdate BETWEEN p_fdate AND p_tdate
          AND empcode = NVL (p_empcode, empcode);

   COMMIT;

   MERGE INTO att_emp_t01 x
        USING (SELECT a.empcode, a.ter_date + 1 attdate
                 FROM emp a
                WHERE     a.emp_status = 'S'
                      AND a.ter_date + 1 >= p_fdate
                      AND a.ter_date IS NOT NULL
                      AND a.empcode = NVL (p_empcode, a.empcode)) y
           ON (    x.attdate >= y.attdate
               AND x.empcode = y.empcode
               AND x.attdate BETWEEN p_fdate AND p_tdate)
   WHEN MATCHED
   THEN
      UPDATE SET x.remark = 'Updated'
      DELETE
              WHERE x.remark = 'Updated';

   COMMIT;

   INSERT INTO att_emp
      SELECT *
        FROM att_emp_t01
       WHERE     (attdate BETWEEN p_fdate AND p_tdate)
             AND empcode = NVL (p_empcode, empcode);

   COMMIT;
   --  RETURN;
   COMMIT;
   show_leave2attstatus (p_empcode, p_fdate, p_tdate);

   COMMIT;
   o_msg := SQLERRM;
   ------ refreshment

   /*
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
         o_msg := SQLERRM;
         */

   /*
         select * from emp where empcode='DIH-0412'

   PRN-0016/DIH-0412/IPI-001376

   select * from ipihr.emp where empcode  ='IPI-001376'


   select  * from ipihr.hr_leave_child where empcode ='IPI-001376'

   select * from ipihr.emp where empno ='DIH-0412'

   select * from ipihr.emp where empno ='PRN-0016'


   select * from ipihr.emp where empno ='PRN-0016'


   att_manual













   select * from dpuser.EMPLEAVE_IPI where EMPUID =869

   insert into ipihr.hr_leave_child (empcode , leave_type ,date_from,date_to,duration,year,leaveadtype)
   select 'IPI-001376' empcode , decode ( LEAVETYPEID , 1,'CL',2,'SL',3,'EL') leave_type ,STARTDATE date_from,ENDDATE date_to,LEAVEQTY duration,to_char(STARTDATE,'rrrr') year,leaveadtype
    from dpuser.EMPLEAVE_IPI  where EMPUID =869
    */
   ipihr.show_leave2attstatus (p_empcode, p_fdate, p_tdate);

   UPDATE att_running
      SET status = NULL;

   --select 1/vn into vn from dual;
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
   --   RAISE;
      ROLLBACK;

      UPDATE att_running
         SET status = NULL;
         
         raise_application_error(-20010,DBMS_UTILITY.format_error_backtrace || SQLERRM);

      o_msg := DBMS_UTILITY.format_error_backtrace || SQLERRM;
      -- insert into erra values ( o_msg);
      -- commit;

    --  RAISE;
-- COMMIT;


END;
/
