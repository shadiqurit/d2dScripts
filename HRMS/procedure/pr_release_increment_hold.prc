DROP PROCEDURE HRMS.PR_RELEASE_INCREMENT_HOLD;

CREATE OR REPLACE PROCEDURE HRMS.pr_release_increment_hold (
    p_emp_id      IN NUMBER,
    p_remarks     IN VARCHAR2,
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
        'INCREMENT_RELEASE',
        SYSDATE,
        SYSDATE,
        'Increment hold released',
        p_remarks,
        'APPROVED',
        p_user_id,
        p_user_id,
        SYSDATE
    )
    RETURNING action_id INTO v_action_id;

    UPDATE hr_increment_hold
    SET hold_status     = 'RELEASED',
        released_date   = SYSDATE,
        released_by     = p_user_id,
        release_remarks = p_remarks,
        upd_by          = p_user_id,
        upd_date        = SYSDATE
    WHERE emp_id = p_emp_id
    AND hold_status = 'ACTIVE';

    UPDATE employees
    SET increment_hold_status = 'N',
        increment_hold_reason = NULL,
        increment_hold_date   = NULL
    WHERE id = p_emp_id;

    COMMIT;
END;
/
