/* ============================================================
   HRMS EMPLOYEE PROMOTION MODULE
   Oracle APEX / Oracle Database

   Depends on:
   - employees
   - job_grades / pay_scale_master / pay_scale_detail
   - allowance_head / emp_salary_structure / vw_employee_salary
   - hr_action_type / hr_employee_action
   - hr_employee_career_hist / emp_salary_structure_hist
   - fn_get_salary_head_amount(p_job_id, p_headcode, p_basic)
   ============================================================ */
---------------------------------------------------------------
-- TABLE SCRIPTS
---------------------------------------------------------------
-- Run these table scripts first:
-- 1. Table/hr_action_type_promotion.sql
-- 2. Table/hr_promotion_policy.sql
-- 3. Table/hr_employee_promotion.sql
-- 4. Table/hr_employee_action_promotion_columns.sql
-- 5. Table/hr_letter_template.sql
-- 6. Table/hr_employee_letter.sql


---------------------------------------------------------------
-- 1. HELPERS: PROMOTION POLICY AND BASIC FITMENT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_acc_promotion_limit (
    p_effective_date IN DATE DEFAULT SYSDATE)
    RETURN NUMBER
IS
    v_limit   NUMBER;
BEGIN
    SELECT max_accelerated_promotions
      INTO v_limit
      FROM hr_promotion_policy
     WHERE     policy_code = 'DEFAULT'
           AND NVL (is_active, 'Y') = 'Y'
           AND NVL (p_effective_date, TRUNC (SYSDATE)) BETWEEN NVL (effective_from, DATE '1900-01-01')
                                                          AND NVL (effective_to, DATE '2999-12-31');

    RETURN NVL (v_limit, 2);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 2;
END;
/


CREATE OR REPLACE FUNCTION fn_get_acc_promotion_count (
    p_emp_id                 IN NUMBER,
    p_exclude_promotion_id   IN NUMBER DEFAULT NULL)
    RETURN NUMBER
IS
    v_count   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO v_count
      FROM hr_employee_promotion
     WHERE     emp_id = p_emp_id
           AND promotion_type = 'ACCELERATED'
           AND approval_status = 'POSTED'
           AND promotion_id <> NVL (p_exclude_promotion_id, -1);

    RETURN v_count;
END;
/


CREATE OR REPLACE FUNCTION fn_get_acc_promotion_remaining (
    p_emp_id          IN NUMBER,
    p_effective_date  IN DATE DEFAULT SYSDATE)
    RETURN NUMBER
IS
    v_remaining   NUMBER;
BEGIN
    v_remaining :=
          fn_get_acc_promotion_limit (p_effective_date)
        - fn_get_acc_promotion_count (p_emp_id);

    RETURN GREATEST (v_remaining, 0);
END;
/

CREATE OR REPLACE FUNCTION fn_get_promotion_basic (
    p_new_job_id      IN NUMBER,
    p_current_basic   IN NUMBER,
    p_min_increase    IN NUMBER DEFAULT 0)
    RETURN NUMBER
IS
    v_basic   NUMBER;
BEGIN
    SELECT MIN (d.basic_amount)
      INTO v_basic
      FROM pay_scale_master m
           JOIN pay_scale_detail d ON d.scale_id = m.scale_id
     WHERE     m.grade_id = p_new_job_id
           AND NVL (m.is_active, 'Y') = 'Y'
           AND d.basic_amount >= NVL (p_current_basic, 0) + NVL (p_min_increase, 0);

    IF v_basic IS NOT NULL
    THEN
        RETURN v_basic;
    END IF;

    SELECT m.max_basic
      INTO v_basic
      FROM pay_scale_master m
     WHERE m.grade_id = p_new_job_id AND NVL (m.is_active, 'Y') = 'Y';

    RETURN v_basic;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN p_current_basic;
END;
/


---------------------------------------------------------------
-- 7. PROCEDURE: CREATE DRAFT PROMOTION
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_create_promotion (
    p_emp_id           IN     NUMBER,
    p_effective_date   IN     DATE,
    p_new_job_id       IN     NUMBER,
    p_new_desig_id     IN     NUMBER,
    p_new_dept_id      IN     NUMBER DEFAULT NULL,
    p_new_emp_type_id  IN     NUMBER DEFAULT NULL,
    p_new_basic        IN     NUMBER DEFAULT NULL,
    p_min_increase     IN     NUMBER DEFAULT 0,
    p_reason           IN     VARCHAR2 DEFAULT NULL,
    p_remarks          IN     VARCHAR2 DEFAULT NULL,
    p_user_id          IN     NUMBER,
    p_promotion_id        OUT NUMBER,
    p_promotion_type   IN     VARCHAR2 DEFAULT 'REGULAR')
