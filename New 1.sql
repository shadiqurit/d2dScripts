/* Formatted on 10/28/2024 11:09:18 AM (QP5 v5.362) */
  SELECT ALL
         b.name                                       companyname,
         LTRIM (RTRIM (UPPER (a.department_name)))    department_name,
         a.salaryyear,
         a.salarymonth,
         a.department,
         a.paysliplocation,
         a.yearmn,
         SUM (NVL (a.basic, 0))                       basic,
         SUM (NVL (a.h_r, 0))                         h_r,
         SUM (NVL (a.c_a, 0))                         c_a,
         SUM (NVL (a.m_a, 0))                         m_a,
         SUM (NVL (a.cpf, 0))                         cpf,
         SUM (NVL (a.d_a, 0))                         d_a,
         SUM (NVL (a.spa, 0))                         spa,
         SUM (NVL (a.cha, 0))                         cha,
         SUM (NVL (a.allowance, 0))                   allowance,
         SUM (NVL (a.motiv_allow, 0))                 motiv_allow,
         SUM (NVL (a.arrear, 0))                      arrear,
         --sum(nvl(a.cha,0)+nvl(a.tele,0)+nvl(a.motiv_allow,0)+nvl(a.city,0)+nvl(mcma,0)+nvl(a.n_other_add,0)+nvl(hqa,0))  others,
         SUM (NVL (total_other_add, 0))               others,
         SUM (NVL (a.gross, 0))                       gross,
         SUM (NVL (a.i_t, 0))                         i_t,
         SUM (NVL (a.pf, 0))                          pf,
         SUM (NVL (a.aas, 0))                         aas,
         SUM (NVL (a.pfl, 0))                         pfl,
         SUM (NVL (a.eks, 0))                         eks,
         SUM (NVL (a.eksla, 0))                       eksla,
         SUM (NVL (a.saf, 0))                         saf,
         SUM (NVL (a.oth_ded, 0))                     oth_ded,
         SUM (NVL (a.mcad, 0))                        mcad,
         SUM (
               NVL (eks, 0)
             + NVL (a.eksla, 0)
             + NVL (a.oth_ded, 0)
             + NVL (bnf, 0)
             + NVL (conv_ded, 0)
             + NVL (n_other_ded, 0))                  other_ded,
         SUM (NVL (a.tot_ded, 0))                     tot_ded,
         SUM (NVL (a.netpay, 0))                      netpay,
         COUNT (DISTINCT (employeecode))              no_of_emp
    FROM v$salarysheet a, company b
   WHERE     a.companyid = b.ccode
         AND yearmn = :p_yearmn
         AND UPPER (paytype) = 'SALARY'
         AND companyid = NVL ( :p_ccode, companyid)
--&v_unitid
GROUP BY b.name,
         LTRIM (RTRIM (UPPER (a.department_name))),
         a.salaryyear,
         a.salarymonth,
         a.department,
         a.paysliplocation,
         a.yearmn
ORDER BY department_name