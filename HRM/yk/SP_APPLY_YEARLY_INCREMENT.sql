/* Formatted on 5/12/2026 2:49:37 PM (QP5 v5.362) */
CREATE OR REPLACE PROCEDURE HRM.sp_apply_yearly_increment (
    p_from_date   DATE,
    p_to_date     DATE)
AS
    v_count   NUMBER := 0;
BEGIN
    FOR rec
        IN (SELECT main_data.emp_id,
                   main_data.basic_salary
                       AS old_basic,
                   main_data.gross_salary
                       AS old_gross,
                   ROUND (main_data.basic_salary * 1.09)
                       AS new_basic,
                   ROUND ((main_data.basic_salary * 1.09 * 1.5) + 2450)
                       AS new_gross,
                   main_data.increment_month
              FROM (SELECT e.emp_id,
                           e.basic_salary,
                           e.gross_salary,
                           ADD_MONTHS (
                               TRUNC (
                                   ADD_MONTHS (
                                       ADD_MONTHS (e.emp_joining_date, 12),
                                       CASE
                                           WHEN EXTRACT (
                                                    DAY FROM ADD_MONTHS (
                                                                 e.emp_joining_date,
                                                                 12)) >=
                                                26
                                           THEN
                                               1
                                           ELSE
                                               0
                                       END),
                                   'MM'),
                               (years.lvl - 1) * 12)    AS increment_month
                      FROM pr_employee_list  e
                           CROSS JOIN (    SELECT LEVEL     AS lvl
                                             FROM DUAL
                                       CONNECT BY LEVEL <= 10) years
                     WHERE     e.emp_status = 'A'
                           AND e.emp_joining_date > DATE '2023-12-31')
                   main_data
                   LEFT JOIN pr_increment_history h
                       ON     h.emp_id = main_data.emp_id
                          AND TO_CHAR (h.increment_date, 'YYYY') =
                              TO_CHAR (main_data.increment_month, 'YYYY')
             WHERE     main_data.increment_month BETWEEN p_from_date
                                                     AND p_to_date
                   AND h.emp_id IS NULL   -- No history for that calendar year
                                       )
    LOOP
        -- 1. Update Current Salary in Main Table
        UPDATE pr_employee_list
           SET basic_salary = rec.new_basic, gross_salary = rec.new_gross
         WHERE emp_id = rec.emp_id;

        -- 2. Sync Salary Components Table
        MERGE INTO pr_salary_components target
             USING (SELECT rec.emp_id        AS eid,
                           rec.new_basic     AS nb,
                           rec.new_gross     AS ng
                      FROM DUAL) src
                ON (target.emp_id = src.eid)
        WHEN MATCHED
        THEN
            UPDATE SET
                target.basic_salary = src.nb,
                target.house_rent = ROUND (src.nb * 0.50),
                target.medical_allow =
                    src.ng - (src.nb + ROUND (src.nb * 0.50)),
                target.last_updated = SYSDATE
        WHEN NOT MATCHED
        THEN
            INSERT     (emp_id,
                        basic_salary,
                        house_rent,
                        medical_allow,
                        last_updated)
                VALUES (src.eid,
                        src.nb,
                        ROUND (src.nb * 0.50),
                        src.ng - (src.nb + ROUND (src.nb * 0.50)),
                        SYSDATE);

        -- 3. Log History (prevents duplicate for this year)
        INSERT INTO pr_increment_history (emp_id,
                                          old_gross,
                                          new_gross,
                                          old_basic,
                                          new_basic,
                                          increment_date,
                                          remarks)
             VALUES (rec.emp_id,
                     rec.old_gross,
                     rec.new_gross,
                     rec.old_basic,
                     rec.new_basic,
                     rec.increment_month,
                     'Yearly Increment Processed');

        v_count := v_count + 1;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE (
        'Total Employees Updated for this Year: ' || v_count);
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE ('Error: ' || SQLERRM);
        RAISE;
END;
/