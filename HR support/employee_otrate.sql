/* Formatted on 8/3/2025 11:32:06 AM (QP5 v5.362) */
DECLARE
    vnm               VARCHAR2 (100);
    basic             NUMBER := 0;
    vcata             VARCHAR2 (30);
    v_rec             NUMBER;
    v_service_years   NUMBER;
BEGIN
    IF :hr_overtime_det.empcode IS NOT NULL
    THEN
        IF    :hr_overtime_det.monthno IS NULL
           OR :hr_overtime_det.yearno IS NULL
        THEN
            MESSAGE ('Please enter Month For First');
            MESSAGE ('Please enter Month For First');
            --go_item('hr_overtime_det.monthno');
            RETURN;
        ELSE
            :global.monthno := :hr_overtime_det.monthno;
            :global.yearno := :hr_overtime_det.yearno;
        END IF;
    END IF;

    IF :hr_overtime_det.empcode IS NOT NULL
    THEN
        SELECT NVL (COUNT (*), 0)
          INTO v_rec
          FROM hr_overtime_det
         WHERE     yearno = :hr_overtime_det.yearno
               AND monthno = :hr_overtime_det.monthno
               AND empcode = :hr_overtime_det.empcode
               AND trntype = 'OT';

        IF NVL (v_rec, 0) > 0
        THEN
            MESSAGE ('Already exist record for this employee');
            MESSAGE ('Already exist record for this employee');
            RETURN;
            RAISE form_trigger_failure;
            RETURN;
        END IF;

        SELECT NVL (MAX (e_name), '#'),
               MAX (UPPER (NVL (cata, '#'))),
               MAX (d_code),
               MAX (department_name),
               MAX (desig_code),
               MAX (desig_name),
               MAX (businessunitid),
               MAX (businessunit),
               MAX (UPPER (payment_type))     paymenttype,
               MAX (bank_id),
               MAX (bankname),
               MAX (bankaccno),
               MAX (dp_code),
               MAX (depot),
               MAX (branch_name),
               MAX (costcenter),
               MAX (costcenter_name)
          INTO vnm,
               vcata,
               :dept_code,
               :dept_name,
               :desig_code,
               :desig_name,
               :businessunitid,
               :businessunit,
               :paytype,
               :bank_id,
               :bankname,
               :bankaccountno,
               :locid,
               :locname,
               :branch_name,
               :costcenter_id,
               :costcenter_name
          FROM emp
         WHERE empcode = :hr_overtime_det.empcode;

        IF NVL (vnm, '#') = '#'
        THEN
            MESSAGE ('Invalid employee ID');
            RAISE form_trigger_failure;
        ELSE
            :ename := vnm;

            IF vcata <> 'OFFICER'
            THEN
                SELECT NVL (MAX (salper), 0)
                  INTO basic
                  FROM hr_empsalstructure
                 WHERE empcode = :hr_overtime_det.empcode AND slno = 1;

                IF NVL (basic, 0) > 0
                THEN
                    :hr_overtime_det.basic := basic;
                    :otrate := ROUND ((NVL (basic, 0) / 208) * 2, 2);


                    IF SUBSTR (UPPER ( :hr_overtime_det.empcode), 1, 3) =
                       'EMP'
                    THEN
                        SELECT CEIL (
                                   MONTHS_BETWEEN (
                                       TO_DATE (
                                              '01'
                                           || LPAD ( :monthno, 2, 0)
                                           || :yearno,
                                           'ddmmyyyy'),
                                       JOIN_DATE))
                          --  max( trunc(  (  (   to_date (  '01'|| lpad(  :hr_overtime_det.monthno,2,0) ||:hr_overtime_det.yearno ,
                          --  'ddmmyyyy') - join_date ) +1 ) /365,2)  )


                          INTO v_service_years
                          FROM emp
                         WHERE empcode = :hr_overtime_det.empcode;

                        IF v_service_years >= 6
                        THEN
                            :otrate := 50;
                        ELSE
                            :otrate := 45;
                        END IF;
                    END IF;
                ELSE
                    MESSAGE ('Basic has not been set for selected employee');
                    MESSAGE (' ');
                END IF;
            END IF;
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        MESSAGE (SQLERRM (SQLCODE));
END;