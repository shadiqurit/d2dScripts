/* Formatted on 12/11/2024 5:54:10 PM (QP5 v5.362) */
CREATE TABLE act_trns_log
AS
    SELECT * FROM act_trns;
/

ALTER TABLE act_trns_log
    ADD sid NUMBER;
/

ALTER TABLE act_trns_log
    ADD serial# NUMBER;
/

ALTER TABLE act_trns_log
    ADD action_date DATE;
/

ALTER TABLE act_trns_log
    ADD action_status VARCHAR2 (5);
/

CREATE OR REPLACE TRIGGER TRI_act_trns_LOG
    AFTER DELETE OR INSERT OR UPDATE
    ON act_trns
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    v_sid      NUMBER;
    v_serial   NUMBER;
BEGIN
    IF INSERTING
    THEN
        INSERT INTO act_trns_log (ID,
                                  PUR_ID,
                                  SUPP_ID,
                                  TRDATE,
                                  AMOUNT,
                                  BALANCE,
                                  NOTES,
                                  ENT_BY,
                                  ENT_DATE,
                                  UPD_BY,
                                  UPD_DATE,
                                  COM_ID,
                                  CH_AMT,
                                  TYP,
                                  action_date,
                                  action_status)
             VALUES (:new.ID,
                     :new.PUR_ID,
                     :new.SUPP_ID,
                     :new.TRDATE,
                     :new.AMOUNT,
                     :new.BALANCE,
                     :new.NOTES,
                     :new.ENT_BY,
                     :new.ENT_DATE,
                     :new.UPD_BY,
                     :new.UPD_DATE,
                     :new.COM_ID,
                     :new.CH_AMT,
                     :new.TYP,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO act_trns_log (ID,
                                  PUR_ID,
                                  SUPP_ID,
                                  TRDATE,
                                  AMOUNT,
                                  BALANCE,
                                  NOTES,
                                  ENT_BY,
                                  ENT_DATE,
                                  UPD_BY,
                                  UPD_DATE,
                                  COM_ID,
                                  CH_AMT,
                                  TYP,
                                  action_date,
                                  action_status)
             VALUES (:old.ID,
                     :old.PUR_ID,
                     :old.SUPP_ID,
                     :old.TRDATE,
                     :old.AMOUNT,
                     :old.BALANCE,
                     :old.NOTES,
                     :old.ENT_BY,
                     :old.ENT_DATE,
                     :old.UPD_BY,
                     :old.UPD_DATE,
                     :old.COM_ID,
                     :old.CH_AMT,
                     :old.TYP,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO act_trns_log (ID,
                                  PUR_ID,
                                  SUPP_ID,
                                  TRDATE,
                                  AMOUNT,
                                  BALANCE,
                                  NOTES,
                                  ENT_BY,
                                  ENT_DATE,
                                  UPD_BY,
                                  UPD_DATE,
                                  COM_ID,
                                  CH_AMT,
                                  TYP,
                                  --  sid,
                                  -- serial#,
                                  action_date,
                                  action_status)
             VALUES (:old.ID,
                     :old.PUR_ID,
                     :old.SUPP_ID,
                     :old.TRDATE,
                     :old.AMOUNT,
                     :old.BALANCE,
                     :old.NOTES,
                     :old.ENT_BY,
                     :old.ENT_DATE,
                     :old.UPD_BY,
                     :old.UPD_DATE,
                     :old.COM_ID,
                     :old.CH_AMT,
                     :old.TYP,
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