IS
    v_old_emp_type   NUMBER;
    v_old_job_id     NUMBER;
    v_old_desig_id   NUMBER;
    v_old_dept_id    NUMBER;
    v_old_basic      NUMBER;
    v_old_gross      NUMBER;
    v_new_basic      NUMBER;
    v_new_gross      NUMBER;
    v_promotion_type VARCHAR2 (20);
    v_acc_limit      NUMBER;
    v_acc_count      NUMBER;
BEGIN
    v_promotion_type := UPPER (NVL (p_promotion_type, 'REGULAR'));

    IF v_promotion_type = 'NORMAL'
    THEN
        v_promotion_type := 'REGULAR';
    END IF;

    IF v_promotion_type NOT IN ('REGULAR', 'ACCELERATED')
    THEN
        RAISE_APPLICATION_ERROR (
            -20100,
            'Promotion type must be REGULAR or ACCELERATED.');
    END IF;

    SELECT e.emp_type,
           e.job_id,
           e.desig_id,
           e.dept_id,
           NVL (v.basic_salary, 0),
           NVL (v.gross_salary, 0)
      INTO v_old_emp_type,
           v_old_job_id,
           v_old_desig_id,
           v_old_dept_id,
           v_old_basic,
           v_old_gross
      FROM employees e LEFT JOIN vw_employee_salary v ON v.emp_id = e.id
     WHERE e.id = p_emp_id;

    IF v_promotion_type = 'ACCELERATED'
    THEN
        v_acc_limit := fn_get_acc_promotion_limit (p_effective_date);
        v_acc_count := fn_get_acc_promotion_count (p_emp_id);

        IF v_acc_count >= v_acc_limit
        THEN
            RAISE_APPLICATION_ERROR (
                -20102,
                   'Accelerated promotion limit exceeded. Employee already received '
                || v_acc_count
                || ' accelerated promotion(s). Policy limit is '
                || v_acc_limit
                || '.');
        END IF;
    ELSE
        v_acc_count := NULL;
    END IF;

    v_new_basic :=
        NVL (
            p_new_basic,
            fn_get_promotion_basic (p_new_job_id,
                                    v_old_basic,
                                    NVL (p_min_increase, 0)));

    IF NVL (v_new_basic, 0) < NVL (v_old_basic, 0)
    THEN
        RAISE_APPLICATION_ERROR (
            -20101,
            'Promotion basic cannot be lower than current basic.');
    END IF;

    SELECT NVL (
               SUM (
                   CASE
                       WHEN ah.head_type = 'EARNING'
                       THEN
                           fn_get_salary_head_amount (p_new_job_id,
                                                      s.headcode,
                                                      v_new_basic)
                       ELSE
                           0
                   END),
               0)
      INTO v_new_gross
      FROM emp_salary_structure s
           JOIN allowance_head ah ON ah.head_id = s.slno
     WHERE s.employee_id = p_emp_id AND NVL (s.is_active, 'Y') = 'Y';

    INSERT INTO hr_employee_promotion (emp_id,
                                       promotion_type,
                                       accelerated_count,
                                       promotion_date,
                                       effective_date,
                                       old_emp_type_id,
                                       new_emp_type_id,
                                       old_job_id,
                                       new_job_id,
                                       old_desig_id,
                                       new_desig_id,
                                       old_dept_id,
                                       new_dept_id,
                                       old_basic,
                                       new_basic,
                                       old_gross,
                                       new_gross,
                                       increase_amount,
                                       increase_percent,
                                       reason,
                                       remarks,
                                       approval_status,
                                       proposed_by,
                                       ent_by)
         VALUES (p_emp_id,
                 v_promotion_type,
                 CASE WHEN v_promotion_type = 'ACCELERATED' THEN v_acc_count + 1 END,
                 SYSDATE,
                 p_effective_date,
                 v_old_emp_type,
                 NVL (p_new_emp_type_id, v_old_emp_type),
                 v_old_job_id,
                 p_new_job_id,
                 v_old_desig_id,
                 p_new_desig_id,
                 v_old_dept_id,
                 NVL (p_new_dept_id, v_old_dept_id),
                 v_old_basic,
                 v_new_basic,
                 v_old_gross,
                 v_new_gross,
                 v_new_basic - v_old_basic,
                 CASE
                     WHEN NVL (v_old_basic, 0) = 0 THEN NULL
                     ELSE ROUND (((v_new_basic - v_old_basic) / v_old_basic) * 100, 2)
                 END,
                 p_reason,
                 p_remarks,
                 'DRAFT',
                 p_user_id,
                 p_user_id)
      RETURNING promotion_id
           INTO p_promotion_id;
