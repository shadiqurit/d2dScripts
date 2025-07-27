/* Formatted on 7/20/2025 4:28:36 PM (QP5 v5.362) */
INSERT INTO hr_review_history (SLNO,
                               REFNO,
                               REFDATE,
                               EMPCODE,
                               DPCODE,
                               USERNAME,
                               CCODE,
                               AMOUNT,
                               EDATE,
                               EMP_HRCODE,
                               INCRTYPE,
                               DATASOURCE,
                               YEARMN,
                               SGRADE_BEFORE,
                               SGRADE_AFTER,
                               INCRRATE,
                               DEPT,
                               DESIG_NAME_BEFORE,
                               DESIG_NAME_AFTER,
                               CONSIDER_NEXT_REVIEW,
                               STOP_REFNO)
    SELECT SLNO,
           REFNO,
           REFDATE,
           EMPCODE,
           DP_CODE,
           USERNAME,
           CCODE,
           AMOUNT,
           EDATE,
           EMPCODE,
           INCRTYPE,
           'Auto'     DATASOURCE,
           YEARMN,
           SGRADE_BEFORE,
           SGRADE_AFTER,
           INCRRATE,
           DEPARTMENT_NAME,
           DESIG_NAME_BEFORE,
           DESIG_NAME_BEFORE,
           CONSIDER_NEXT_REVIEW,
           'N'
      FROM V_REVIEW_HISTORY_WO;
      
      
   UPDATE EMP 
   SET DESIG_NAME_OLD = desig_name
 WHERE EMP_STATUS = 'A' AND  CATA = 'NON OFFICER' AND DESIG_NAME LIKE '%SALES REP%';
 
 UPDATE EMP 
   SET desig_name = 'DISTRIBUTION REP.',
   DESIG_CODE = 'DES-283'
 WHERE EMP_STATUS = 'A' AND  CATA = 'NON OFFICER' AND DESIG_NAME = 'SR. SALES REP.';