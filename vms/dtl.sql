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