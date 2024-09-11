/* Formatted on 31/Aug/24 3:38:12 PM (QP5 v5.362) */
SELECT empcode,
       E_NAME,
       web_password,
       EMP_STATUS
  FROM EMP_SEP310824
 WHERE empcode IN ('IPI-002025',
                   'IPI-002062',
                   'IPI-007924',
                   'IPI-002071',
                   'IPI-005865',
                   'IPI-007911',
                   'IPI-002113',
                   'IPI-002120',
                   'IPI-001407',
                   'IPI-007886',
                   'IPI-001393',
                   'IPI-003367');
                   
                   
                   /* Formatted on 31/Aug/24 3:40:38 PM (QP5 v5.362) */
UPDATE emp
   SET EMP_STATUS = 'N'
 WHERE empcode IN ('IPI-002025',
                   'IPI-002062',
                   'IPI-007924',
                   'IPI-002071',
                   'IPI-005865',
                   'IPI-007911',
                   'IPI-002113',
                   'IPI-002120',
                   'IPI-001407',
                   'IPI-007886',
                   'IPI-001393',
                   'IPI-003367');

COMMIT;
/


UPDATE emp
   SET EMP_STATUS = 'A'
 WHERE empcode IN ('IPI-009129');
 COMMIT;