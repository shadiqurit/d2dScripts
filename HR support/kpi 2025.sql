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
           SYSDATE,
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

The Management of The IBN SINA Pharmaceutical Industry PLC has been pleased to grant you the allowance for special achievement of 1 (One )  increment equivalent financial benefit  of your scale of pay 17050-1530x10-32350-EB-1580x15-56050 of GRADE-07 with effect from 01-JAN-25

Your Pay and Allowances are as follows :'
 WHERE REFDATE = TO_DATE('1/1/2025', 'MM/DD/YYYY')
AND LTYPE = '116'
AND NO_OFINCR = 1;