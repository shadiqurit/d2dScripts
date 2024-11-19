/* Formatted on 11/19/2024 11:07:34 AM (QP5 v5.362) */
SELECT empcode          "ID No",
       e_name           "Sub A/C Name",
       FATHER_NAME      "Father Name",
       MOTHER_NAME      "Mother Name",
       SPOUSE_NAME      "Spouse Name",
       SALARYGRADE      "Rank Code (Grade)",
       PHONE,
       JOIN_DATE        "Join Date / Opening Date",
       FULL_ADD         "Present Address 1",
       ''               AS "Present Address 2",
       ''               AS "Present Address 3",
       LOCATION_ATT     "Present Address",
       P_FULL_ADD       "Permanent Address",
       BIRTHDATE        "Date of Birth",
       VOTER_ID         nid,
       TIN,
       EMPSEX           "Gender",
       BANKACCNO        "Bank Account",
       BRANCH_NAME      "Branch Name",
       BANKNAME         "Bank Name"
  FROM emp
 WHERE empcode IN ('IPI-009521')
 
 --UPDATED ON 19-NOV-2024