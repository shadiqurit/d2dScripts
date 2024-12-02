/* Formatted on 12/2/2024 2:18:17 PM (QP5 v5.362) */
CREATE OR REPLACE PROCEDURE IPIHR.att_daily_cloud_manual
AS
    p_fdate     DATE;
    p_tdate     DATE;
    p_empcode   VARCHAR2 (200);
    p_dp_code   VARCHAR2 (200);
    o_msg       VARCHAR2 (2000);
BEGIN
    p_fdate := TO_DATE('11/01/2024', 'MM/DD/YYYY');

    p_tdate := TO_DATE('11/30/2024', 'MM/DD/YYYY');
    p_empcode := NULL;
    p_dp_code := NULL;
    o_msg := NULL;


    ipihr.att_faster_cloud (p_fdate     => p_fdate,
                            p_tdate     => p_tdate,
                            p_empcode   => p_empcode,
                            p_dp_code   => p_dp_code,
                            o_msg       => o_msg);



    --DBMS_OUTPUT.Put_Line('O_MSG = ' || O_MSG);

    -- DBMS_OUTPUT.Put_Line('');
    COMMIT;
  /*


BEGIN
   DBMS_SCHEDULER.create_job (
     job_name        => 'daily_attendance_scheduler',
     job_type        => 'PLSQL_BLOCK',
     job_action      => 'BEGIN att_440_2; END;',
     start_date      => SYSTIMESTAMP,
     repeat_interval => 'freq=minutely; interval=15; bysecond=0;',
     end_date        => NULL,
     enabled         => TRUE,
     comments        => 'Job defined entirely by the CREATE JOB procedure.');
 END;


 */
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/