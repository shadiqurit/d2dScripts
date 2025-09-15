CREATE TABLE PUR_ITEM
(
  ITEM_ID    NUMBER,
  ITEM_NAME  VARCHAR2(100 BYTE),
  DEPT_NAME  VARCHAR2(200 BYTE),
  EMPCODE    VARCHAR2(30 BYTE),
  CREATE_BY  VARCHAR2(100 BYTE),
  UPDATE_BY  DATE,
  CCODE      VARCHAR2(20 BYTE),
  ID         NUMBER,
  UNITID     VARCHAR2(30 BYTE),
  ENT_BY     VARCHAR2(30 BYTE),
  ENT_DATE   DATE,
  UPD_BY     VARCHAR2(30 BYTE),
  UPD_DATE   DATE
);
SET DEFINE OFF;
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (1, 'Raw Material Api', 'Product Development', 'IPI-003357', 'DBMIS', 
    NULL, 'IPI', 1, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (2, 'Raw Material Excipient', 'Product Development', 'IPI-003357', 'DBMIS', 
    NULL, 'IPI', 2, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (3, 'Primary Packaging Material', 'Product Development', 'IPI-003357', 'DBMIS', 
    NULL, 'IPI', 3, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (4, 'Secondary Packaging Material', 'Product Development', 'IPI-003357', 'DBMIS', 
    NULL, 'IPI', 4, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (5, 'Civil & Plumbing', 'Engineering', 'IPI-005078', 'DBMIS', 
    NULL, 'IPI', 5, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (6, 'Engineering Machinary', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 6, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (7, 'Electrical', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 7, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (8, 'Eng. Chemical', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 8, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (9, 'Entertainment', 'Purchase', 'IPI-000831', 'DBMIS', 
    NULL, 'IPI', 9, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (10, 'Gift Item', 'Marketing', 'IPI-001360', 'DBMIS', 
    NULL, 'IPI', 10, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (11, 'Hand Tools', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 11, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (12, 'Literature', 'Marketing', 'IPI-001360', 'DBMIS', 
    NULL, 'IPI', 12, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (13, 'Machine Item', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 13, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (14, 'Production Machinary', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 14, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (15, 'Production Equipment & Accessories', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 15, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (16, 'Promotional', 'Marketing', 'IPI-001360', 'DBMIS', 
    NULL, 'IPI', 16, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (17, 'Qc Equipment', 'Quality Assurance', 'IPI-003571', 'DBMIS', 
    NULL, 'IPI', 17, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (18, 'Qc Reagent & Accessories', 'Quality Assurance', 'IPI-003571', 'DBMIS', 
    NULL, 'IPI', 18, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (19, 'Service', 'Purchase', 'IPI-000831', 'DBMIS', 
    NULL, 'IPI', 19, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (20, 'Spare Parts', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 20, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (21, 'Stationary', 'Administration', 'IPI-000827', 'DBMIS', 
    NULL, 'IPI', 21, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (22, 'Transport', 'Administration', 'IPI-000812', 'DBMIS', 
    NULL, 'IPI', 22, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (23, 'Utility and service Equipment', 'Engineering', 'IPI-008316', 'DBMIS', 
    NULL, 'IPI', 23, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (24, 'Computer & Accessories', 'Information Technology', 'IPI-002760', 'DBMIS', 
    NULL, 'IPI', 24, 'Unit-01', NULL, 
    NULL, NULL, NULL);
Insert into PUR_ITEM
   (ITEM_ID, ITEM_NAME, DEPT_NAME, EMPCODE, CREATE_BY, 
    UPDATE_BY, CCODE, ID, UNITID, ENT_BY, 
    ENT_DATE, UPD_BY, UPD_DATE)
 Values
   (25, 'Furniture', 'Accounts', 'IPI-004302', 'DBMIS', 
    NULL, 'IPI', 25, 'Unit-01', NULL, 
    NULL, NULL, NULL);
COMMIT;
