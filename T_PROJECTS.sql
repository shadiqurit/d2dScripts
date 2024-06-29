/* Formatted on 01/Jun/24 3:06:34 PM (QP5 v5.362) */
CREATE TABLE T_PROJECTS
(
    ID            NUMBER,
    RV_NUMBER     NUMBER,
    PROJECT       VARCHAR2 (300 BYTE),
    TASK_NAME     VARCHAR2 (255 BYTE) NOT NULL,
    START_DATE    DATE NOT NULL,
    END_DATE      DATE,
    STATUS        VARCHAR2 (30 BYTE) NOT NULL
);

ALTER TABLE T_PROJECTS
    ADD (CONSTRAINT T_PROJECTS_PK PRIMARY KEY (ID));


CREATE OR REPLACE TRIGGER TRG_PROJECTS
    BEFORE INSERT OR UPDATE
    ON T_PROJECTS
    FOR EACH ROW
BEGIN
    IF :new."ID" IS NULL
    THEN
        SELECT NVL (MAX (ID), 0) + 1 IDT INTO :new.id FROM T_PROJECTS;
    END IF;

    IF INSERTING
    THEN
        :new.RV_NUMBER := 1;
    ELSIF UPDATING
    THEN
        :new.RV_NUMBER := NVL (:old.RV_NUMBER, 1) + 1;
    END IF;

    IF :new.start_date > :new.end_date
    THEN
        RAISE_APPLICATION_ERROR (-20001,
                                 'Error start date must be before end date');
    END IF;
END;
/