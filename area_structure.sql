/* Formatted on 1/5/2025 12:59:44 PM (QP5 v5.362) */

CREATE TABLE t_structure
(
    id           NUMBER,
    str_name     VARCHAR2 (50),
    str_type     VARCHAR2 (20),
    parent_id    NUMBER,
    dept_id      NUMBER,
    comp_id      NUMBER,
    unit         NUMBER,
    status       VARCHAR2 (20),
    ent_by       NUMBER,
    ent_date     DATE DEFAULT SYSDATE,
    upd_by       NUMBER,
    upd_date     DATE
);
/
CREATE OR REPLACE FORCE VIEW V_SUP_AREA
AS
    SELECT ID,
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
      FROM SUP_AREA@NewSales;


CREATE OR REPLACE FORCE VIEW V_AREA_STRUCT
AS
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
      FROM AREA_STRUCTURE@NewSales;

CREATE OR REPLACE FORCE VIEW V_REP_AREA
AS
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
      FROM REP_AREA@NewSales;

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

CREATE TABLE SUP_AREA
(
    ID                 NUMBER,
    SUP_ID             VARCHAR2 (20 BYTE),
    NAME               VARCHAR2 (50 BYTE),
    AREA_ID            VARCHAR2 (20 BYTE),
    AREA_NAME          VARCHAR2 (50 BYTE),
    LEVEL_DEPTH_NO     NUMBER (2),
    CREATED_ON         TIMESTAMP (6) DEFAULT SYSTIMESTAMP,
    CREATED_BY         VARCHAR2 (30 BYTE),
    UPDATED_ON         TIMESTAMP (6),
    UPDATED_BY         VARCHAR2 (30 BYTE),
    ORC_INSERT_DATE    DATE
);

CREATE TABLE REP_AREA
(
    ID                 NUMBER,
    REP_ID             VARCHAR2 (20 BYTE),
    NAME               VARCHAR2 (50 BYTE),
    REP_CATEGORY       VARCHAR2 (20 BYTE),
    AREA_ID            VARCHAR2 (20 BYTE),
    AREA_NAME          VARCHAR2 (50 BYTE),
    CREATED_ON         TIMESTAMP (6) DEFAULT SYSTIMESTAMP,
    CREATED_BY         VARCHAR2 (30 BYTE),
    UPDATED_ON         TIMESTAMP (6),
    UPDATED_BY         VARCHAR2 (30 BYTE),
    ORC_INSERT_DATE    DATE
);


ALTER TABLE REP_AREA
    ADD (PRIMARY KEY (ID));


ALTER TABLE SUP_AREA
    ADD (PRIMARY KEY (ID));


ALTER TABLE AREA_STRUCTURE
    ADD (PRIMARY KEY (ID));

CREATE OR REPLACE PROCEDURE p_area_structure
AS
BEGIN
    MERGE INTO AREA_STRUCTURE trg
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
            ON (trg.ID = src.ID)                         -- Match condition
    WHEN MATCHED
    THEN
        UPDATE SET trg.AREA_ID = src.AREA_ID,
                   trg.AREA_NAME = src.AREA_NAME,
                   trg.PARENT_LEVEL_ID = src.PARENT_LEVEL_ID,
                   trg.PARENT_LEVEL_NAME = src.PARENT_LEVEL_NAME,
                   trg.LEVEL0_ID = src.LEVEL0_ID,
                   trg.LEVEL0_NAME = src.LEVEL0_NAME,
                   trg.LEVEL1_ID = src.LEVEL1_ID,
                   trg.LEVEL1_NAME = src.LEVEL1_NAME,
                   trg.LEVEL2_ID = src.LEVEL2_ID,
                   trg.LEVEL2_NAME = src.LEVEL2_NAME,
                   trg.LEVEL3_ID = src.LEVEL3_ID,
                   trg.LEVEL3_NAME = src.LEVEL3_NAME,
                   trg.UPDATED_ON = SYSTIMESTAMP,
                   trg.UPDATED_BY = src.UPDATED_BY,
                   trg.ORC_INSERT_DATE = src.ORC_INSERT_DATE
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
    MERGE INTO SUP_AREA trg
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
            ON (trg.ID = src.ID)   -- Match condition: ID is the unique key
    WHEN MATCHED
    THEN
        UPDATE SET trg.SUP_ID = src.SUP_ID,
                   trg.NAME = src.NAME,
                   trg.AREA_ID = src.AREA_ID,
                   trg.AREA_NAME = src.AREA_NAME,
                   trg.LEVEL_DEPTH_NO = src.LEVEL_DEPTH_NO,
                   trg.UPDATED_ON = SYSTIMESTAMP,
                   trg.UPDATED_BY = src.UPDATED_BY,
                   trg.ORC_INSERT_DATE = src.ORC_INSERT_DATE
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
    MERGE INTO REP_AREA trg
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
            ON (trg.ID = src.ID)   -- Match condition: ID as the unique key
    WHEN MATCHED
    THEN
        UPDATE SET trg.REP_ID = src.REP_ID,
                   trg.NAME = src.NAME,
                   trg.REP_CATEGORY = src.REP_CATEGORY,
                   trg.AREA_ID = src.AREA_ID,
                   trg.AREA_NAME = src.AREA_NAME,
                   trg.UPDATED_ON = SYSTIMESTAMP,
                   trg.UPDATED_BY = src.UPDATED_BY,
                   trg.ORC_INSERT_DATE = src.ORC_INSERT_DATE
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