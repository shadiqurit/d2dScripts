/* Formatted on 13/May/24 9:35:59 AM (QP5 v5.362) */
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'T_EMP_V_TRANSFER_DATA',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN p_emp_data_transfer; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=daily; INTERVAL=1',
        enabled           => TRUE);
END;
/

BEGIN
    p_emp_data_transfer;
END;