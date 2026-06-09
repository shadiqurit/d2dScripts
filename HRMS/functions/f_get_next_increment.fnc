DROP FUNCTION HRMS.F_GET_NEXT_INCREMENT;

CREATE OR REPLACE FUNCTION HRMS.f_get_next_increment (p_grade_code      IN VARCHAR2,
                                               p_current_basic   IN NUMBER)
    RETURN VARCHAR2
AS
    v_result   VARCHAR2 (500);
BEGIN
      SELECT    'NEXT_BASIC='
             || d.basic_amount
             || '|INCREMENT='
             || d.increment_amount
             || '|STEP='
             || d.step_no
             || '|EB_CROSSING='
             || d.is_eb_step
        INTO v_result
        FROM pay_scale_detail d
             JOIN pay_scale_master s ON s.scale_id = d.scale_id
             JOIN JOB_GRADES g ON g.ID = s.grade_id
       WHERE     g.grade_code = p_grade_code
             AND s.is_active = 'Y'
             AND d.basic_amount > p_current_basic
             AND ROWNUM = 1
    ORDER BY d.step_no;

    RETURN v_result;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 'MAX_REACHED';
END;
/
