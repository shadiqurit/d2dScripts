/* Formatted on 9/10/2024 10:45:47 AM (QP5 v5.362) */
---- Scheduler

BEGIN
  --  p_att_mysql_to_orcl;
   --p_att104_to_att_time;
    ATTANCE_SYNC;
END;

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'J_ATT_MYSQL_ORCL',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN p_att_mysql_to_orcl; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=DAILY; BYHOUR=8,9,10,11; BYMINUTE=05,40',
        enabled           => TRUE);
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'J_ATT_MYSQL_ORCL2',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN p_att104_to_att_time; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=DAILY; BYHOUR=8,9,10,11; BYMINUTE=10,50',
        enabled           => TRUE);
END;
/

SELECT SYSDATE FROM DUAL;