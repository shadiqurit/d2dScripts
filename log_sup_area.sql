/* Formatted on 12/18/2024 12:51:17 PM (QP5 v5.362) */
CREATE TABLE sup_area_log
AS
    SELECT * FROM sup_area;
/

ALTER TABLE sup_area_log
    ADD sid NUMBER;
/

ALTER TABLE sup_area_log
    ADD serial# NUMBER;
/

ALTER TABLE sup_area_log
    ADD action_date DATE;
/

ALTER TABLE sup_area_log
    ADD action_status VARCHAR2 (5);
/

CREATE OR REPLACE TRIGGER tri_sup_area_log
    AFTER DELETE OR INSERT OR UPDATE
    ON sup_area
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    IF INSERTING
    THEN
        INSERT INTO sup_area_log (id,
                                  sup_id,
                                  name,
                                  area_id,
                                  area_name,
                                  level_depth_no,
                                  created_on,
                                  created_by,
                                  updated_on,
                                  updated_by,
                                  orc_insert_date,
                                  action_date,
                                  action_status)
             VALUES (:new.id,
                     :new.sup_id,
                     :new.name,
                     :new.area_id,
                     :new.area_name,
                     :new.level_depth_no,
                     :new.created_on,
                     :new.created_by,
                     :new.updated_on,
                     :new.updated_by,
                     :new.orc_insert_date,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO sup_area_log (id,
                                  sup_id,
                                  name,
                                  area_id,
                                  area_name,
                                  level_depth_no,
                                  created_on,
                                  created_by,
                                  updated_on,
                                  updated_by,
                                  orc_insert_date,
                                  action_date,
                                  action_status)
             VALUES (:old.id,
                     :old.sup_id,
                     :old.name,
                     :old.area_id,
                     :old.area_name,
                     :old.level_depth_no,
                     :old.created_on,
                     :old.created_by,
                     :old.updated_on,
                     :old.updated_by,
                     :old.orc_insert_date,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO sup_area_log (id,
                                  sup_id,
                                  name,
                                  area_id,
                                  area_name,
                                  level_depth_no,
                                  created_on,
                                  created_by,
                                  updated_on,
                                  updated_by,
                                  orc_insert_date,
                                  action_date,
                                  action_status)
             VALUES (:old.id,
                     :old.sup_id,
                     :old.name,
                     :old.area_id,
                     :old.area_name,
                     :old.level_depth_no,
                     :old.created_on,
                     :old.created_by,
                     :old.updated_on,
                     :old.updated_by,
                     :old.orc_insert_date,
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