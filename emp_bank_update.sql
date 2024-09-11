/* Formatted on 9/10/2024 1:34:06 PM (QP5 v5.362) */
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
         b.BANKNAME,
         b.BANKACCNO
    FROM emp b
   WHERE b.empcode IN (SELECT EMPCODE FROM emp_bank_up)
ORDER BY 1 ASC;



DECLARE
    CURSOR dt IS
        SELECT EMPCODE, ACC_NO, BANK, BRANCH_NAME, PAY_TYPE FROM emp_bank_up;
BEGIN
    FOR x IN dt
    LOOP
        UPDATE emp b
           ---empcode, PAYMENT_TYPE, BANKNAME, BANKACCNO
           SET b.PAYMENT_TYPE = x.PAY_TYPE,
               b.BANKNAME = x.BANK,
               b.BANKACCNO = x.ACC_NO
         WHERE b.empcode = x.empcode;
    END LOOP;

    COMMIT;
END;