CREATE OR REPLACE PROCEDURE HRMS.merge_into_t_structure
AS
BEGIN
    MERGE INTO T_STRUCTURE target
         USING (SELECT 2 || id       AS id,
                       dept_name     STR_NAME,
                       'DEPT'        STR_TYPE,
                       ''            code,
                       2             parent_id,
                       1             status
                  FROM DEPARTMENTS) source
            ON (target.id = source.id)
    WHEN MATCHED
    THEN
        UPDATE SET target.STR_NAME = source.STR_NAME,
                   target.STR_TYPE = source.STR_TYPE,
                   target.CODE = source.code,
                   target.PARENT_ID = source.parent_id,
                   target.status = source.status
    WHEN NOT MATCHED
    THEN
        INSERT     (id,
                    STR_NAME,
                    STR_TYPE,
                    CODE,
                    PARENT_ID,
                    status)
            VALUES (source.id,
                    source.STR_NAME,
                    source.STR_TYPE,
                    source.code,
                    source.parent_id,
                    source.status);

    COMMIT;
END;
/
