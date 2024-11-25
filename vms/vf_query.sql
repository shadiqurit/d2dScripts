/* Formatted on 11/25/2024 3:58:42 PM (QP5 v5.362) */
SELECT mst.VAT_FORMULA_SLNO                  vfid,
       mst.PRODUCT_CODE                      prodid,
       mst.ENTRY_DATE                        edt,
       mst.TOTAL_BUY_PRICE                   tbprc,
       mst.SD_APPLICABLE_CURRENT_PRICE       sdacprc,
       mst.SD_APPLICABLE_PROPOSED_PRICE      sdaprc,
       mst.SD_ON_SD_APP_PROPOSED_PRICE       sdapprc,
       mst.VAT_APPLICABLE_CURRENT_PRICE      vacprc,
       mst.VAT_APPLICABLE_PROPOSED_PRICE     vapprc,
       mst.CORPORATE_RATE                    corprt,
       mst.MRP_RATE                          mrprt,
       mst.WHOLE_SALE_PRICE                  whsprc,
       mst.RETAIL_PRICE                      rtlprc,
       mst.HSCODE                            hscode,
       mst.UNIT                              unit,
       mst.COMPANY_ID                        cid,
       mst.SD                                sd,
       mst.SDA                               sda,
       mst.ACTIVE                            act,
       mst.GA                                ga,
       mst.STATUS                            st,
       mst.PO_STATUS                         pst,
       mst.UNIT_VAT                          uvat,
       mst.VAT_TYPE                          vtyp,
       mst.USER1                             u1,
       mst.APP_DATE                          apdt,
       mst.INACTIVE_DATE                     inactdt,
       mst.NUMBEROFCO                        ncofn
  FROM VAT_FORMULATION mst;

SELECT dtl.VAT_FORMULA_SLNO      vfid,
       dtl.RMPMEXP_CODE          rmid,
       dtl.EXP_CODE              expid,
       dtl.REQUIRED_QTY_DISP     reqdqty,
       dtl.REQUIRED_QTY          reqqty,
       dtl.WASTAGE_QTY           wstqty,
       dtl.UNIT_PRICE            uprc,
       dtl.PRICE                 prc,
       dtl.EXP_PRICE             exprc,
       dtl.COLNUMBER             colno,
       dtl.T_TYPE                typ,
       dtl.SLNO                  sl,
       dtl.UVPRICE               uvprc,
       dtl.WASTAGE_PER           wstprcnt,
       dtl.GRN_NO                grno,
       dtl.HSCODE                hsc,
       dtl.HSCODE1               hsc1,
       dtl.EXP_TYPE              exptyp,
       dtl.REC_TYPE              rectyp,
       dtl.UNIT_SD               usd,
       dtl.UNIT_VAT              uvat,
       dtl.COMPANY_ID            cid,
       dtl.UOM                   um
  FROM RMPMEXP_VAT_FORMULA_MASTER dtl
 WHERE VAT_FORMULA_SLNO = :P444_VAT_FORMULA_SLNO;

SELECT mst.vat_formula_slno                  vfid,
       mst.product_code                      prodid,
       mst.entry_date                        edt,
       mst.total_buy_price                   tbprc,
       mst.sd_applicable_current_price       sdacprc,
       mst.sd_applicable_proposed_price      sdaprc,
       mst.sd_on_sd_app_proposed_price       sdapprc,
       mst.vat_applicable_current_price      vacprc,
       mst.vat_applicable_proposed_price     vapprc,
       mst.corporate_rate                    corprt,
       mst.mrp_rate                          mrprt,
       mst.whole_sale_price                  whsprc,
       mst.retail_price                      rtlprc,
       mst.hscode                            hscode,
       mst.unit                              unit,
       mst.company_id                        cid,
       mst.sd                                sd,
       mst.sda                               sda,
       mst.active                            act,
       mst.ga                                ga,
       mst.status                            st,
       mst.po_status                         pst,
       mst.unit_vat                          uvat,
       mst.vat_type                          vtyp,
       mst.user1                             u1,
       mst.app_date                          apdt,
       mst.inactive_date                     inactdt,
       mst.numberofco                        ncofn,
       dtl.vat_formula_slno                  vfid,
       dtl.rmpmexp_code                      rmid,
       dtl.exp_code                          expid,
       dtl.required_qty_disp                 reqdqty,
       dtl.required_qty                      reqqty,
       dtl.wastage_qty                       wstqty,
       dtl.unit_price                        uprc,
       dtl.price                             prc,
       dtl.exp_price                         exprc,
       dtl.colnumber                         colno,
       dtl.t_type                            typ,
       dtl.slno                              sl,
       dtl.uvprice                           uvprc,
       dtl.wastage_per                       wstprcnt,
       dtl.grn_no                            grno,
       dtl.hscode                            hsc,
       dtl.hscode1                           hsc1,
       dtl.exp_type                          exptyp,
       dtl.rec_type                          rectyp,
       dtl.unit_sd                           usd,
       dtl.unit_vat                          udvat,
       dtl.company_id                        cid,
       dtl.uom                               um
  FROM vat_formulation mst, rmpmexp_vat_formula_master dtl
 WHERE mst.vat_formula_slno = dtl.vat_formula_slno



