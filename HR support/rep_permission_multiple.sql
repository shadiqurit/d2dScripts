CREATE OR REPLACE PROCEDURE ins_sm_obj_for_users (
  p_userids    IN SYS.ODCIVARCHAR2LIST   -- e.g. SYS.ODCIVARCHAR2LIST('IPI-004281','IPI-004282')
) IS
BEGIN
  MERGE INTO sm_object_list_2 t
  USING (
    SELECT u.userid,
           b.obj_id, b.obj_title, b.obj_name, b.is_display, b.p_obj_id,
           b.addedby, b.dateadded, b.updateby, b.updatedate
    FROM (SELECT COLUMN_VALUE AS userid FROM TABLE(p_userids)) u
    CROSS JOIN (
      /* === Base rows copied from your script === */
      SELECT 219 obj_id, 'Leave Status' obj_title, 'ipi_leave_report_1' obj_name, 1 is_display, 104 p_obj_id,
             'IPI-009129' addedby, sysdate dateadded,
             'IPI-009129' updateby, sysdate updatedate FROM dual
      UNION ALL SELECT 220, 'Leave Details', 'ipi_leave_report_2', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 221, 'Encashment Status', 'ipi_leave_report_3', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 242, 'Monthwise Leave Report', 'leave_monthly', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 33, 'Employee Detail', 'empdetail', 1, 102,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 77, 'Attendence> Job Card Report', 'att_emp', 1, 105,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 277, 'Late Attendance Detail', 'att_emp_LATE', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 102, 'Employee', 'Employee', 1, NULL,
             'IPI-009129', sysdate,
             NULL, NULL FROM dual
      UNION ALL SELECT 104, 'Leave', 'Leave', 1, NULL,
             'IPI-009129', sysdate,
             NULL, NULL FROM dual
      UNION ALL SELECT 79, 'Attendence Monthly Summary', 'att_monthly_summary', 1, 105,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 105, 'Attendance', 'ATTENDENCE', 1, NULL,
             'IPI-009129', sysdate,
             NULL, NULL FROM dual
      UNION ALL SELECT 78, 'Attendence Daily  Status', 'att_daily_status', 1, 105,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 276, 'Leave For Late', 'Leave_for_late', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 306, 'Leave Avail Info', 'Leave_avail_info', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 263, 'leave EL (GL)', 'ipi_leave_el_gl', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 302, 'Sick Leave Status', 'slleave', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
      UNION ALL SELECT 328, 'Non Officer El GL', 'pi_el_gl_nonofficer_rdf', 1, 104,
             'IPI-009129', sysdate,
             'IPI-009129', sysdate FROM dual
    ) b
  ) s
  ON (t.obj_id = s.obj_id AND t.userid = s.userid)
  WHEN NOT MATCHED THEN
    INSERT (obj_id, obj_title, obj_name, userid, is_display, p_obj_id, addedby, dateadded, updateby, updatedate)
    VALUES (s.obj_id, s.obj_title, s.obj_name, s.userid, s.is_display, s.p_obj_id, s.addedby, s.dateadded, s.updateby, s.updatedate);
END;
/
