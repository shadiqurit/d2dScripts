DECLARE
    l_user_id NUMBER;
BEGIN
    -- Get the currently logged-in user ID
    l_user_id := :user_id;

    IF :P16_ID IS NOT NULL THEN
        -- Update
        UPDATE EXPAY_MST
        SET upd_by = l_user_id,
            upd_date = sysdate
        WHERE id = :P16_ID;
    END IF;
 exception 
    when others then 
    null;
END;
