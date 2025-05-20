SELECT ROW_NUMBER() OVER(ORDER BY NULL) AS slno,gname,gco,rel,prof,nid,mobile,preadd,peradd
  FROM v_guarator
 WHERE emp_id = :P401_EMPID