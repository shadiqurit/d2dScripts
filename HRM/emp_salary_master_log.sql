/* Formatted on 2/26/2026 10:38:26 AM (QP5 v5.362) */
CREATE TABLE EMP_SALARY_MASTER_log
AS
    SELECT * FROM EMP_SALARY_MASTER;
/

ALTER TABLE EMP_SALARY_MASTER_log
    ADD sid NUMBER;
/

ALTER TABLE EMP_SALARY_MASTER_log
    ADD serial# NUMBER;
/

ALTER TABLE EMP_SALARY_MASTER_log
    ADD action_date DATE;
/

ALTER TABLE EMP_SALARY_MASTER_log
    ADD action_status VARCHAR2 (5);
/

CREATE OR REPLACE TRIGGER TRI_EMP_SALARY_MASTER_LOG
    AFTER DELETE OR INSERT OR UPDATE
    ON EMP_SALARY_MASTER
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    SELECT sid, serial#
      INTO v_sid, v_serial
      FROM v$session
     WHERE audsid = USERENV ('SESSIONID');

    IF INSERTING
    THEN
        INSERT INTO EMP_SALARY_MASTER_log (EMP_SALARY_ID,
                                           EMP_ID,
                                           AGROSS,
                                           ABASIC,
                                           AHR,
                                           BGROSS,
                                           BBASIC,
                                           BHR,
                                           FA,
                                           MA,
                                           TA,
                                           DA,
                                           OTH_ALLOWANCE,
                                           TECH_ALLOWANCE,
                                           ACTIVE_FLAG,
                                           EFFECTIVE_DATE,
                                           ENT_BY,
                                           ENT_DATE,
                                           UPD_BY,
                                           UPD_DATE,
                                           sid,
                                           serial#,
                                           action_date,
                                           action_status)
             VALUES (:new.EMP_SALARY_ID,
                     :new.EMP_ID,
                     :new.AGROSS,
                     :new.ABASIC,
                     :new.AHR,
                     :new.BGROSS,
                     :new.BBASIC,
                     :new.BHR,
                     :new.FA,
                     :new.MA,
                     :new.TA,
                     :new.DA,
                     :new.OTH_ALLOWANCE,
                     :new.TECH_ALLOWANCE,
                     :new.ACTIVE_FLAG,
                     :new.EFFECTIVE_DATE,
                     :new.ENT_BY,
                     :new.ENT_DATE,
                     :new.UPD_BY,
                     :new.UPD_DATE,
                     v_sid,
                     v_serial,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO EMP_SALARY_MASTER_log (EMP_SALARY_ID,
                                           EMP_ID,
                                           AGROSS,
                                           ABASIC,
                                           AHR,
                                           BGROSS,
                                           BBASIC,
                                           BHR,
                                           FA,
                                           MA,
                                           TA,
                                           DA,
                                           OTH_ALLOWANCE,
                                           TECH_ALLOWANCE,
                                           ACTIVE_FLAG,
                                           EFFECTIVE_DATE,
                                           ENT_BY,
                                           ENT_DATE,
                                           UPD_BY,
                                           UPD_DATE,
                                           sid,
                                           serial#,
                                           action_date,
                                           action_status)
             VALUES (:old.EMP_SALARY_ID,
                     :old.EMP_ID,
                     :old.AGROSS,
                     :old.ABASIC,
                     :old.AHR,
                     :old.BGROSS,
                     :old.BBASIC,
                     :old.BHR,
                     :old.FA,
                     :old.MA,
                     :old.TA,
                     :old.DA,
                     :old.OTH_ALLOWANCE,
                     :old.TECH_ALLOWANCE,
                     :old.ACTIVE_FLAG,
                     :old.EFFECTIVE_DATE,
                     :old.ENT_BY,
                     :old.ENT_DATE,
                     :old.UPD_BY,
                     :old.UPD_DATE,
                     v_sid,
                     v_serial,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO EMP_SALARY_MASTER_log (EMP_SALARY_ID,
                                           EMP_ID,
                                           AGROSS,
                                           ABASIC,
                                           AHR,
                                           BGROSS,
                                           BBASIC,
                                           BHR,
                                           FA,
                                           MA,
                                           TA,
                                           DA,
                                           OTH_ALLOWANCE,
                                           TECH_ALLOWANCE,
                                           ACTIVE_FLAG,
                                           EFFECTIVE_DATE,
                                           ENT_BY,
                                           ENT_DATE,
                                           UPD_BY,
                                           UPD_DATE,
                                           sid,
                                           serial#,
                                           action_date,
                                           action_status)
             VALUES (:old.EMP_SALARY_ID,
                     :old.EMP_ID,
                     :old.AGROSS,
                     :old.ABASIC,
                     :old.AHR,
                     :old.BGROSS,
                     :old.BBASIC,
                     :old.BHR,
                     :old.FA,
                     :old.MA,
                     :old.TA,
                     :old.DA,
                     :old.OTH_ALLOWANCE,
                     :old.TECH_ALLOWANCE,
                     :old.ACTIVE_FLAG,
                     :old.EFFECTIVE_DATE,
                     :old.ENT_BY,
                     :old.ENT_DATE,
                     :old.UPD_BY,
                     :old.UPD_DATE,
                     v_sid,
                     v_serial,
                     SYSDATE,
                     'D');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
/