CREATE OR REPLACE PROCEDURE p_att_update_details
IS
BEGIN
    UPDATE attendance_details
       SET OUT_TIME = in_time
     WHERE OUT_TIME IS NULL;

    COMMIT;

    UPDATE attendance_details
       SET DUTY_HOURS =
               CASE
                   WHEN IN_TIME IS NOT NULL OR OUT_TIME IS NOT NULL
                   THEN
                          -- Calculate Duty Hours in HH:MM format
                          FLOOR ((OUT_TIME - IN_TIME) * 24)
                       || ':'
                       || LPAD (
                              ROUND (
                                    ((OUT_TIME - IN_TIME) * 24 * 60)
                                  - (FLOOR ((OUT_TIME - IN_TIME) * 24) * 60)),
                              2,
                              '0') -- Converts total minutes into hours:minutes format
                   ELSE
                       NULL
               END,
           LATE_IN =
               CASE
                   WHEN IN_TIME IS NOT NULL OR OUT_TIME IS NOT NULL
                   THEN
                       -- Calculate LATE_IN (only count if IN_TIME is more than 10 minutes late)
                       GREATEST (
                           ROUND ((IN_TIME - REGULAR_IN_TIME) * 24 * 60) - 10,
                           0) -- If the result is negative or within the grace period, return 0
                   ELSE
                       0
               END,
           EARLY_OUT =
               CASE
                   WHEN IN_TIME IS NOT NULL OR OUT_TIME IS NOT NULL
                   THEN
                       -- Calculate EARLY_OUT
                       GREATEST (
                           ROUND ((REGULAR_OUT_TIME - OUT_TIME) * 24 * 60),
                           0) -- If the result is negative or within the grace period, return 0
                   ELSE
                       0
               END,
           STATUS =
               CASE
                   WHEN IN_TIME IS NOT NULL OR OUT_TIME IS NOT NULL THEN 'P' -- Set status as 'P' if both IN_TIME and OUT_TIME are present
                   ELSE NULL -- Keep the existing status if either IN_TIME or OUT_TIME is NULL
               END
     WHERE IN_TIME IS NOT NULL OR OUT_TIME IS NOT NULL;

    COMMIT;

    UPDATE attendance_details
       SET STATUS = 'A', REMARKS = 'Absent'
     WHERE IN_TIME IS NULL;
     
      UPDATE attendance_details
       SET REMARKS = null
     WHERE IN_TIME IS not null;

    COMMIT;

    UPDATE attendance_details
       SET LATE_IN = LATE_IN + 10
     WHERE LATE_IN > 0;

    COMMIT;

    UPDATE attendance_details
       SET STATUS = 'W', REMARKS = 'Weekly Holiday'
     WHERE DAYOFWEEK IN ('FRIDAY');

    COMMIT;

    UPDATE attendance_details ad
       SET ad.status = 'H', REMARKS = 'Holiday'
     WHERE EXISTS
               (SELECT 1
                  FROM t_holiday th
                 WHERE ad.ATTENDANCE_DATE = th.HOLIDAY_DATE);

    COMMIT;
END;
/
