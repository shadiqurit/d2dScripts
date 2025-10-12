/* Formatted on 10/7/2025 12:39:31 PM (QP5 v5.362) */
--http://10.30.20.5:9009/reports/rwservlet?userid=ipihr/i@ipihr&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\emp_service_info_2.RDF&p_department=&p_designation=&p_grade=&p_JobType=&p_workstation=HDO&p_fromdate=01-JUL-25&p_to_date=07-OCT-25&p_group_type=Work%20station&p_unitid=

  SELECT empcode,
         employee_name,
         desig_name,
         dp_code,
         phone,
         desig_sl,
         desig_sl     desig_sl_2,
         department_name,
         add1,
         home_district,
         group_by_key,
         group_by_value,
         group_by_value_a,
         job_type,
         join_date,
         fixation_date,
         grade,
         Contract_expire_date,
         SEPARATETYPENAME,
         emp_status,
         ter_date
    FROM (--nvl(to_number( nvl(  (select  x.gsl from desig_sl x where x.DESIG_NAME=a.desig_name and x.salarygrade=a.salarygrade  ) ,null) ),null)

          SELECT empcode,
                 e_name
                     employee_name,
                 desig_name,
                 dp_code,
                 phone,
                 TO_NUMBER (a.desig_sl)
                     desig_sl,
                 department_name,
                 add1,
                 NULL
                     home_district,
                 DECODE (NVL ( :is_group, 0),  0, NULL,  1, :p_group_type)
                     group_by_key,
                 DECODE (
                     NVL ( :is_group, 0),
                     0, NULL,
                     1, CASE
                            WHEN :p_group_type = 'Department'
                            THEN
                                department_name
                            WHEN :p_group_type = 'Designation'
                            THEN
                                desig_name
                            WHEN :p_group_type = 'Grade'
                            THEN
                                SALARYGRADE
                            WHEN :p_group_type = 'Job Type'
                            THEN
                                confirm_st
                            WHEN :p_group_type = 'Work station'
                            THEN
                                dp_code
                            WHEN :p_group_type = 'joining Date'
                            THEN
                                TO_CHAR (join_date, 'dd-Mon-rrrr')
                            WHEN :p_group_type = 'Fixation Date'
                            THEN
                                TO_CHAR (confirm_date, 'dd-Mon-rrrr')
                            WHEN :p_group_type = 'TerminationDate'
                            THEN
                                TRIM (TO_CHAR (ter_date, 'dd-Mon-rrrr'))
                        END)
                     group_by_value,
                 DECODE (
                     NVL ( :is_group, 0),
                     0, NULL,
                     1, NVL (
                            CASE
                                WHEN :p_group_type = 'Designation'
                                THEN
                                    NVL (
                                        TO_NUMBER (
                                            (SELECT x.sl
                                               FROM desig_sl x
                                              WHERE x.DESIG_NAME = a.desig_name)),
                                        NULL)
                                ELSE
                                    NULL
                            END,
                            0))
                     group_by_value_a,
                 /*

                 case when :p_group_type='Termination Date'  then   'Grade'  else  'Fixation date'  end  c_g,
                  case when :p_group_type='Termination Date'  then   'Separation Date'  else 'Grade'   end   c_h,
                 case when :p_group_type='Termination Date'  then   'Separation Type'  else  'Contract expire Date'
                 */


                 --1

                 confirm_st
                     job_type,
                 --2
                 TO_CHAR (join_date, 'dd-mon-rrrr')
                     join_date,
                 --3

                 CASE
                     WHEN :p_group_type = 'TerminationDate' THEN salarygrade
                     ELSE TO_CHAR (confirm_date, 'dd-mon-rrrr')
                 END
                     fixation_date,
                 --4

                 CASE
                     WHEN :p_group_type = 'TerminationDate'
                     THEN
                         TO_CHAR (ter_date, 'dd-mon-rrrr')
                     ELSE
                         salarygrade
                 END
                     grade,
                 --5

                 CASE
                     WHEN :p_group_type = 'TerminationDate'
                     THEN
                         SEPARATETYPENAME
                     ELSE
                         TO_CHAR (prob_end_date, 'dd-mon-rrrr')
                 END
                     Contract_expire_date,
                 SEPARATETYPENAME,
                 emp_status,
                 ter_date
            --

            FROM emp a, hr_report_type b
           WHERE     emp_status IN ('A', 'S')
                 AND a.emp_status =
                     (CASE
                          WHEN :p_group_type = 'TerminationDate' THEN 'S'
                          ELSE 'A'
                      END)
                 AND b.name = :p_group_type
                 AND ---------------------


                     CASE
                         WHEN :p_group_type = 'Department'
                         THEN
                             NVL (department_name, '#')
                         WHEN :p_group_type = 'Designation'
                         THEN
                             NVL (desig_name, '#')
                         WHEN :p_group_type = 'Grade'
                         THEN
                             NVL (SALARYGRADE, '#')
                         WHEN :p_group_type = 'Job Type'
                         THEN
                             NVL (confirm_st, '#')
                         WHEN :p_group_type = 'Work station'
                         THEN
                             NVL (dp_code, '#')
                         WHEN :p_group_type = 'joining Date'
                         THEN
                             TO_CHAR (join_date, 'rrrrmmdd')
                         WHEN :p_group_type = 'Fixation Date'
                         THEN
                             TO_CHAR (confirm_date, 'rrrrmmdd')
                         WHEN :p_group_type = 'TerminationDate'
                         THEN
                             TRIM (TO_CHAR (ter_date, 'yyyymmdd'))
                     END =
                     ------------------------------


                     CASE
                         WHEN :p_group_type = 'Department'
                         THEN
                             NVL ( :p_department, NVL (department_name, '#'))
                         WHEN :p_group_type = 'Designation'
                         THEN
                             NVL ( :p_designation, NVL (desig_name, '#'))
                         WHEN :p_group_type = 'Grade'
                         THEN
                             NVL ( :p_grade, NVL (salarygrade, '#'))
                         WHEN :p_group_type = 'Job Type'
                         THEN
                             NVL ( :p_JobType, NVL (confirm_st, '#'))
                         WHEN :p_group_type = 'Work station'
                         THEN
                             NVL ( :p_workstation, NVL (dp_code, '#'))
                         WHEN :p_group_type = 'joining Date'
                         THEN
                             TO_CHAR (join_date, 'rrrrmmdd')
                         WHEN :p_group_type = 'Fixation Date'
                         THEN
                             TO_CHAR (confirm_date, 'rrrrmmdd')
                         WHEN :p_group_type = 'TerminationDate'
                         THEN
                             TRIM (TO_CHAR (ter_date, 'yyyymmdd'))
                     END
                 AND NVL (department_name, '#') =
                     NVL ( :p_department, NVL (department_name, '#'))
                 AND NVL (desig_name, '#') =
                     NVL ( :p_designation, NVL (desig_name, '#'))
                 AND NVL (salarygrade, '#') =
                     NVL ( :p_grade, NVL (salarygrade, '#'))
                 AND NVL (confirm_st, '#') =
                     NVL ( :p_JobType, NVL (confirm_st, '#'))
                 AND NVL (dp_code, '#') =
                     NVL ( :p_workstation, NVL (dp_code, '#'))
                 AND NVL (BUSINESSUNITID, '#') =
                     NVL ( :p_unitid, NVL (BUSINESSUNITID, '#'))
                 /*
                 p_fromdate
                 p_to_date
                 */

                 AND --
                     NVL (
                         TO_NUMBER (
                             CASE
                                 WHEN :p_group_type = 'joining Date'
                                 THEN
                                     TO_CHAR (join_date, 'rrrrmmdd')
                                 WHEN :p_group_type = 'Fixation Date'
                                 THEN
                                     TO_CHAR (confirm_date, 'rrrrmmdd')
                                 WHEN :p_group_type = 'TerminationDate'
                                 THEN
                                     TRIM (TO_CHAR (ter_date, 'yyyymmdd'))
                                 ELSE
                                     '111'
                             END),
                         111) >=
                     NVL (
                         TO_NUMBER (
                             CASE
                                 WHEN :p_group_type IN
                                          ('joining Date',
                                           'Fixation Date',
                                           'TerminationDate')
                                 THEN
                                     TO_CHAR ( :p_fromdate, 'rrrrmmdd')
                                 ELSE
                                     '111'
                             END),
                         111)
                 AND --
                     NVL (
                         TO_NUMBER (
                             CASE
                                 WHEN :p_group_type = 'joining Date'
                                 THEN
                                     TO_CHAR (join_date, 'rrrrmmdd')
                                 WHEN :p_group_type = 'Fixation Date'
                                 THEN
                                     TO_CHAR (confirm_date, 'rrrrmmdd')
                                 WHEN :p_group_type = 'TerminationDate'
                                 THEN
                                     TRIM (TO_CHAR (ter_date, 'yyyymmdd'))
                                 ELSE
                                     '111'
                             END),
                         111) <=
                     NVL (
                         TO_NUMBER (
                             CASE
                                 WHEN :p_group_type IN
                                          ('joining Date',
                                           'Fixation Date',
                                           'TerminationDate')
                                 THEN
                                     TO_CHAR (NVL ( :p_to_date, :p_fromdate),
                                              'rrrrmmdd')
                                 ELSE
                                     '111'
                             END),
                         111)--and rownum=1
                             ---order by  to_number(desig_sl
                             )
ORDER BY TO_NUMBER (desig_sl) ASC, join_date, desig_sl_2