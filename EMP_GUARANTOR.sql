/* Formatted on 4/29/2025 11:50:18 AM (QP5 v5.362) */
INSERT INTO EMP_GUARANTORS (empcode,
                            GRNT_NM,
                            GRNT_FATHER,
                            GRNT_ADD1,
                            GRNT_ADD2,
                            GRNT_RELE,
                            GRNT_NATIONALITY,
                            GRNT_PROFFESSION,
                            GRNT_BUSINES_ADD,
                            GRNT_NID,
                            GRNT_OFF_PHON,
                            GRNT_PASSPORT_NO,
                            GRNT_RES_PHONE,
                            GRNT_MOBILE)
    (SELECT empcode,
            GRNT_NM,
            GRNT_FATHER,
            GRNT_ADD1,
            GRNT_ADD2,
            GRNT_RELE,
            GRNT_NATIONALITY,
            GRNT_PROFFESSION,
            GRNT_BUSINES_ADD,
            GRNT_NID,
            GRNT_OFF_PHON,
            GRNT_PASSPORT_NO,
            GRNT_RES_PHONE,
            GRNT_MOBILE
       FROM emp@ipihr
      WHERE emp_status = 'A' AND GRNT_NM IS NOT NULL);

SELECT empcode,
       ee.emp_id     emcode,
       GRNT_NM,
       ee.id,
       eg.emp_id
  FROM EMP_GUARANTORS eg, employees ee
 WHERE eg.empcode = ee.emp_id;


UPDATE EMP_GUARANTORS eg
   SET eg.emp_id =
           (SELECT ee.id
              FROM employees ee
             WHERE eg.empcode = ee.emp_id);


CREATE SEQUENCE eggr;

UPDATE EMP_GUARANTORS
   SET CONTACT_DETAILS = NULL
 WHERE CONTACT_DETAILS = 0;

CREATE TABLE EMP_GUARANTORS
(
    ID                  NUMBER,
    EMP_ID              NUMBER,
    NAME                VARCHAR2 (100 BYTE),
    RELATIONSHIP        VARCHAR2 (100 BYTE),
    CONTACT_DETAILS     VARCHAR2 (255 BYTE),
    ADDRESS             VARCHAR2 (100 BYTE),
    P_POST              NUMBER,
    P_THANA             NUMBER,
    P_DISTRICT          NUMBER,
    P_DIVISION          NUMBER,
    EMPCODE             VARCHAR2 (150 BYTE),
    GRNT_NM             VARCHAR2 (150 BYTE),
    GRNT_FATHER         VARCHAR2 (150 BYTE),
    GRNT_ADD1           VARCHAR2 (300 BYTE),
    GRNT_ADD2           VARCHAR2 (300 BYTE),
    GRNT_RELE           VARCHAR2 (150 BYTE),
    GRNT_NATIONALITY    VARCHAR2 (45 BYTE),
    GRNT_PROFFESSION    VARCHAR2 (30 BYTE),
    GRNT_BUSINES_ADD    VARCHAR2 (300 BYTE),
    GRNT_NID            VARCHAR2 (90 BYTE),
    GRNT_OFF_PHON       VARCHAR2 (60 BYTE),
    GRNT_PASSPORT_NO    VARCHAR2 (150 BYTE),
    GRNT_RES_PHONE      VARCHAR2 (60 BYTE),
    GRNT_MOBILE         VARCHAR2 (150 BYTE),
    REMARKS             VARCHAR2 (100 BYTE),
    ENT_BY              NUMBER,
    ENT_DATE            DATE,
    UPD_BY              NUMBER,
    UPD_DATE            DATE
);



--ALTER TABLE EMP_GUARANTORS
--    ADD (CONSTRAINT PK_EMP_ID_GUARANTORS PRIMARY KEY (ID));


--CREATE OR REPLACE TRIGGER TRG_EMP_GUARANTORS_PK
--    BEFORE INSERT OR UPDATE
--    ON HRMS.EMP_GUARANTORS
--    FOR EACH ROW
--BEGIN
--    IF :new.id IS NULL
--    THEN
--        SELECT NVL (MAX (id), 0) + 1 INTO :new.id FROM EMP_GUARANTORS;
--    END IF;
--END TRG_EMP_GUARANTORS_PK;
--/


--ALTER TABLE EMP_GUARANTORS
--    ADD (
--        CONSTRAINT FK_EMP_ID_GUARANTORS FOREIGN KEY (EMP_ID)
--            REFERENCES EMPLOYEES (ID)
--            ENABLE VALIDATE);