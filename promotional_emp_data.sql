/* Formatted on 11/11/2024 12:22:32 PM (QP5 v5.362) */
  SELECT hc.EMPCODE      AS ipi,
         e_name          AS "Name",
         hc.REFDATE      "Date",
         hc.INCRTYPE     "Type",
         hc.LTYPEDES     "Letter Type"
    FROM hr_empchange hc, emp e
   WHERE     hc.empcode = e.empcode
         AND REFDATE BETWEEN TO_DATE ('12/01/2023', 'MM/DD/YYYY')
                         AND TO_DATE ('12/31/2024', 'MM/DD/YYYY')
         AND LTYPEDES NOT IN
                 ('Transfer Letter',
                  'Charge Handover',
                  'Deduction from Allownace for special Achievement',
                  'Allowance for Special Achievement')
ORDER BY REFDATE ASC;



SELECT DISTINCT LTYPEDES
  FROM hr_empchange;