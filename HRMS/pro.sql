BEGIN
    SELECT emp_id,
           promotion_type,
           promotion_date,
           effective_date,

           old_dept_id,
           new_dept_id,
           old_desig_id,
           new_desig_id,
        

           old_basic,
           new_basic,
           old_gross,
           new_gross,
           

           
           remarks,
           approval_status
      INTO :P476_EMP_ID,
           :P476_PROMOTION_TYPE,
           :P476_PROMOTION_DATE,
           :P476_EFFECTIVE_DATE,

           :P476_DEPARTMENT,
           :P476_NEW_DEPT_ID,
           :P476_DESIGNATION,
           :P476_NEW_DESIG_ID,
         

           :P476_CURRENT_BASIC,
           :P476_NEW_BASIC,
           :P476_CURRENT_GROSS,
           :P476_NEW_GROSS,
          

           
           :P476_REMARKS,
           :P476_APPROVAL_STATUS
      FROM hr_employee_promotion
     WHERE promotion_id = :P476_PROMOTION_ID;

    :P476_ACTION_MODE := 'EDIT';
END;