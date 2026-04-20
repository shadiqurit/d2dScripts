/* Formatted on 4/6/2026 3:20:09 PM (QP5 v5.362) */
----- Procedures -----
--populate_scale_detail
--revise_pay_scale
--populate_all_scale_details

---Function---
--f_get_basic_by_step
--f_get_next_increment

---Views---
--v_active_pay_scale
--v_pay_scale_detail
--v_pay_scale_history

CREATE TABLE JOB_GRADES
(
    ID             NUMBER PRIMARY KEY,
    GRADE_NAME     VARCHAR2 (100 BYTE),
    MIN_SALARY     NUMBER,
    MAX_SALARY     NUMBER,
    DESCRIPTION    VARCHAR2 (255 BYTE),
    ENT_DATE       DATE DEFAULT SYSDATE,
    UPD_DATE       DATE,
    ENT_BY         NUMBER,             --REF Employee ID as employees table id
    UPD_BY         NUMBER,
    SCALES         VARCHAR2 (100 BYTE),
    GRADE_CODE     VARCHAR2 (30 BYTE),
    GRADE_ORDER    NUMBER (3)
);

CREATE OR REPLACE TRIGGER TRG_job_grades_PK
    BEFORE INSERT OR UPDATE
    ON JOB_GRADES
    FOR EACH ROW
BEGIN
    IF :new.id IS NULL
    THEN
        SELECT NVL (MAX (id), 0) + 1 INTO :new.id FROM job_grades;
    END IF;
END TRG_job_grades_PK;
/

CREATE TABLE PAY_SCALE_MASTER
(
    SCALE_ID           NUMBER,
    GRADE_ID           NUMBER NOT NULL,
    REVISION_NO        NUMBER (3) DEFAULT 1,
    REVISION_NAME      VARCHAR2 (100 BYTE),
    START_BASIC        NUMBER (10, 2) NOT NULL,
    INCREMENT_1        NUMBER (10, 2) NOT NULL,
    STEPS_BEFORE_EB    NUMBER (3) DEFAULT 10 NOT NULL,
    EB_BASIC           NUMBER (10, 2) NOT NULL,
    INCREMENT_2        NUMBER (10, 2) NOT NULL,
    STEPS_AFTER_EB     NUMBER (3) DEFAULT 15 NOT NULL,
    MAX_BASIC          NUMBER (10, 2) NOT NULL,
    IS_ACTIVE          VARCHAR2 (1 BYTE) DEFAULT 'Y' NOT NULL,
    EFFECTIVE_FROM     DATE,
    EFFECTIVE_TO       DATE,
    APPROVED_BY        NUMBER,
    APPROVED_DATE      DATE,
    CREATED_BY         NUMBER,         --REF Employee ID as employees table id
    CREATED_DATE       DATE DEFAULT SYSDATE,
    UPDATED_BY         NUMBER,         --REF Employee ID as employees table id
    UPDATED_DATE       DATE,
    HR                 NUMBER,
    CPF                NUMBER,
    PFCONT             NUMBER,
    CONV               NUMBER,
    MEDICAL            NUMBER,
    ALLOWANCE          NUMBER,
    SAF                NUMBER
);

/* Formatted on 4/8/2026 11:03:10 AM (QP5 v5.362) */
CREATE TABLE ALLOWANCE_HEAD
(
    HEAD_ID         NUMBER,
    HEAD_CODE       VARCHAR2 (20 BYTE) NOT NULL,
    HEAD_NAME       VARCHAR2 (100 BYTE) NOT NULL,
    HEAD_TYPE       VARCHAR2 (10 BYTE) NOT NULL,
    CALC_TYPE       VARCHAR2 (10 BYTE) NOT NULL,
    IS_TAXABLE      VARCHAR2 (1 BYTE) DEFAULT 'Y',
    PRINT_ORDER     NUMBER (3),
    IS_ACTIVE       VARCHAR2 (1 BYTE) DEFAULT 'Y',
    REMARKS         VARCHAR2 (200 BYTE),
    CREATED_BY      NUMBER,
    CREATED_DATE    DATE DEFAULT SYSDATE,
    UPDATED_BY      NUMBER,
    UPDATED_DATE    DATE
);

