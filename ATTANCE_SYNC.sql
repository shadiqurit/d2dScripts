CREATE OR REPLACE PROCEDURE ATTENDENCE.attance_sync
AS
    CURSOR c1 IS
        SELECT userid, att_time, device
          FROM attendance_time
         WHERE status = 0;
BEGIN
    MERGE INTO attendance_time a
         USING (SELECT EMP_CODE,
                       TO_DATE (TO_CHAR (PUNCH_TIME, 'DD-MON-YY HH:MI AM'),
                                'DD-MON-YY HH:MI AM')    TIME,
                       (Case When AREA_ALIAS=TERMINAL_ALIAS  then AREA_ALIAS else    TERMINAL_ALIAS end) deviceid
                  FROM ICLOCK_TRANSACTION) b
            ON (a.userid = b.emp_code AND a.att_time = b.time)
    WHEN NOT MATCHED
    THEN
        INSERT     (USERID,
                    ATT_TIME,
                    DEVICE,
                    STATUS)
            VALUES (B.EMP_CODE,
                    b.time,
                    B.DEVICEID,
                    0);

    FOR i IN c1
    LOOP
        INSERT INTO a_punchlog@hlink
             VALUES (i.userid, i.att_time, i.device);

        UPDATE attendance_time
           SET status = 1
         WHERE userid = i.userid;
    END LOOP;

    COMMIT;
END;
/
