/* Formatted on 3/31/2026 10:41:55 AM (QP5 v5.362) */

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
    ID             NUMBER,
    GRADE_NAME     VARCHAR2 (100 BYTE),
    MIN_SALARY     NUMBER,
    MAX_SALARY     NUMBER,
    DESCRIPTION    VARCHAR2 (255 BYTE),
    ENT_DATE       DATE DEFAULT SYSDATE,
    UPD_DATE       DATE,
    ENT_BY         NUMBER,
    UPD_BY         NUMBER,
    SCALES         VARCHAR2 (100 BYTE)
);

ALTER TABLE JOB_GRADES
    ADD (grade_code VARCHAR2 (30 BYTE), grade_order NUMBER (3));

CREATE TABLE pay_scale_master
(
    scale_id           NUMBER,
    grade_id           NUMBER NOT NULL,
    revision_no        NUMBER (3) DEFAULT 1, -- 1=Original, 2=1st revision, etc.
    revision_name      VARCHAR2 (100), -- e.g. 'Pay Scale 2024', 'Revised Scale 2026'
    start_basic        NUMBER (10, 2) NOT NULL,                       -- 46550
    increment_1        NUMBER (10, 2) NOT NULL,     --4190 Increment before EB
    steps_before_eb    NUMBER (3) DEFAULT 10 NOT NULL,
    eb_basic           NUMBER (10, 2) NOT NULL,      --88450 Basic at EB point
    increment_2        NUMBER (10, 2) NOT NULL,      --4310 Increment after EB
    steps_after_eb     NUMBER (3) DEFAULT 15 NOT NULL,
    max_basic          NUMBER (10, 2) NOT NULL,                      ---153100
    is_active          VARCHAR2 (1) DEFAULT 'Y' NOT NULL,
    effective_from     DATE,
    effective_to       DATE,                        -- NULL = currently active
    approved_by        NUMBER,
    approved_date      DATE,
    created_by         NUMBER,
    created_date       DATE DEFAULT SYSDATE,
    updated_by         NUMBER,
    updated_date       DATE,
    CONSTRAINT fk_scale_grade FOREIGN KEY (grade_id)
        REFERENCES JOB_GRADES (id),
    CONSTRAINT chk_scale_active CHECK (is_active IN ('Y', 'N')),
    CONSTRAINT chk_scale_dates CHECK
        (effective_to IS NULL OR effective_to >= effective_from),
    CONSTRAINT uk_grade_revision UNIQUE (grade_id, revision_no)
);

-- Index for common APEX queries

CREATE INDEX idx_scale_grade_active
    ON pay_scale_master (grade_id, is_active);

CREATE INDEX idx_scale_active
    ON pay_scale_master (is_active);


-- ============================================================
-- 3. PAY SCALE DETAIL (Step-wise Expansion)
--    Auto-populated from master. Regenerated on revision.
-- ============================================================

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

CREATE INDEX idx_detail_scale
    ON pay_scale_detail (scale_id);

CREATE INDEX idx_detail_basic
    ON pay_scale_detail (basic_amount);





DECLARE
    v_id NUMBER;
BEGIN
    -- GRADE-01
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-01';
    revise_pay_scale(v_id, 46550, 4190, 10, 88450, 4310, 15, 153100, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-02
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-02';
    revise_pay_scale(v_id, 37050, 3330, 10, 70350, 3430, 15, 121800, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-03
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-03';
    revise_pay_scale(v_id, 30550, 2750, 10, 58050, 2830, 15, 100500, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-04
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-04';
    revise_pay_scale(v_id, 25050, 2250, 10, 47550, 2320, 15, 82350, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-05
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-05';
    revise_pay_scale(v_id, 22050, 1980, 10, 41850, 2040, 15, 72450, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-06
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-06';
    revise_pay_scale(v_id, 19050, 1710, 10, 36150, 1760, 15, 62550, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-07
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-07';
    revise_pay_scale(v_id, 17050, 1530, 10, 32350, 1580, 15, 56050, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-08
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-08';
    revise_pay_scale(v_id, 15250, 1370, 10, 28950, 1410, 15, 50100, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-09
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-09';
    revise_pay_scale(v_id, 13300, 1200, 10, 25300, 1230, 15, 43750, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-10
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-10';
    revise_pay_scale(v_id, 12250, 1100, 10, 23250, 1130, 15, 40200, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-11
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-11';
    revise_pay_scale(v_id, 11000, 990, 10, 20900, 1020, 15, 36200, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-12
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-12';
    revise_pay_scale(v_id, 10250, 920, 10, 19450, 950, 15, 33700, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-13
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-13';
    revise_pay_scale(v_id, 9700, 870, 10, 18400, 900, 15, 31900, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-14
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-14';
    revise_pay_scale(v_id, 9100, 820, 10, 17300, 840, 15, 29900, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-15
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-15';
    revise_pay_scale(v_id, 8250, 740, 10, 15650, 765, 15, 27125, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-16
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-16';
    revise_pay_scale(v_id, 7700, 695, 10, 14650, 710, 15, 25300, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-17
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-17';
    revise_pay_scale(v_id, 7150, 645, 10, 13600, 660, 15, 23500, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-18
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-18';
    revise_pay_scale(v_id, 6600, 595, 10, 12550, 610, 15, 21700, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-19
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-19';
    revise_pay_scale(v_id, 6050, 545, 10, 11500, 560, 15, 19900, DATE '2025-07-01', 'Pay Scale 2025');

    -- GRADE-20
    SELECT id INTO v_id FROM JOB_GRADES WHERE grade_code = 'GRADE-20';
    revise_pay_scale(v_id, 5500, 500, 10, 10500, 510, 15, 18150, DATE '2025-07-01', 'Pay Scale 2025');
END;
/
