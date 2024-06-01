SELECT DISTINCT
    a.sl,
    a.emp_code,
    a.emp_name,
    a.staff_no,
    a.grade_no,
    a.designation,
    a.last_jobplace,
    a.job_type,
    a.join_date,
    a.resign_date,
    a.insert_by,
    a.insert_date,
    a.trn_status,
    a.update_by,
    a.update_date,
    decode(trn_status,
           'D',
           'Final Settlement is Draft now',
           fs_approval_emp(a.emp_code)) status,
    (
        CASE
            WHEN ( b.status IS NULL
                   OR b.status = 'N' ) THEN
                'Pending'
            ELSE
                'Approved'
        END
    )                                   checking_approve_status,
    'P'                                 check_status,
    b.check_emp,
    (
        SELECT
            '('
            || 'Pending'
            || ')'
            || (
                LISTAGG(DISTINCT x.check_emp, ',') WITHIN GROUP(
                ORDER BY
                    y.empcode
                )
            )
        FROM
            fs_trn_dtl x,
            t_emp_v      y
        WHERE
                x.emp_code = y.empcode
            AND x.emp_code = a.emp_code
            AND x.status IS NULL
        GROUP BY
            x.emp_code
    )                                   pending_list
FROM
    fs_trn_mst a,
    fs_trn_dtl b
WHERE
    ( b.status IS NULL
      OR b.status = 'N' )
    AND a.emp_code = b.emp_code
UNION ALL
SELECT DISTINCT
    a.sl,
    a.emp_code,
    a.emp_name,
    a.staff_no,
    a.grade_no,
    a.designation,
    a.last_jobplace,
    a.job_type,
    a.join_date,
    a.resign_date,
    a.insert_by,
    a.insert_date,
    a.trn_status,
    a.update_by,
    a.update_date,
    decode(trn_status,
           'D',
           'Final Settlement is Draft now',
           fs_approval_emp(a.emp_code)) status,
    (
        CASE
            WHEN ( b.status IS NULL
                   OR b.status = 'N' ) THEN
                'Pending'
            ELSE
                'Approved'
        END
    )                                   checking_approve_status,
    'A'                                 check_status,
    b.check_emp,
    (
        SELECT
            '('
            || 'Pending'
            || ')'
            || (
                LISTAGG(DISTINCT x.check_emp, ',') WITHIN GROUP(
                ORDER BY
                    y.empcode
                )
            )
        FROM
            fs_trn_dtl x,
            t_emp_v      y
        WHERE
                x.emp_code = y.empcode
            AND x.emp_code = a.emp_code
            AND x.status IS NULL
        GROUP BY
            x.emp_code
    )                                   pending_list
FROM
    fs_trn_mst a,
    fs_trn_dtl b
WHERE
        nvl(b.check_status, '#') = 'Y' --AND b.CHECK_EMP = :APP_USER  -- OR b.CHECK_EMP = 'IPI-007470' )
    AND a.emp_code = b.emp_code;