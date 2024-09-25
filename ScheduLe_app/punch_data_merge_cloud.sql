CREATE OR REPLACE PROCEDURE IPIHR.punch_data_merge_cloud (pdt1    DATE,
                                                          pdt2    DATE)
AS
----


BEGIN


update a_punchlog set DEVID=202  where DEVID='Head Office';

   -- DELETE FROM checkinout_02;
   EXECUTE IMMEDIATE ('truncate table checkinout_02');

   COMMIT;

     INSERT INTO checkinout_02 (userid, checktime, deviceid)
       SELECT DISTINCT userid, datetime checktime, devid
         FROM transaction_v
        WHERE TRUNC (DATETIME) BETWEEN pdt1 AND pdt2;


 

   COMMIT;

   -- DELETE FROM checkinout_03;

   EXECUTE IMMEDIATE ('truncate table checkinout_03');

   COMMIT;

   INSERT INTO checkinout_03 (userid,
                              empcode,
                              attdate,
                              checktime,
                              deviceid)
        SELECT userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI')
                  atttime,
               MAX (deviceid) deviceidmax
          FROM checkinout_02 a, emp_all_v b
         WHERE     userid <> '0'
               --   AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
               --  AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)


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
          FROM checkinout_02 a, emp_all_v b
         WHERE     userid <> '0'
               --   AND TRUNC (a.checktime) BETWEEN p_fdate AND p_tdate
               --  AND SUBSTR (a.userid, -6) = SUBSTR (b.empcode, -6)


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
      GROUP BY a.userid,
               b.empcode,
               TRUNC (a.checktime),
               TO_DATE (TO_CHAR (a.checktime, 'DDMMRRRRHH24MI'),
                        'DDMMRRRRHH24MI');

   COMMIT;

   DELETE FROM checkinout_04;

   COMMIT;

   INSERT INTO checkinout_04 (empcode,
                              attdate,
                              checktime,
                              deviceid)
        SELECT DISTINCT empcode,
                        attdate,
                        checktime,
                        MAX (deviceid)
          FROM checkinout_03
      GROUP BY empcode, attdate, checktime;

   --222222----   backup  of access table (userinfo and  checkinout ) in oracle ( userinfo_access_db and  checkinout_access_db )  without any change

   -----------------------
   COMMIT;

   MERGE INTO transaction_access_db a
        USING (SELECT badgenumber,
                      userid,
                      checktime,
                      checktype,
                      verifycode,
                      sensorid,
                      workcode,
                      sn,
                      deviceid
                 FROM checkinout_02) b
           ON (a.checktime = b.checktime AND a.userid = b.userid)
   WHEN NOT MATCHED
   THEN
      INSERT     (badgenumber,
                  tran_date,
                  userid,
                  checktime,
                  checktype,
                  verifycode,
                  sensorid,
                  workcode,
                  sn,
                  deviceid)
          VALUES (b.badgenumber,
                  SYSDATE,
                  b.userid,
                  b.checktime,
                  b.checktype,
                  b.verifycode,
                  b.sensorid,
                  b.workcode,
                  b.sn,
                  b.deviceid);

              /*
MERGE INTO userinfo_access_db a
   USING (SELECT userid, badgenumber, NAME, cardno
            FROM userinfo_01) b
   ON (a.userid = b.userid)
   WHEN NOT MATCHED THEN
      INSERT (userid, badgenumber, NAME, cardno)
      VALUES (b.userid, b.badgenumber, b.NAME, b.cardno);
      */

   /*
     BEGIN
     DBMS_SCHEDULER.create_job (
       job_name        => 'punch_data',
       job_type        => 'PLSQL_BLOCK',
       job_action      => 'BEGIN punch_data_merge; END;',
       start_date      => SYSTIMESTAMP,
       repeat_interval => 'FREQ=minutely; INTERVAL=2;',
       end_date        => NULL,
       enabled         => TRUE,
       comments        => 'Job defined entirely by the CREATE JOB procedure.');
   END;
   */
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE;
END;
/
