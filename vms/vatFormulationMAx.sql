SELECT VAT_FORMULA_SLNO
FROM (
    SELECT VAT_FORMULA_SLNO, 
           ROW_NUMBER() OVER (PARTITION BY PRODUCT_CODE ORDER BY VAT_FORMULA_SLNO DESC) AS rn
    FROM VAT_FORMULATION mst
    where PRODUCT_CODE = :P444_PRODUCT_CODE
) ranked
WHERE rn = 1;



SELECT mst.SD_APPLICABLE_PROPOSED_PRICE      sdaprc,       
       mst.VAT_APPLICABLE_PROPOSED_PRICE     vapprc,
       mst.CORPORATE_RATE                    corprt,
       mst.MRP_RATE                          mrprt,
       mst.WHOLE_SALE_PRICE                  whsprc,
       mst.RETAIL_PRICE                      rtlprc,
       mst.HSCODE                            hscode,       
       mst.COMPANY_ID                        cid,
       mst.SD                                sd,
       nvl(mst.SDA ,0)                             sda,      
      nvl( mst.UNIT_VAT,0)                         uvat,
       mst.VAT_TYPE                          vtyp
  FROM VAT_FORMULATION mst
 WHERE     PRODUCT_CODE = :P444_PRODUCT_CODE
       AND VAT_FORMULA_SLNO = (SELECT MAX (VAT_FORMULA_SLNO)
                                 FROM VAT_FORMULATION m2
                                WHERE mst.PRODUCT_CODE = m2.PRODUCT_CODE)