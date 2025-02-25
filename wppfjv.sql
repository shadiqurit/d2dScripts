/* Formatted on 2/17/2025 10:13:20 AM (QP5 v5.362) */
SELECT *
  FROM pm_journal_voucher
 WHERE VOUCHERNO = 2941;



SELECT *
  FROM pm_journal_jv
 WHERE     VOUCHERNO = 2941
       AND actid = 200102
       AND actcode = 6003
       AND prefno IN (SELECT empcode FROM inmemp);

UPDATE pm_journal_jv
   SET CRAMOUNT = 0
 WHERE     VOUCHERNO = 2941
       AND actid = 200102
       AND actcode = 6003
       AND prefno IN (SELECT empcode FROM inmemp);