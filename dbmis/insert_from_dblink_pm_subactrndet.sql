CREATE OR REPLACE PROCEDURE insert_from_dblink_pm_subactrndet
IS
   v_insert_count   NUMBER := 0;
   v_row_count      NUMBER := 0;
BEGIN
   -- Get current row count before truncate
   SELECT COUNT(*) INTO v_row_count FROM t_pm_subactrndet;
   
   -- Truncate table using dynamic SQL
   EXECUTE IMMEDIATE 'TRUNCATE TABLE t_pm_subactrndet';
   
   DBMS_OUTPUT.put_line (
      'Truncated ' || v_row_count || ' existing rows from t_pm_subactrndet.');

   -- Insert fresh data from dblink using dynamic SQL
   EXECUTE IMMEDIATE '
      INSERT INTO t_pm_subactrndet (REFNO,
                                    MVOUCHERNO,
                                    ENTRYDATE,
                                    STATUS,
                                    PERIOD,
                                    DESCRIPTION,
                                    VDATE,
                                    PARTYID,
                                    DRCR,
                                    SACTCODE,
                                    SACTNAME,
                                    REFACCOUNTCODE,
                                    VOUCHERNO,
                                    REFVOUCHERNO,
                                    NARRATIVE,
                                    PASTSTATUS,
                                    AMOUNT,
                                    DRAMOUNT,
                                    CRAMOUNT,
                                    CCODE,
                                    USERNAME,
                                    VOUCHERSN,
                                    REFACTCODE,
                                    DPCODE,
                                    OREFACTCODE,
                                    OREFACTID,
                                    REC_STATUS,
                                    UNITID,
                                    CHEQUENO_C,
                                    CHEQUE_NO,
                                    CHEQUE_DATE,
                                    ACTTYPE,
                                    PAYTYPE,
                                    PAYTO,
                                    ONAC_OFNAME)
           SELECT REFNO,
                  MVOUCHERNO,
                  ENTRYDATE,
                  STATUS,
                  PERIOD,
                  DESCRIPTION,
                  VDATE,
                  PARTYID,
                  DRCR,
                  SACTCODE,
                  SACTNAME,
                  REFACCOUNTCODE,
                  VOUCHERNO,
                  REFVOUCHERNO,
                  NARRATIVE,
                  PASTSTATUS,
                  AMOUNT,
                  DRAMOUNT,
                  CRAMOUNT,
                  CCODE,
                  USERNAME,
                  VOUCHERSN,
                  REFACTCODE,
                  DPCODE,
                  OREFACTCODE,
                  OREFACTID,
                  REC_STATUS,
                  UNITID,
                  CHEQUENO_C,
                  CHEQUE_NO,
                  CHEQUE_DATE,
                  ACTTYPE,
                  PAYTYPE,
                  PAYTO,
                  ONAC_OFNAME
             FROM PM_SUBACTRNDET@hlink';

   -- Get number of rows inserted
   v_insert_count := SQL%ROWCOUNT;

   -- Commit the transaction
   COMMIT;

   -- Log the result
   DBMS_OUTPUT.put_line (
      'Successfully inserted ' || v_insert_count || ' fresh rows from PM_SUBACTRNDET@hlink.');
   DBMS_OUTPUT.put_line (
      'Total operation: Removed ' || v_row_count || ' old rows, Inserted ' || v_insert_count || ' new rows.');
EXCEPTION
   WHEN OTHERS
   THEN
      -- Rollback in case of error
      ROLLBACK;

      -- Log the error
      DBMS_OUTPUT.put_line (
         'Error in data refresh from dblink: ' || SQLERRM);

      -- Re-raise the exception
      RAISE;
END insert_from_dblink_pm_subactrndet;
/