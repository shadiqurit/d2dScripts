CREATE OR REPLACE PROCEDURE p_revert_salary_incr (
    p_emp_id    IN     NUMBER,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2)
AS
    v_current_salary_id   NUMBER;
    v_prev_rec            EMP_SALARY_MASTER%ROWTYPE;
    v_emp_name            VARCHAR2 (200);
BEGIN
    -- 1. Validation
    IF p_emp_id IS NULL
    THEN
        p_status := 'E';
        p_message :=
            'Employee selection is required to revert the increment.';
        RETURN;
    END IF;

    -- 2. Fetch Employee Name
    SELECT RTRIM (emp_f_name)
      INTO v_emp_name
      FROM pr_employee_list
     WHERE emp_id = p_emp_id;

    -- 3. Identify Current Active Record
    SELECT EMP_SALARY_ID
      INTO v_current_salary_id
      FROM EMP_SALARY_MASTER
     WHERE EMP_ID = p_emp_id AND ACTIVE_FLAG = 'Y';

    -- 4. Fetch and Restore Previous Record
    BEGIN
          SELECT *
            INTO v_prev_rec
            FROM EMP_SALARY_MASTER
           WHERE EMP_ID = p_emp_id AND ACTIVE_FLAG = 'N'
        ORDER BY EMP_SALARY_ID DESC
           FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_status := 'E';
            p_message := 'No previous salary history found. Cannot revert.';
            RETURN;
    END;

    -- 5. Perform Updates
    UPDATE pr_employee_list
       SET agross = v_prev_rec.agross,
           abasic = v_prev_rec.abasic,
           ahr = v_prev_rec.ahr
     WHERE emp_id = p_emp_id;

    DELETE FROM EMP_SALARY_MASTER
          WHERE EMP_SALARY_ID = v_current_salary_id;

    UPDATE EMP_SALARY_MASTER
       SET ACTIVE_FLAG = 'Y', UPD_DATE = SYSDATE
     WHERE EMP_SALARY_ID = v_prev_rec.emp_salary_id;

    p_status := 'S';
    p_message :=
        'Salary Increment Reverted for (' || v_emp_name || ') successfully!';
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        p_status := 'E';
        p_message := 'Employee record not found.';
    WHEN OTHERS
    THEN
        p_status := 'E';
        p_message := 'Database Error: ' || SQLERRM;
END;
/
