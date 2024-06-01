/* Formatted on 25/May/24 4:40:02 PM (QP5 v5.362) */
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name          => 'j_t_hr_salary_d_trnsf',
        job_type          => 'PLSQL_BLOCK',
        job_action        => 'BEGIN p_t_hr_salary_d_trnsf; END;',
        start_date        => SYSTIMESTAMP,
        repeat_interval   => 'FREQ=daily; INTERVAL=1',
        enabled           => TRUE);
END;
/

BEGIN
    p_t_hr_salary_d_trnsf;
END;
/



CREATE OR REPLACE PROCEDURE p_t_hr_salary_d_trnsf
AS
BEGIN
    DELETE FROM T_HR_SALARY_D;

    COMMIT;

    DECLARE
        CURSOR hrsd IS
            SELECT SLNO,
                   EMPCODE,
                   YEAROFSTRUC,
                   EDATE,
                   TRNDATE,
                   PARTICULAR,
                   DESIGCODE,
                   AMOUNTPRV,
                   AMOUNTCUR,
                   SALPER,
                   REFNO,
                   YEARMN,
                   PRTCLR_TYPE,
                   PTC_FLAT,
                   IS_DISPLAY,
                   TRAN_ID,
                   IS_PC_PAYSLIP,
                   ADD_COMP_NAME,
                   ADD_IP_ADD,
                   PAYTYPE,
                   ADV_REFNO,
                   TRN_TYPE
              FROM HR_SALARY_D@hlink a
             WHERE NOT EXISTS
                       (SELECT *
                          FROM T_HR_SALARY_D b
                         WHERE     b.YEARMN = a.YEARMN
                               AND b.REFNO = a.REFNO
                               AND b.EMPCODE = a.EMPCODE
                               AND b.PAYTYPE = a.PAYTYPE);
    BEGIN
        FOR x IN hrsd
        LOOP
            INSERT INTO T_HR_SALARY_D (SLNO,
                                       EMPCODE,
                                       YEAROFSTRUC,
                                       EDATE,
                                       TRNDATE,
                                       PARTICULAR,
                                       DESIGCODE,
                                       AMOUNTPRV,
                                       AMOUNTCUR,
                                       SALPER,
                                       REFNO,
                                       YEARMN,
                                       PRTCLR_TYPE,
                                       PTC_FLAT,
                                       IS_DISPLAY,
                                       TRAN_ID,
                                       IS_PC_PAYSLIP,
                                       ADD_COMP_NAME,
                                       ADD_IP_ADD,
                                       PAYTYPE,
                                       ADV_REFNO,
                                       TRN_TYPE)
                 VALUES (x.SLNO,
                         x.EMPCODE,
                         x.YEAROFSTRUC,
                         x.EDATE,
                         x.TRNDATE,
                         x.PARTICULAR,
                         x.DESIGCODE,
                         x.AMOUNTPRV,
                         x.AMOUNTCUR,
                         x.SALPER,
                         x.REFNO,
                         x.YEARMN,
                         x.PRTCLR_TYPE,
                         x.PTC_FLAT,
                         x.IS_DISPLAY,
                         x.TRAN_ID,
                         x.IS_PC_PAYSLIP,
                         x.ADD_COMP_NAME,
                         x.ADD_IP_ADD,
                         x.PAYTYPE,
                         x.ADV_REFNO,
                         x.TRN_TYPE);
        END LOOP;
    END;

    COMMIT;
END;
/