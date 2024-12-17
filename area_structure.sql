/* Formatted on 12/17/2024 12:18:07 PM (QP5 v5.362) */
SELECT * FROM AREA_STRUCTURE@NewSales;

SELECT ID,
       AREA_ID,
       AREA_NAME,
       PARENT_LEVEL_ID,
       PARENT_LEVEL_NAME,
       LEVEL0_ID,
       LEVEL0_NAME,
       LEVEL1_ID,
       LEVEL1_NAME,
       LEVEL2_ID,
       LEVEL2_NAME,
       LEVEL3_ID,
       LEVEL3_NAME,
       CREATED_ON,
       CREATED_BY,
       UPDATED_ON,
       UPDATED_BY,
       ORC_INSERT_DATE
  FROM v_area_struct;

CREATE TABLE AREA_STRUCTURE
(
    ID                   NUMBER,
    AREA_ID              VARCHAR2 (20 BYTE) DEFAULT NULL,
    AREA_NAME            VARCHAR2 (50 BYTE) DEFAULT NULL,
    PARENT_LEVEL_ID      VARCHAR2 (20 BYTE) DEFAULT NULL,
    PARENT_LEVEL_NAME    VARCHAR2 (50 BYTE) DEFAULT NULL,
    LEVEL0_ID            VARCHAR2 (20 BYTE) DEFAULT NULL,
    LEVEL0_NAME          VARCHAR2 (50 BYTE) DEFAULT NULL,
    LEVEL1_ID            VARCHAR2 (20 BYTE) DEFAULT NULL,
    LEVEL1_NAME          VARCHAR2 (50 BYTE) DEFAULT NULL,
    LEVEL2_ID            VARCHAR2 (20 BYTE) DEFAULT NULL,
    LEVEL2_NAME          VARCHAR2 (50 BYTE) DEFAULT NULL,
    LEVEL3_ID            VARCHAR2 (100 BYTE) DEFAULT NULL,
    LEVEL3_NAME          VARCHAR2 (50 BYTE) DEFAULT NULL,
    CREATED_ON           TIMESTAMP (6) DEFAULT SYSTIMESTAMP,
    CREATED_BY           VARCHAR2 (30 BYTE),
    UPDATED_ON           TIMESTAMP (6) DEFAULT NULL,
    UPDATED_BY           VARCHAR2 (30 BYTE),
    ORC_INSERT_DATE      DATE
);


ALTER TABLE AREA_STRUCTURE
    ADD (PRIMARY KEY (ID));



CREATE OR REPLACE PROCEDURE p_area_structure
AS
BEGIN
    MERGE INTO AREA_STRUCTURE target
         USING (SELECT ID,
                       AREA_ID,
                       AREA_NAME,
                       PARENT_LEVEL_ID,
                       PARENT_LEVEL_NAME,
                       LEVEL0_ID,
                       LEVEL0_NAME,
                       LEVEL1_ID,
                       LEVEL1_NAME,
                       LEVEL2_ID,
                       LEVEL2_NAME,
                       LEVEL3_ID,
                       LEVEL3_NAME,
                       CREATED_ON,
                       CREATED_BY,
                       UPDATED_ON,
                       UPDATED_BY,
                       ORC_INSERT_DATE
                  FROM v_area_struct) source
            ON (target.ID = source.ID)                      -- Match condition
    WHEN MATCHED
    THEN
        UPDATE SET target.AREA_ID = source.AREA_ID,
                   target.AREA_NAME = source.AREA_NAME,
                   target.PARENT_LEVEL_ID = source.PARENT_LEVEL_ID,
                   target.PARENT_LEVEL_NAME = source.PARENT_LEVEL_NAME,
                   target.LEVEL0_ID = source.LEVEL0_ID,
                   target.LEVEL0_NAME = source.LEVEL0_NAME,
                   target.LEVEL1_ID = source.LEVEL1_ID,
                   target.LEVEL1_NAME = source.LEVEL1_NAME,
                   target.LEVEL2_ID = source.LEVEL2_ID,
                   target.LEVEL2_NAME = source.LEVEL2_NAME,
                   target.LEVEL3_ID = source.LEVEL3_ID,
                   target.LEVEL3_NAME = source.LEVEL3_NAME,
                   target.UPDATED_ON = SYSTIMESTAMP,
                   target.UPDATED_BY = source.UPDATED_BY,
                   target.ORC_INSERT_DATE = source.ORC_INSERT_DATE
    WHEN NOT MATCHED
    THEN
        INSERT     (ID,
                    AREA_ID,
                    AREA_NAME,
                    PARENT_LEVEL_ID,
                    PARENT_LEVEL_NAME,
                    LEVEL0_ID,
                    LEVEL0_NAME,
                    LEVEL1_ID,
                    LEVEL1_NAME,
                    LEVEL2_ID,
                    LEVEL2_NAME,
                    LEVEL3_ID,
                    LEVEL3_NAME,
                    CREATED_ON,
                    CREATED_BY,
                    UPDATED_ON,
                    UPDATED_BY,
                    ORC_INSERT_DATE)
            VALUES (source.ID,
                    source.AREA_ID,
                    source.AREA_NAME,
                    source.PARENT_LEVEL_ID,
                    source.PARENT_LEVEL_NAME,
                    source.LEVEL0_ID,
                    source.LEVEL0_NAME,
                    source.LEVEL1_ID,
                    source.LEVEL1_NAME,
                    source.LEVEL2_ID,
                    source.LEVEL2_NAME,
                    source.LEVEL3_ID,
                    source.LEVEL3_NAME,
                    source.CREATED_ON,
                    source.CREATED_BY,
                    SYSTIMESTAMP,
                    source.UPDATED_BY,
                    source.ORC_INSERT_DATE);

    COMMIT;                          -- Commit the transaction to save changes

    DBMS_OUTPUT.PUT_LINE (
        'Data successfully updated or inserted into AREA_STRUCTURE.');
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;                                -- Roll back changes on error
        DBMS_OUTPUT.PUT_LINE ('Error occurred: ' || SQLERRM);