END;
/


---------------------------------------------------------------
-- 8. PROCEDURE: APPROVE / POST PROMOTION
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_post_promotion (
    p_promotion_id   IN NUMBER,
    p_user_id        IN NUMBER)
IS
    v_promo       hr_employee_promotion%ROWTYPE;
    v_action_id   NUMBER;
    v_acc_limit   NUMBER;
    v_acc_count   NUMBER;
BEGIN
    SELECT *
      INTO v_promo
      FROM hr_employee_promotion
     WHERE promotion_id = p_promotion_id
       FOR UPDATE;

    IF v_promo.approval_status = 'POSTED'
    THEN
        RAISE_APPLICATION_ERROR (-20110, 'Promotion is already posted.');
    END IF;

    IF v_promo.approval_status = 'CANCELLED'
    THEN
            RAISE_APPLICATION_ERROR (-20111, 'Cancelled promotion cannot be posted.');
    END IF;

    v_promo.promotion_type := UPPER (NVL (v_promo.promotion_type, 'REGULAR'));

    IF v_promo.promotion_type = 'NORMAL'
    THEN
        v_promo.promotion_type := 'REGULAR';
    END IF;

    IF v_promo.promotion_type = 'ACCELERATED'
    THEN
        v_acc_limit := fn_get_acc_promotion_limit (v_promo.effective_date);
        v_acc_count :=
            fn_get_acc_promotion_count (v_promo.emp_id, v_promo.promotion_id);

        IF v_acc_count >= v_acc_limit
        THEN
            RAISE_APPLICATION_ERROR (
                -20112,
                   'Accelerated promotion limit exceeded. Employee already received '
                || v_acc_count
                || ' accelerated promotion(s). Policy limit is '
                || v_acc_limit
                || '.');
        END IF;

        v_promo.accelerated_count := v_acc_count + 1;
    ELSE
        v_promo.accelerated_count := NULL;
    END IF;

    INSERT INTO hr_employee_action (emp_id,
                                    action_type,
                                    promotion_type,
                                    accelerated_count,
                                    action_date,
                                    effective_date,
                                    old_emp_type_id,
                                    new_emp_type_id,
                                    old_job_id,
                                    new_job_id,
                                    old_desig_id,
                                    new_desig_id,
                                    old_dept_id,
                                    new_dept_id,
                                    old_basic,
                                    new_basic,
                                    old_gross,
                                    new_gross,
                                    increment_amount,
                                    increment_percent,
                                    reason,
                                    remarks,
                                    approval_status,
                                    ent_by,
                                    approved_by,
                                    approved_date)
         VALUES (v_promo.emp_id,
                 'PROMOTION',
                 v_promo.promotion_type,
                 v_promo.accelerated_count,
                 SYSDATE,
                 v_promo.effective_date,
                 v_promo.old_emp_type_id,
                 v_promo.new_emp_type_id,
                 v_promo.old_job_id,
                 v_promo.new_job_id,
                 v_promo.old_desig_id,
                 v_promo.new_desig_id,
                 v_promo.old_dept_id,
                 v_promo.new_dept_id,
                 v_promo.old_basic,
                 v_promo.new_basic,
                 v_promo.old_gross,
                 v_promo.new_gross,
                 v_promo.increase_amount,
                 v_promo.increase_percent,
                 v_promo.reason,
                 v_promo.remarks,
                 'APPROVED',
                 p_user_id,
                 p_user_id,
                 SYSDATE)
      RETURNING action_id
           INTO v_action_id;

    INSERT INTO hr_employee_career_hist (emp_id,
                                         action_id,
                                         action_type,
                                         effective_date,
                                         old_emp_type_id,
                                         new_emp_type_id,
                                         old_job_id,
                                         new_job_id,
                                         old_desig_id,
                                         new_desig_id,
                                         old_dept_id,
                                         new_dept_id,
                                         remarks,
                                         ent_by)
         VALUES (v_promo.emp_id,
                 v_action_id,
                 'PROMOTION',
                 v_promo.effective_date,
                 v_promo.old_emp_type_id,
                 v_promo.new_emp_type_id,
                 v_promo.old_job_id,
                 v_promo.new_job_id,
                 v_promo.old_desig_id,
                 v_promo.new_desig_id,
                 v_promo.old_dept_id,
                 v_promo.new_dept_id,
                 v_promo.remarks,
                 p_user_id);

    INSERT INTO emp_salary_structure_hist (action_id,
                                           emp_id,
                                           sals_id,
                                           slno,
                                           headcode,
                                           old_amount,
                                           new_amount,
                                           revision_type,
                                           effective_date,
                                           remarks,
                                           ent_by)
        SELECT v_action_id,
               s.employee_id,
               s.sals_id,
               s.slno,
               s.headcode,
               s.amount,
               fn_get_salary_head_amount (v_promo.new_job_id,
                                          s.headcode,
                                          v_promo.new_basic),
               'P',
               v_promo.effective_date,
               v_promo.remarks,
               p_user_id
          FROM emp_salary_structure s
         WHERE s.employee_id = v_promo.emp_id
           AND NVL (s.is_active, 'Y') = 'Y';

    UPDATE emp_salary_structure s
       SET s.amount =
               fn_get_salary_head_amount (v_promo.new_job_id,
                                          s.headcode,
                                          v_promo.new_basic),
           s.revision_type = 'P',
           s.updated_by = p_user_id,
           s.updated_date = SYSDATE
     WHERE s.employee_id = v_promo.emp_id
       AND NVL (s.is_active, 'Y') = 'Y';

    UPDATE employees
       SET emp_type = v_promo.new_emp_type_id,
           job_id = v_promo.new_job_id,
           desig_id = v_promo.new_desig_id,
           dept_id = v_promo.new_dept_id,
           last_increment_date = v_promo.effective_date,
           next_increment_date =
               ADD_MONTHS (v_promo.effective_date,
                           NVL (increment_cycle_months, 12)),
           upd_by = p_user_id,
           upd_date = SYSDATE
     WHERE id = v_promo.emp_id;

    UPDATE hr_employee_promotion
       SET action_id = v_action_id,
           accelerated_count = v_promo.accelerated_count,
           approval_status = 'POSTED',
           approved_by = NVL (approved_by, p_user_id),
           approved_date = NVL (approved_date, SYSDATE),
           posted_by = p_user_id,
           posted_date = SYSDATE,
           upd_by = p_user_id,
           upd_date = SYSDATE
     WHERE promotion_id = p_promotion_id;

    COMMIT;
