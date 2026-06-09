DROP PROCEDURE HRMS.POPULATE_SCALE_DETAIL;

CREATE OR REPLACE PROCEDURE HRMS.populate_scale_detail (
    p_scale_id IN NUMBER
) AS
    v_basic   NUMBER(10,2);
    v_rec     pay_scale_master%ROWTYPE;
BEGIN
    SELECT * INTO v_rec FROM pay_scale_master WHERE scale_id = p_scale_id;

    -- Remove old detail rows for this scale
    DELETE FROM pay_scale_detail WHERE scale_id = p_scale_id;

    v_basic := v_rec.start_basic;

    -- Step 0: Starting basic
    INSERT INTO pay_scale_detail (scale_id, step_no, basic_amount, increment_amount, is_eb_step, phase)
    VALUES (p_scale_id, 0, v_basic, NULL, 'N', 'INITIAL');

    -- Steps 1 to N: Pre-EB increments
    FOR i IN 1..v_rec.steps_before_eb LOOP
        v_basic := v_basic + v_rec.increment_1;
        INSERT INTO pay_scale_detail (scale_id, step_no, basic_amount, increment_amount, is_eb_step, phase)
        VALUES (p_scale_id, i, v_basic, v_rec.increment_1,
                CASE WHEN i = v_rec.steps_before_eb THEN 'Y' ELSE 'N' END,
                'PRE_EB');
    END LOOP;

    -- Steps N+1 to N+M: Post-EB increments
    FOR i IN 1..v_rec.steps_after_eb LOOP
        v_basic := v_basic + v_rec.increment_2;
        INSERT INTO pay_scale_detail (scale_id, step_no, basic_amount, increment_amount, is_eb_step, phase)
        VALUES (p_scale_id, v_rec.steps_before_eb + i, v_basic, v_rec.increment_2, 'N', 'POST_EB');
    END LOOP;

    COMMIT;
END;
/
