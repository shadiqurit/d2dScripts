CREATE OR REPLACE FORCE VIEW IPIHR.HR_EMP_SHIFT_WH_V
AS
    SELECT DISTINCT empcode,
                    yearmn,
                    attdate,
                    shift
      FROM (SELECT empcode,
                   shift_type,
                   yearmn,
                   attdate,
                   shift
              FROM (SELECT empcode,
                           shift_type,
                           yearmn,
                           attdate,
                           CASE
                               WHEN LOWER (shift) IN ('w', 'h', 'g')
                               THEN
                                   shift
                               ELSE
                                   NULL
                           END    shift
                      FROM (SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '01', 'yyyymmdd')
                                       attdate,
                                   dt1
                                       shift
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '02', 'yyyymmdd')
                                       attdate,
                                   dt2
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '03', 'yyyymmdd')
                                       attdate,
                                   dt3
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '04', 'yyyymmdd')
                                       attdate,
                                   dt4
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '05', 'yyyymmdd')
                                       attdate,
                                   dt5
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '06', 'yyyymmdd')
                                       attdate,
                                   dt6
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '07', 'yyyymmdd')
                                       attdate,
                                   dt7
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '08', 'yyyymmdd')
                                       attdate,
                                   dt8
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '09', 'yyyymmdd')
                                       attdate,
                                   dt9
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '10', 'yyyymmdd')
                                       attdate,
                                   dt10
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '11', 'yyyymmdd')
                                       attdate,
                                   dt11
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '12', 'yyyymmdd')
                                       attdate,
                                   dt12
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '13', 'yyyymmdd')
                                       attdate,
                                   dt13
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '14', 'yyyymmdd')
                                       attdate,
                                   dt14
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '15', 'yyyymmdd')
                                       attdate,
                                   dt15
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '16', 'yyyymmdd')
                                       attdate,
                                   dt16
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '17', 'yyyymmdd')
                                       attdate,
                                   dt17
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '18', 'yyyymmdd')
                                       attdate,
                                   dt18
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '19', 'yyyymmdd')
                                       attdate,
                                   dt19
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '20', 'yyyymmdd')
                                       attdate,
                                   dt20
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '21', 'yyyymmdd')
                                       attdate,
                                   dt21
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '22', 'yyyymmdd')
                                       attdate,
                                   dt22
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '23', 'yyyymmdd')
                                       attdate,
                                   dt23
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '24', 'yyyymmdd')
                                       attdate,
                                   dt24
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '25', 'yyyymmdd')
                                       attdate,
                                   dt25
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '26', 'yyyymmdd')
                                       attdate,
                                   dt26
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '27', 'yyyymmdd')
                                       attdate,
                                   dt27
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '28', 'yyyymmdd')
                                       attdate,
                                   dt28
                              FROM hr_emp_shift
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   CASE
                                       WHEN TO_NUMBER (
                                                TO_CHAR (
                                                    LAST_DAY (
                                                        TO_DATE (
                                                            yearmn || '01',
                                                            'yyyymmdd')),
                                                    'dd')) >=
                                            29
                                       THEN
                                           TO_DATE (yearmn || '29',
                                                    'yyyymmdd')
                                       ELSE
                                           NULL
                                   END    attdate,
                                   dt29
                              FROM hr_emp_shift
                             WHERE TO_NUMBER (
                                       TO_CHAR (
                                           LAST_DAY (
                                               TO_DATE (yearmn || '01',
                                                        'yyyymmdd')),
                                           'dd')) >=
                                   29
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   CASE
                                       WHEN TO_NUMBER (
                                                TO_CHAR (
                                                    LAST_DAY (
                                                        TO_DATE (
                                                            yearmn || '01',
                                                            'yyyymmdd')),
                                                    'dd')) >=
                                            30
                                       THEN
                                           TO_DATE (yearmn || '30',
                                                    'yyyymmdd')
                                       ELSE
                                           NULL
                                   END    attdate,
                                   dt30
                              FROM hr_emp_shift
                             WHERE TO_NUMBER (
                                       TO_CHAR (
                                           LAST_DAY (
                                               TO_DATE (yearmn || '01',
                                                        'yyyymmdd')),
                                           'dd')) >=
                                   30
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   CASE
                                       WHEN TO_NUMBER (
                                                TO_CHAR (
                                                    LAST_DAY (
                                                        TO_DATE (
                                                            yearmn || '01',
                                                            'yyyymmdd')),
                                                    'dd')) =
                                            31
                                       THEN
                                           TO_DATE (yearmn || '31',
                                                    'yyyymmdd')
                                       ELSE
                                           NULL
                                   END    attdate,
                                   dt31
                              FROM hr_emp_shift
                             WHERE TO_NUMBER (
                                       TO_CHAR (
                                           LAST_DAY (
                                               TO_DATE (yearmn || '01',
                                                        'yyyymmdd')),
                                           'dd')) =
                                   31)));


GRANT SELECT ON IPIHR.HR_EMP_SHIFT_WH_V TO DPUSER;
