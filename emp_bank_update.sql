/* Formatted on 5/6/2026 11:09:14 AM (QP5 v5.362) */
UPDATE emp_bank_up
   SET STATUS = 'P' 
 WHERE STATUS = 'D' and
 ENT_DATE = TO_DATE('5/6/2026 5:05:53 AM', 'MM/DD/YYYY HH:MI:SS AM');

--hr_base

  SELECT empcode,
         b.PAYMENT_TYPE,
         b.BANKNAME,
         b.BANKACCNO
    FROM emp_100924 b
   WHERE b.empcode IN (SELECT EMPCODE FROM emp_bank_up)
ORDER BY 1 ASC;


  SELECT empcode,
         b.PAYMENT_TYPE,
         b.BANKNAME,BRANCH_NAME,
         b.BANKACCNO
    FROM emp b
   WHERE b.empcode IN (SELECT EMPCODE FROM emp_bank_up
   )
ORDER BY 1 ASC;



DECLARE
    CURSOR dt IS
        SELECT EMPCODE,
               ACC_NO,
               BANK,
               BRANCH_NAME,
               PAY_TYPE
          FROM emp_bank_up
         WHERE STATUS = 'P';
BEGIN
    FOR x IN dt
    LOOP
        UPDATE emp b
           ---empcode, PAYMENT_TYPE, BANKNAME, BANKACCNO
           SET b.PAYMENT_TYPE = x.PAY_TYPE,
               b.BANKNAME = x.BANK,
               b.BRANCH_NAME = x.BRANCH_NAME,
               b.BANKACCNO = x.ACC_NO
         WHERE b.empcode = x.empcode;
    END LOOP;

    COMMIT;

    UPDATE emp_bank_up
       SET STATUS = 'D'
     WHERE STATUS = 'P';

    COMMIT;
END;