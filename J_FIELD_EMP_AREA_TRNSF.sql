/* Formatted on 12/18/2024 11:52:01 AM (QP5 v5.362) */
BEGIN
    SYS.DBMS_SCHEDULER.DROP_JOB (job_name => 'IPIHR.J_FIELD_EMP_AREA_TRNSF');
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'J_FIELD_EMP_AREA_TRNSF',
        job_type          => 'PLSQL_BLOCK',
        job_action        =>
            'BEGIN  p_rep_area; p_sup_area; p_area_structure; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=HOURLY; INTERVAL=6',
        enabled           => TRUE);
END;
/