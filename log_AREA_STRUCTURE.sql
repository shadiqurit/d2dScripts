/* Formatted on 12/18/2024 12:41:25 PM (QP5 v5.362) */
CREATE TABLE area_structure_log
AS
    SELECT * FROM area_structure;
/

ALTER TABLE area_structure_log
    ADD sid NUMBER;
/

ALTER TABLE area_structure_log
    ADD serial# NUMBER;
/

ALTER TABLE area_structure_log
    ADD action_date DATE;
/

ALTER TABLE area_structure_log
    ADD action_status VARCHAR2 (5);
/



CREATE OR REPLACE TRIGGER trg_area_structure_log
    AFTER DELETE OR INSERT OR UPDATE
    ON area_structure
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    IF INSERTING
    THEN
        INSERT INTO area_structure_log (id,
                                        area_id,
                                        area_name,
                                        parent_level_id,
                                        parent_level_name,
                                        level0_id,
                                        level0_name,
                                        level1_id,
                                        level1_name,
                                        level2_id,
                                        level2_name,
                                        level3_id,
                                        level3_name,
                                        created_on,
                                        created_by,
                                        updated_on,
                                        updated_by,
                                        orc_insert_date,
                                        action_date,
                                        action_status)
             VALUES (:new.id,
                     :new.area_id,
                     :new.area_name,
                     :new.parent_level_id,
                     :new.parent_level_name,
                     :new.level0_id,
                     :new.level0_name,
                     :new.level1_id,
                     :new.level1_name,
                     :new.level2_id,
                     :new.level2_name,
                     :new.level3_id,
                     :new.level3_name,
                     :new.created_on,
                     :new.created_by,
                     :new.updated_on,
                     :new.updated_by,
                     :new.orc_insert_date,
                     SYSDATE,
                     'i');
    ELSIF UPDATING
    THEN
        INSERT INTO area_structure_log (id,
                                        area_id,
                                        area_name,
                                        parent_level_id,
                                        parent_level_name,
                                        level0_id,
                                        level0_name,
                                        level1_id,
                                        level1_name,
                                        level2_id,
                                        level2_name,
                                        level3_id,
                                        level3_name,
                                        created_on,
                                        created_by,
                                        updated_on,
                                        updated_by,
                                        orc_insert_date,
                                        action_date,
                                        action_status)
             VALUES (:old.id,
                     :old.area_id,
                     :old.area_name,
                     :old.parent_level_id,
                     :old.parent_level_name,
                     :old.level0_id,
                     :old.level0_name,
                     :old.level1_id,
                     :old.level1_name,
                     :old.level2_id,
                     :old.level2_name,
                     :old.level3_id,
                     :old.level3_name,
                     :old.created_on,
                     :old.created_by,
                     :old.updated_on,
                     :old.updated_by,
                     :old.orc_insert_date,
                     SYSDATE,
                     'u');
    ELSIF DELETING
    THEN
        INSERT INTO area_structure_log (id,
                                        area_id,
                                        area_name,
                                        parent_level_id,
                                        parent_level_name,
                                        level0_id,
                                        level0_name,
                                        level1_id,
                                        level1_name,
                                        level2_id,
                                        level2_name,
                                        level3_id,
                                        level3_name,
                                        created_on,
                                        created_by,
                                        updated_on,
                                        updated_by,
                                        orc_insert_date,
                                        action_date,
                                        action_status)
             VALUES (:old.id,
                     :old.area_id,
                     :old.area_name,
                     :old.parent_level_id,
                     :old.parent_level_name,
                     :old.level0_id,
                     :old.level0_name,
                     :old.level1_id,
                     :old.level1_name,
                     :old.level2_id,
                     :old.level2_name,
                     :old.level3_id,
                     :old.level3_name,
                     :old.created_on,
                     :old.created_by,
                     :old.updated_on,
                     :old.updated_by,
                     :old.orc_insert_date,
                     SYSDATE,
                     'd');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
/