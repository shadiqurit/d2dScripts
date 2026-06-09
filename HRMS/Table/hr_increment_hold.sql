DROP TABLE HRMS.HR_INCREMENT_HOLD CASCADE CONSTRAINTS;

CREATE TABLE HRMS.HR_INCREMENT_HOLD
(
  HOLD_ID          NUMBER GENERATED ALWAYS AS IDENTITY ( START WITH 21 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER NOKEEP NOSCALE) NOT NULL,
  EMP_ID           NUMBER                       NOT NULL,
  HOLD_FROM_DATE   DATE                         DEFAULT SYSDATE,
  HOLD_TO_DATE     DATE,
  HOLD_REASON      VARCHAR2(1000 BYTE),
  HOLD_STATUS      VARCHAR2(20 BYTE)            DEFAULT 'ACTIVE',
  RELEASED_DATE    DATE,
  RELEASED_BY      NUMBER,
  RELEASE_REMARKS  VARCHAR2(1000 BYTE),
  ACTION_ID        NUMBER,
  ENT_BY           NUMBER,
  ENT_DATE         DATE                         DEFAULT SYSDATE,
  UPD_BY           NUMBER,
  UPD_DATE         DATE
)
TABLESPACE HRMS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


ALTER TABLE HRMS.HR_INCREMENT_HOLD ADD (
  PRIMARY KEY
  (HOLD_ID)
  USING INDEX
    TABLESPACE HRMS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
  ENABLE VALIDATE);


DROP SEQUENCE HRMS.ISEQ$$_226104;

-- Sequence ISEQ$$_226104 is created automatically by Oracle for use with an Identity column


--  There is no statement for index HRMS.SYS_C0024995.
--  The object is created when the parent object is created.
