CREATE OR REPLACE PROCEDURE IPIHR.holiday_process_att (p_fdate     DATE,
                                                       p_tdate     DATE,
                                                       p_empcode   VARCHAR2)
IS
    -- hr_emp_shift
    CURSOR c1 IS
        SELECT DISTINCT yearmn, empcode
          FROM hr_emp_shift_wh_v
         WHERE     attdate BETWEEN p_fdate AND p_tdate
               AND shift IS NOT NULL
               AND LOWER (shift) IN ('w', 'h', 'g')
               AND empcode = NVL (p_empcode, empcode);

    CURSOR c2 IS
        SELECT empcode,
               yearmn,
               attdate,
               shift
          FROM hr_emp_shift_wh_v
         WHERE     attdate BETWEEN p_fdate AND p_tdate
               AND shift IS NOT NULL
               AND LOWER (shift) IN ('w', 'h', 'g')
               AND empcode = NVL (p_empcode, empcode);
BEGIN
    FOR a IN c1
    LOOP
        UPDATE att_emp_t01
           SET is_holiday = NULL, is_govt_holiday = NULL
         --  is_shift = NULL
         WHERE     empcode = a.empcode
               AND TO_CHAR (attdate, 'rrrrmm') = a.yearmn
               AND empcode = NVL (p_empcode, empcode);
    END LOOP;

    FOR a IN c2
    LOOP
        IF LOWER (a.shift) = 'w'
        THEN
            UPDATE att_emp_t01
               SET is_holiday = 1, is_shift = 1
             WHERE     attdate BETWEEN p_fdate AND p_tdate
                   AND empcode = a.empcode
                   AND attdate = a.attdate
                   AND empcode = NVL (p_empcode, empcode);
        END IF;

        IF LOWER (a.shift) = 'h'
        THEN
            UPDATE att_emp_t01
               SET is_govt_holiday = 1, is_shift = 1
             WHERE     attdate BETWEEN p_fdate AND p_tdate
                   AND empcode = a.empcode
                   AND attdate = a.attdate
                   AND empcode = NVL (p_empcode, empcode);
        END IF;


        IF LOWER (a.shift) = 'g'
        THEN
            UPDATE att_emp_t01
               SET is_govt_holiday = 1
             WHERE     attdate BETWEEN p_fdate AND p_tdate
                   AND empcode = a.empcode
                   AND attdate = a.attdate
                   AND empcode = NVL (p_empcode, empcode);
        END IF;
    END LOOP;
END;
/
