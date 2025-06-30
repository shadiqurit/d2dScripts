/* Formatted on 6/24/2025 10:24:12 AM (QP5 v5.362) */
--select emp_id,
--       attendance_date,
--       in_device,
--       out_device,
--       in_time,
--       out_time
--  from v_fpunch_lpunc;
--
--select emp_id,
--       attendance_date,
--       in_location,
--       out_location,
--       in_time,
--       out_time
--  from attendance_details;
--

CREATE OR REPLACE PROCEDURE p_att_schedule
AS
BEGIN
    MERGE INTO attendance_details ad
         USING (SELECT id                            AS emp_id,
                       day_date                      AS attendance_date,
                       TO_CHAR (day_date, 'DAY')     AS dayofweek,
                       regular_in_time,
                       regular_out_time
                  FROM v_att_gen) s
            ON (    ad.emp_id = s.emp_id
                AND ad.attendance_date = s.attendance_date)
    WHEN MATCHED
    THEN
        UPDATE SET
            ad.dayofweek = s.dayofweek,
            ad.regular_in_time = s.regular_in_time,
            ad.regular_out_time = s.regular_out_time
    WHEN NOT MATCHED
    THEN
        INSERT     (attendance_id,
                    emp_id,
                    attendance_date,
                    dayofweek,
                    regular_in_time,
                    regular_out_time)
            VALUES (s_attdata.NEXTVAL,
                    s.emp_id,
                    s.attendance_date,
                    s.dayofweek,
                    s.regular_in_time,
                    s.regular_out_time);

    COMMIT;

    UPDATE attendance_details ad
       SET ad.IN_LOCATION =
               (SELECT vfp.IN_DEVICE
                  FROM v_fpunch_lpunc vfp
                 WHERE     vfp.EMP_ID = ad.EMP_ID
                       AND vfp.ATTENDANCE_DATE = ad.ATTENDANCE_DATE),
           ad.OUT_LOCATION =
               (SELECT vfp.OUT_DEVICE
                  FROM v_fpunch_lpunc vfp
                 WHERE     vfp.EMP_ID = ad.EMP_ID
                       AND vfp.ATTENDANCE_DATE = ad.ATTENDANCE_DATE),
           ad.IN_TIME =
               (SELECT vfp.IN_TIME
                  FROM v_fpunch_lpunc vfp
                 WHERE     vfp.EMP_ID = ad.EMP_ID
                       AND vfp.ATTENDANCE_DATE = ad.ATTENDANCE_DATE),
           ad.OUT_TIME =
               (SELECT vfp.OUT_TIME
                  FROM v_fpunch_lpunc vfp
                 WHERE     vfp.EMP_ID = ad.EMP_ID
                       AND vfp.ATTENDANCE_DATE = ad.ATTENDANCE_DATE)
     WHERE EXISTS
               (SELECT 1
                  FROM v_fpunch_lpunc vfp
                 WHERE     vfp.EMP_ID = ad.EMP_ID
                       AND vfp.ATTENDANCE_DATE = ad.ATTENDANCE_DATE);

    COMMIT;
END;
/