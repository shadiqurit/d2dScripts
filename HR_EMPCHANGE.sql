SET DEFINE OFF;
Insert into HR_EMPCHANGE
   (REFNO, REFDATE, LTYPE, CHFROM, CHTO, 
    EMPCODE, DPTO, DPCODE, USERNAME, CCODE, 
    AMOUNT, TOCODE, FRMCODE, TERICODE, EDATE, 
    EMP_HRCODE, TARM_TYPE, INCRTYPE, SALARYB4INCR, SALARYAFTERINCR, 
    LASTINCRDATE, LASTINCRAMOUNT, LASTCONFST, DATASOURCE, HRREFNO, 
    PERIOD, ARREARVALUE, YEAROFAPP, SHOWCAUSE_NO, ACH, 
    AMOUNT_PROMO, UPKEEPING, DESPATCHNO, YEARMN, PUPKEEP, 
    NO_OFINCR, SGRADE_BEFORE, SGRADE_AFTER, INCRRATE, TXT1, 
    TXT2, DIVCODE, DEPT, SUBDEPT, SALARYSTEP, 
    LTYPEDES, SIGN_EMPCODE, SIGN_DESIG, OTHERAMOUNT, OTHERAMOUNTALLOW, 
    TRANSFERTYPE, TERINAME, SIGN_ENAME, TERRITORY_ID, TERRITORY_NAME, 
    AREA_ID, AREA_NAME, REGION_ID, REGION_NAME, DP_CODE, 
    DESIG_NAME_BEFORE, DESIG_NAME_AFTER, DESIG_CODE_BEFORE, DESIG_CODE_AFTER, EBRATE, 
    NO_OFINCR_EB, AMOUNT_EB, SLNO, INCRRATE_P, EBRATE_P, 
    ARREAR_C, ARREAR_P, AMOUNT_P, P_MONTH, P_DAY, 
    C_MONTH, C_DAY, GET_EB, UNITID_EC)
 Values
   ('102202407/79', TO_DATE('01/Jul/24', 'DD/MON/YY'), '102', NULL, NULL, 
    'IPI-007001', NULL, 'SYL', 'IPI-006231', 'IPI', 
    3375, NULL, NULL, 'SYL332', TO_DATE('06/Jul/24', 'DD/MON/YY'), 
    'IPI-007001', NULL, 'Promotional', 10800, 14175, 
    NULL, NULL, NULL, 'M', NULL, 
    NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, 
    5, 'GRADE-13', 'GRADE-12', 675, 'Assalamu Alaikum Warahmatualla', 
    'Assalamu Alaikum Warahmatualla', NULL, 'Marketing', NULL, 1, 
    'Promotion Letter', NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, 
    'MEDICAL PROMOTION OFFICER-2', 'MEDICAL PROMOTION OFFICER-1', 'DES-181', 'DES-226', 675, 
    NULL, NULL, 6, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, 'N', 'Unit-01');
COMMIT;
SET DEFINE OFF;
Insert into HR_REVIEW_HISTORY
   (SLNO, REFNO, REFDATE, LTYPE, EMPCODE, 
    DPCODE, USERNAME, CCODE, AMOUNT, TOCODE, 
    FRMCODE, EDATE, EMP_HRCODE, INCRTYPE, LASTINCRDATE, 
    DATASOURCE, YEARMN, NO_OFINCR, SGRADE_BEFORE, SGRADE_AFTER, 
    INCRRATE, DEPT, SUBDEPT, TRANSFERTYPE, DESIG_NAME_BEFORE, 
    DESIG_NAME_AFTER, CONSIDER_NEXT_REVIEW, STOP_REFNO, UPDATEDATE, UPDATEBY, 
    DP_CODE, DP_NAME)
 Values
   (6, '102202407/79', TO_DATE('01/Jul/24', 'DD/MON/YY'), '102', 'IPI-007001', 
    'SYL', 'IPI-006231', 'IPI', 3375, NULL, 
    NULL, TO_DATE('06/Jul/24', 'DD/MON/YY'), 'IPI-007001', 'Promotional', NULL, 
    'Auto', NULL, 5, 'GRADE-13', 'GRADE-12', 
    675, 'Marketing', NULL, NULL, 'MEDICAL PROMOTION OFFICER-2', 
    'MEDICAL PROMOTION OFFICER-1', 'Y', 'N', NULL, NULL, 
    NULL, NULL);
COMMIT;
