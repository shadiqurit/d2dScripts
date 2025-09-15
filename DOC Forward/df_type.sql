CREATE TABLE df_type
(
    type_id      NUMBER (15),
    type_name    VARCHAR2 (20 BYTE),
    type_desc    VARCHAR2 (150 BYTE),
    ent_by       VARCHAR2 (20 BYTE),
    ent_date     DATE,
    upd_by       VARCHAR2 (20 BYTE),
    upd_date     DATE
);

SET DEFINE OFF;
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (2, 'Office Order/ Memo', 'Office order Administration order', 'IPI-006410', TO_DATE('4/5/2023', 'MM/DD/YYYY'), 
    '05-APR-23', 'IPI-006410', TO_DATE('4/5/2023', 'MM/DD/YYYY'), '05-APR-23');
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (5, 'Manpower Note', 'Manpower Node', NULL, NULL, 
    NULL, NULL, NULL, NULL);
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (3, 'Notice / Circular', 'Requisition Note', 'IPI-006410', TO_DATE('4/5/2023', 'MM/DD/YYYY'), 
    '05-APR-23', 'IPI-006410', TO_DATE('4/5/2023', 'MM/DD/YYYY'), '05-APR-23');
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (6, 'Meeting Minutes', 'Meeting minute', NULL, NULL, 
    NULL, NULL, NULL, NULL);
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (7, 'Procurment Note', 'Procurment Note', NULL, NULL, 
    NULL, NULL, NULL, NULL);
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (1, 'General Note / Memo', 'General Note', 'IPI-006410', TO_DATE('12/28/2022', 'MM/DD/YYYY'), 
    '28-DEC-22', 'IPI-006410', TO_DATE('12/28/2022', 'MM/DD/YYYY'), '28-DEC-22');
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (8, 'IT Requisition', 'General', 'IPI-009129', TO_DATE('4/29/2025', 'MM/DD/YYYY'), 
    '29-APR-25', 'IPI-009129', TO_DATE('4/29/2025', 'MM/DD/YYYY'), '29-APR-25');
Insert into DF_TYPE
   (TYPE_ID, TYPE_NAME, TYPE_DESC, INSERT_BY, INSERT_DATE, 
    INSERT_TIME, UPDATE_BY, UPDATE_DATE, UPDATE_TIME)
 Values
   (4, 'Departmental Memo', 'Meeting Minutes', 'IPI-006410', TO_DATE('4/6/2023', 'MM/DD/YYYY'), 
    '06-APR-23', 'IPI-006410', TO_DATE('4/6/2023', 'MM/DD/YYYY'), '06-APR-23');
COMMIT;
