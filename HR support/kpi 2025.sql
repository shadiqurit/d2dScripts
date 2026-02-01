/* Formatted on 8/24/2025 1:50:03 PM (QP5 v5.362) */
SET DEFINE OFF;
INSERT INTO HR_EMPCHANGE (REFNO,
                          REFDATE,
                          LTYPE,
                          EMPCODE,
                          AMOUNT,
                          EDATE,
                          EMP_HRCODE,
                          INCRTYPE,
                          NO_OFINCR,
                          INCRRATE,
                          LTYPEDES)
    SELECT REFNO,
           EFFECTIVE_DATE,
           116,
           EMPCODE,
           ALLOWANCE,
           to_char (SYSDATE, 'MM/DD/YYYY') dt ,
           EMPCODE,
           'Anual',
           NO_OF_INCR,
           ALLOWANCE,
           'Allowance for Special Achievement'
      FROM kpi_reward
     WHERE refno <> '116202508/1';


UPDATE HR_EMPCHANGE e
   SET e.TXT1 = 'Mohtaram,

Assalamu Alaikum Wa-Rahmatullah.

The Management of The IBN SINA Pharmaceutical Industry PLC has been pleased to grant you the allowance for special achievement of 3 (Three ) Special increment equivalent financial benefit, effect from 01-JAN-25

Your Pay and Allowances are as follows :'
 WHERE REFDATE = TO_DATE('1/1/2025', 'MM/DD/YYYY')
 and EDATE = TO_DATE('9/24/2025 5:43:19 AM', 'MM/DD/YYYY HH:MI:SS AM')
AND LTYPE = '116'
AND NO_OFINCR = 3;


/* Formatted on 9/24/2025 12:37:05 PM (QP5 v5.362) */
DECLARE
    CURSOR dt IS
        SELECT empcode,
               DESIGCODE,
               AMOUNTPRV,
               amountcur,
               salper
          FROM V_KPI_DATA121;
BEGIN
    FOR x IN dt
    LOOP
        UPDATE hr_empsalstructure b
           SET b.AMOUNTPRV = x.AMOUNTPRV,
               b.AMOUNTCUR = x.AMOUNTCUR,
               b.SALPER = x.SALPER,
               b.DESIGCODE = x.DESIGCODE
         WHERE b.EMPCODE = x.empcode AND slno = 121;
    END LOOP;

    COMMIT;
END;