/* Formatted on 5/20/2025 1:03:50 PM (QP5 v5.362) */
CREATE OR REPLACE VIEW v_guarator
AS
    SELECT es.emp_id,
           es.NAME                      gname,
           GRNT_FATHER                  gco,
           RELATIONSHIP                 rel,
           GRNT_PROFFESSION             prof,
           GRNT_NID                     nid,
           CONTACT_DETAILS              mobile,
              'Area/Village: '
           || es.address2
           || ', Post Office: '
           || NVL (un.name, 'N/A')
           || ', Thana/Upazila: '
           || NVL (upz.name, 'N/A')
           || ', District: '
           || NVL (dis.name, 'N/A')
           || ', Division: '
           || NVL (div.name, 'N/A')     AS preadd,
              'Area/Village: '
           || es.address
           || ', Post Office: '
           || NVL (un1.name, 'N/A')
           || ', Thana/Upazila: '
           || NVL (upz1.name, 'N/A')
           || ', District: '
           || NVL (dis1.name, 'N/A')
           || ', Division: '
           || NVL (div1.name, 'N/A')    AS peradd
      FROM EMP_GUARANTORS  es,
           division        div,
           district        dis,
           upazila         upz,
           unions          un,
           division        div1,
           district        dis1,
           upazila         upz1,
           unions          un1
     WHERE     es.POST = un.id(+)
           AND es.thana = upz.id(+)
           AND es.district = dis.id(+)
           AND es.division = div.id(+)
           AND es.p_post = un1.id(+)
           AND es.p_thana = upz1.id(+)
           AND es.p_district = dis1.id(+)
           AND es.p_division = div1.id(+)