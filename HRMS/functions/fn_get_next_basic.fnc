DROP FUNCTION HRMS.FN_GET_NEXT_BASIC;

CREATE OR REPLACE FUNCTION HRMS.fn_get_next_basic (
    p_job_id         IN NUMBER,
    p_current_basic  IN NUMBER,
    p_eb_status      IN VARCHAR2 DEFAULT 'NORMAL'
) RETURN NUMBER
IS
    v_next_basic NUMBER;
BEGIN
    SELECT CASE
             WHEN p_current_basic < start_basic THEN
                  start_basic

             WHEN p_current_basic < eb_basic THEN
                  CASE
                    WHEN p_current_basic + increment_1 >= eb_basic
                         AND NVL(p_eb_status,'NORMAL') = 'EB_HOLD'
                    THEN p_current_basic
                    ELSE LEAST(p_current_basic + increment_1, eb_basic)
                  END

             WHEN p_current_basic >= eb_basic
                  AND p_current_basic < max_basic THEN
                  CASE
                    WHEN NVL(p_eb_status,'NORMAL') = 'EB_HOLD'
                    THEN p_current_basic
                    ELSE LEAST(p_current_basic + increment_2, max_basic)
                  END

             WHEN p_current_basic >= max_basic THEN
                  max_basic

             ELSE p_current_basic
           END
    INTO v_next_basic
    FROM pay_scale_master
    WHERE GRADE_ID = p_job_id
    AND NVL(is_active,'Y') = 'Y';

    RETURN NVL(v_next_basic, p_current_basic);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN p_current_basic;
END;
/
