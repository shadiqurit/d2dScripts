CREATE TABLE HRMS.T_STRUCTURE
(
    ID           NUMBER,
    STR_NAME     VARCHAR2 (100 BYTE),
    STR_TYPE     VARCHAR2 (20 BYTE),
    CODE         VARCHAR2 (100 BYTE),
    PARENT_ID    NUMBER,
    DEPT_ID      NUMBER,
    COMP_ID      NUMBER,
    UNIT         NUMBER,
    STATUS       VARCHAR2 (20 BYTE),
    ENT_BY       NUMBER,
    ENT_DATE     DATE DEFAULT SYSDATE,
    UPD_BY       NUMBER,
    UPD_DATE     DATE
);



ALTER TABLE HRMS.T_STRUCTURE
    ADD (CONSTRAINT T_STRUCTURE_PK PRIMARY KEY (ID));


CREATE OR REPLACE TRIGGER HRMS.TRG_T_STRUCTURE_PK
    BEFORE INSERT OR UPDATE
    ON HRMS.t_structure
    FOR EACH ROW
BEGIN
    IF :new.id IS NULL
    THEN
        SELECT NVL (MAX (id), 0) + 1 INTO :new.id FROM t_structure;
    END IF;
END trg_t_structure_pk;
/


ALTER TABLE HRMS.T_STRUCTURE
    ADD (
        CONSTRAINT T_STRUCTURE_R01 FOREIGN KEY (PARENT_ID)
            REFERENCES HRMS.T_STRUCTURE (ID)
            ENABLE VALIDATE);