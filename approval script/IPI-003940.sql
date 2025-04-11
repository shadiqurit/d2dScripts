SET DEFINE OFF;
Insert into HR_EMP_SHIFT
   (YEARMN, EMPCODE, E_NAME, DESIG_CODE, DESIG_NAME, 
    DEPTID, SUBDEPTID, DT1, DT2, DT3, 
    DT4, DT5, DT6, DT7, DT8, 
    DT9, DT10, DT11, DT12, DT13, 
    DT14, DT15, DT16, DT17, DT18, 
    DT19, DT20, DT21, DT22, DT23, 
    DT24, DT25, DT26, DT27, DT28, 
    DT29, DT30, DT31, SHIFT_TYPE, DEPARTMENT_NAME, 
    BUSINESSUNITID, OVERLAPING_DAYS, DP_CODE)
 Values
   (202503, 'IPI-003940', 'MD. OBAIDUL ISLAM', NULL, 'SECURITY GUARD', 
    NULL, NULL, '06:00am02:00pm', '10:00pm06:00am', '10:00pm06:00am', 
    '10:00pm06:00am', '10:00pm06:00am', '10:00pm06:00am', '06:00pm12:00am', '02:00pm10:00pm', 
    '02:00pm10:00pm', '02:00pm10:00pm', '02:00pm10:00pm', '06:00am02:00pm', '06:00am02:00pm', 
    '06:00am12:00pm', '06:00am02:00pm', '06:00am02:00pm', '10:00pm06:00am', '10:00pm06:00am', 
    '10:00pm06:00am', '10:00pm06:00am', '13:00am06:00am', '02:00pm10:00pm', '02:00pm10:00pm', 
    '02:00pm10:00pm', '02:00pm10:00pm', '06:00pm12:00am', '06:00am02:00pm', '06:00am12:00pm', 
    '06:00am02:00pm', '06:00am12:00pm', NULL, 'GENERAL', 'Administration', 
    'Unit-01', NULL, 'FAC');
COMMIT;
