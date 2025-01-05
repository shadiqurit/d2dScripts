/* Formatted on 1/5/2025 2:06:27 PM (QP5 v5.362) */
DELETE FROM HR_LEAVE_CHILD
      WHERE     YEAR = 2024
            AND LEAVE_TYPE = 'EL'
            AND LEAVEADTYPE = 'Opening'
            AND empcode IN (SELECT empcode
                              FROM EMP
                             WHERE cata = 'NON OFFICER' AND EMP_STATUS = 'A');



--             

CREATE TABLE hr_leave_child_102024
AS
    SELECT * FROM hr_leave_child;

BEGIN
    ipi_leave_calc_2_v3_102024;
END;



SELECT f_get_leave_balance ('IPI-007514', 'EL') FROM DUAL;

SELECT dpuser.get_leave_balance ('IPI-007514', 'EL') FROM DUAL;

SELECT EMPCODE, ELAVAILABLE FROM V_IPI_LEAVE_REPORT;


SELECT empcode,
       'EL'
           leave_type,
       TO_DATE ('01-Jan-' || TO_CHAR (SYSDATE, 'rrrr'), 'dd-Mon-rrrr')
           date_from,
       TO_DATE ('31-Dec-' || TO_CHAR (SYSDATE, 'rrrr'), 'dd-Mon-rrrr')
           date_to,
       days
           DURATION,
       TO_CHAR (SYSDATE, 'rrrr')
           YEAR,
       'Opening'
           leaveadtype,
       'A'
           entry_type,
       'New process'
           COMMENTS
  FROM (SELECT empcode,
               TO_DATE ('01-Sep-22', 'dd-Mon-rr')    el_join_date,
               CASE
                   WHEN DP_CODE = 'FAC'
                   THEN
                       CASE
                           WHEN elavailable > 40
                           THEN
                               (40 - elavailable)
                           WHEN elavailable BETWEEN 19 AND 40
                           THEN
                               (40 - elavailable)
                           ELSE
                               21
                       END
                   ELSE
                       CASE
                           WHEN elavailable > 60
                           THEN
                               (60 - elavailable)
                           WHEN elavailable BETWEEN 39 AND 60
                           THEN
                               (60 - elavailable)
                           ELSE
                               21
                       END
               END                                   AS DAYS
          FROM (SELECT B.EMPCODE,
                       b.DP_CODE,
                       B.CONFIRM_ST,
                       B.CONFIRM_DATE,
                       B.JOIN_DATE,
                       A.TYPE,
                       c.ELAVAILABLE,
                       NULL                      confirm_type,
                       TO_DATE ('01-Sep-22')     el_join_date
                  FROM (SELECT EMPCODE, 1 TYPE FROM EL_UPLOAD) A,
                       EMP                 B,
                       V_IPI_LEAVE_REPORT  c
                 WHERE     A.EMPCODE = B.EMPCODE
                       AND A.EMPCODE = c.EMPCODE
                       AND UPPER (B.cata) = 'NON OFFICER') a
         WHERE MONTHS_BETWEEN (SYSDATE, el_join_date) >= 11);



SELECT e_name,
       DP_CODE,
       desig_code,
       DESIG_NAME,
       DEPARTMENT_NAME
  FROM emp
 WHERE empcode = 'IPI-003354'        --'IPI-000842' 'IPI-003354' 'IPI-002068';