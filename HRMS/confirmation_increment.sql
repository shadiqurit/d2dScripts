/* Formatted on 5/18/2026 7:21:52 PM (QP5 v5.362) */
/* ============================================================
   HRMS CONFIRMATION + INCREMENT MODULE
   Oracle APEX / Oracle Database
   ============================================================ */

---------------------------------------------------------------
-- 1. ADD REQUIRED COLUMNS IN EMPLOYEES
---------------------------------------------------------------

ALTER TABLE employees
    ADD (eb_status VARCHAR2 (20) DEFAULT 'NORMAL');

-- EB_STATUS values:
-- NORMAL
-- EB_HOLD
-- AEB_APPROVED


---------------------------------------------------------------
-- 2. ACTION TYPE MASTER
---------------------------------------------------------------

CREATE TABLE hr_action_type
(
    action_type_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    action_code       VARCHAR2 (30) UNIQUE NOT NULL,
    action_name       VARCHAR2 (100) NOT NULL,
    is_active         VARCHAR2 (1) DEFAULT 'Y',
    ent_by            NUMBER,
    ent_date          DATE DEFAULT SYSDATE
);

INSERT INTO hr_action_type (action_code, action_name)
     VALUES ('CONFIRMATION', 'Employee Confirmation');

INSERT INTO hr_action_type (action_code, action_name)
     VALUES ('INCREMENT', 'Annual Increment');

INSERT INTO hr_action_type (action_code, action_name)
     VALUES ('INCREMENT_HOLD', 'Increment Hold');

INSERT INTO hr_action_type (action_code, action_name)
     VALUES ('INCREMENT_RELEASE', 'Increment Hold Release');

COMMIT;


---------------------------------------------------------------
-- 3. MAIN EMPLOYEE ACTION HISTORY TABLE
---------------------------------------------------------------

CREATE TABLE hr_employee_action
(
    action_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id               NUMBER NOT NULL,
    action_type          VARCHAR2 (30) NOT NULL,
    action_date          DATE DEFAULT SYSDATE NOT NULL,
    effective_date       DATE NOT NULL,
    old_emp_type_id      NUMBER,
    new_emp_type_id      NUMBER,
    old_job_id           NUMBER,
    new_job_id           NUMBER,
    old_desig_id         NUMBER,
    new_desig_id         NUMBER,
    old_dept_id          NUMBER,
    new_dept_id          NUMBER,
    old_basic            NUMBER (14, 2),
    new_basic            NUMBER (14, 2),
    old_gross            NUMBER (14, 2),
    new_gross            NUMBER (14, 2),
    increment_amount     NUMBER (14, 2),
    increment_percent    NUMBER (8, 2),
    old_eb_status        VARCHAR2 (20),
    new_eb_status        VARCHAR2 (20),
    reason               VARCHAR2 (1000),
    remarks              VARCHAR2 (1000),
    approval_status      VARCHAR2 (20) DEFAULT 'DRAFT',
    ent_by               NUMBER,
    ent_date             DATE DEFAULT SYSDATE,
    upd_by               NUMBER,
    upd_date             DATE,
    approved_by          NUMBER,
    approved_date        DATE
);


---------------------------------------------------------------
-- 4. SALARY STRUCTURE HISTORY TABLE
---------------------------------------------------------------

CREATE TABLE emp_salary_structure_hist
(
    hist_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    action_id         NUMBER NOT NULL,
    emp_id            NUMBER NOT NULL,
    sals_id           NUMBER,
    slno              NUMBER,
    headcode          VARCHAR2 (30),
    old_amount        NUMBER (14, 2),
    new_amount        NUMBER (14, 2),
    revision_type     VARCHAR2 (1),
    -- C = Confirmation
    -- I = Increment

    effective_date    DATE,
    remarks           VARCHAR2 (1000),
    ent_by            NUMBER,
    ent_date          DATE DEFAULT SYSDATE
);


---------------------------------------------------------------
-- 5. INCREMENT HOLD TABLE
---------------------------------------------------------------

CREATE TABLE hr_increment_hold
(
    hold_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id             NUMBER NOT NULL,
    hold_from_date     DATE DEFAULT SYSDATE,
    hold_to_date       DATE,
    hold_reason        VARCHAR2 (1000),
    hold_status        VARCHAR2 (20) DEFAULT 'ACTIVE',
    released_date      DATE,
    released_by        NUMBER,
    release_remarks    VARCHAR2 (1000),
    action_id          NUMBER,
    ent_by             NUMBER,
    ent_date           DATE DEFAULT SYSDATE,
    upd_by             NUMBER,
    upd_date           DATE
);


