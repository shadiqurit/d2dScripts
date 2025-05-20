SELECT ROW_NUMBER() OVER(ORDER BY NULL) AS slno,topics,country,training_name course_title,institution,start_date,completion_date,duration,result
  FROM EMP_TRAINING
 WHERE emp_id = :P401_EMPID