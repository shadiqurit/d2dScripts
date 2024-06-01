/* Formatted on 20/May/24 4:56:05 PM (QP5 v5.362) */
--CREATE OR REPLACE FORCE VIEW IPIHR.ATT_EMP_V
--AS

SELECT CASE
           WHEN att_pkg.datediff2 (a.intime, a.office_in_time) IS NOT NULL
           THEN
               att_pkg.datediff2 (a.intime, a.office_in_time) || ' Late'
           ELSE
               NULL
       END
           checkin_status,
       CASE
           WHEN att_pkg.datediff2 (a.office_out_time, a.outtime) IS NOT NULL
           THEN
               att_pkg.datediff2 (a.office_out_time, a.outtime) || 'Early. '
           ELSE
               NULL
       END
           checkout_status,
       a.office_out_time,
       a.office_in_time,
       a.remark,
       a.attstatus,
       a.outtime,
       a.intime,
       TO_CHAR (a.outtime, 'hh:mi AM')
           out_time_wdate,
       TO_CHAR (a.intime, 'hh:mi AM')
           in_time_wdate,
       a.attdate,
       a.empcode,
       e_name,
       join_date,
       empcodehr,
       TO_CHAR (a.attdate, 'mm')
           base_month,
       TO_CHAR (a.attdate, 'yyyy')
           base_year,
       TRIM (TO_CHAR (a.attdate, 'Month')) || TO_CHAR (a.attdate, ',yyyy')
           yearmn,
       --     base_month_2,
       att_pkg.datediff2 (a.outtime, a.intime)
           total_hours,
       att_pkg.datediff3 (a.outtime, a.intime)
           total_hours_short,
       NULL
           overall_status,
       b.desig_name,
       b.department_name,
       b.department_name
           sub_department_name,
       a.status,
       b.dp_code
           LOCATION,
       a.remark_long,
       b.dp_code
           dp_code,
       b.dp_code
           dp_code_att,
       b.dp_code
           location_att,
       latein,
       earlyout,
       b.desig_sl,
       b.businessunitid
           unitid,
       a.in_location,
       a.out_location
  FROM att_emp a, emp b
 WHERE a.empcode = b.empcode
/* UNION ALL
 SELECT null checkin_status,
        null checkout_status,
        null office_out_time, null office_in_time, a.remark, null attstatus,
        a.outtime, a.intime, TO_CHAR (a.outtime, 'hh:mi AM') out_time_wdate,
        TO_CHAR (a.intime, 'hh:mi AM') in_time_wdate, a.attdate, a.empcode,
        e_name, join_date, empcodehr, TO_CHAR (a.attdate, 'mm') base_month,
        TO_CHAR (a.attdate, 'yyyy') base_year,
           TRIM (TO_CHAR (a.attdate, 'Month'))
        || TO_CHAR (a.attdate, ',yyyy') yearmn,
        --     base_month_2,
        att_pkg.datediff2 (a.outtime, a.intime) total_hours,
        att_pkg.datediff3 (a.outtime, a.intime) total_hours_short,
        NULL overall_status, b.desig_name, b.department_name,
        b.department_name sub_department_name, 'P' status, b.dp_code LOCATION,
        null remark_long, b.dp_code dp_code, b.dp_code dp_code_att,
        b.dp_code location_att, null latein, null earlyout, b.desig_sl,
        b.businessunitid unitid, null in_location,
                                      null out_location
   FROM att_manual a, emp b
  WHERE a.empcode = b.empcode
  */;