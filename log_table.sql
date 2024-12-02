/* Formatted on 12/2/2024 11:44:09 AM (QP5 v5.362) */
CREATE TABLE invoice_log
AS
    SELECT * FROM invoice;
/

ALTER TABLE invoice_log
    ADD sid NUMBER;
/

ALTER TABLE invoice_log
    ADD serial# NUMBER;
/

ALTER TABLE invoice_log
    ADD action_date DATE;
/

ALTER TABLE invoice_log
    ADD action_status VARCHAR2 (5);
/

CREATE OR REPLACE TRIGGER TRI_invoice_LOG
    AFTER DELETE OR INSERT OR UPDATE
    ON invoice
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
        INSERT INTO invoice_log (INV_ID,
                                 INV_NO,
                                 INV_DATE,
                                 DIST_CODE,
                                 DIST_NAME,
                                 DELIVERY_POINT,
                                 ADDRESS1,
                                 CONTACT_NO,
                                 DIST_ID,
                                 SLNO,
                                 PRODUCT_ID,
                                 PROD_CODE,
                                 PROD_NAME,
                                 UNIT_ID,
                                 UNIT_NAME,
                                 PRODUCT_QNTY,
                                 PRODUCT_PRICE,
                                 TOTAL_VALUE,
                                 GATE_PASS_NO,
                                 GATE_PASS_DATE,
                                 VEHICLE_ID,
                                 VEHICLE_NO,
                                 DRIVER_NAME,
                                 MOBILE_NO,
                                 DEL_OUTTIME,
                                 INV_PO_NO,
                                 PARTY_PO_NO,
                                 REMARKS,
                                 FLAG,
                                 UOM,
                                 UOMID,
                                 sid,
                                 serial#,
                                 action_date,
                                 action_status)
             VALUES (:new.INV_ID,
                     :new.INV_NO,
                     :new.INV_DATE,
                     :new.DIST_CODE,
                     :new.DIST_NAME,
                     :new.DELIVERY_POINT,
                     :new.ADDRESS1,
                     :new.CONTACT_NO,
                     :new.DIST_ID,
                     :new.SLNO,
                     :new.PRODUCT_ID,
                     :new.PROD_CODE,
                     :new.PROD_NAME,
                     :new.UNIT_ID,
                     :new.UNIT_NAME,
                     :new.PRODUCT_QNTY,
                     :new.PRODUCT_PRICE,
                     :new.TOTAL_VALUE,
                     :new.GATE_PASS_NO,
                     :new.GATE_PASS_DATE,
                     :new.VEHICLE_ID,
                     :new.VEHICLE_NO,
                     :new.DRIVER_NAME,
                     :new.MOBILE_NO,
                     :new.DEL_OUTTIME,
                     :new.INV_PO_NO,
                     :new.PARTY_PO_NO,
                     :new.REMARKS,
                     :new.FLAG,
                     :new.UOM,
                     :new.UOMID,
                     v_sid,
                     v_serial,
                     SYSDATE,
                     'I');
    ELSIF UPDATING
    THEN
        INSERT INTO invoice_log (INV_ID,
                                 INV_NO,
                                 INV_DATE,
                                 DIST_CODE,
                                 DIST_NAME,
                                 DELIVERY_POINT,
                                 ADDRESS1,
                                 CONTACT_NO,
                                 DIST_ID,
                                 SLNO,
                                 PRODUCT_ID,
                                 PROD_CODE,
                                 PROD_NAME,
                                 UNIT_ID,
                                 UNIT_NAME,
                                 PRODUCT_QNTY,
                                 PRODUCT_PRICE,
                                 TOTAL_VALUE,
                                 GATE_PASS_NO,
                                 GATE_PASS_DATE,
                                 VEHICLE_ID,
                                 VEHICLE_NO,
                                 DRIVER_NAME,
                                 MOBILE_NO,
                                 DEL_OUTTIME,
                                 INV_PO_NO,
                                 PARTY_PO_NO,
                                 REMARKS,
                                 FLAG,
                                 UOM,
                                 UOMID,
                                 sid,
                                 serial#,
                                 action_date,
                                 action_status)
             VALUES (:old.INV_ID,
                     :old.INV_NO,
                     :old.INV_DATE,
                     :old.DIST_CODE,
                     :old.DIST_NAME,
                     :old.DELIVERY_POINT,
                     :old.ADDRESS1,
                     :old.CONTACT_NO,
                     :old.DIST_ID,
                     :old.SLNO,
                     :old.PRODUCT_ID,
                     :old.PROD_CODE,
                     :old.PROD_NAME,
                     :old.UNIT_ID,
                     :old.UNIT_NAME,
                     :old.PRODUCT_QNTY,
                     :old.PRODUCT_PRICE,
                     :old.TOTAL_VALUE,
                     :old.GATE_PASS_NO,
                     :old.GATE_PASS_DATE,
                     :old.VEHICLE_ID,
                     :old.VEHICLE_NO,
                     :old.DRIVER_NAME,
                     :old.MOBILE_NO,
                     :old.DEL_OUTTIME,
                     :old.INV_PO_NO,
                     :old.PARTY_PO_NO,
                     :old.REMARKS,
                     :old.FLAG,
                     :old.UOM,
                     :old.UOMID,
                     v_sid,
                     v_serial,
                     SYSDATE,
                     'U');
    ELSIF DELETING
    THEN
        INSERT INTO invoice_log (INV_ID,
                                 INV_NO,
                                 INV_DATE,
                                 DIST_CODE,
                                 DIST_NAME,
                                 DELIVERY_POINT,
                                 ADDRESS1,
                                 CONTACT_NO,
                                 DIST_ID,
                                 SLNO,
                                 PRODUCT_ID,
                                 PROD_CODE,
                                 PROD_NAME,
                                 UNIT_ID,
                                 UNIT_NAME,
                                 PRODUCT_QNTY,
                                 PRODUCT_PRICE,
                                 TOTAL_VALUE,
                                 GATE_PASS_NO,
                                 GATE_PASS_DATE,
                                 VEHICLE_ID,
                                 VEHICLE_NO,
                                 DRIVER_NAME,
                                 MOBILE_NO,
                                 DEL_OUTTIME,
                                 INV_PO_NO,
                                 PARTY_PO_NO,
                                 REMARKS,
                                 FLAG,
                                 UOM,
                                 UOMID,
                                 sid,
                                 serial#,
                                 action_date,
                                 action_status)
             VALUES (:old.INV_ID,
                     :old.INV_NO,
                     :old.INV_DATE,
                     :old.DIST_CODE,
                     :old.DIST_NAME,
                     :old.DELIVERY_POINT,
                     :old.ADDRESS1,
                     :old.CONTACT_NO,
                     :old.DIST_ID,
                     :old.SLNO,
                     :old.PRODUCT_ID,
                     :old.PROD_CODE,
                     :old.PROD_NAME,
                     :old.UNIT_ID,
                     :old.UNIT_NAME,
                     :old.PRODUCT_QNTY,
                     :old.PRODUCT_PRICE,
                     :old.TOTAL_VALUE,
                     :old.GATE_PASS_NO,
                     :old.GATE_PASS_DATE,
                     :old.VEHICLE_ID,
                     :old.VEHICLE_NO,
                     :old.DRIVER_NAME,
                     :old.MOBILE_NO,
                     :old.DEL_OUTTIME,
                     :old.INV_PO_NO,
                     :old.PARTY_PO_NO,
                     :old.REMARKS,
                     :old.FLAG,
                     :old.UOM,
                     :old.UOMID,
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