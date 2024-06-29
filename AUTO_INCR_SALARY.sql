CREATE OR REPLACE PROCEDURE IPIHR.auto_incr_salary (
   p_yearmn     IN     NUMBER,
   p_ltype      IN     VARCHAR2,
   p_ccode      IN     VARCHAR2,
   p_username   IN     VARCHAR2,
   o_msg           OUT VARCHAR2)
AS
   CURSOR c_emp
   IS
      SELECT yearmn,
             empcode,
             refdate,
             empno,
             e_name,
             desig_code,
             desig_name,
             dept_code,
             dept_name,
             lr_refno,
             lr_refdate,
             lr_edate,
             lr_type,
             lr_typename,
             nr_date,
             review_qualify,
             actual_date,
             actual_refno,
             username,
             updateby,
             updateddate,
             review_cons_date,
             businessunitid,
             trnfrom
        FROM hr_review_det
       WHERE     yearmn = p_yearmn
             AND NVL (review_qualify, 'N') = 'Y'
             AND actual_refno IS NULL;

   CURSOR c1 (
      p_empcode        VARCHAR2,
      p_salarygrade    VARCHAR2)
   IS
        SELECT h.slno,
               h.empcode,
               h.yearofstruc,
               h.edate,
               h.trndate,
               h.particular,
               h.desigcode,
               h.amountprv,
               h.amountcur,
               h.salper,
               h.refno,
               h.yearmn,
               h.prtclr_type,
               h.ptc_flat,
               h.headcode,
               h.sl,
               h.addedby,
               h.add_comp_name,
               h.add_ipadd,
               h.add_osuser,
               h.upd_comp_name,
               h.upd_ipadd,
               h.upd_osuser,
               h.updateddate,
               h.updatedby,
               h.scale
          FROM hr_empsalstructure h, hr_head b
         WHERE     h.slno = b.slno
               AND empcode = p_empcode
               AND h.slno <> 15
               AND (SUBSTR (b.TYPE, 1, 1) = '1' OR h.slno = 57)
      ORDER BY slno;

   v_ebrate          NUMBER;
   v_initial_basic   NUMBER;
   v_no_ofincr       NUMBER;
   no_ofincr         NUMBER;
   v_n_incr          NUMBER;
   v_n_ebincr        NUMBER;
   v_n_genincr       NUMBER;
   v_ebamount        NUMBER;
   v_genamount       NUMBER;
   v_diff            NUMBER;
   salaryb4incr      NUMBER;
   ebrate            NUMBER;
   v_incrrate        NUMBER;
   v_amount          NUMBER;
   v_hr              NUMBER;
   v_pf              NUMBER;
   salaryafterincr   NUMBER;
   vsl               NUMBER;
   v_txt1            VARCHAR2 (2000);
   v_salarygrade     VARCHAR2 (30);
   v_rec             NUMBER;
   no_ofincr_eb      NUMBER;
   v_refno           VARCHAR2 (30);
   v_slno            NUMBER;
   v_amountcur       NUMBER;
   v_salper          NUMBER;
   v_totemp          NUMBER := 1;
   v_get_eb          VARCHAR2 (1) := 'N';
   v_da              NUMBER;

   v_max_basic       NUMBER;
