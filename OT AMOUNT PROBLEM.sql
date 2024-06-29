/* Formatted on 05/Jun/24 9:42:36 AM (QP5 v5.362) */
SELECT refno,
       refdate,
       edate,
       empcode,
       otrate,
       OTHOUR,
       otamount,
       OTHERAMOUNT,
       TRNTYPE
  FROM hr_overtime_det
 WHERE     YEARNO = 2024
       AND MONTHNO = 5
       AND OTAMOUNT > 20000
       AND OTHOUR IS NULL
       AND TRNTYPE = 'OT';



SELECT *
  FROM hr_overtime_det2405BK
 WHERE     YEARNO = 2024
       AND MONTHNO = 5
       AND EDATE BETWEEN TO_DATE ('14/May/24 1:44:15 AM',
                                  'DD/MON/YY HH:MI:SS AM')
                     AND TO_DATE ('16/May/24 4:44:15 PM',
                                  'DD/MON/YY HH:MI:SS AM')
       AND TRNTYPE = 'OT'
       AND OTHOUR IS NULL;