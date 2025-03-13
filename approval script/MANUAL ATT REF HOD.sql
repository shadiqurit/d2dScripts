/* Formatted on 3/6/2025 1:40:12 PM (QP5 v5.362) */
  SELECT *
    FROM dpuser.manual_att_approval x
   WHERE     EMPCODE_2_HOD = 'IPI-002760'
         AND status_l1 = 'Y'
         AND TRUNC (TO_CHAR (PROPOSED_END_DATE, 'RRRRMM')) = '202502'
ORDER BY PROPOSED_END_DATE DESC NULLS LAST;


SELECT *
  FROM dpuser.refreshment_approval x
 WHERE     EMPCODE_2_HOD = 'IPI-002760'
       AND status_l1 = 'Y'
       AND TRUNC (TO_CHAR (PROPOSED_START_DATE, 'RRRRMM')) = '202502';


UPDATE dpuser.refreshment_approval x
   SET STATUS_L2 = 'Y'
 WHERE     EMPCODE_2_HOD = 'IPI-002760'
       AND status_l1 = 'Y'
       AND TRUNC (TO_CHAR (PROPOSED_START_DATE, 'RRRRMM')) = '202502';
       
       
       /* Formatted on 3/6/2025 1:34:53 PM (QP5 v5.362) */
UPDATE dpuser.manual_att_approval x
   SET status_l2 = 'Y'
 WHERE     EMPCODE_2_HOD = 'IPI-002760'
       AND status_l1 = 'Y'
       AND TRUNC (TO_CHAR (PROPOSED_END_DATE, 'RRRRMM')) = '202502';