/* Formatted on 14/Jul/24 3:22:14 PM (QP5 v5.362) */

---- Scheduler
BEGIN
    p_att_mysql_to_orcl;
    p_att104_to_att_time;
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

select sysdate from dual;