END;
/


---------------------------------------------------------------
-- 9. FUNCTION: RENDER PROMOTION LETTER HTML
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_render_promotion_letter (
    p_promotion_id   IN NUMBER,
    p_template_code  IN VARCHAR2 DEFAULT 'PROMOTION_DEFAULT')
    RETURN CLOB
IS
    v_html              CLOB;
    v_emp_code          VARCHAR2 (100);
    v_emp_name          VARCHAR2 (300);
    v_old_designation   VARCHAR2 (300);
    v_new_designation   VARCHAR2 (300);
    v_effective_date    VARCHAR2 (30);
    v_new_basic         VARCHAR2 (50);
    v_new_gross         VARCHAR2 (50);
    v_promotion_type    VARCHAR2 (30);
BEGIN
    SELECT t.body_template,
           e.emp_id,
           TRIM (e.f_name || ' ' || e.l_name),
           INITCAP (p.promotion_type),
           old_d.designation,
           new_d.designation,
           TO_CHAR (p.effective_date, 'DD-MON-YYYY'),
           TO_CHAR (p.new_basic, 'FM999G999G999G990D00'),
           TO_CHAR (p.new_gross, 'FM999G999G999G990D00')
      INTO v_html,
           v_emp_code,
           v_emp_name,
           v_promotion_type,
           v_old_designation,
           v_new_designation,
           v_effective_date,
           v_new_basic,
           v_new_gross
      FROM hr_employee_promotion p
           JOIN employees e ON e.id = p.emp_id
           LEFT JOIN designations old_d ON old_d.id = p.old_desig_id
           LEFT JOIN designations new_d ON new_d.id = p.new_desig_id
           JOIN hr_letter_template t
               ON t.template_code = p_template_code
              AND t.action_type = 'PROMOTION'
              AND NVL (t.is_active, 'Y') = 'Y'
     WHERE p.promotion_id = p_promotion_id;

    v_html := REPLACE (v_html, '#LETTER_DATE#', TO_CHAR (SYSDATE, 'DD-MON-YYYY'));
    v_html := REPLACE (v_html, '#EMP_CODE#', v_emp_code);
    v_html := REPLACE (v_html, '#EMP_NAME#', v_emp_name);
    v_html := REPLACE (v_html, '#PROMOTION_TYPE#', v_promotion_type);
    v_html := REPLACE (v_html, '#OLD_DESIGNATION#', NVL (v_old_designation, '-'));
    v_html := REPLACE (v_html, '#NEW_DESIGNATION#', NVL (v_new_designation, '-'));
    v_html := REPLACE (v_html, '#EFFECTIVE_DATE#', v_effective_date);
    v_html := REPLACE (v_html, '#NEW_BASIC#', v_new_basic);
    v_html := REPLACE (v_html, '#NEW_GROSS#', v_new_gross);

    RETURN v_html;
