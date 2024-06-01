/* Formatted on 14/May/24 11:06:44 AM (QP5 v5.362) */
SELECT user_avatar,
       CARD_TITLE,
       event_date,
       TYPE
  FROM (  SELECT b.ID,
                 b.TYPE,
                 TO_CHAR (SYSDATE, 'dd/mm/yyyy, hh:mi:ss am')
                     AS event_date,
                 b.TYPE || ' (Total: ' || COUNT (a.VH_REGI_NO) || ')'
                     AS CARD_TITLE,
                 COUNT (a.VH_REGI_NO)
                     AS VHQTY,
                 b.mime_type,
                 (SELECT CASE
                             WHEN NVL (DBMS_LOB.getlength (doc_file), 0) = 0
                             THEN
                                 NULL
                             ELSE
                                 CASE
                                     WHEN mime_type LIKE 'image%'
                                     THEN
                                            '<img src="'
                                         || APEX_UTIL.get_blob_file_src (
                                                'P4_DOCUMENT',
                                                id)
                                         || '" />'
                                     ELSE
                                            '<a href="'
                                         || APEX_UTIL.get_blob_file_src (
                                                'P4_DOCUMENT',
                                                id)
                                         || '">Download</a>'
                                 END
                         END    new_img
                    FROM VEHICLE_TYPE b2
                   WHERE b2.id = b.id)
                     AS user_avatar
            FROM VH_REGISTRATION a, VEHICLE_TYPE b
           WHERE a.type_id = b.id
        GROUP BY b.ID,
                 b.TYPE,
                 TO_CHAR (SYSDATE, 'dd/mm/yyyy, hh:mi:ss am'),
                 b.mime_type
        ORDER BY 1)