/* Formatted on 2/13/2025 10:06:10 AM (QP5 v5.362) */
CREATE OR REPLACE PROCEDURE WPPF.wppf_dist_to_emp (p_finyear   IN VARCHAR2,
                                                   p_dt2       IN DATE)
AS
    CURSOR c1 IS
        SELECT religion,
               NULL
                   mscode,
               a.empcode
                   employeecode,
               a.e_name
                   employeename,
               a.ccode
                   companyid,
               'The IBN SINA Pharmaceutical Ind. WPPFT'
                   companyname,
               a.businessunitid,
               a.businessunit
                   unitname,
               a.costcenter
                   costcenter,
               TRIM (costcenter_name)
                   costcentername,
               SYSDATE
                   processdate,
               ---p_year salaryyear, p_month salarymonth,
               salarygrade
                   gradecode,
               a.desig_name
                   designation,
               a.department_name
                   department,
               sub_department_name
                   subdepartment,
               join_date
                   doj,
               a.emp_status
                   employeestatus,
               UPPER (payment_type)
                   paymenttype,
               bank_id,
               bank_id
                   branch_id,
               bankname
                   bankname,
               bankaccno
                   bankaccno,
               branch_name
                   branchadd,
               NVL (
                   TRIM (paysliplocation_name),
                   DECODE (UPPER (depot),
                           'FACTORY', 'FACTORY',
                           'HEAD OFFICE'))
                   paysliplocation,
               NULL
                   salarystatus,
               empno
                   empcodehr,
               region_id,
               area_id,
               territory_id,
               region_name,
               area_name,
               territory_name,
               costcenter_name,
               department_name,
               sub_department_name,
               desig_name,
               a.depot
                   location_name,
               a.dp_code
                   location_id,
               division_id,
               division_name,
               TRIM (paysliplocation_name)
                   paysliplocation_name,
               cheque_id,
               branch_name,
               NULL
                   joiningposition_name,
               desig_name_old,
               salarygrade_old,
               salarystep_old,
               increasedamount,
               gross_old,
               0
                   gross,
               salarystep,
               NULL
                   paysliplocation_id,
               salaryscal,
               a.join_date,
               p_dt2 - join_date
                   total_day,
               a.empno
          --b.total_day
          FROM ipihr.emp a --, wppf_emplist b                          --wppf_emp b
         WHERE                                        -- a.empcode = b.empcode
                   --AND
                   a.empcode NOT LIKE 'EMP%'
               AND EMPCODE NOT IN ('IPI-008651', 'IPI-009516')
               AND a.empno NOT LIKE '%***%'
               AND a.empno NOT LIKE '%POL%'
               AND a.empno NOT LIKE '%API%'
               AND p_dt2 - join_date >= 274
               AND NVL (empcode, '#') IN (SELECT NVL (y.empcode, '#')
                                            FROM wppf_eligible_for_salary y
                                           WHERE fin_year = p_finyear)
               /*(SELECT b.employeecode
                                 FROM ipihr.hr_salary_m b
                                WHERE TO_NUMBER (
                                            b.salaryyear
                                         || LPAD (b.salarymonth, 2, 0)) BETWEEN TO_NUMBER (
                                                                                      SUBSTR (
                                                                                         p_finyear,
                                                                                         1,
                                                                                         4)
                                                                                   || '07') --202207
                                                                            AND TO_NUMBER (
                                                                                      SUBSTR (
                                                                                         p_finyear,
                                                                                         6)
                                                                                   || '06')) -- 202306)*/
               -- AND b.yearmn = TO_CHAR (p_dt2, 'yyyymm')
               AND UPPER (desig_name) NOT LIKE 'EXECUTIVE DIRECTOR%';

    CURSOR c2 IS
        SELECT employeecode
          FROM wppf_dist
         WHERE fin_year = p_finyear;

    v_dist_amt           NUMBER;
    v_rec                NUMBER (10);
    v_year               NUMBER := TO_NUMBER (TO_CHAR (p_dt2, 'YYYY'));
    v_month              NUMBER := TO_NUMBER (TO_CHAR (p_dt2, 'MM'));
    tot_emp              NUMBER;
    v_emp_total_amount   NUMBER;
    v_emp_dist_amt       NUMBER;