---------------------------------------------------------------
-- 6. EMPLOYEE CAREER HISTORY
---------------------------------------------------------------

CREATE TABLE hr_employee_career_hist
(
    career_hist_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id             NUMBER NOT NULL,
    action_id          NUMBER,
    action_type        VARCHAR2 (30),
    effective_date     DATE,
    old_emp_type_id    NUMBER,
    new_emp_type_id    NUMBER,
    old_job_id         NUMBER,
    new_job_id         NUMBER,
    old_desig_id       NUMBER,
    new_desig_id       NUMBER,
    old_dept_id        NUMBER,
    new_dept_id        NUMBER,
    remarks            VARCHAR2 (1000),
    ent_by             NUMBER,
    ent_date           DATE DEFAULT SYSDATE
);


---------------------------------------------------------------
-- 7. CURRENT SALARY VIEW
---------------------------------------------------------------

CREATE OR REPLACE VIEW vw_employee_salary
AS
      SELECT s.EMPLOYEE_ID,
             SUM (
                 CASE WHEN s.headcode = '001' THEN NVL (s.amount, 0) ELSE 0 END)
                 basic_salary,
             SUM (
                 CASE
                     WHEN ah.head_type = 'EARNING' THEN NVL (s.amount, 0)
                     ELSE 0
                 END)
                 gross_salary
        FROM emp_salary_structure s
             JOIN allowance_head ah ON ah.HEAD_ID = s.slno
       WHERE NVL (s.is_active, 'Y') = 'Y'
    GROUP BY s.EMPLOYEE_ID;


---------------------------------------------------------------
-- 8. UPDATE CONFIRMATION DUE DATE
---------------------------------------------------------------

UPDATE employees
   SET confirmation_due_date =
           ADD_MONTHS (join_date, NVL (probation_period_months, 12))
 WHERE STATUS = 1 AND EMP_TYPE = 1 AND confirmation_due_date IS NULL;

COMMIT;



---------------------------------------------------------------
-- 9. FUNCTION: GET NEXT BASIC FROM PAY SCALE 

SELECT fn_get_next_basic (9, 25300) FROM DUAL;

---------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_get_next_basic (
    p_job_id          IN NUMBER,
    p_current_basic   IN NUMBER,
    p_eb_status       IN VARCHAR2 DEFAULT 'NORMAL')
    RETURN NUMBER
IS
    v_next_basic   NUMBER;
BEGIN
    SELECT CASE
               WHEN p_current_basic < start_basic
               THEN
                   start_basic
               WHEN p_current_basic < eb_basic
               THEN
                   CASE
                       WHEN     p_current_basic + increment_1 >= eb_basic
                            AND NVL (p_eb_status, 'NORMAL') = 'EB_HOLD'
                       THEN
                           p_current_basic
                       ELSE
                           LEAST (p_current_basic + increment_1, eb_basic)
                   END
               WHEN     p_current_basic >= eb_basic
                    AND p_current_basic < max_basic
               THEN
                   CASE
                       WHEN NVL (p_eb_status, 'NORMAL') = 'EB_HOLD'
                       THEN
                           p_current_basic
                       ELSE
                           LEAST (p_current_basic + increment_2, max_basic)
                   END
               WHEN p_current_basic >= max_basic
               THEN
                   max_basic
               ELSE
                   p_current_basic
           END
      INTO v_next_basic
      FROM pay_scale_master
     WHERE GRADE_ID = p_job_id AND NVL (is_active, 'Y') = 'Y';

    RETURN NVL (v_next_basic, p_current_basic);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN p_current_basic;
END;
/


---------------------------------------------------------------
-- 10. FUNCTION: SALARY HEAD CALCULATION
---------------------------------------------------------------

SELECT fn_get_salary_head_amount (9, '057', 15700) FROM DUAL;




---------------------------------------------------------------
-- 11. PROCEDURE: CONFIRM EMPLOYEE
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_confirm_employee (
    p_emp_id         IN NUMBER,
    p_confirm_date   IN DATE,
    p_remarks        IN VARCHAR2,
    p_user_id        IN NUMBER)
IS
    v_action_id      NUMBER;
    v_old_basic      NUMBER;
    v_old_gross      NUMBER;
    v_old_emp_type   NUMBER;
    v_job_id         NUMBER;
    v_desig_id       NUMBER;
    v_dept_id        NUMBER;
