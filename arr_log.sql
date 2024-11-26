/* Formatted on 11/26/2024 7:13:39 PM (QP5 v5.362) */
CREATE TABLE T_ARREAR_UP_log
AS
    SELECT * FROM T_ARREAR_UP;
/

ALTER TABLE T_ARREAR_UP_log
    ADD sid NUMBER;
/

ALTER TABLE T_ARREAR_UP_log
    ADD serial# NUMBER;
/

ALTER TABLE T_ARREAR_UP_log
    ADD action_date DATE;
/

ALTER TABLE T_ARREAR_UP_log
    ADD action_status VARCHAR2 (5);
/


CREATE OR REPLACE TRIGGER TRg_T_ARREAR_UP_LOG
    AFTER DELETE OR INSERT OR UPDATE
    ON T_ARREAR_UP
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    IF INSERTING
    THEN
        INSERT INTO T_ARREAR_UP_log (SLNO,
                                     EMPCODE,
                                     GRADE,
                                     YEARMN,
                                     PARTICULAR,
                                     ARREAR_AMT,
                                     HEADCODE,
                                     REFNO,
                                     REMARKS,
                                     action_date,
                                     action_status)
             VALUES (:new.SLNO,
                     :new.EMPCODE,
                     :new.GRADE,
                     :new.YEARMN,
                     :new.PARTICULAR,
                     :new.ARREAR_AMT,
                     :new.HEADCODE,
                     :new.REFNO,
                     :new.REMARKS,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO T_ARREAR_UP_log (SLNO,
                                     EMPCODE,
                                     GRADE,
                                     YEARMN,
                                     PARTICULAR,
                                     ARREAR_AMT,
                                     HEADCODE,
                                     REFNO,
                                     REMARKS,
                                     action_date,
                                     action_status)
             VALUES (:old.SLNO,
                     :old.EMPCODE,
                     :old.GRADE,
                     :old.YEARMN,
                     :old.PARTICULAR,
                     :old.ARREAR_AMT,
                     :old.HEADCODE,
                     :old.REFNO,
                     :old.REMARKS,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO T_ARREAR_UP_log (SLNO,
                                     EMPCODE,
                                     GRADE,
                                     YEARMN,
                                     PARTICULAR,
                                     ARREAR_AMT,
                                     HEADCODE,
                                     REFNO,
                                     REMARKS,
                                     action_date,
                                     action_status)
             VALUES (:old.SLNO,
                     :old.EMPCODE,
                     :old.GRADE,
                     :old.YEARMN,
                     :old.PARTICULAR,
                     :old.ARREAR_AMT,
                     :old.HEADCODE,
                     :old.REFNO,
                     :old.REMARKS,
                     SYSDATE,
                     'D');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
/