DROP PROCEDURE HRMS.PR_APPLY_INCREMENT;

CREATE OR REPLACE PROCEDURE HRMS.pr_apply_increment (
    p_emp_id           IN NUMBER,
    p_effective_date   IN DATE,
    p_remarks          IN VARCHAR2,
    p_user_id          IN NUMBER
)
IS
    v_action_id       NUMBER;
    v_job_id          NUMBER;
    v_grade_id        NUMBER;
    v_desig_id        NUMBER;
    v_dept_id         NUMBER;
    v_emp_type_id     NUMBER;
    v_eb_status       VARCHAR2(20);
    v_old_basic       NUMBER;
    v_new_basic       NUMBER;
    v_old_gross       NUMBER;
    v_new_gross       NUMBER;
    v_hold_count      NUMBER;
BEGIN
    SELECT e.job_id,
           e.job_id AS grade_id,
           e.desig_id,
           e.dept_id,
           e.emp_type,
           NVL(e.eb_status, 'NORMAL'),
           NVL(v.basic_salary, 0),
           NVL(v.gross_salary, 0)
      INTO v_job_id,
           v_grade_id,
           v_desig_id,
           v_dept_id,
           v_emp_type_id,
           v_eb_status,
           v_old_basic,
           v_old_gross
      FROM employees e
           LEFT JOIN vw_employee_salary v 
                  ON v.emp_id = e.id
     WHERE e.id = p_emp_id;

    IF NVL(v_emp_type_id, 0) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Only confirmed employees are eligible for increment.');
    END IF;

    IF NVL(v_eb_status, 'NORMAL') = 'EB_HOLD' THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Employee increment is held due to EB hold.');
    END IF;

    SELECT COUNT(*)
      INTO v_hold_count
      FROM hr_increment_hold
     WHERE emp_id = p_emp_id
       AND hold_status = 'ACTIVE';

    IF v_hold_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Employee has active increment hold.');
    END IF;

    v_new_basic :=
        HRMS.fn_get_next_basic(
            p_job_id        => v_grade_id,
            p_current_basic => v_old_basic,
            p_eb_status     => v_eb_status
        );

    IF NVL(v_new_basic, 0) <= NVL(v_old_basic, 0) THEN
        RAISE_APPLICATION_ERROR(-20004,
            'No increment available. Employee may have reached max basic or EB hold.');
    END IF;

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
        0,
        v_new_basic - v_old_basic,
        v_eb_status,
        v_eb_status,
        'Annual increment based on pay scale',
        p_remarks,
        'APPROVED',
        p_user_id,
        p_user_id,
        SYSDATE
    )
    RETURNING action_id INTO v_action_id;

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
    WITH base_heads AS (
        SELECT MAX(ah.head_id) AS slno,
               ah.head_code,
               NVL(
                   HRMS.fn_get_salary_head_amount(
                       p_grade_id       => v_grade_id,
                       p_headcode       => ah.head_code,
                       p_basic          => v_new_basic,
                       p_effective_date => p_effective_date
                   ), 0
               ) AS new_amount
          FROM allowance_head ah
         WHERE ah.head_code IN (
               '001',
               '005',
               '007',
               '010',
               '013',
               '037',
               '057',
               '075'
         )
         GROUP BY ah.head_code
    ),
    calc_025 AS (
        SELECT MAX(ah.head_id) AS slno,
               ah.head_code,
               NVL(
                   HRMS.fn_get_salary_head_amount(
                       p_grade_id       => v_grade_id,
                       p_headcode       => ah.head_code,
                       p_basic          => v_new_basic,
                       p_effective_date => p_effective_date
                   ), 0
               ) AS new_amount
          FROM allowance_head ah
         WHERE ah.head_code = '025'
         GROUP BY ah.head_code
    ),
    calc_026 AS (
        SELECT MAX(ah.head_id) AS slno,
               '026' AS head_code,
               NVL(MAX(c25.new_amount), 0)
               -
               NVL(SUM(
                   CASE
                       WHEN bh.head_code IN ('005','007','010','013','037')
                       THEN bh.new_amount
                       ELSE 0
                   END
               ), 0) AS new_amount
          FROM allowance_head ah
               CROSS JOIN base_heads bh
               CROSS JOIN calc_025 c25
         WHERE ah.head_code = '026'
         GROUP BY ah.head_code
    ),
    final_heads AS (
        SELECT * FROM base_heads
        UNION ALL
        SELECT * FROM calc_025
        UNION ALL
        SELECT * FROM calc_026
    )
    SELECT v_action_id,
           p_emp_id,
           s.sals_id,
           fh.slno,
           fh.head_code,
           NVL(s.amount, 0) AS old_amount,
           fh.new_amount,
           'I',
           p_effective_date,
           p_remarks,
           p_user_id
      FROM final_heads fh
           LEFT JOIN emp_salary_structure s
                  ON s.employee_id = p_emp_id
                 AND s.headcode = fh.head_code
                 AND NVL(s.is_active, 'Y') = 'Y';

    MERGE INTO emp_salary_structure s
    USING (
        WITH base_heads AS (
            SELECT MAX(ah.head_id) AS slno,
                   ah.head_code,
                   NVL(
                       HRMS.fn_get_salary_head_amount(
                           p_grade_id       => v_grade_id,
                           p_headcode       => ah.head_code,
                           p_basic          => v_new_basic,
                           p_effective_date => p_effective_date
                       ), 0
                   ) AS new_amount
              FROM allowance_head ah
             WHERE ah.head_code IN (
                   '001',
                   '005',
                   '007',
                   '010',
                   '013',
                   '037',
                   '057',
                   '075'
             )
             GROUP BY ah.head_code
        ),
        calc_025 AS (
            SELECT MAX(ah.head_id) AS slno,
                   ah.head_code,
                   NVL(
                       HRMS.fn_get_salary_head_amount(
                           p_grade_id       => v_grade_id,
                           p_headcode       => ah.head_code,
                           p_basic          => v_new_basic,
                           p_effective_date => p_effective_date
                       ), 0
                   ) AS new_amount
              FROM allowance_head ah
             WHERE ah.head_code = '025'
             GROUP BY ah.head_code
        ),
        calc_026 AS (
            SELECT MAX(ah.head_id) AS slno,
                   '026' AS head_code,
                   NVL(MAX(c25.new_amount), 0)
                   -
                   NVL(SUM(
                       CASE
                           WHEN bh.head_code IN ('005','007','010','013','037')
                           THEN bh.new_amount
                           ELSE 0
                       END
                   ), 0) AS new_amount
              FROM allowance_head ah
                   CROSS JOIN base_heads bh
                   CROSS JOIN calc_025 c25
             WHERE ah.head_code = '026'
             GROUP BY ah.head_code
        )
        SELECT * FROM base_heads
        UNION ALL
        SELECT * FROM calc_025
        UNION ALL
        SELECT * FROM calc_026
    ) x
    ON (
        s.employee_id = p_emp_id
        AND s.headcode = x.head_code
    )
    WHEN MATCHED THEN
        UPDATE SET s.slno          = x.slno,
                   s.amount        = x.new_amount,
                   s.revision_type = 'I',
                   s.updated_by    = p_user_id,
                   s.updated_date  = SYSDATE,
                   s.is_active     = 'Y'
    WHEN NOT MATCHED THEN
        INSERT (
            employee_id,
            slno,
            headcode,
            amount,
            is_active,
            revision_type,
            created_by,
            created_date
        )
        VALUES (
            p_emp_id,
            x.slno,
            x.head_code,
            x.new_amount,
            'Y',
            'I',
            p_user_id,
            SYSDATE
        );

    SELECT NVL(SUM(s.amount), 0)
      INTO v_new_gross
      FROM emp_salary_structure s
           JOIN allowance_head ah 
             ON ah.head_id = s.slno
     WHERE s.employee_id = p_emp_id
       AND NVL(s.is_active, 'Y') = 'Y'
       AND ah.head_type = 'EARNING'
       AND s.headcode NOT IN ('025','026');

    UPDATE hr_employee_action
       SET new_gross = v_new_gross
     WHERE action_id = v_action_id;

    UPDATE employees
       SET last_increment_date = p_effective_date,
           next_increment_date =
               ADD_MONTHS(p_effective_date, NVL(increment_cycle_months, 12))
     WHERE id = p_emp_id;

    COMMIT;
END;
/