BEGIN
    SELECT e.emp_type,
           e.job_id,
           e.desig_id,
           e.dept_id,
           NVL (v.basic_salary, 0),
           NVL (v.gross_salary, 0)
      INTO v_old_emp_type,
           v_job_id,
           v_desig_id,
           v_dept_id,
           v_old_basic,
           v_old_gross
      FROM employees e LEFT JOIN vw_employee_salary v ON v.emp_id = e.id
     WHERE e.id = p_emp_id;

    INSERT INTO hr_employee_action (emp_id,
                                    action_type,
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
                                    reason,
                                    remarks,
                                    approval_status,
                                    ent_by,
                                    approved_by,
                                    approved_date)
         VALUES (p_emp_id,
                 'CONFIRMATION',
                 SYSDATE,
                 p_confirm_date,
                 v_old_emp_type,
                 2,
                 v_job_id,
                 v_job_id,
                 v_desig_id,
                 v_desig_id,
                 v_dept_id,
                 v_dept_id,
                 v_old_basic,
                 v_old_basic,
                 v_old_gross,
                 v_old_gross,
                 'Employee confirmed from probation',
                 p_remarks,
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
         VALUES (p_emp_id,
                 v_action_id,
                 'CONFIRMATION',
                 p_confirm_date,
                 v_old_emp_type,
                 2,
                 v_job_id,
                 v_job_id,
                 v_desig_id,
                 v_desig_id,
                 v_dept_id,
                 v_dept_id,
                 p_remarks,
                 p_user_id);

    UPDATE employees
       SET emp_type = 2,
           conf_date = p_confirm_date,
           last_increment_date = p_confirm_date,
           next_increment_date =
               ADD_MONTHS (p_confirm_date, NVL (increment_cycle_months, 12))
     WHERE id = p_emp_id;

    COMMIT;
END;
/


---------------------------------------------------------------
-- 12. PROCEDURE: APPLY INCREMENT
---------------------------------------------------------------


CREATE OR REPLACE PROCEDURE pr_apply_increment (
    p_emp_id           IN NUMBER,
    p_effective_date   IN DATE,
    p_remarks          IN VARCHAR2,
    p_user_id          IN NUMBER)
IS
    v_action_id     NUMBER;

    v_job_id        NUMBER;
    v_desig_id      NUMBER;
    v_dept_id       NUMBER;
    v_emp_type_id   NUMBER;
    v_eb_status     VARCHAR2 (20);

    v_old_basic     NUMBER;
    v_new_basic     NUMBER;
    v_old_gross     NUMBER;
    v_new_gross     NUMBER;
BEGIN
    SELECT e.job_id,
           e.desig_id,
           e.dept_id,
           e.emp_type,
           NVL (e.eb_status, 'NORMAL'),
           NVL (v.basic_salary, 0),
           NVL (v.gross_salary, 0)
      INTO v_job_id,
           v_desig_id,
           v_dept_id,
           v_emp_type_id,
           v_eb_status,
           v_old_basic,
           v_old_gross
      FROM employees e LEFT JOIN vw_employee_salary v ON v.emp_id = e.id
     WHERE e.id = p_emp_id;

    IF NVL (v_emp_type_id, 0) <> 2
    THEN
        RAISE_APPLICATION_ERROR (
            -20001,
            'Only confirmed employees are eligible for increment.');
    END IF;

    IF NVL (v_eb_status, 'NORMAL') = 'EB_HOLD'
    THEN
        RAISE_APPLICATION_ERROR (
            -20002,
            'Employee increment is held due to EB hold.');
    END IF;

    SELECT COUNT (*)
      INTO v_new_gross
      FROM hr_increment_hold
     WHERE emp_id = p_emp_id AND hold_status = 'ACTIVE';

    IF v_new_gross > 0
    THEN
        RAISE_APPLICATION_ERROR (-20003,
                                 'Employee has active increment hold.');
    END IF;

    v_new_basic :=
        fn_get_next_basic (p_job_id          => v_job_id,
                           p_current_basic   => v_old_basic,
                           p_eb_status       => v_eb_status);

    IF NVL (v_new_basic, 0) <= NVL (v_old_basic, 0)
    THEN
        RAISE_APPLICATION_ERROR (
            -20004,
            'No increment available. Employee may have reached max basic or EB hold.');
    END IF;

    SELECT SUM (
               fn_get_salary_head_amount (v_job_id, s.headcode, v_new_basic))
      INTO v_new_gross
      FROM emp_salary_structure  s
           JOIN allowance_head ah ON ah.head_id = s.slno
     WHERE     s.employee_id = p_emp_id
           AND NVL (s.is_active, 'Y') = 'Y'
           AND ah.head_type = 'EARNING';

    INSERT INTO hr_employee_action (emp_id,
                                    action_type,
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
                                    old_eb_status,
                                    new_eb_status,
                                    reason,
                                    remarks,
                                    approval_status,
                                    ent_by,
                                    approved_by,
                                    approved_date)
         VALUES (p_emp_id,
                 'INCREMENT',
                 SYSDATE,
                 p_effective_date,
                 v_emp_type_id,
                 v_emp_type_id,
                 v_job_id,
                 v_job_id,
                 v_desig_id,
                 v_desig_id,
                 v_dept_id,
                 v_dept_id,
                 v_old_basic,
                 v_new_basic,
                 v_old_gross,
                 NVL (v_new_gross, 0),
                 v_new_basic - v_old_basic,
                 v_eb_status,
                 v_eb_status,
                 'Annual increment based on pay scale',
                 p_remarks,
                 'APPROVED',
                 p_user_id,
                 p_user_id,
                 SYSDATE)
      RETURNING action_id
           INTO v_action_id;

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
               s.EMPLOYEE_ID,
               s.sals_id,
               s.slno,
               s.headcode,
               s.amount
                   AS old_amount,
               fn_get_salary_head_amount (v_job_id, s.headcode, v_new_basic)
                   AS new_amount,
               'I',
               p_effective_date,
               p_remarks,
               p_user_id
          FROM emp_salary_structure s
         WHERE s.EMPLOYEE_ID = p_emp_id AND NVL (s.is_active, 'Y') = 'Y';

    UPDATE emp_salary_structure s
       SET s.amount =
               fn_get_salary_head_amount (v_job_id, s.headcode, v_new_basic),
           s.revision_type = 'I',
           s.UPDATED_BY = p_user_id,
           s.UPDATED_DATE = SYSDATE
     WHERE s.EMPLOYEE_ID = p_emp_id AND NVL (s.is_active, 'Y') = 'Y';

    UPDATE employees
       SET last_increment_date = p_effective_date,
           next_increment_date =
               ADD_MONTHS (p_effective_date,
                           NVL (increment_cycle_months, 12))
     WHERE id = p_emp_id;

    COMMIT;
END;
/

---------------------------------------------------------------
-- 13. PROCEDURE: HOLD INCREMENT
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_hold_increment (p_emp_id    IN NUMBER,
                                               p_reason    IN VARCHAR2,
                                               p_user_id   IN NUMBER)
IS
    v_action_id   NUMBER;
BEGIN
    INSERT INTO hr_employee_action (emp_id,
                                    action_type,
                                    action_date,
                                    effective_date,
                                    reason,
                                    remarks,
                                    approval_status,
                                    ent_by,
                                    approved_by,
                                    approved_date)
         VALUES (p_emp_id,
                 'INCREMENT_HOLD',
                 SYSDATE,
                 SYSDATE,
                 p_reason,
                 p_reason,
                 'APPROVED',
                 p_user_id,
                 p_user_id,
                 SYSDATE)
      RETURNING action_id
           INTO v_action_id;

    INSERT INTO hr_increment_hold (emp_id,
                                   hold_from_date,
                                   hold_reason,
                                   hold_status,
                                   action_id,
                                   ent_by)
         VALUES (p_emp_id,
                 SYSDATE,
                 p_reason,
                 'ACTIVE',
                 v_action_id,
                 p_user_id);

    UPDATE employees
       SET increment_hold_status = 'Y',
           increment_hold_reason = p_reason,
           increment_hold_date = SYSDATE
     WHERE id = p_emp_id;

    COMMIT;
END;
/

---------------------------------------------------------------
-- 14. PROCEDURE: RELEASE INCREMENT HOLD
---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_release_increment_hold (
    p_emp_id    IN NUMBER,
    p_remarks   IN VARCHAR2,
    p_user_id   IN NUMBER)
IS
    v_action_id   NUMBER;
BEGIN
    INSERT INTO hr_employee_action (emp_id,
                                    action_type,
                                    action_date,
                                    effective_date,
                                    reason,
                                    remarks,
                                    approval_status,
                                    ent_by,
                                    approved_by,
                                    approved_date)
         VALUES (p_emp_id,
                 'INCREMENT_RELEASE',
                 SYSDATE,
                 SYSDATE,
                 'Increment hold released',
                 p_remarks,
                 'APPROVED',
                 p_user_id,
                 p_user_id,
                 SYSDATE)
      RETURNING action_id
           INTO v_action_id;

    UPDATE hr_increment_hold
       SET hold_status = 'RELEASED',
           released_date = SYSDATE,
           released_by = p_user_id,
           release_remarks = p_remarks,
           upd_by = p_user_id,
           upd_date = SYSDATE
     WHERE emp_id = p_emp_id AND hold_status = 'ACTIVE';

    UPDATE employees
       SET increment_hold_status = 'N',
           increment_hold_reason = NULL,
           increment_hold_date = NULL
     WHERE id = p_emp_id;

    COMMIT;
END;
/


---------------------------------------------------------------
-- 15. CONFIRMATION DUE LIST QUERY
---------------------------------------------------------------

SELECT e.emp_id,
       e.F_NAME || ' ' || l_name
           emp_name,
       e.join_date,
       e.confirmation_due_date,
       NVL (e.confirmation_due_date,
            ADD_MONTHS (e.join_date, NVL (e.probation_period_months, 12)))
           confirmation_due_dat,
       e.conf_date,
       t.etype
           emp_type,
       e.job_id,
       e.desig_id,
       e.dept_id
  FROM employees e JOIN t_emp_typ t ON t.id = e.emp_type
 WHERE     e.emp_type = 1
       AND NVL (
               e.confirmation_due_date,
               ADD_MONTHS (e.join_date, NVL (e.probation_period_months, 12))) <=
           TRUNC (SYSDATE);


---------------------------------------------------------------
-- 16. INCREMENT DUE LIST QUERY
---------------------------------------------------------------

SELECT e.emp_id,
       e.F_NAME || ' ' || l_name
           emp_name,
       e.conf_date,
       e.last_increment_date,
       e.next_increment_date,
       e.job_id,
       v.basic_salary
           current_basic,
       fn_get_next_basic (e.job_id, v.basic_salary, e.eb_status)
           proposed_basic,
       v.gross_salary
           current_gross,
       e.eb_status,
       e.increment_hold_status
  FROM employees e LEFT JOIN vw_employee_salary v ON v.emp_id = e.id
 WHERE     e.emp_type = 2
       AND e.next_increment_date <= TRUNC (SYSDATE)
       AND NVL (e.increment_hold_status, 'N') = 'N'
       AND NOT EXISTS
               (SELECT 1
                  FROM hr_employee_action a
                 WHERE     a.emp_id = e.emp_id
                       AND a.action_type = 'INCREMENT'
                       AND a.effective_date = e.next_increment_date
                       AND a.approval_status IN ('SUBMITTED', 'APPROVED'));



---------------------------------------------------------------
-- 17. SALARY BEFORE/AFTER REPORT QUERY
---------------------------------------------------------------

  SELECT h.action_id,
         h.emp_id,
         e.F_NAME || ' ' || l_name       emp_name,
         h.headcode,
         ah.head_name,
         h.old_amount,
         h.new_amount,
         h.new_amount - h.old_amount     difference_amount,
         h.revision_type,
         h.effective_date
    FROM emp_salary_structure_hist h
         JOIN employees e ON e.id = h.emp_id
         JOIN allowance_head ah ON ah.head_code = h.headcode
   WHERE h.action_id = :P_ACTION_ID
ORDER BY h.slno;


---------------------------------------------------------------
-- 18. EMPLOYEE ACTION HISTORY REPORT
---------------------------------------------------------------

  SELECT a.action_id,
         a.emp_id,
         e.F_NAME || ' ' || l_name     emp_name,
         a.action_type,
         a.effective_date,
         old_type.etype                old_emp_type,
         new_type.etype                new_emp_type,
         a.old_job_id,
         a.new_job_id,
         a.old_desig_id,
         a.new_desig_id,
         a.old_basic,
         a.new_basic,
         a.old_gross,
         a.new_gross,
         a.increment_amount,
         a.old_eb_status,
         a.new_eb_status,
         a.approval_status,
         a.remarks,
         a.ent_date
    FROM hr_employee_action a
         JOIN employees e ON e.id = a.emp_id
         LEFT JOIN t_emp_typ old_type ON old_type.id = a.old_emp_type_id
         LEFT JOIN t_emp_typ new_type ON new_type.id = a.new_emp_type_id
ORDER BY a.effective_date DESC, a.action_id DESC;