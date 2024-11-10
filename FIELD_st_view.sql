CREATE OR REPLACE FORCE VIEW DPUSER.FIELD_STRUC
AS
    SELECT EMPCODE_MIO,
           TERI_CODE,
           EMPCODE_ASM,
           AREA_CODE,
           EMPCODE_RSM,
           REGION_CODE,
           LEVEL0_EMPCODE,
           LEVEL1_EMPCODE,
           LEVEL2_EMPCODE,
          'IPI-004157' LEVEL3_EMPCODE, ---hARD CODE
           Unit,
           TERI_TYPE
      FROM (SELECT DISTINCT (CASE
                                 WHEN TERI_TYPE = 'Territory'
                                 THEN
                                     EMPCODE_MIO
                                 WHEN TERI_TYPE = 'Area'
                                 THEN
                                     EMPCODE_ASM
                                 WHEN TERI_TYPE = 'Region'
                                 THEN
                                     EMPCODE_RSM
                                 WHEN TERI_TYPE = 'Zone'
                                 THEN
                                     LEVEL0_EMPCODE
                                 WHEN TERI_TYPE = 'DMM'
                                 THEN
                                     LEVEL1_EMPCODE
                                 WHEN TERI_TYPE = 'MMM'
                                 THEN
                                     LEVEL2_EMPCODE
                                 WHEN TERI_TYPE = 'HOM'
                                 THEN
                                     LEVEL3_EMPCODE
                                 ELSE
                                     NULL
                             END)                 EMPCODE_MIO,
                            TERI_CODE,
                            (CASE
                                 WHEN TERI_TYPE = 'Territory'
                                 THEN
                                     EMPCODE_ASM
                                 WHEN TERI_TYPE != 'Territory'
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 EMPCODE_ASM,
                            AREA_CODE,
                            (CASE
                                 WHEN TERI_TYPE IN ('Territory', 'Area')
                                 THEN
                                     EMPCODE_RSM
                                 WHEN TERI_TYPE NOT IN ('Territory', 'Area')
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 EMPCODE_RSM,
                            REGION_CODE,
                            (CASE
                                 WHEN TERI_TYPE IN
                                          ('Territory', 'Area', 'Region')
                                 THEN
                                     LEVEL0_EMPCODE
                                 WHEN TERI_TYPE NOT IN
                                          ('Territory', 'Area', 'Region')
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 LEVEL0_EMPCODE,
                            (CASE
                                 WHEN TERI_TYPE IN ('Territory',
                                                    'Area',
                                                    'Region',
                                                    'Zone')
                                 THEN
                                     LEVEL1_EMPCODE
                                 WHEN TERI_TYPE NOT IN ('Territory',
                                                        'Area',
                                                        'Region',
                                                        'Zone')
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 LEVEL1_EMPCODE,
                            (CASE
                                 WHEN TERI_TYPE IN ('Territory',
                                                    'Area',
                                                    'Region',
                                                    'Zone',
                                                    'DMM')
                                 THEN
                                     LEVEL2_EMPCODE
                                 WHEN TERI_TYPE NOT IN ('Territory',
                                                        'Area',
                                                        'Region',
                                                        'Zone',
                                                        'DMM')
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 LEVEL2_EMPCODE,
                            (CASE
                                 WHEN TERI_TYPE IN ('Territory',
                                                    'Area',
                                                    'Region',
                                                    'Zone',
                                                    'DMM',
                                                    'MMM')
                                 THEN
                                     LEVEL3_EMPCODE
                                 WHEN TERI_TYPE NOT IN ('Territory',
                                                        'Area',
                                                        'Region',
                                                        'Zone',
                                                        'DMM',
                                                        'MMM')
                                 THEN
                                     NULL
                                 ELSE
                                     NULL
                             END)                 LEVEL3_EMPCODE,
                            DECODE (UNITID,
                                    1, 'Unit-01',
                                    2, 'Unit-02',
                                    'Unit-01')    Unit,
                            TERI_TYPE
              FROM TERRITORY@gplink
             WHERE LEVEL0_CODE NOT IN ('REGIONPH', 'REGIONNMD', 'REGIONTN'))
     WHERE EMPCODE_MIO IS NOT NULL;
