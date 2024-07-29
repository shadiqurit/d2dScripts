BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'IPIHR.IPI_LEAVE_CALC_2SC');
END;
/

BEGIN
   DBMS_SCHEDULER.create_job (
      job_name          => 'IPI_LEAVE_CALC_2SC',
      job_type          => 'PLSQL_BLOCK',
      job_action        => 'BEGIN ipi_leave_calc_2; END;',
      start_date        => SYSTIMESTAMP,
      repeat_interval   => 'FREQ=DAILY; BYHOUR=3,4,5,6,7,8,9,10,11,12,13,14,15,16; BYMINUTE=01',
      enabled           => TRUE);
END;
/