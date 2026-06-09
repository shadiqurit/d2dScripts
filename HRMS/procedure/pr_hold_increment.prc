DROP PROCEDURE HRMS.PR_HOLD_INCREMENT;

CREATE OR REPLACE PROCEDURE HRMS.pr_hold_increment (
    p_emp_id      IN NUMBER,
    p_reason      IN VARCHAR2,
    p_user_id     IN NUMBER
)
IS
    v_action_id NUMBER;
BEGIN
    INSERT INTO hr_employee_action (
        emp_id,
        action_type,
        action_date,
        effective_date,
        reason,
        remarks,
        approval_status,
        ent_by,
        approved_by,
        approved_date
    )
    VALUES (
        p_emp_id,
        'INCREMENT_HOLD',
        SYSDATE,
        SYSDATE,
        p_reason,
        p_reason,
        'APPROVED',
        p_user_id,
        p_user_id,
        SYSDATE
    )
    RETURNING action_id INTO v_action_id;

    INSERT INTO hr_increment_hold (
        emp_id,
        hold_from_date,
        hold_reason,
        hold_status,
        action_id,
        ent_by
    )
    VALUES (
        p_emp_id,
        SYSDATE,
        p_reason,
        'ACTIVE',
        v_action_id,
        p_user_id
    );

    UPDATE employees
    SET increment_hold_status = 'Y',
        increment_hold_reason = p_reason,
        increment_hold_date   = SYSDATE
    WHERE id = p_emp_id;

    COMMIT;
END;
/