END;
/


---------------------------------------------------------------
-- 10. PROCEDURE: GENERATE PROMOTION LETTER
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_generate_promotion_letter (
    p_promotion_id   IN     NUMBER,
    p_template_code  IN     VARCHAR2 DEFAULT 'PROMOTION_DEFAULT',
    p_user_id        IN     NUMBER,
    p_letter_id         OUT NUMBER)
IS
    v_template_id   NUMBER;
    v_emp_id        NUMBER;
    v_action_id     NUMBER;
    v_subject       VARCHAR2 (500);
    v_body_html     CLOB;
    v_emp_name      VARCHAR2 (300);
    v_promotion_type VARCHAR2 (30);
BEGIN
    SELECT p.emp_id,
           p.action_id,
           t.template_id,
           t.subject_template,
           TRIM (e.f_name || ' ' || e.l_name),
           INITCAP (p.promotion_type)
      INTO v_emp_id,
           v_action_id,
           v_template_id,
           v_subject,
           v_emp_name,
           v_promotion_type
      FROM hr_employee_promotion p
           JOIN employees e ON e.id = p.emp_id
           JOIN hr_letter_template t
               ON t.template_code = p_template_code
              AND t.action_type = 'PROMOTION'
              AND NVL (t.is_active, 'Y') = 'Y'
     WHERE p.promotion_id = p_promotion_id;

    v_body_html := fn_render_promotion_letter (p_promotion_id, p_template_code);
    v_subject := REPLACE (v_subject, '#EMP_NAME#', v_emp_name);
    v_subject := REPLACE (v_subject, '#PROMOTION_TYPE#', v_promotion_type);

    INSERT INTO hr_employee_letter (emp_id,
                                    action_id,
                                    promotion_id,
                                    template_id,
                                    letter_date,
                                    subject_text,
                                    body_html,
                                    status,
                                    generated_by)
         VALUES (v_emp_id,
                 v_action_id,
                 p_promotion_id,
                 v_template_id,
                 SYSDATE,
                 v_subject,
                 v_body_html,
                 'DRAFT',
                 p_user_id)
      RETURNING letter_id
           INTO p_letter_id;

    UPDATE hr_employee_letter
       SET letter_no = 'LTR-' || TO_CHAR (SYSDATE, 'YYYY') || '-' || LPAD (letter_id, 6, '0')
     WHERE letter_id = p_letter_id;

    COMMIT;
END;
/


---------------------------------------------------------------
-- 11. APEX REPORT QUERIES
---------------------------------------------------------------

-- Promotion list:
-- SELECT p.promotion_id,
--        p.promotion_no,
--        p.promotion_type,
--        p.accelerated_count,
--        e.emp_id,
--        TRIM(e.f_name || ' ' || e.l_name) emp_name,
--        od.designation old_designation,
--        nd.designation new_designation,
--        p.effective_date,
--        p.old_basic,
--        p.new_basic,
--        p.old_gross,
--        p.new_gross,
--        CASE
--            WHEN p.promotion_type = 'ACCELERATED'
--            THEN fn_get_acc_promotion_remaining(p.emp_id, p.effective_date)
--        END accelerated_remaining,
--        p.approval_status
--   FROM hr_employee_promotion p
--        JOIN employees e ON e.id = p.emp_id
--        LEFT JOIN designations od ON od.id = p.old_desig_id
--        LEFT JOIN designations nd ON nd.id = p.new_desig_id;

-- Promotion type LOV:
-- SELECT 'Normal / Regular Promotion' d, 'REGULAR' r FROM dual
-- UNION ALL
-- SELECT 'Accelerated Promotion' d, 'ACCELERATED' r FROM dual;

-- Employee accelerated promotion balance:
-- SELECT fn_get_acc_promotion_count(:PXX_EMP_ID) accelerated_used,
--        fn_get_acc_promotion_limit(:PXX_EFFECTIVE_DATE) accelerated_limit,
--        fn_get_acc_promotion_remaining(:PXX_EMP_ID, :PXX_EFFECTIVE_DATE) accelerated_remaining
--   FROM dual;

-- Letter print region source:
-- SELECT body_html
--   FROM hr_employee_letter
--  WHERE letter_id = :PXX_LETTER_ID;

