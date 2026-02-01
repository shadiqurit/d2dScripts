/* Formatted on 12/24/2025 10:06:47 AM (QP5 v5.362) */
SELECT *
  FROM pm_journal_voucher
 WHERE VOUCHERNO = 2941;



UPDATE pm_journal_jv
   SET DRAMOUNT = 4412
 WHERE     MVOUCHERNO = 'BPAY2512-0001'
       AND VOUCHERNO = '3135'
       AND ACTCODE = '6002';

COMMIT;



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