BEGIN
    -- Open the main JSON object
    APEX_JSON.open_object;
    
    -- Open the array to hold multiple items
    APEX_JSON.open_array('items');
    
    -- Query the data from your table
    FOR rec IN (
        SELECT dtl.vat_formula_slno      vfid,
               dtl.rmpmexp_code          rmid,
               dtl.exp_code              expid,
               dtl.required_qty_disp     reqdqty,
               dtl.required_qty          reqqty,
               dtl.wastage_qty           wstqty,
               dtl.unit_price            uprc,
               dtl.price                 prc,
               dtl.exp_price             exprc,
               dtl.colnumber             colno,
               dtl.t_type                typ,
               dtl.slno                  sl,
               dtl.uvprice               uvprc,
               dtl.wastage_per           wstprcnt,
               dtl.grn_no                grno,
               dtl.hscode                hsc,
               dtl.hscode1               hsc1,
               dtl.exp_type              exptyp,
               dtl.rec_type              rectyp,
               dtl.unit_sd               usd,
               dtl.unit_vat              udvat,
               dtl.company_id            cid,
               dtl.uom                   um
          FROM vat_formulation mst, rmpmexp_vat_formula_master dtl
         WHERE mst.vat_formula_slno = dtl.vat_formula_slno
           AND product_code = :p444_product_code
           AND mst.vat_formula_slno = (
               SELECT MAX(vat_formula_slno)
                 FROM vat_formulation m2
                WHERE mst.product_code = m2.product_code
           )
    ) LOOP
        -- Open an object for each record
        APEX_JSON.open_object;        
        -- Write key-value pairs for each field
        APEX_JSON.write('vfid', rec.vfid);
        APEX_JSON.write('rmid', rec.rmid);
        APEX_JSON.write('expid', rec.expid);
        APEX_JSON.write('reqdqty', rec.reqdqty);
        APEX_JSON.write('reqqty', rec.reqqty);
        APEX_JSON.write('wstqty', rec.wstqty);
        APEX_JSON.write('uprc', rec.uprc);
        APEX_JSON.write('prc', rec.prc);
        APEX_JSON.write('exprc', rec.exprc);
        APEX_JSON.write('colno', rec.colno);
        APEX_JSON.write('typ', rec.typ);
        APEX_JSON.write('sl', rec.sl);
        APEX_JSON.write('uvprc', rec.uvprc);
        APEX_JSON.write('wstprcnt', rec.wstprcnt);
        APEX_JSON.write('grno', rec.grno);
        APEX_JSON.write('hsc', rec.hsc);
        APEX_JSON.write('hsc1', rec.hsc1);
        APEX_JSON.write('exptyp', rec.exptyp);
        APEX_JSON.write('rectyp', rec.rectyp);
        APEX_JSON.write('usd', rec.usd);
        APEX_JSON.write('udvat', rec.udvat);
        APEX_JSON.write('cid', rec.cid);
        APEX_JSON.write('um', rec.um);
        
        -- Close the object for this record
        APEX_JSON.close_object;
    END LOOP;
    
    -- Close the array
    APEX_JSON.close_array;
    
    -- Close the main JSON object
    APEX_JSON.close_object;
END;