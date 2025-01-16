/* Formatted on 1/13/2025 5:44:17 PM (QP5 v5.362) */
SELECT *
  FROM OT_MASTER
 WHERE REFNO IN
           (SELECT refno
              FROM OT_APPLICATION
             WHERE     OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                                  AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
                   AND EMPCODE = 'IPI-008574');


  SELECT a.EMPCODE,
         a.ATTDATE,
         a.OFFICE_IN_TIME,
         a.OFFICE_OUT_TIME,
         a.ATTSTATUS,
         a.INTIME,
         a.OUTTIME,
         a.STATUS,
         a.REMARK_LONG,
         a.IN_LOCATION,
         a.OUT_LOCATION,
         o.OTDATE,
         o.REFNO,
         o.ST1_H,
         o.ET1_H,
         o.ST2_H,
         o.ET2_H,
         SECTION_NAME
    FROM ATT_EMP  a
         LEFT JOIN OT_APPLICATION o
             ON a.EMPCODE = o.EMPCODE AND a.ATTDATE = o.OTDATE,
         OT_MASTER OM
   WHERE     (a.INTIME IS NULL OR a.OUTTIME IS NULL)
         AND o.REFNO = OM.REFNO
         AND o.OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                          AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
         AND o.st1_h IS NOT NULL
--AND o.EMPCODE = 'IPI-008574'
-- AND O.REFNO = 26959
ORDER BY a.EMPCODE, a.ATTDATE;


  SELECT O.EMPCODE, SECTION_NAME, COUNT (O.REFNO) APPLICATIONS
    FROM ATT_EMP  a
         LEFT JOIN OT_APPLICATION o
             ON a.EMPCODE = o.EMPCODE AND a.ATTDATE = o.OTDATE,
         OT_MASTER OM
   WHERE     (a.INTIME IS NULL OR a.OUTTIME IS NULL)
         AND o.REFNO = OM.REFNO
         AND o.st1_h IS NOT NULL
         AND o.OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                          AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
         AND o.EMPCODE = 'IPI-008574'
-- AND O.REFNO = 26959
GROUP BY SECTION_NAME, O.EMPCODE
ORDER BY 2;

SELECT COUNT (DISTINCT (A.EMPCODE))     CNT
  FROM ATT_EMP  a
       LEFT JOIN OT_APPLICATION o
           ON a.EMPCODE = o.EMPCODE AND a.ATTDATE = o.OTDATE
 WHERE     (a.INTIME IS NULL OR a.OUTTIME IS NULL)
       AND o.OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                        AND TO_DATE ('12/31/2024', 'MM/DD/YYYY');


SELECT o.refno,
       o.empcode,
       o.otdate,
       o.st1_h,
       o.et1_h,
       o.st1,
       o.et1,
       a.intime,
       a.outtime,
       o.IS_APPROVED1,
       TO_CHAR (o.et1_h, 'HH:MI:SS AM')       OTT_MORN,
       TO_CHAR (a.outtime, 'HH:MI:SS AM')     OUTTIMES
  FROM att_emp a, ot_application o, ot_master om
 WHERE     a.empcode = o.empcode
       AND a.attdate = o.otdate
       AND o.IS_APPROVED1 IS NULL
       AND REMARK = 'Holiday'
       -- AND a.office_out_time < a.outtime
       AND o.et2 <= a.outtime
       --AND TO_CHAR (a.outtime, 'HH:MI:SS AM') NOT BETWEEN '08:30:00 PM' AND '11:59:00 PM'
       AND o.refno = om.refno
       AND A.ATTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                         AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
--AND o.empcode = 'IPI-002078'

;
/* Formatted on 1/16/2025 3:45:12 PM (QP5 v5.362) */
  SELECT o.REFNO||
         a.EMPCODE,
         a.ATTDATE,
         a.OFFICE_IN_TIME,
         a.OFFICE_OUT_TIME,
         OT_STATUS,
         final_status,
         a.INTIME,
         a.OUTTIME,
         a.STATUS,
         a.REMARK_LONG,
         a.IN_LOCATION,
         a.OUT_LOCATION,
         o.OTDATE,
         o.ST1,
         o.ST1_H,
         o.ET1,
         o.ET1_H,
         o.ST2,
         o.ST2_H,
         o.eT2,
         o.ET2_H,
         SECTION_NAME
    FROM ATT_EMP  a
         LEFT JOIN OT_APPLICATION o
             ON a.EMPCODE = o.EMPCODE AND a.ATTDATE = o.OTDATE,
         OT_MASTER OM
   WHERE     o.REFNO = OM.REFNO
         AND o.OTDATE BETWEEN TO_DATE ('12/1/2024', 'MM/DD/YYYY')
                          AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
         AND a.INTIME <= o.ST1
         AND o.ST1_h IS NULL
         AND o.ST2_h IS NULL
         -- AND o.ST2_h IS NULL
         AND NVL (remark_long, '#') not in( 'Due to duty outside office', 'Holiday', 'ipi duty')
         --AND o.EMPCODE = 'IPI-008347'
         AND O.REFNO not in (28109,28110, 27208,27352, 27876)
         and in_location not like '%Head Office%'
         --and  O.REFNO = 27367
ORDER BY a.EMPCODE, a.ATTDATE;