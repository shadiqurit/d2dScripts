/* Formatted on 12/22/2024 1:03:06 PM (QP5 v5.362) */
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
                  FROM v_area_struct) src
            ON (target.ID = src.ID)                         -- Match condition
    WHEN MATCHED
    THEN
        UPDATE SET target.AREA_ID = src.AREA_ID,
                   target.AREA_NAME = src.AREA_NAME,
                   target.PARENT_LEVEL_ID = src.PARENT_LEVEL_ID,
                   target.PARENT_LEVEL_NAME = src.PARENT_LEVEL_NAME,
                   target.LEVEL0_ID = src.LEVEL0_ID,
                   target.LEVEL0_NAME = src.LEVEL0_NAME,
                   target.LEVEL1_ID = src.LEVEL1_ID,
                   target.LEVEL1_NAME = src.LEVEL1_NAME,
                   target.LEVEL2_ID = src.LEVEL2_ID,
                   target.LEVEL2_NAME = src.LEVEL2_NAME,
                   target.LEVEL3_ID = src.LEVEL3_ID,
                   target.LEVEL3_NAME = src.LEVEL3_NAME,
                   target.UPDATED_ON = SYSTIMESTAMP,
                   target.UPDATED_BY = src.UPDATED_BY,
                   target.ORC_INSERT_DATE = src.ORC_INSERT_DATE
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
            VALUES (src.ID,
                    src.AREA_ID,
                    src.AREA_NAME,
                    src.PARENT_LEVEL_ID,
                    src.PARENT_LEVEL_NAME,
                    src.LEVEL0_ID,
                    src.LEVEL0_NAME,
                    src.LEVEL1_ID,
                    src.LEVEL1_NAME,
                    src.LEVEL2_ID,
                    src.LEVEL2_NAME,
                    src.LEVEL3_ID,
                    src.LEVEL3_NAME,
                    src.CREATED_ON,
                    src.CREATED_BY,
                    SYSTIMESTAMP,
                    src.UPDATED_BY,
                    src.ORC_INSERT_DATE);

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
                  FROM v_sup_area) src
            ON (target.ID = src.ID)   -- Match condition: ID is the unique key
    WHEN MATCHED
    THEN
        UPDATE SET target.SUP_ID = src.SUP_ID,
                   target.NAME = src.NAME,
                   target.AREA_ID = src.AREA_ID,
                   target.AREA_NAME = src.AREA_NAME,
                   target.LEVEL_DEPTH_NO = src.LEVEL_DEPTH_NO,
                   target.UPDATED_ON = SYSTIMESTAMP,
                   target.UPDATED_BY = src.UPDATED_BY,
                   target.ORC_INSERT_DATE = src.ORC_INSERT_DATE
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
            VALUES (src.ID,
                    src.SUP_ID,
                    src.NAME,
                    src.AREA_ID,
                    src.AREA_NAME,
                    src.LEVEL_DEPTH_NO,
                    SYSTIMESTAMP,
                    src.CREATED_BY,
                    SYSTIMESTAMP,
                    src.UPDATED_BY,
                    src.ORC_INSERT_DATE);

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
         USING (SELECT ID,
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
                  FROM v_rep_area) src
            ON (target.ID = src.ID)   -- Match condition: ID as the unique key
    WHEN MATCHED
    THEN
        UPDATE SET target.REP_ID = src.REP_ID,
                   target.NAME = src.NAME,
                   target.REP_CATEGORY = src.REP_CATEGORY,
                   target.AREA_ID = src.AREA_ID,
                   target.AREA_NAME = src.AREA_NAME,
                   target.UPDATED_ON = SYSTIMESTAMP,
                   target.UPDATED_BY = src.UPDATED_BY,
                   target.ORC_INSERT_DATE = src.ORC_INSERT_DATE
    WHEN NOT MATCHED
    THEN
        INSERT     (ID,
                    REP_ID,
                    NAME,
                    REP_CATEGORY,
                    AREA_ID,
                    AREA_NAME,
                    CREATED_ON,
                    CREATED_BY,
                    UPDATED_ON,
                    UPDATED_BY,
                    ORC_INSERT_DATE)
            VALUES (src.ID,
                    src.REP_ID,
                    src.NAME,
                    src.REP_CATEGORY,
                    src.AREA_ID,
                    src.AREA_NAME,
                    SYSTIMESTAMP,
                    src.CREATED_BY,
                    SYSTIMESTAMP,
                    src.UPDATED_BY,
                    src.ORC_INSERT_DATE);

    COMMIT;                                              -- Commit transaction

    DBMS_OUTPUT.PUT_LINE ('Data successfully merged into REP_AREA table.');
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;                  -- Rollback transaction in case of an error
        DBMS_OUTPUT.PUT_LINE ('Error occurred: ' || SQLERRM);
END p_rep_area;
/

BEGIN
    SYS.DBMS_SCHEDULER.DROP_JOB (job_name => 'IPIHR.J_FIELD_EMP_AREA_TRNSF');
END;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'J_FIELD_EMP_AREA_TRNSF',
        job_type          => 'PLSQL_BLOCK',
        job_action        =>
            'BEGIN  p_rep_area; p_sup_area; p_area_structure; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=HOURLY; INTERVAL=6',
        enabled           => TRUE);
END;
/



BEGIN
    p_sup_area;
    p_area_structure;
    p_rep_area;
END;



SELECT COUNT (REP_ID)     cnt
  FROM rep_area
 WHERE REP_ID NOT IN (SELECT sup_id FROM sup_area);

SELECT COUNT (sup_id)     cnt
  FROM sup_area
 WHERE sup_id NOT IN (SELECT REP_ID FROM rep_area);


SELECT LEVEL0_NAME,
       LEVEL1_NAME,
       LEVEL2_NAME,
       AREA_NAME
  FROM area_structure
 WHERE area_id IN
           (SELECT CASE
                       WHEN REP_CATEGORY IN ('A', 'B', 'Z')
                       THEN
                           AREA_ID
                       WHEN REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%'
                       THEN
                           AREA_ID
                       ELSE
                           NULL
                   END    AS AREA_ID
              FROM rep_area
             WHERE     rep_id = :P557_EMPCODE
                   AND (   (REP_CATEGORY IN ('A', 'B'))
                        OR (REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%'))
             FETCH FIRST 1 ROW ONLY);


SELECT CASE
           WHEN REP_CATEGORY IN ('A', 'B', 'Z') THEN AREA_ID
           WHEN REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%' THEN AREA_ID
           ELSE NULL
       END    AS AREA_ID
  FROM rep_area
 WHERE     rep_id = :P557_EMPCODE
       AND (   (REP_CATEGORY IN ('A', 'B'))
            OR (REP_CATEGORY = 'SV' AND AREA_ID LIKE 'SV%'))
 FETCH FIRST 1 ROW ONLY;