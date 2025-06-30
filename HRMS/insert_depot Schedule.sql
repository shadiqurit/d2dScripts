DECLARE
    v_schedule_id      NUMBER := 2;
    v_schedule_start   DATE := TO_DATE('6/1/2025', 'MM/DD/YYYY');
    v_schedule_end     DATE := TO_DATE('6/30/2026', 'MM/DD/YYYY');
    v_office_start     VARCHAR2(10) := '8.30am';
    v_office_end       VARCHAR2(10) := '5.30pm';
    v_status           VARCHAR2(1) := 'A';
    v_com_id           NUMBER := 1;
    v_ent_by           NUMBER := 555009129;
    v_ent_date         DATE := SYSDATE;
    v_notes            VARCHAR2(100) := 'Depo reguler schedule';
BEGIN
    FOR loc_id IN 2 .. 21 LOOP
        BEGIN
            -- Try to insert
            INSERT INTO OFFICE_SCHEDULE (
                 LOCATION_ID, SCHEDULE_START_DATE, SCHEDULE_END_DATE, 
                OFFICE_START, OFFICE_END, STATUS, COM_ID, ENT_BY, ENT_DATE, 
                UPD_BY, UPD_DATE, NOTES
            )
            VALUES (
                 loc_id, v_schedule_start, v_schedule_end,
                v_office_start, v_office_end, v_status, v_com_id, v_ent_by, v_ent_date,
                NULL, NULL, v_notes
            );
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                -- If record exists, update it
                UPDATE OFFICE_SCHEDULE
                SET 
                    SCHEDULE_START_DATE = v_schedule_start,
                    SCHEDULE_END_DATE   = v_schedule_end,
                    OFFICE_START        = v_office_start,
                    OFFICE_END          = v_office_end,
                    STATUS              = v_status,
                    COM_ID              = v_com_id,
                    ENT_BY              = v_ent_by,
                    ENT_DATE            = v_ent_date,
                    UPD_BY              = NULL,
                    UPD_DATE            = NULL,
                    NOTES               = v_notes
                WHERE LOCATION_ID = loc_id
                  AND SCHEDULE_ID = v_schedule_id;
        END;
    END LOOP;

    COMMIT;
END;