ALTER TABLE ALLOWANCE_HEAD
    ADD (
        CONSTRAINT CHK_HEAD_ACTIVE CHECK
            (is_active IN ('Y', 'N'))
            ENABLE VALIDATE,
        CONSTRAINT CHK_HEAD_CALC CHECK
            (calc_type IN ('PERCENT', 'FIXED'))
            ENABLE VALIDATE,
        CONSTRAINT CHK_HEAD_TAXABLE CHECK
            (is_taxable IN ('Y', 'N'))
            ENABLE VALIDATE,
        CONSTRAINT CHK_HEAD_TYPE CHECK
            (head_type IN ('EARNING', 'DEDUCTION'))
            ENABLE VALIDATE,
        CONSTRAINT ALLOWANCE_HEAD_PK PRIMARY KEY (HEAD_ID),
        CONSTRAINT UK_HEAD_CODE UNIQUE (HEAD_CODE));


ALTER TABLE PAY_SCALE_MASTER
    ADD (
        CONSTRAINT CHK_SCALE_ACTIVE CHECK
            (is_active IN ('Y', 'N'))
            ENABLE VALIDATE,
        CONSTRAINT CHK_SCALE_DATES CHECK
            (effective_to IS NULL OR effective_to >= effective_from)
            ENABLE VALIDATE,
        CONSTRAINT PAY_SCALE_MASTER_PK PRIMARY KEY (SCALE_ID),
        CONSTRAINT UK_GRADE_REVISION UNIQUE (GRADE_ID, REVISION_NO));



CREATE OR REPLACE TRIGGER t_pay_scale_master_pk
    BEFORE INSERT OR UPDATE
    ON PAY_SCALE_MASTER
    FOR EACH ROW
BEGIN
    IF :new.scale_id IS NULL
    THEN
        SELECT NVL (MAX (scale_id), 0) + 1
          INTO :new.scale_id
          FROM pay_scale_master;
    END IF;
END t_pay_scale_master_pk;
/

CREATE TABLE emp_salary_structure
(
    sals_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id      NUMBER REFERENCES employees (id),
    slno             NUMBER,
    headcode         VARCHAR2 (20),---allowance_head
    amount           NUMBER (12, 2) DEFAULT 0,  
    revision_type    VARCHAR2 (1) DEFAULT 'J' CHECK(revision_type IN ('J','I','P','R')),
    -- J=Joining, I=Increment, P=Promotion, R=Revision Payscale
    is_active        VARCHAR2 (1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    created_by       NUMBER,
    created_date     DATE DEFAULT SYSDATE,
    updated_by       NUMBER,
    updated_date     DATE
);

CREATE INDEX idx_ess_emp_active
    ON emp_salary_structure (employee_id, is_active);

CREATE INDEX idx_ess_emp_head
    ON emp_salary_structure (slno, employee_id, headcode);
ALTER TABLE PAY_SCALE_MASTER
    ADD (
        CONSTRAINT FK_SCALE_GRADE FOREIGN KEY (GRADE_ID)
            REFERENCES JOB_GRADES (ID)
            ENABLE VALIDATE);

CREATE TABLE pay_scale_detail
(
    detail_id           NUMBER,
    scale_id            NUMBER NOT NULL,
    step_no             NUMBER (3) NOT NULL, -- 0=Start, 1-10=Pre-EB, 11-25=Post-EB
    basic_amount        NUMBER (10, 2) NOT NULL,
    increment_amount    NUMBER (10, 2),                     -- NULL for step 0
    is_eb_step          VARCHAR2 (1) DEFAULT 'N' NOT NULL,
    phase               VARCHAR2 (10) NOT NULL,    -- INITIAL, PRE_EB, POST_EB
    --
    CONSTRAINT fk_detail_scale FOREIGN KEY (scale_id)
        REFERENCES pay_scale_master (scale_id),
    CONSTRAINT chk_detail_eb CHECK (is_eb_step IN ('Y', 'N')),
    CONSTRAINT chk_detail_phase CHECK
        (phase IN ('INITIAL', 'PRE_EB', 'POST_EB')),
    CONSTRAINT uk_scale_step UNIQUE (scale_id, step_no)
);

