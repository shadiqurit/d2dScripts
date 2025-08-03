/* Formatted on 7/28/2025 1:14:40 PM (QP5 v5.362) */
CREATE OR REPLACE FORCE VIEW V_SAL_REFIX25_7
AS
      SELECT empcode        AS empcode_s,
             ''             AS refno_s,
             particular     AS particular_s,
             amountprv,
             amountcur,
             s.headcode     AS headcode_s
        FROM v_salary_comparison s JOIN hr_head h ON h.slno = s.slno
       WHERE     -- empcode = 'IPI-009129'    AND
                 h.TYPE = '1-Pay'
             AND (s.slno <> 15 OR s.slno = 15)
             AND (s.amountprv + s.amountcur) > 0
    ORDER BY empcode, s.slno;