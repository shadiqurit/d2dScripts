/* Formatted on 2/11/2025 12:03:56 PM (QP5 v5.362) */
  SELECT o.ot_date,
         o.refno,
         o.IS_APPROVAL,
         o.OT_STATUS,
         o.DP_CODE,
         o.DEPARTMENT_NAME,
         o.SECTION_NAME,
         a.EMPCODE,
         a.OTDATE,
         a.ST1_H,
         a.ET1_H,
         a.ST2_H,
         a.ET2_H,
         a.IS_APPROVED2,
         a.FINAL_STATUS,
         e.attdate,
         e.intime,
         e.outtime,
         -- Calculate morning hours
         ROUND ((a.ET1_H - a.ST1_H) * 24, 2)      AS morning_hours,
         -- Calculate evening hours
         ROUND ((a.ET2_H - a.ST2_H) * 24, 2)      AS evening_hours,
           -- Total hours
           ROUND ((a.ET1_H - a.ST1_H) * 24, 2)
         + ROUND ((a.ET2_H - a.ST2_H) * 24, 2)    AS total_hours
    FROM ipihr.ot_master o
         JOIN ipihr.ot_application a
             ON o.ot_date = a.OTDATE AND a.refno = o.refno
         JOIN ipihr.att_emp e ON a.EMPCODE = e.empcode AND a.OTDATE = e.attdate
   WHERE     o.OT_STATUS = 'Approved'
         AND o.OT_DATE BETWEEN TO_DATE ('1/01/2025', 'MM/DD/YYYY')
                           AND TO_DATE ('1/31/2025', 'MM/DD/YYYY')
         AND a.IS_APPROVED2 = 'Y'
         AND a.FINAL_STATUS = 'Approved'
         AND (   (   a.ST1_H IS NULL
                  OR TO_CHAR (a.ST1_H, 'HH24:MI') BETWEEN TO_CHAR (e.intime,
                                                                   'HH24:MI')
                                                      AND TO_CHAR (e.outtime,
                                                                   'HH24:MI'))
              OR (   a.ST2_H IS NULL
                  OR TO_CHAR (a.ST2_H, 'HH24:MI') BETWEEN TO_CHAR (e.intime,
                                                                   'HH24:MI')
                                                      AND TO_CHAR (e.outtime,
                                                                   'HH24:MI')))
         AND (   (   a.ET1_H IS NULL
                  OR TO_CHAR (a.ET1_H, 'HH24:MI') BETWEEN TO_CHAR (e.intime,
                                                                   'HH24:MI')
                                                      AND TO_CHAR (e.outtime,
                                                                   'HH24:MI'))
              OR (   a.ET2_H IS NULL
                  OR TO_CHAR (a.ET2_H, 'HH24:MI') BETWEEN TO_CHAR (e.intime,
                                                                   'HH24:MI')
                                                      AND TO_CHAR (e.outtime,
                                                                   'HH24:MI')))
         AND a.EMPCODE = 'IPI-000865'
ORDER BY o.ot_date DESC;