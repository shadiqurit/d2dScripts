CREATE OR REPLACE PROCEDURE p_att_schedule
IS
BEGIN
    MERGE INTO attendance_details ad
         USING (SELECT emp_id,
                       MC_ID,
                       attendance_date,
                       dayofweek,
                       regular_in_time,
                       regular_out_time,
                       com_id
                  FROM v_att_gen) s
            ON (                                        --ad.emp_id = s.emp_id
                ad.mc_id = s.mc_id AND ad.attendance_date = s.attendance_date)
    WHEN MATCHED
    THEN
        UPDATE SET
            ad.dayofweek = s.dayofweek,
            ad.com_id = s.com_id,
            ad.regular_in_time = s.regular_in_time,
            ad.regular_out_time = s.regular_out_time
    WHEN NOT MATCHED
    THEN
        INSERT     (attendance_id,
                    emp_id,
                    mc_id,
                    attendance_date,
                    dayofweek,
                    regular_in_time,
                    regular_out_time)
            VALUES (s_attdata.NEXTVAL,
                    s.emp_id,
                    s.MC_ID,
                    s.attendance_date,
                    s.dayofweek,
                    s.regular_in_time,
                    s.regular_out_time);

    COMMIT;

    MERGE INTO attendance_details ad
         USING v_fpunch_lpunc vfp
            ON (    ad.MC_ID = vfp.EMP_ID
                AND ad.ATTENDANCE_DATE = vfp.ATTENDANCE_DATE)
    WHEN MATCHED
    THEN
        UPDATE SET ad.IN_LOCATION = vfp.IN_DEVICE,
                   ad.OUT_LOCATION = vfp.OUT_DEVICE,
                   ad.IN_TIME = vfp.IN_TIME,
                   ad.OUT_TIME = vfp.OUT_TIME;

    COMMIT;

    --    --Manual Attendance approve then
    --    MERGE INTO attendance_details ad
    --         USING V_ATT_MANUAL_APPROVE vfp
    --            ON (    ad.EMP_ID = vfp.EMPID
    --                AND ad.ATTENDANCE_DATE = vfp.ATTENDANCE_DATE)
    --    WHEN MATCHED
    --    THEN
    --        UPDATE SET
    --            ad.REMARKS = vfp.REASON,
    --            ad.IN_TIME = vfp.IN_TIME,
    --          ad.OUT_TIME = vfp.OUT_TIME;



    COMMIT;
END;
/
