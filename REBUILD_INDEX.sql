/* Formatted on 02/Jun/24 2:55:39 PM (QP5 v5.362) */
SELECT OWNER,
       INDEX_NAME,
       INDEX_TYPE,
       TABLE_OWNER,
       COMPRESSION,
       STATUS
  FROM DBA_INDEXES
 WHERE TABLE_NAME = 'EMP' AND STATUS <> 'VALID';
 
 SELECT 'ALTER INDEX '||OWNER||'.'||INDEX_NAME||' REBUILD;' FROM DBA_INDEXES 
WHERE STATUS = 'UNUSABLE' AND TABLE_NAME = 'EMP';