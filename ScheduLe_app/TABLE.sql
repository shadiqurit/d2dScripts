/* Formatted on 27/May/24 10:48:08 AM (QP5 v5.362) */
CREATE TABLE T_PROJECTS
(
    ID                    NUMBER,
    rv_number    NUMBER,
    PROJECT               VARCHAR2 (30) NOT NULL ENABLE,
    TASK_NAME             VARCHAR2 (255) NOT NULL ENABLE,
    START_DATE            DATE NOT NULL ENABLE,
    END_DATE              DATE NOT NULL ENABLE,
    STATUS                VARCHAR2 (30) NOT NULL ENABLE,
    ASSIGNED_TO           VARCHAR2 (30),
    COST                  NUMBER,
    BUDGET                NUMBER,
    CONSTRAINT T_PROJECTS_PK PRIMARY KEY (ID) USING INDEX ENABLE
);


CREATE OR REPLACE TRIGGER t_PROJECTS
    BEFORE INSERT OR UPDATE
    ON T_PROJECTS
    FOR EACH ROW
BEGIN
    IF :new.ID IS NULL
    THEN
        SELECT max(nvl(id,0))+1
          INTO :new.id
          FROM T_PROJECTS;
    END IF;

    IF INSERTING
    THEN
        :new.rv_number := 1;
    ELSIF UPDATING
    THEN
        :new.rv_number := NVL (:old.rv_number, 1) + 1;
    END IF;

    IF :new.start_date > :new.end_date
    THEN
        RAISE_APPLICATION_ERROR (-20001,
                                 'Error start date must be before end date');
    END IF;
END;
/