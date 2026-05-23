CREATE OR REPLACE FUNCTION fn_custom_login (p_username   IN VARCHAR2,
                                            p_password   IN VARCHAR2)
    RETURN BOOLEAN
IS
    v_password          VARCHAR2 (4000);
    v_stored_password   VARCHAR2 (4000);

    v_count             NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO v_count
      FROM appuser
     WHERE     (   LOWER (username) = LOWER (p_username)
                OR LOWER (email) = LOWER (p_username))
           AND STATUS = 'A';

    IF v_count != 0
    THEN
        SELECT pass
          INTO v_stored_password
          FROM appuser
         WHERE     (   LOWER (username) = LOWER (p_username)
                    OR LOWER (email) = LOWER (p_username))
               AND STATUS = 'A';

        v_password := p_password;

        IF v_password = v_stored_password
        THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END IF;
END fn_custom_login;
/
