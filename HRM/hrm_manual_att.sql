/* Formatted on 8/26/2025 8:05:26 PM (QP5 v5.362) */
ALTER TABLE MENUAL_ATTENDANCE
    MODIFY ATT_ID NUMBER PRIMARY KEY;

ALTER TABLE HRM.MENUAL_ATTENDANCE
    MODIFY (ATT_ID DEFAULT NULL);

--    MENUAL_ATTENDANCE_SEQ.NEXTVAL

ALTER SEQUENCE MENUAL_ATTENDANCE_SEQ NOCACHE;


CREATE OR REPLACE TRIGGER t_menual_attendance_pk
    BEFORE INSERT OR UPDATE
    ON menual_attendance
    FOR EACH ROW
BEGIN
    IF :new.att_id IS NULL
    THEN
        :new.att_id := menual_attendance_seq.NEXTVAL;
    END IF;
END t_menual_attendance_pk;
/

CREATE SEQUENCE menual_attendance_seq START WITH 520 INCREMENT BY 1 NOCACHE;

DROP SEQUENCE menual_attendance_seq;

    SELECT TO_CHAR (TO_DATE (LEVEL, 'MM'), 'Month')     AS month_name,
           LEVEL                                        AS month_no
      FROM DUAL
CONNECT BY LEVEL <= 12;

    SELECT RTRIM (TO_CHAR (TO_DATE (LEVEL, 'MM'), 'Month'))     AS month_name,
           TO_CHAR (LEVEL, 'FM00')                              AS month_no
      FROM DUAL
CONNECT BY LEVEL <= 12;


    SELECT TO_CHAR (LEVEL, 'FM00')                              AS month_number,
           RTRIM (TO_CHAR (TO_DATE (LEVEL, 'MM'), 'Month'))     AS month_name,
           TO_CHAR (LAST_DAY (TO_DATE (LEVEL, 'MM')), 'DD')     AS days_in_month
      FROM DUAL
CONNECT BY LEVEL <= 12
  ORDER BY month_number;

--MENUAL_ATTENDANCE