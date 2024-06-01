BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
      ,start_date      => TO_TIMESTAMP_TZ('2019/03/31 18:56:30.944790 +06:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,repeat_interval => 'freq=minutely; interval=15; bysecond=0;'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'BEGIN att_daily_cloud; END;'
      ,comments        => 'Job defined entirely by the CREATE JOB procedure.'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'AUTO_DROP'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER'
     ,attribute => 'STORE_OUTPUT'
     ,value     => TRUE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'IPIHR.DAILY_ATTENDANCE_SCHEDULER');
END;
/
