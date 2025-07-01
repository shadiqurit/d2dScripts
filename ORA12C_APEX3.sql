set define off;
CREATE OR REPLACE PACKAGE BODY IPIHR.ora12c_apex3
IS
---- VERSION 2.0 UPDATE ON 17 FEB, 2013------------------------------
   PROCEDURE get_report_param_default_value (
      p_userid                         VARCHAR2,
      p_report_id                      NUMBER,
      p_parameter_id                   NUMBER,
      p_paramater_value_date     OUT   DATE,
      p_paramater_value_char     OUT   VARCHAR2,
      p_paramater_value_char_t   OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT MAX (DECODE (parameter_datatype_id, 3, default_value_date, NULL)),
             MAX (DECODE (parameter_datatype_id, 3, NULL, default_value_char)),
             MAX (default_value_char_t)
        INTO p_paramater_value_date,
             p_paramater_value_char,
             p_paramater_value_char_t
        FROM ipihr.report_param_default_value
       WHERE UPPER (userid) = UPPER (p_userid)
         AND report_id = p_report_id
         AND parameter_id = p_parameter_id;

      p_paramater_value_date := NVL (p_paramater_value_date, SYSDATE);
            /*
            update report_param_default_value a
   set default_value_char=(select max(default_value ) from report_parameter
   where report_id =a.report_id and parameter_id =a.parameter_id ) ;

   */
   END;

   PROCEDURE ins_report_param_default_value (
      p_userid      VARCHAR2,
      p_report_id   NUMBER,
      p_301         DATE,
      p_302         DATE,
      p_303         DATE,
      p_304         DATE,
      p_201         NUMBER,
      p_202         NUMBER,
      p_203         NUMBER,
      p_204         NUMBER,
      p_205         NUMBER,
      p_206         NUMBER,
      p_207         NUMBER,
      p_401         VARCHAR2,
      p_402         VARCHAR2,
      p_403         VARCHAR2,
      p_404         VARCHAR2,
      p_405         VARCHAR2,
      p_406         VARCHAR2,
      p_407         VARCHAR2
   )
   IS
   BEGIN
      --- insert
      MERGE INTO ipihr.report_param_default_apex a
         USING (SELECT p_userid userid, p_report_id report_id, p_301 b_301,
                       p_302 b_302, p_303 b_303, p_304 b_304, p_201 b_201,
                       p_202 b_202, p_203 b_203, p_204 b_204, p_205 b_205,
                       p_206 b_206, p_207 b_207, p_401 b_401, p_402 b_402,
                       p_403 b_403, p_404 b_404, p_405 b_405, p_406 b_406,
                       p_407 b_407
                  FROM SYS.DUAL) b
         ON (a.userid = b.userid AND a.report_id = b.report_id)
         WHEN MATCHED THEN
            UPDATE
               SET p_301 = b_301, p_302 = b_302, p_303 = b_303,
                   p_304 = b_304, p_201 = b_201, p_202 = b_202,
                   p_203 = b_203, p_204 = b_204, p_205 = b_205,
                   p_206 = b_206, p_207 = b_207, p_401 = b_401,
                   p_402 = b_402, p_403 = b_403, p_404 = b_404,
                   p_405 = b_405, p_406 = b_406, p_407 = b_407
         WHEN NOT MATCHED THEN
            INSERT (a.userid, a.report_id, p_301, p_302, p_303, p_304, p_201,
                    p_202, p_203, p_204, p_205, p_206, p_207, p_401, p_402,
                    p_403, p_404, p_405, p_406, p_407)
            VALUES (b.userid, b.report_id, b_301, b_302, b_303, b_304, b_201,
                    b_202, b_203, b_204, b_205, b_206, b_207, b_401, b_402,
                    b_403, b_404, b_405, b_406, b_407);
      COMMIT;
   END;

   FUNCTION parameter_replace (p_report_id NUMBER, p_parameter_id NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR c
      IS
         SELECT a.parameter_title, c.parameter_datatype
           FROM ipihr.report_parameter a,
                ipihr.report_parameter_list b,
                ipihr.report_parameter_type c
          WHERE report_id = p_report_id
            AND a.parameter_id <> p_parameter_id
            AND a.parameter_id = b.parameter_id
            AND b.parameter_datatype_id = c.parameter_datatype_id;

      v_lov_id   NUMBER;
      l          report_lov_list%ROWTYPE;
      v_value    VARCHAR2 (100);
      v_exists   NUMBER                    := 0;
      --REPORT_PARAM_DEFAULT_VALUE

      --REPORT_LOV_LIST
      v_r_text   VARCHAR2 (100);
   BEGIN
      SELECT MAX (lov_id)
        INTO v_lov_id
        FROM ipihr.report_parameter
       WHERE report_id = p_report_id
         AND parameter_datatype_id || '0' || sl = p_parameter_id
         AND is_replace = 1;

      SELECT COUNT (*)
        INTO v_exists
        FROM ipihr.report_lov_list
       WHERE lov_id = v_lov_id AND is_replace = 1;

      IF v_exists = 1
      THEN
         RETURN v_lov_id;
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   PROCEDURE run_process (
      p_obj_id_p      IN       NUMBER,
      o_status_code            NUMBER,
      o_status_msg    OUT      VARCHAR2
   )
   IS
      v_sql   VARCHAR2 (1500);
   BEGIN
      SELECT sql_statement
        INTO v_sql
        FROM sm_object_list
       WHERE obj_id = p_obj_id_p;

      EXECUTE IMMEDIATE v_sql
                  USING OUT o_status_msg;
   END;

   ----------- url generate /* Formatted on 2016/09/26 16:17 (Formatter Plus v4.8.8) */
   PROCEDURE get_report_url_001 (
      p_current_url         VARCHAR2,
      p_obj_id_2            NUMBER,
      p_301                 DATE DEFAULT NULL,
      p_302                 DATE DEFAULT NULL,
      p_303                 DATE DEFAULT NULL,
      p_304                 DATE DEFAULT NULL,
      p_201                 NUMBER DEFAULT NULL,
      p_202                 NUMBER DEFAULT NULL,
      p_203                 NUMBER DEFAULT NULL,
      p_204                 NUMBER DEFAULT NULL,
      p_205                 NUMBER DEFAULT NULL,
      p_206                 NUMBER DEFAULT NULL,
      p_207                 NUMBER DEFAULT NULL,
      p_401                 VARCHAR2 DEFAULT NULL,
      p_402                 VARCHAR2 DEFAULT NULL,
      p_403                 VARCHAR2 DEFAULT NULL,
      p_404                 VARCHAR2 DEFAULT NULL,
      p_405                 VARCHAR2 DEFAULT NULL,
      p_406                 VARCHAR2 DEFAULT NULL,
      p_407                 VARCHAR2 DEFAULT NULL,
      o_url           OUT   VARCHAR2
   )
   --BOOLEAN
   IS
      v_ip            VARCHAR2 (100);
      v               VARCHAR2 (4000);
      v_report_name   VARCHAR2 (100);
      r_port number;

      CURSOR c
      IS
         SELECT '&' || parameter_title || '=' || parameter_value url
           FROM (SELECT a.parameter_title,
                        b.parameter_datatype_id || '0' || b.sl dos,
                        DECODE (b.parameter_datatype_id || '0' || b.sl,
                                '301', TO_CHAR (p_301, 'DD-MON-RR'),
                                '302', TO_CHAR (p_302, 'DD-MON-RR'),
                                '303', TO_CHAR (p_303, 'DD-MON-RR'),
                                '304', TO_CHAR (p_304, 'DD-MON-RR'),
                                '201', p_201,
                                '202', p_202,
                                '203', p_203,
                                '204', p_204,
                                '205', p_205,
                                '206', p_206,
                                '207', p_207,
                                '401', p_401,
                                '402', p_402,
                                '403', p_403,
                                '404', p_404,
                                '405', p_405,
                                '406', p_406,
                                '407', p_407
                               ) parameter_value
                   FROM ipihr.report_parameter_list a,
                        ipihr.report_parameter b,
                        ipihr.parameter_sl c
                  WHERE a.parameter_id = b.parameter_id
                    AND a.parameter_datatype_id = b.parameter_datatype_id
                    AND b.parameter_datatype_id || '0' || b.sl = c.sl
                    AND b.report_id = p_obj_id_2);
   BEGIN
      SELECT obj_name
        INTO v_report_name
        FROM sm_object_list
       WHERE obj_id = p_obj_id_2;
       
       r_port := TRUNC(DBMS_RANDOM.VALUE(9003, 9013));

      FOR a IN c
      LOOP
         v := v || a.url;
      END LOOP;

      -- http://192.168.5.95:9002/reports/rwservlet?dsc&server=rep_wls_reports_comp344&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\att_daily_status.rdf&P_FDATE=24-SEP-16&P_D_CODE=Accounts&p_status=&p_unitid=Unit-01&p_dp_code=HDO&p_section_name=

      --http://192.168.5.95:9002/reports/rwservlet?dsc&server=rep_wls_reports_comp344&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\att_daily_status.rdf&P_FDATE=24-SEP-16&P_D_CODE=Accounts&p_status=&p_unitid=Unit-01&p_dp_code=HDO&p_section_name=

      --local ip

      /*
      IF NVL (INSTR (p_current_url, '192.168.5.95'), 0) > 0
      THEN
         v_ip := '192.168.5.95';
      END IF;

      -- Real IP
      IF NVL (INSTR (p_current_url, '119.148.41.20'), 0) > 0
      THEN
         v_ip := '119.148.41.20';
      END IF;

      */
      v_ip := '10.30.20.5';
      o_url :=
            'http://'
         || v_ip
         || ':'|| r_port|| '/reports/rwservlet?userid=ipihr/i@ipihr&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\'
         --
         || v_report_name
         || '.RDF'
         || v;
   /*

   javascript:var x=window.open('http://192.168.199.230:9002/reports/rwservlet?userid=ppldp/p@ppl12c&server=rep_wls_reports_webserver12c&desformat=PDF'+document.getElementById('P132_P_301_P').value +document.getElementById('P132_P_301').value +document.getElementById('P132_P_302_P').value +document.getElementById('P132_P_302').value +document.getElementById('P132_P_303_P').value +document.getElementById('P132_P_303').value +document.getElementById('P132_P_304_P').value +document.getElementById('P132_P_304').value +document.getElementById('P132_P_401_P').value +document.getElementById('P132_P_401').value +document.getElementById('P132_P_402_P').value +document.getElementById('P132_P_402').value +document.getElementById('P132_P_403_P').value +document.getElementById('P132_P_403').value +document.getElementById('P132_P_404_P').value +document.getElementById('P132_P_404').value +document.getElementById('P132_P_405_P').value +document.getElementById('P132_P_405').value +document.getElementById('P132_P_406_P').value +document.getElementById('P132_P_406').value +document.getElementById('P132_P_407_P').value +document.getElementById('P132_P_407').value +document.getElementById('P132_P_201_P').value +document.getElementById('P132_P_201').value +document.getElementById('P132_P_202_P').value +document.getElementById('P132_P_202').value +document.getElementById('P132_P_203_P').value +document.getElementById('P132_P_203').value +document.getElementById('P132_P_204_P').value +document.getElementById('P132_P_204').value +document.getElementById('P132_P_205_P').value +document.getElementById('P132_P_205').value +document.getElementById('P132_P_206_P').value +document.getElementById('P132_P_206').value +document.getElementById('P132_P_207_P').value +document.getElementById('P132_P_207').value +'&destype=cache&report=Z:/Stepserp/depo/invoice_sum'+document.getElementById('P132_REPORT_NAME').value + '.RDF','_blank');

   */
   END;

   PROCEDURE get_report_url_001_xl (
      p_current_url         VARCHAR2,
      p_obj_id_2            NUMBER,
      p_301                 DATE DEFAULT NULL,
      p_302                 DATE DEFAULT NULL,
      p_303                 DATE DEFAULT NULL,
      p_304                 DATE DEFAULT NULL,
      p_201                 NUMBER DEFAULT NULL,
      p_202                 NUMBER DEFAULT NULL,
      p_203                 NUMBER DEFAULT NULL,
      p_204                 NUMBER DEFAULT NULL,
      p_205                 NUMBER DEFAULT NULL,
      p_206                 NUMBER DEFAULT NULL,
      p_207                 NUMBER DEFAULT NULL,
      p_401                 VARCHAR2 DEFAULT NULL,
      p_402                 VARCHAR2 DEFAULT NULL,
      p_403                 VARCHAR2 DEFAULT NULL,
      p_404                 VARCHAR2 DEFAULT NULL,
      p_405                 VARCHAR2 DEFAULT NULL,
      p_406                 VARCHAR2 DEFAULT NULL,
      p_407                 VARCHAR2 DEFAULT NULL,
      o_url           OUT   VARCHAR2
   )
   --BOOLEAN
   IS
      v_ip            VARCHAR2 (100);
      v               VARCHAR2 (4000);
      v_report_name   VARCHAR2 (100);

      CURSOR c
      IS
         SELECT '&' || parameter_title || '=' || parameter_value url
           FROM (SELECT a.parameter_title,
                        b.parameter_datatype_id || '0' || b.sl dos,
                        DECODE (b.parameter_datatype_id || '0' || b.sl,
                                '301', TO_CHAR (p_301, 'DD-MON-RR'),
                                '302', TO_CHAR (p_302, 'DD-MON-RR'),
                                '303', TO_CHAR (p_303, 'DD-MON-RR'),
                                '304', TO_CHAR (p_304, 'DD-MON-RR'),
                                '201', p_201,
                                '202', p_202,
                                '203', p_203,
                                '204', p_204,
                                '205', p_205,
                                '206', p_206,
                                '207', p_207,
                                '401', p_401,
                                '402', p_402,
                                '403', p_403,
                                '404', p_404,
                                '405', p_405,
                                '406', p_406,
                                '407', p_407
                               ) parameter_value
                   FROM ipihr.report_parameter_list a,
                        ipihr.report_parameter b,
                        ipihr.parameter_sl c
                  WHERE a.parameter_id = b.parameter_id
                    AND a.parameter_datatype_id = b.parameter_datatype_id
                    AND b.parameter_datatype_id || '0' || b.sl = c.sl
                    AND b.report_id = p_obj_id_2);
                    v_port number ;
   BEGIN
      SELECT obj_name
        INTO v_report_name
        FROM sm_object_list
       WHERE obj_id = p_obj_id_2;

      FOR a IN c
      LOOP
         v := v || a.url;
      END LOOP;

      -- http://192.168.5.95:9002/reports/rwservlet?dsc&server=rep_wls_reports_comp344&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\att_daily_status.rdf&P_FDATE=24-SEP-16&P_D_CODE=Accounts&p_status=&p_unitid=Unit-01&p_dp_code=HDO&p_section_name=

      --http://192.168.5.95:9002/reports/rwservlet?dsc&server=rep_wls_reports_comp344&desformat=PDF&destype=cache&report=e:\global\Stepshr\hr\report\att_daily_status.rdf&P_FDATE=24-SEP-16&P_D_CODE=Accounts&p_status=&p_unitid=Unit-01&p_dp_code=HDO&p_section_name=

      --local ip

      /*
      IF NVL (INSTR (p_current_url, '192.168.5.95'), 0) > 0
      THEN
         v_ip := '192.168.5.95';
      END IF;

      -- Real IP
      IF NVL (INSTR (p_current_url, '119.148.41.20'), 0) > 0
      THEN
         v_ip := '119.148.41.20';
      END IF;

      */
      
         get_set_report_server (p_user    =>'system' ,
                                                   o_port =>    v_port);
      v_ip := '10.30.20.5';
      o_url :=
            'http://'
         || v_ip
         || ':'|| v_port|| '/reports/rwservlet?userid=ipihr/i@ipihr&desformat=spreadsheet&destype=cache&report=e:\global\Stepshr\hr\report\'
         --
         || v_report_name
         || '.RDF'
         || v;
   /*

   javascript:var x=window.open('http://192.168.199.230:9002/reports/rwservlet?userid=ppldp/p@ppl12c&server=rep_wls_reports_webserver12c&desformat=PDF'+document.getElementById('P132_P_301_P').value +document.getElementById('P132_P_301').value +document.getElementById('P132_P_302_P').value +document.getElementById('P132_P_302').value +document.getElementById('P132_P_303_P').value +document.getElementById('P132_P_303').value +document.getElementById('P132_P_304_P').value +document.getElementById('P132_P_304').value +document.getElementById('P132_P_401_P').value +document.getElementById('P132_P_401').value +document.getElementById('P132_P_402_P').value +document.getElementById('P132_P_402').value +document.getElementById('P132_P_403_P').value +document.getElementById('P132_P_403').value +document.getElementById('P132_P_404_P').value +document.getElementById('P132_P_404').value +document.getElementById('P132_P_405_P').value +document.getElementById('P132_P_405').value +document.getElementById('P132_P_406_P').value +document.getElementById('P132_P_406').value +document.getElementById('P132_P_407_P').value +document.getElementById('P132_P_407').value +document.getElementById('P132_P_201_P').value +document.getElementById('P132_P_201').value +document.getElementById('P132_P_202_P').value +document.getElementById('P132_P_202').value +document.getElementById('P132_P_203_P').value +document.getElementById('P132_P_203').value +document.getElementById('P132_P_204_P').value +document.getElementById('P132_P_204').value +document.getElementById('P132_P_205_P').value +document.getElementById('P132_P_205').value +document.getElementById('P132_P_206_P').value +document.getElementById('P132_P_206').value +document.getElementById('P132_P_207_P').value +document.getElementById('P132_P_207').value +'&destype=cache&report=Z:/Stepserp/depo/invoice_sum'+document.getElementById('P132_REPORT_NAME').value + '.RDF','_blank');

   */
   END;
END;
/
