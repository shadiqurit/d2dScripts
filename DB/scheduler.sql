BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'ATT_DAILY_8AM_10AM',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN att_daily_cloud; END;',
      start_date        => SYSTIMESTAMP,
      repeat_interval   =>'FREQ=DAILY; BYHOUR=2,3,6; BYMINUTE=20,50',
      enabled           => TRUE);
END;
/