BEGIN
    SYSINFO.SET_PYEARMN (p_dt2);
    SYSINFO.SET_YEARMN (p_dt2);

    SELECT NVL (COUNT (*), 0)
      INTO v_rec
      FROM wppf_dist
     WHERE fin_year = p_finyear;

    IF NVL (v_rec, 0) > 0
    THEN
        RETURN;
    END IF;

    DELETE FROM wppf_eligible_for_salary
          WHERE fin_year = p_finyear;

    INSERT INTO wppf_eligible_for_salary (empcode,
                                          tot_salary_month,
                                          fin_year,
                                          trndate)
        (SELECT empcode,
                tot,
                p_finyear,
                SYSDATE
           FROM (  SELECT employeecode empcode, COUNT (*) tot
                     FROM ipihr.hr_salary_m b
                    WHERE TO_NUMBER (
                              b.salaryyear || LPAD (b.salarymonth, 2, 0)) BETWEEN TO_NUMBER (
                                                                                         SUBSTR (
                                                                                             p_finyear,
                                                                                             1,
                                                                                             4)
                                                                                      || '07') --202207
                                                                              AND TO_NUMBER (
                                                                                         SUBSTR (
                                                                                             p_finyear,
                                                                                             6)
                                                                                      || '06')
                 GROUP BY employeecode)
          WHERE NVL (tot, 0) >= 6);

    FOR i IN c1
    LOOP
        INSERT INTO wppf_dist (mscode,
                               employeecode,
                               employeename,
                               companyid,
                               companyname,
                               businessunitid,
                               unitname,
                               costcenter,
                               costcentername,
                               processdate,
                               salaryyear,
                               salarymonth,
                               gradecode,
                               designation,
                               department,
                               subdepartment,
                               doj,
                               employeestatus,
                               paymenttype,
                               bankname,
                               bankaccno,
                               branchadd,
                               paysliplocation,
                               salarystatus,
                               tran_id,
                               empcodehr,
                               bankid,
                               barnchid,
                               paysliplocation_id,
                               region_id,
                               area_id,
                               territory_id,
                               region_name,
                               area_name,
                               territory_name,
                               costcenter_name,
                               department_name,
                               sub_department_name,
                               desig_name,
                               location_name,
                               location_id,
                               division_id,
                               division_name,
                               paysliplocation_name,
                               cheque_id,
                               branch_name,
                               joiningposition_name,
                               fin_year,
                               yearmn,
                               trndate,
                               empstatus,
                               empcode,
                               cons_date,
                               total_day)
             VALUES (i.mscode,
                     i.employeecode,
                     i.employeename,
                     i.companyid,
                     i.companyname,
                     i.businessunitid,
                     i.unitname,
                     i.costcenter,
                     i.costcentername,
                     i.processdate,
                     v_year,
                     v_month,
                     i.gradecode,
                     i.designation,
                     i.department,
                     i.subdepartment,
                     i.doj,
                     i.employeestatus,
                     i.paymenttype,
                     i.bankname,
                     i.bankaccno,
                     i.branchadd,
                     i.paysliplocation,
                     i.salarystatus,
                     NULL,
                     i.empno,
                     i.bank_id,
                     i.branch_id,
                     i.paysliplocation_id,
                     i.region_id,
                     i.area_id,
                     i.territory_id,
                     i.region_name,
                     i.area_name,
                     i.territory_name,
                     i.costcenter_name,
                     i.department_name,
                     i.sub_department_name,
                     i.desig_name,
                     i.location_name,
                     i.location_id,
                     i.division_id,
                     i.division_name,
                     i.paysliplocation_name,
                     i.cheque_id,
                     i.branch_name,
                     i.joiningposition_name,
                     p_finyear,
                     TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymm')),
                     TRUNC (SYSDATE),
                     i.employeestatus,
                     i.employeecode,
                     p_dt2,
                     i.total_day);
    END LOOP;

    --commit;

    SELECT NVL (COUNT (*), 0)
      INTO tot_emp
      FROM wppf_dist
     WHERE fin_year = p_finyear;

    SELECT NVL (dist_amount, 0)
      INTO v_dist_amt
      FROM wppf_income
     WHERE fin_year = p_finyear;

    v_emp_total_amount := FLOOR (NVL (v_dist_amt, 0) / tot_emp);

    -- INSERT INTO t_1
    -- VALUES (NULL, v_dist_amt, v_emp_total_amount, tot_emp);
    FOR A IN c2
    LOOP
        --INSERT INTO t_1
        --VALUES (a.employeecode, v_dist_amt, v_emp_total_amount, tot_emp);

        UPDATE wppf_dist
           SET gross = v_emp_total_amount, netpay = v_emp_total_amount
         WHERE employeecode = a.employeecode AND fin_year = p_finyear;
    END LOOP;

    SELECT SUM (NVL (netpay, 0))
      INTO v_emp_dist_amt
      FROM wppf_dist
     WHERE fin_year = p_finyear;

    --v_diff:=nvl(v_dist_amt,0)-nvl(v_emp_dist_amt,0);

    UPDATE wppf.wppf_income
       SET dist_amount = v_emp_dist_amt,
           reserve_amount = NVL (net_amount, 0) - NVL (v_emp_dist_amt, 0)
     WHERE fin_year = p_finyear;
--select *from wppf.wppf_income
END;
--create table t_1(empcode varchar2(30), amt number,amt1 number,amt3 number)
/