BEGIN
   SELECT NVL (COUNT (*), 0)
     INTO v_rec
     FROM hr_empchange
    WHERE yearmn = p_yearmn AND datasource = 'Process';

   IF NVL (v_rec, 0) > 0
   THEN
      o_msg := 'Already process data';
   -- RETURN;
   END IF;

   SELECT NVL (MAX (TO_NUMBER (SUBSTR (refno, 11))), 0) + 1
     INTO vsl
     FROM hr_empchange
    WHERE refno LIKE p_ltype || p_yearmn || '%';

   SELECT lbody1
     INTO v_txt1
     FROM hr_letterbody
    WHERE ltype = '101';

   FOR a IN c_emp
   LOOP
      SELECT salarygrade
        INTO v_salarygrade
        FROM emp
       WHERE empcode = a.empcode;

      SELECT MAX (NVL (ebrate, 0)),
             MAX (NVL (lfa1, 0)),
             MAX (NVL (gradelevel, 0)),
             MAX (NVL (incrrate, 0)),
            max(  NVL (lfa1, 0) + (gradelevel * incrrate) + (ebrate * no_ofincr)) 
        INTO v_ebrate,
             v_initial_basic,
             v_no_ofincr,
             v_incrrate,
             v_max_basic
        FROM hr_salarygrade
       WHERE sgrade = v_salarygrade;

      SELECT MAX (NVL (salper, 0))
        INTO salaryb4incr
        FROM hr_empsalstructure
       WHERE empcode = a.empcode AND slno = 1;


      IF salaryb4incr >= v_max_basic
      THEN
      null;
      
     else 



      --v_diff := NVL (salaryb4incr, 0) - NVL (v_initial_basic, 0);
      ebrate := v_ebrate;
      no_ofincr := 1;
      v_n_incr := 0;
      v_amount := 0;
      no_ofincr_eb := 0;
      v_n_genincr := 0;
      v_ebamount := 0;
      v_genamount := 0;
      v_diff := 0;
      v_diff := NVL (salaryb4incr, 0) - NVL (v_initial_basic, 0);

      IF p_ltype IN ('101', '110')
      THEN
         IF NVL (v_incrrate, 0) > 0
         THEN
            v_n_incr := NVL (v_diff, 0) / NVL (v_incrrate, 0);

            IF NVL (v_n_incr, 0) >= NVL (v_no_ofincr, 0)
            THEN
               NULL;
               v_amount := ROUND (NVL (no_ofincr, 0) * NVL (v_ebrate, 0));
               v_get_eb := 'Y';
            ELSIF NVL (v_n_incr, 0) + NVL (no_ofincr, 0) >
                     NVL (v_no_ofincr, 0)
            THEN
               v_n_ebincr :=
                    (NVL (v_n_incr, 0) + NVL (no_ofincr, 0))
                  - NVL (v_no_ofincr, 0);
               no_ofincr_eb := NVL (v_n_ebincr, 0);
               v_n_genincr := NVL (no_ofincr, 0) - NVL (v_n_ebincr, 0);
               v_ebamount := NVL (v_n_ebincr, 0) * NVL (v_ebrate, 0);
               v_genamount := NVL (v_n_genincr, 0) * NVL (v_incrrate, 0);
               v_amount := NVL (v_ebamount, 0) + NVL (v_genamount, 0);

               IF NVL (no_ofincr_eb, 0) > 0
               THEN
                  v_get_eb := 'Y';
               ELSE
                  v_get_eb := 'N';
               END IF;
            ELSE
               v_amount := NVL (no_ofincr, 0) * NVL (v_incrrate, 0);
               v_get_eb := 'N';
            END IF;
         END IF;
      ELSIF p_ltype IN ('102')
      THEN
         IF NVL (no_ofincr, 0) > NVL (v_no_ofincr, 0)
         THEN
            v_n_ebincr := NVL (no_ofincr, 0) - NVL (v_no_ofincr, 0);
            v_ebamount := NVL (v_n_ebincr, 0) * NVL (v_ebrate, 0);
            v_genamount := NVL (v_no_ofincr, 0) * NVL (v_incrrate, 0);
            v_amount := NVL (v_ebamount, 0) + NVL (v_genamount, 0);
         ELSE
            NULL;
            v_amount := NVL (no_ofincr, 0) * NVL (v_incrrate, 0);
         END IF;
      ELSE
         v_amount := NVL (no_ofincr, 0) * NVL (v_incrrate, 0);
      END IF;

      v_hr := ROUND (NVL (v_amount, 0) * .75);
      v_pf := ROUND (NVL (v_amount, 0) * .1);
      salaryafterincr := NVL (salaryb4incr, 0) + NVL (v_amount, 0);
      --letter_content_replace (v_txt2, v_txt1);
      --v_ebrate := v_ebrate;
      --end if;
      --NULL;
      v_refno := p_ltype || p_yearmn || '/' || vsl;
      vsl := NVL (vsl, 0) + 1;

      SELECT NVL (MAX (slno), 0) + 1
        INTO v_slno
        FROM hr_empchange
       WHERE empcode = a.empcode;

      INSERT INTO hr_empchange (refno,
                                refdate,
                                ltype,
                                empcode,
                                username,
                                ccode,
                                amount,
                                tericode,
                                edate,
                                emp_hrcode,
                                tarm_type,
                                incrtype,
                                salaryb4incr,
                                salaryafterincr,
                                lastincrdate,
                                lastincramount,
                                lastconfst,
                                datasource,
                                hrrefno,
                                period,
                                yearofapp,
                                yearmn,
                                no_ofincr,
                                sgrade_before,
                                sgrade_after,
                                incrrate,
                                txt1,
                                txt2,
                                dept,
                                subdept,
                                salarystep,
                                ltypedes,
                                teriname,
                                area_id,
                                area_name,
                                region_id,
                                region_name,
                                dp_code,
                                desig_name_before,
                                desig_name_after,
                                desig_code_before,
                                desig_code_after,
                                ebrate,
                                no_ofincr_eb,
                                amount_eb,
                                slno,
                                incrrate_p,
                                ebrate_p,
                                arrear_c,
                                arrear_p,
                                amount_p,
                                p_month,
                                p_day,
                                c_month,
                                c_day,
                                get_eb)
         (SELECT v_refno refno, /*TO_DATE (p_yearmn || '01',
                                         'yyyymmdd') */
                 a.nr_date refdate,
                 '101' ltype,
                 a.empcode empcode,
                 p_username username,
                 p_ccode ccode,
                 v_amount amount,
                 NULL tericode,
                 SYSDATE edate,
                 a.empcode emp_hrcode,
                 NULL tarm_type,
                 'Anual' incrtype,
                 salaryb4incr salaryb4incr,
                 salaryafterincr salaryafterincr,
                 NULL lastincrdate,
                 NULL lastincramount,
                 NULL lastconfst,
                 'Process' datasource,
                 NULL hrrefno,
                 SUBSTR (p_yearmn, 1, 4) period,
                 SUBSTR (p_yearmn, 1, 4) yearofapp,
                 p_yearmn yearmn,
                 1 no_ofincr,
                 v_salarygrade sgrade_before,
                 v_salarygrade sgrade_after,
                 v_incrrate incrrate,
                 v_txt1 txt1,
                 v_txt1 txt2,
                 NULL dept,
                 NULL subdept,
                 NULL salarystep,
                 'Increment Letter' ltypedes,
                 NULL teriname,
                 NULL area_id,
                 NULL area_name,
                 NULL region_id,
                 NULL region_name,
                 NULL dp_code,
                 a.desig_name desig_name_before,
                 a.desig_name desig_name_after,
                 a.desig_code desig_code_before,
                 a.desig_code desig_code_after,
                 v_ebrate ebrate,
                 no_ofincr_eb no_ofincr_eb,
                 v_ebamount amount_eb,
                 v_slno slno,
                 NULL incrrate_p,
                 NULL ebrate_p,
                 NULL arrear_c,
                 NULL arrear_p,
                 NULL amount_p,
                 NULL p_month,
                 NULL p_day,
                 NULL c_month,
                 NULL c_day,
                 v_get_eb get_eb
            FROM SYS.DUAL);

      --- Salary Log Generate -------------------
      salary_log_gen (a.empcode, v_refno, 'Process');

      -----Salary structure updation-----------------------
      FOR i IN c1 (a.empcode, v_salarygrade)
      LOOP
         IF i.slno = 1
         THEN
            v_amountcur := NVL (i.salper, 0) + NVL (v_amount, 0);
            v_salper := NVL (i.salper, 0) + NVL (v_amount, 0);
         --:cur_amt := NVL (i.salper, 0);
         ELSIF i.slno = 5
         THEN
            v_amountcur := NVL (i.salper, 0) + NVL (v_hr, 0);
            v_salper := NVL (i.salper, 0) + NVL (v_hr, 0);
         ELSIF i.slno = 13
         THEN
            v_amountcur := NVL (i.salper, 0) + NVL (v_pf, 0);
            v_salper := NVL (i.salper, 0) + NVL (v_pf, 0);
         ELSIF i.slno = 57
         THEN
            v_amountcur := NVL (i.salper, 0) + (NVL (v_pf, 0) * 2);
            v_salper := NVL (i.salper, 0) + (NVL (v_pf, 0) * 2);
         ELSIF i.slno = 15
         THEN
            IF UPPER (v_salarygrade) NOT IN ('GRADE-15',
                                             'GRADE-16',
                                             'GRADE-17',
                                             'GRADE-18',
                                             'GRADE-19',
                                             'GRADE-20')
            THEN
               IF ROUND ( (NVL (salaryb4incr, 0) + NVL (v_amount, 0)) * .15) <
                     1500
               THEN
                  v_da := 0;                                           --1500;
               ELSE
                  v_da := 0;
               --ROUND ((NVL (salaryb4incr, 0) + NVL (v_amount, 0)) * .15);
               END IF;
            ELSE
               v_da := 0;
            END IF;

            v_amountcur := v_da;
            /*   NVL (i.salper, 0)
             + CASE
                  WHEN NVL (i.salper, 0) > 0
                     THEN (ROUND (NVL (v_amount, 0) * .15))
                  ELSE 0
               END; */
            v_salper := v_da;
         /*    NVL (i.salper, 0)
           + CASE
                WHEN NVL (i.salper, 0) > 0
                   THEN (ROUND (NVL (v_amount, 0) * .2))
                ELSE 0
             END; */
         ELSE
            v_amountcur := i.salper;
            v_salper := i.salper;
         END IF;

         INSERT INTO hr_empincr_det (refno,
                                     ltype,
                                     slno,
                                     empcode,
                                     yearofstruc,
                                     edate,
                                     trndate,
                                     particular,
                                     desigcode,
                                     salary_1step_before,
                                     amountprv,
                                     amountcur,
                                     salper,
                                     yearmn,
                                     prtclr_type,
                                     headcode,
                                     addedby,
                                     add_comp_name,
                                     add_ipadd,
                                     add_osuser,
                                     upd_comp_name,
                                     upd_ipadd,
                                     upd_osuser,
                                     updateddate,
                                     updatedby,
                                     scale,
                                     datasource)
            (SELECT v_refno,
                    p_ltype ltype,
                    i.slno,
                    a.empcode empcode,
                    i.yearofstruc,
                    SYSDATE edate,
                    TRUNC (SYSDATE) trndate,
                    i.particular,
                    i.desigcode,
                    CASE
                       WHEN NVL (i.amountprv, 0) > 0
                       THEN
                          NVL (i.amountprv, 0)
                       ELSE
                          NVL (i.amountcur, 0)
                    END,
                    i.salper amountprv,
                    v_amountcur amountcur,
                    v_salper salper,
                    i.yearmn,
                    i.prtclr_type,
                    i.headcode,
                    p_username,
                    NULL add_comp_name,
                    NULL add_ipadd,
                    NULL add_osuser,
                    NULL upd_comp_name,
                    NULL upd_ipadd,
                    NULL upd_osuser,
                    NULL updateddate,
                    NULL updatedby,
                    NULL scale,
                    'Process'
               FROM SYS.DUAL);
      END LOOP;

      UPDATE hr_review_det
         SET actual_refno = v_refno, actual_date = SYSDATE
       WHERE empcode = a.empcode AND yearmn = p_yearmn;

      v_totemp := NVL (v_totemp, 0) + 1;
      
      end if;
      
   END LOOP;

   ---- For arrear  calculation------------------------
   arrear_for_p_incr (p_yearmn, NULL);
   o_msg := 'Total ' || v_totemp || ' record process succesfully';
/*EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      o_msg := 'Process fail due to ' || SQLERRM (SQLCODE);*/
END;
/
