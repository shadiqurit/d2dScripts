/* Formatted on 6/24/2025 9:32:44 AM (QP5 v5.362) */
SELECT * FROM v_att_gen;

delete from attendance_details;
commit;
drop SEQUENCE S_ATTDATA;
CREATE SEQUENCE S_ATTDATA;


BEGIN
    p_att_schedule;
    update_attendance_details;
END;

