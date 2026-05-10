CREATE OR REPLACE PROCEDURE HRMS.generate_monthly_salary (
    p_salary_month  IN NUMBER,
    p_employee_id   IN NUMBER DEFAULT NULL,
    p_created_by    IN NUMBER DEFAULT NULL
)
IS
    v_ms_id       NUMBER;
    v_total_earn  NUMBER := 0;
    v_total_ded   NUMBER := 0;
    v_exists      NUMBER;
BEGIN
    FOR emp IN (
        SELECT DISTINCT employee_id
          FROM emp_salary_structure
         WHERE employee_id = NVL(p_employee_id, employee_id)
    ) LOOP

        SELECT COUNT(1) INTO v_exists
          FROM monthly_salary
         WHERE employee_id = emp.employee_id
           AND salary_month = p_salary_month;

        IF v_exists > 0 THEN
            CONTINUE;
        END IF;

        -- Insert master
        INSERT INTO monthly_salary (employee_id, salary_month, created_by, created_date)
        VALUES (emp.employee_id, p_salary_month, p_created_by, SYSDATE)
        RETURNING ms_id INTO v_ms_id;

        -- Insert from salary structure
        INSERT INTO monthly_salary_details
            (ms_id, employee_id, salary_month, slno, headcode, head_name, head_type, amount, source, created_by, created_date)
        SELECT v_ms_id,
               sl.employee_id,
               p_salary_month,
               sl.slno,
               sl.headcode,
               ah.head_name,
               ah.head_type,
               sl.amount,
               'STRUCTURE',
               p_created_by,
               SYSDATE
          FROM emp_salary_structure sl
          JOIN allowance_head ah ON sl.slno = ah.head_id
         WHERE sl.employee_id = emp.employee_id;

        -- Insert from adjustments
        INSERT INTO monthly_salary_details
            (ms_id, employee_id, salary_month, slno, headcode, head_name, head_type, amount, source, remarks, created_by, created_date)
        SELECT v_ms_id,
               adj.employee_id,
               p_salary_month,
               NULL,
               adj.headcode,
               adj.head_name,
               adj.head_type,
               adj.amount,
               'ADDITIONAL',
               adj.remarks,
               p_created_by,
               SYSDATE
          FROM monthly_salary_adjustment adj
         WHERE adj.employee_id = emp.employee_id
           AND adj.salary_month = p_salary_month;

        -- Calculate totals
        SELECT NVL(SUM(CASE WHEN head_type = 'EARNING' THEN amount ELSE 0 END), 0),
               NVL(SUM(CASE WHEN head_type = 'DEDUCTION' THEN amount ELSE 0 END), 0)
          INTO v_total_earn, v_total_ded
          FROM monthly_salary_details
         WHERE ms_id = v_ms_id;

        -- Update master
        UPDATE monthly_salary
           SET total_earning   = v_total_earn,
               total_deduction = v_total_ded,
               net_salary      = v_total_earn - v_total_ded
         WHERE ms_id = v_ms_id;

    END LOOP;

    COMMIT;
END;
/