END p_area_structure;
/


CREATE OR REPLACE PROCEDURE p_sup_area
AS
BEGIN
    MERGE INTO SUP_AREA target
         USING (SELECT ID,
                       SUP_ID,
                       NAME,
                       AREA_ID,
                       AREA_NAME,
                       LEVEL_DEPTH_NO,
                       CREATED_ON,
                       CREATED_BY,
                       UPDATED_ON,
                       UPDATED_BY,
                       ORC_INSERT_DATE
                  FROM v_sup_area) source
            ON (target.ID = source.ID) -- Match condition: ID is the unique key
    WHEN MATCHED
    THEN
        UPDATE SET target.SUP_ID = source.SUP_ID,
                   target.NAME = source.NAME,
                   target.AREA_ID = source.AREA_ID,
                   target.AREA_NAME = source.AREA_NAME,
                   target.LEVEL_DEPTH_NO = source.LEVEL_DEPTH_NO,
                   target.UPDATED_ON = SYSTIMESTAMP,
                   target.UPDATED_BY = source.UPDATED_BY,
                   target.ORC_INSERT_DATE = source.ORC_INSERT_DATE
    WHEN NOT MATCHED
    THEN
        INSERT     (ID,
                    SUP_ID,
                    NAME,
                    AREA_ID,
                    AREA_NAME,
                    LEVEL_DEPTH_NO,
                    CREATED_ON,
                    CREATED_BY,
                    UPDATED_ON,
                    UPDATED_BY,
                    ORC_INSERT_DATE)
            VALUES (source.ID,
                    source.SUP_ID,
                    source.NAME,
                    source.AREA_ID,
                    source.AREA_NAME,
                    source.LEVEL_DEPTH_NO,
                    SYSTIMESTAMP,
                    source.CREATED_BY,
                    SYSTIMESTAMP,
                    source.UPDATED_BY,
                    source.ORC_INSERT_DATE);

    COMMIT;                                          -- Commit the transaction

    DBMS_OUTPUT.PUT_LINE ('Data successfully merged into SUP_AREA table.');
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;                             -- Rollback transaction on error
        DBMS_OUTPUT.PUT_LINE ('Error occurred: ' || SQLERRM);
END p_sup_area;
/



CREATE OR REPLACE PROCEDURE p_rep_area
AS
BEGIN
    MERGE INTO REP_AREA target
    USING (
        SELECT ID,
               REP_ID,
               NAME,
               REP_CATEGORY,
               AREA_ID,
               AREA_NAME,
               CREATED_ON,
               CREATED_BY,
               UPDATED_ON,
               UPDATED_BY,
               ORC_INSERT_DATE
          FROM v_rep_area
    ) source
    ON (target.ID = source.ID) -- Match condition: ID as the unique key
    WHEN MATCHED THEN
        UPDATE SET
            target.REP_ID          = source.REP_ID,
            target.NAME            = source.NAME,
            target.REP_CATEGORY    = source.REP_CATEGORY,
            target.AREA_ID         = source.AREA_ID,
            target.AREA_NAME       = source.AREA_NAME,
            target.UPDATED_ON      = SYSTIMESTAMP,
            target.UPDATED_BY      = source.UPDATED_BY,
            target.ORC_INSERT_DATE = source.ORC_INSERT_DATE
    WHEN NOT MATCHED THEN
        INSERT (
            ID, REP_ID, NAME, REP_CATEGORY, AREA_ID, AREA_NAME,
            CREATED_ON, CREATED_BY, UPDATED_ON, UPDATED_BY, ORC_INSERT_DATE
        )
        VALUES (
            source.ID, source.REP_ID, source.NAME, source.REP_CATEGORY,
            source.AREA_ID, source.AREA_NAME, SYSTIMESTAMP, source.CREATED_BY,
            SYSTIMESTAMP, source.UPDATED_BY, source.ORC_INSERT_DATE
        );

    COMMIT; -- Commit transaction

    DBMS_OUTPUT.PUT_LINE('Data successfully merged into REP_AREA table.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Rollback transaction in case of an error
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END p_rep_area;
/
