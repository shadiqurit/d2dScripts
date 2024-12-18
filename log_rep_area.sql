/* Formatted on 12/18/2024 12:57:20 PM (QP5 v5.362) */
CREATE TABLE rep_area_log
AS
    SELECT * FROM rep_area;
/

ALTER TABLE rep_area_log
    ADD sid NUMBER;
/

ALTER TABLE rep_area_log
    ADD serial# NUMBER;
/

ALTER TABLE rep_area_log
    ADD action_date DATE;
/

ALTER TABLE rep_area_log
    ADD action_status VARCHAR2 (5);
/

CREATE OR REPLACE TRIGGER tri_rep_area_log
    AFTER DELETE OR INSERT OR UPDATE
    ON rep_area
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    IF INSERTING
    THEN
        INSERT INTO rep_area_log (ID,
                                  REP_ID,
                                  NAME,
                                  REP_CATEGORY,
                                  AREA_ID,
                                  AREA_NAME,
                                  CREATED_ON,
                                  CREATED_BY,
                                  UPDATED_ON,
                                  UPDATED_BY,
                                  ORC_INSERT_DATE,
                                  action_date,
                                  action_status)
             VALUES (:new.ID,
                     :new.REP_ID,
                     :new.NAME,
                     :new.REP_CATEGORY,
                     :new.AREA_ID,
                     :new.AREA_NAME,
                     :new.CREATED_ON,
                     :new.CREATED_BY,
                     :new.UPDATED_ON,
                     :new.UPDATED_BY,
                     :new.ORC_INSERT_DATE,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO rep_area_log (ID,
                                  REP_ID,
                                  NAME,
                                  REP_CATEGORY,
                                  AREA_ID,
                                  AREA_NAME,
                                  CREATED_ON,
                                  CREATED_BY,
                                  UPDATED_ON,
                                  UPDATED_BY,
                                  ORC_INSERT_DATE,
                                  action_date,
                                  action_status)
             VALUES (:old.ID,
                     :old.REP_ID,
                     :old.NAME,
                     :old.REP_CATEGORY,
                     :old.AREA_ID,
                     :old.AREA_NAME,
                     :old.CREATED_ON,
                     :old.CREATED_BY,
                     :old.UPDATED_ON,
                     :old.UPDATED_BY,
                     :old.ORC_INSERT_DATE,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO rep_area_log (ID,
                                  REP_ID,
                                  NAME,
                                  REP_CATEGORY,
                                  AREA_ID,
                                  AREA_NAME,
                                  CREATED_ON,
                                  CREATED_BY,
                                  UPDATED_ON,
                                  UPDATED_BY,
                                  ORC_INSERT_DATE,
                                  action_date,
                                  action_status)
             VALUES (:old.ID,
                     :old.REP_ID,
                     :old.NAME,
                     :old.REP_CATEGORY,
                     :old.AREA_ID,
                     :old.AREA_NAME,
                     :old.CREATED_ON,
                     :old.CREATED_BY,
                     :old.UPDATED_ON,
                     :old.UPDATED_BY,
                     :old.ORC_INSERT_DATE,
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