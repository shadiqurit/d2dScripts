CREATE OR REPLACE FORCE VIEW IPIHR.HR_EMP_SHIFT_V
AS
    SELECT empcode,
           shift_type,
           yearmn,
           attdate,
           shift,
           CASE
               WHEN start_time_a IS NOT NULL
               THEN
                   dt_mix (attdate, start_time_a)
               ELSE
                   NULL
           END    start_time,
           CASE
               WHEN end_time_a IS NOT NULL
               THEN
                   --
                   CASE
                       WHEN NVL (next_days, 0) = 1
                       THEN
                           dt_mix (attdate + 1, end_time_a)
                       WHEN dt_mix (attdate, end_time_a) <
                            dt_mix (attdate, start_time_a)
                       THEN
                           dt_mix (attdate + 1, end_time_a)
                       WHEN dt_mix (attdate, end_time_a) =
                            dt_mix (attdate, start_time_a)
                       THEN
                           dt_mix (attdate + 1, end_time_a)
                       ELSE
                           dt_mix (attdate, end_time_a)
                   END
               --
               ELSE
                   NULL
           END    end_time,
           start_time_a,
           end_time_a,
           next_days
      FROM (SELECT empcode,
                   shift_type,
                   yearmn,
                   attdate,
                   shift,
                   CASE
                       WHEN shift IS NOT NULL
                       THEN
                             (TO_DATE (
                                     TO_CHAR (attdate, 'ddmmrrrr')
                                  || SUBSTR (shift, 1, 7),
                                  'ddmmrrrrhh:miam'))
                           - 1
                       ELSE
                           NULL
                   END    start_time_a,
                   CASE
                       WHEN shift IS NOT NULL
                       THEN
                           ----------------------
                           CASE
                               WHEN next_days = 1
                               THEN
                                     (TO_DATE (
                                             TO_CHAR (attdate, 'ddmmrrrr')
                                          || SUBSTR (shift, 8, 7),
                                          'ddmmrrrrhh:miam'))
                                   + 1
                               ELSE
                                   TO_DATE (
                                          TO_CHAR (attdate, 'ddmmrrrr')
                                       || SUBSTR (shift, 8, 7),
                                       'ddmmrrrrhh:miam')
                           END
                       ------------------------
                       ELSE
                           NULL
                   END    end_time_a,
                   next_days
              FROM (SELECT empcode,
                           shift_type,
                           yearmn,
                           attdate,
                           CASE
                               WHEN LOWER (rd2x (shift)) = 'xx:xxamxx:xxam'
                               THEN
                                   shift
                               ELSE
                                   NULL
                           END     shift,
                           NULL    start_time,
                           NULL    end_time,
                           next_days
                      FROM (SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '01', 'yyyymmdd')
                                       attdate,
                                   dt1
                                       shift,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',1,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt1 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '02', 'yyyymmdd')
                                       attdate,
                                   dt2,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',2,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt2 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '03', 'yyyymmdd')
                                       attdate,
                                   dt3,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',3,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt3 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '04', 'yyyymmdd')
                                       attdate,
                                   dt4,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',4,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt4 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '05', 'yyyymmdd')
                                       attdate,
                                   dt5,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',5,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt5 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '06', 'yyyymmdd')
                                       attdate,
                                   dt6,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',6,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt6 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '07', 'yyyymmdd')
                                       attdate,
                                   dt7,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',7,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt7 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '08', 'yyyymmdd')
                                       attdate,
                                   dt8,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',8,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt8 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '09', 'yyyymmdd')
                                       attdate,
                                   dt9,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',9,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt9 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '10', 'yyyymmdd')
                                       attdate,
                                   dt10,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',10,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt10 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '11', 'yyyymmdd')
                                       attdate,
                                   dt11,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',11,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt11 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '12', 'yyyymmdd')
                                       attdate,
                                   dt12,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',12,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt12 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '13', 'yyyymmdd')
                                       attdate,
                                   dt13,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',13,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt13 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '14', 'yyyymmdd')
                                       attdate,
                                   dt14,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',14,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt14 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '15', 'yyyymmdd')
                                       attdate,
                                   dt15,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',15,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt15 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '16', 'yyyymmdd')
                                       attdate,
                                   dt16,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',16,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt16 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '17', 'yyyymmdd')
                                       attdate,
                                   dt17,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',17,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt17 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '18', 'yyyymmdd')
                                       attdate,
                                   dt18,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',18,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt18 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '19', 'yyyymmdd')
                                       attdate,
                                   dt19,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',19,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt19 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '20', 'yyyymmdd')
                                       attdate,
                                   dt20,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',20,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt20 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '21', 'yyyymmdd')
                                       attdate,
                                   dt21,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',21,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt21 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '22', 'yyyymmdd')
                                       attdate,
                                   dt22,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',22,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt22 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '23', 'yyyymmdd')
                                       attdate,
                                   dt23,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',23,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt23 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '24', 'yyyymmdd')
                                       attdate,
                                   dt24,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',24,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt24 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '25', 'yyyymmdd')
                                       attdate,
                                   dt25,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',25,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt25 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '26', 'yyyymmdd')
                                       attdate,
                                   dt26,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',26,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt26 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '27', 'yyyymmdd')
                                       attdate,
                                   dt27,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',27,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt27 IS NOT NULL
                            UNION ALL
                            SELECT empcode,
                                   shift_type,
                                   yearmn,
                                   TO_DATE (yearmn || '28', 'yyyymmdd')
                                       attdate,
                                   dt28,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',28,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END
                                       next_days
                              FROM hr_emp_shift
                             WHERE dt28 IS NOT NULL
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
                                   dt29,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',29,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END    next_days
                              FROM hr_emp_shift
                             WHERE     dt29 IS NOT NULL
                                   AND TO_NUMBER (
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
                                   dt30,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',30,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END    next_days
                              FROM hr_emp_shift
                             WHERE     dt30 IS NOT NULL
                                   AND TO_NUMBER (
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
                                   dt31,
                                   CASE
                                       WHEN INSTR (
                                                ',' || overlaping_days || ',',
                                                ',31,') >=
                                            1
                                       THEN
                                           1
                                       ELSE
                                           NULL
                                   END    next_days
                              FROM hr_emp_shift
                             WHERE     dt31 IS NOT NULL
                                   AND TO_NUMBER (
                                           TO_CHAR (
                                               LAST_DAY (
                                                   TO_DATE (yearmn || '01',
                                                            'yyyymmdd')),
                                               'dd')) =
                                       31)));


GRANT SELECT ON IPIHR.HR_EMP_SHIFT_V TO DPUSER;
