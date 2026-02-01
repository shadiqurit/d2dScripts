CREATE OR REPLACE TRIGGER trg_block_postpone_issue
BEFORE UPDATE ON HR_ADVANCE_ISSUE
FOR EACH ROW
BEGIN
    -- Check if the record is already set to 'Postpone'
    IF :OLD.ADV_STATUS = 'Postpone' THEN
        RAISE_APPLICATION_ERROR(-20001, 'This record is Postponed and cannot be modified.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_block_postpone_log
BEFORE UPDATE ON HR_ADVANCE_ISSUE_LOG
FOR EACH ROW
BEGIN
    -- Prevent any updates if the status is already 'Postpone'
    IF :OLD.ADV_STATUS = 'Postpone' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Modifications are locked for Postponed log entries.');
    END IF;
END;
/

--hr_advance_issue_log


--hr_advance_issue

/* Postpone  this methods*/
UPDATE hr_advance_issue
   SET ADV_STATUS = 'Postpone'
 WHERE     ADV_TYPE = '105'
       AND ADV_STATUS != 'Postpone'
       AND refno IN ('A105202403/281',
                     'A105202410/9',
                     'A105202412/14',
                     'A105202402/218',
                     'A105202504/9',
                     'A105202509/5',
                     'A105202502/21',
                     'A105202505/20',
                     'A105202505/21',
                     'A105202505/23',
                     'A105202502/97',
                     'A105202505/154',
                     'A105202410/29',
                     'A105202505/206',
                     'A105202409/43',
                     'A105202411/24',
                     'A105202411/33',
                     'A105202509/118',
                     'A105202511/325',
                     'A105202511/353',
                     'A105202511/155',
                     'A105202511/206',
                     'A105202510/67',
                     'A105202511/308')
       AND empcode IN ('IPI-000335',
                       'IPI-004607',
                       'IPI-001062',
                       'IPI-006169',
                       'IPI-008766',
                       'IPI-008242',
                       'IPI-001665',
                       'IPI-000661',
                       'IPI-002836',
                       'IPI-007205',
                       'IPI-006669',
                       'IPI-000771',
                       'IPI-007838',
                       'IPI-007799',
                       'IPI-005742',
                       'IPI-004552',
                       'IPI-006574',
                       'IPI-006787',
                       'IPI-006693',
                       'IPI-001070',
                       'IPI-005000',
                       'IPI-005390',
                       'IPI-003758',
                       'IPI-003734',
                       'IPI-000714',
                       'IPI-000994',
                       'IPI-001031',
                       'INM-000302',
                       'IPI-005117',
                       'IPI-006134',
                       'IPI-001951');
-----Insert log----
INSERT INTO HR_ADVANCE_ISSUE_LOG (
        SLNO,
        REFNO,
        ENTRY_DATE,
        REFDATE,
        EMPCODE,
        INSTALL_AMOUNT,
        INSTALL_AMOUNT_P,
        NO_OF_INSTALL,
        ADV_STATUS,
        USERNAME
    )
    SELECT 
        1,                    -- Static SLNO as requested
        REFNO,
        SYSDATE,              -- Current entry time
        ISSUE_DATE,           -- Mapping ISSUE_DATE to REFDATE
        EMPCODE,
        0,                    -- Static Install Amount
        INSTALL_AMOUNT,       -- Moving original amount to _P column
        NO_OF_INSTALL,
        'Postpone',
        'WAFI'                -- Static Username
    FROM HR_ADVANCE_ISSUE
    WHERE ADV_STATUS = 'Postpone'
    and refno not in (select refno from HR_ADVANCE_ISSUE_LOG)
    and ADV_TYPE = '105'
      AND ADV_STATUS = 'Postpone'
       AND refno IN ('A105202403/281',
                     'A105202410/9',
                     'A105202412/14',
                     'A105202402/218',
                     'A105202504/9',
                     'A105202509/5',
                     'A105202502/21',
                     'A105202505/20',
                     'A105202505/21',
                     'A105202505/23',
                     'A105202502/97',
                     'A105202505/154',
                     'A105202410/29',
                     'A105202505/206',
                     'A105202409/43',
                     'A105202411/24',
                     'A105202411/33',
                     'A105202509/118',
                     'A105202511/325',
                     'A105202511/353',
                     'A105202511/155',
                     'A105202511/206',
                     'A105202510/67',
                     'A105202511/308');
                     
                     /* Ref no gen and check again */
SELECT ''''||REFNO||''',' as refno
  FROM hr_advance_issue
 WHERE      ADV_TYPE = '105'
       AND ADV_STATUS = 'Open' and empcode IN ('IPI-000335',
'IPI-004607',
'IPI-001062',
'IPI-006169',
'IPI-008766',
'IPI-008242',
'IPI-001665',
'IPI-000661',
'IPI-002836',
'IPI-007205',
'IPI-006669',
'IPI-000771',
'IPI-007838',
'IPI-007799',
'IPI-005742',
'IPI-004552',
'IPI-006574',
'IPI-006787',
'IPI-006693',
'IPI-001070',
'IPI-005000',
'IPI-005390',
'IPI-003758',
'IPI-003734',
'IPI-000714',
'IPI-000994',
'IPI-001031',
'INM-000302',
'IPI-005117',
'IPI-006134',
'IPI-001951')