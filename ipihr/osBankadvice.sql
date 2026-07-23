SELECT ALL a.location_name employeename, sum(nvl(a.netpay,0)) netpay_cal,
             to_char( b.hr_bank_acno) bankaccno,
             b.hr_bank_branch, a.paymenttype, location_name
      FROM v$salarysheet a, depot b
where b.dp_code(+)=a.location_id
and paymenttype=:p_paymenttype
--and a.yearmn=:p_yearmn
and trunc(trndate) between :dt1 and :dt2
and paytype=:p_paynature
--and empcodehr not like '%***%'
--and empcode<>'IPI-004897'
--&vdirector
and a.businessunitid=nvl( :p_unitid,a.businessunitid)
group by location_name,a.paymenttype,to_char( b.hr_bank_acno),b.hr_bank_branch
order by a.location_name;



SELECT ALL COMPANY.NAME, COMPANY.CCODE, COMPANY.ADDRESS, 
COMPANY.PHONE1, COMPANY.PHONE2, COMPANY.FAX, clogo,COMPANY.EMAIL
FROM COMPANY 
where ccode=:p_ccode