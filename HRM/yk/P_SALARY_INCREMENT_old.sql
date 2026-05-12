/* Formatted on 4/30/2026 9:36:56 AM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE PROCEDURE p_salary_increment (
   p_emp_id             IN     pr_employee_list.emp_id%TYPE,
   p_new_agross         IN     NUMBER,
   p_new_gross_salary   IN     NUMBER,
   p_status_badge          OUT VARCHAR2)
AS
   v_old_bgross           NUMBER;
   v_old_bbasic           NUMBER;
   v_old_bhr              NUMBER;
   v_final_bgross         NUMBER;
   v_final_bbasic         NUMBER;
   v_final_bhr            NUMBER;
   v_emp_name             VARCHAR2 (200);

   -- CSS Constants for clean reporting
   c_style_err   CONSTANT VARCHAR2 (200)
      := 'color: #c23d4b; background-color: #fce8e6; padding: 10px; border: 1px solid #c23d4b; border-radius: 3px; display: block;' ;
   c_style_suc   CONSTANT VARCHAR2 (200)
      := 'color: #297a3a; background-color: #eaf7ed; padding: 10px; border: 1px solid #297a3a; border-radius: 3px; display: block;' ;
BEGIN
   -- 1. Validation
   IF p_emp_id IS NULL OR p_new_agross IS NULL
   THEN
      p_status_badge :=
            '<span style="'
         || c_style_err
         || '"><span class="fa fa-exclamation-triangle"></span> Employee and New Actual Gross are required!</span>';
      RETURN;
   END IF;

   -- 2. Fetch Employee Name
   SELECT RTRIM (emp_f_name)
     INTO v_emp_name
     FROM pr_employee_list
    WHERE emp_id = p_emp_id;

   -- 3. Fetch Current Salary Details
   BEGIN
        SELECT bgross, bbasic, bhr
          INTO v_old_bgross, v_old_bbasic, v_old_bhr
          FROM emp_salary_master
         WHERE emp_id = p_emp_id AND active_flag = 'Y'
      ORDER BY emp_salary_id DESC        fetch FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            v_old_bgross := 0;
            v_old_bbasic := 0;
            v_old_bhr := 0;
    END;

    -- 4. Calculate Final Values
    IF p_new_gross_salary IS NOT NULL
    THEN
        v_final_bgross := p_new_gross_salary;
        v_final_bbasic := ROUND ((p_new_gross_salary - 2450) / 1.5);
        v_final_bhr := ROUND ((p_new_gross_salary - 2450) / 3);
    ELSE
        v_final_bgross := v_old_bgross;
        v_final_bbasic := v_old_bbasic;
        v_final_bhr := v_old_bhr;
    END IF;

    -- 5. Data Operations
    -- Inactivate old records
    UPDATE emp_salary_master
       SET active_flag = 'N', upd_date = SYSDATE
     WHERE emp_id = p_emp_id AND active_flag = 'Y';

    -- Update Master List
    UPDATE pr_employee_list
       SET agross = p_new_agross,
           abasic = ROUND ((p_new_agross - 2450) / 1.5),
           ahr = ROUND ((p_new_agross - 2450) / 3)

     WHERE emp_id = p_emp_id;

    -- Insert History
    INSERT INTO emp_salary_master (emp_salary_id,
                                   emp_id,
                                   agross,
                                   abasic,
                                   ahr,
                                   bgross,
                                   bbasic,
                                   bhr,
                                   active_flag,
                                   effective_date,
                                   ent_date)
             VALUES (
                        (SELECT NVL (MAX (emp_salary_id), 0) + 1
                           FROM emp_salary_master),
                        p_emp_id,
                        p_new_agross,
                        ROUND ((p_new_agross - 2450) / 1.5),
                        ROUND ((p_new_agross - 2450) / 3),
                        v_final_bgross,
                        v_final_bbasic,
                        v_final_bhr,
                        'Y',
                        SYSDATE,
                        SYSDATE);

    p_status_badge :=
           '<span style="'
        || c_style_suc
        || '"><span class="fa fa-check-circle"></span> Salary Increment for ('
        || v_emp_name
        || ') processed successfully!</span>';
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        p_status_badge :=
               '<span style="'
            || c_style_err
            || '"><span class="fa fa-exclamation-triangle"></span> Employee ID not found.</span>';
    WHEN OTHERS
    THEN
        p_status_badge :=
               '<span style="'
            || c_style_err
            || '"><span class="fa fa-exclamation-triangle"></span> Error: '
            || SQLERRM
            || '</span>';
END p_salary_increment;
/