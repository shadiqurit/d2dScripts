/* Formatted on 11/3/2024 11:29:19 AM (QP5 v5.362) */
SELECT *
  FROM SM_OBJECT_LIST_2
 WHERE    (USERID = 'IPI-002820' AND p_OBJ_ID = 227)
       OR (USERID = 'IPI-002820' AND OBJ_ID = 227);



UPDATE SM_OBJECT_LIST_2
   SET IS_DISPLAY = 1
 WHERE    (USERID = 'IPI-002820' AND p_OBJ_ID = 227)
       OR (USERID = 'IPI-002820' AND OBJ_ID = 227);

COMMIT;


--  & IPI-002820
-- IPI-008113 & IPI-002820