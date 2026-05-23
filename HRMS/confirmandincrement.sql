CREATE OR REPLACE PROCEDURE HRMS.pr_confirm_employee (
    p_emp_id         IN NUMBER,
    p_confirm_date   IN DATE,
    p_remarks        IN VARCHAR2,
    p_user_id        IN NUMBER)
IS
    v_action_id      NUMBER;

    v_old_basic      NUMBER;
    v_new_basic      NUMBER;
    v_old_gross      NUMBER;
    v_new_gross      NUMBER;

    v_old_emp_type   NUMBER;
    v_job_id         NUMBER;
    v_grade_id       NUMBER;
    v_desig_id       NUMBER;
    v_dept_id        NUMBER;
    v_eb_status      VARCHAR2(20);
BEGIN
    SELECT e.emp_type,
           e.job_id,
           e.job_id grade_id,
           e.desig_id,
           e.dept_id,
           NVL(e.eb_status, 'NORMAL'),
           NVL(v.basic_salary, 0),
           NVL(v.gross_salary, 0)
      INTO v_old_emp_type,
           v_job_id,
           v_grade_id,
           v_desig_id,
           v_dept_id,
           v_eb_status,
           v_old_basic,
           v_old_gross
      FROM employees e
           LEFT JOIN vw_employee_salary v ON v.emp_id = e.id
     WHERE e.id = p_emp_id;

    IF NVL(v_old_emp_type, 0) = 2 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee is already confirmed.');
    END IF;

    v_new_basic :=
        HRMS.fn_get_next_basic (
            p_job_id      => v_grade_id,
            p_current_basic => v_old_basic,
            p_eb_status     => v_eb_status
        );

    IF NVL(v_new_basic, 0) <= NVL(v_old_basic, 0) THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Confirmation increment not available. Check pay scale or max basic.'
        );
    END IF;

    SELECT SUM(
               CASE
                   WHEN s.headcode IN ('001','005','013','057','007','010','037','075')
                   THEN NVL(
                            HRMS.fn_get_salary_head_amount(
                                p_grade_id       => v_grade_id,
                                p_headcode       => s.headcode,
                                p_basic          => v_new_basic,
                                p_effective_date => p_confirm_date
                            ),
                            s.amount
                        )
                   ELSE s.amount
               END
           )
      INTO v_new_gross
      FROM emp_salary_structure s
           JOIN allowance_head ah ON ah.head_id = s.slno
     WHERE s.employee_id = p_emp_id
       AND NVL(s.is_active, 'Y') = 'Y'
       AND ah.head_type = 'EARNING';

    INSERT INTO hr_employee_action (
        emp_id,
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
        approved_date
    )
    VALUES (
        p_emp_id,
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
        v_new_basic,
        v_old_gross,
        NVL(v_new_gross, 0),
        v_new_basic - v_old_basic,
        v_eb_status,
        v_eb_status,
        'Employee confirmed with one increment',
        p_remarks,
        'APPROVED',
        p_user_id,
        p_user_id,
        SYSDATE
    )
    RETURNING action_id INTO v_action_id;

    INSERT INTO hr_employee_career_hist (
        emp_id,
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
        ent_by
    )
    VALUES (
        p_emp_id,
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
        p_user_id
    );

    INSERT INTO emp_salary_structure_hist (
        action_id,
        emp_id,
        sals_id,
        slno,
        headcode,
        old_amount,
        new_amount,
        revision_type,
        effective_date,
        remarks,
        ent_by
    )
    SELECT v_action_id,
           s.employee_id,
           s.sals_id,
           s.slno,
           s.headcode,
           s.amount AS old_amount,
           CASE
               WHEN s.headcode IN ('001','005','013','057','007','010','037','075')
               THEN NVL(
                        HRMS.fn_get_salary_head_amount(
                            p_grade_id       => v_grade_id,
                            p_headcode       => s.headcode,
                            p_basic          => v_new_basic,
                            p_effective_date => p_confirm_date
                        ),
                        s.amount
                    )
               ELSE s.amount
           END AS new_amount,
           'C',
           p_confirm_date,
           p_remarks,
           p_user_id
      FROM emp_salary_structure s
     WHERE s.employee_id = p_emp_id
       AND NVL(s.is_active, 'Y') = 'Y';

    UPDATE emp_salary_structure s
       SET s.amount =
               CASE
                   WHEN s.headcode IN ('001','005','013','057','007','010','037','075')
                   THEN NVL(
                            HRMS.fn_get_salary_head_amount(
                                p_grade_id       => v_grade_id,
                                p_headcode       => s.headcode,
                                p_basic          => v_new_basic,
                                p_effective_date => p_confirm_date
                            ),
                            s.amount
                        )
                   ELSE s.amount
               END,
           s.revision_type = 'C',
           s.updated_by = p_user_id,
           s.updated_date = SYSDATE
     WHERE s.employee_id = p_emp_id
       AND NVL(s.is_active, 'Y') = 'Y';

    UPDATE employees
       SET emp_type = 2,
           conf_date = p_confirm_date,
           last_increment_date = p_confirm_date,
           next_increment_date =
               ADD_MONTHS(p_confirm_date, NVL(increment_cycle_months, 12))
     WHERE id = p_emp_id;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
