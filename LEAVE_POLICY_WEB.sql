CREATE OR REPLACE PROCEDURE IPIHR.leave_policy_web (
   p_empcode                VARCHAR2,
   p_date_from     IN OUT   DATE,
   p_date_to       IN OUT   DATE,
   p_leave_type    IN OUT   VARCHAR2,
   o_duration      OUT      NUMBER,
   o_status_code   OUT      NUMBER,
   o_msg           OUT      VARCHAR2
)
AS
   cl_this_year_balance   NUMBER := 0;
   cl_this_year_avail     NUMBER := 0;
   v_duration_minus       NUMBER := 0;
   v_el                   NUMBER;
   v_cl                   NUMBER;
   v_tran_date            DATE;
   total_el_in_year       NUMBER;
   total_sl_in_year       NUMBER;
   v_leave_el_balance     NUMBER;
   total_pl               NUMBER;
   total_ml               NUMBER;
   v                      NUMBER;
   v_service_period       NUMBER;
------------------------------ prefix
   v_tran_date_a_p_max    DATE;
   v_tran_date_h_p_max    DATE;
   v_tran_date_w_p_max    DATE;
   ------------suffix
   v_tran_date_a_s_min    DATE;
   v_tran_date_h_s_min    DATE;
   v_tran_date_w_s_min    DATE;
   el_this_year_balance   NUMBER;
   v_this_year            NUMBER := TO_CHAR (p_date_from, 'rrrr');
----------------------------------
BEGIN
   IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL
   THEN
      o_duration := FLOOR ((TRUNC (p_date_to) - TRUNC (p_date_from))) + 1;
   END IF;

   -----el (7.2.6 )
   IF p_leave_type = 'EL'
   THEN
      SELECT COUNT (*)
        INTO v_duration_minus
        FROM holiday_info
       WHERE tran_date BETWEEN p_date_from AND p_date_to
         AND NVL (is_holiday, 0) = 1;

      v_duration_minus := NVL (v_duration_minus, 0);

      -- o_duration := NVL (o_duration, 0) - NVL (v_duration_minus, 0);
      SELECT MAX (elavailable)
        INTO el_this_year_balance
        FROM ipi_leave_report_1
       WHERE empcode = p_empcode;

      v := NVL (el_this_year_balance, 0) - o_duration;

      IF v < 0
      THEN
         o_msg :=
               'Earn Leave cannot be taken more than the accumulated EL days';
         o_status_code := 99;
         RETURN;
      END IF;
   -- earned leave

   -- rule  7.2.6
   -- rule 7.2.7

   --  sick leave
   ELSIF p_leave_type = 'SL'
   THEN
      DECLARE
         sl_this_year_avail     NUMBER;
         sl_this_year_balance   NUMBER;
      BEGIN
      
         IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL
   THEN
      o_duration := FLOOR ((TRUNC (p_date_to) - TRUNC (p_date_from))) + 1;
   END IF;
         --rule 7.3.1 ---
         SELECT nvl(SUM (DURATION),0) 
           INTO sl_this_year_avail
           FROM hr_leave_child
          WHERE TO_CHAR (date_from, 'rrrr') = TO_CHAR (p_date_from, 'rrrr')
            AND empcode = p_empcode
            AND leaveadtype = 'Leave'
            AND leave_type = 'SL';

  

       --  cl_this_year_balance := cl_this_year_balance - o_duration;

         --- sick leave
         IF (NVL (sl_this_year_avail, 0) + NVL (o_duration, 0)) > 14
         THEN
            o_msg :=
               'Each empoyee cannot avail more than 14 days of Sick Leave per year ';
                  o_status_code := 99;
            RETURN;
         END IF;
         --  IF NVL (sl_this_year_avail, 0) - NVL (o_duration, 0) >= 0
          -- THEN
             -- o_msg :=
              --   'Total Sick Leave already been Taken then available Earned Leave can be granted';
            --  p_leave_type := 'SL';
             -- o_status_code := 99;
             -- RETURN;
      --casual leave

      ---checke casual leave is available
      END;
      ------========================================
      
      
      ELSIF p_leave_type = 'RL'
   THEN
      ---casual leave
      -- rule 7.4.1
      DECLARE
         rl_this_year_balance   NUMBER;
         rl_this_year_avail     NUMBER;
      BEGIN
         IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL
         THEN
            o_duration :=
                         FLOOR ((TRUNC (p_date_to) - TRUNC (p_date_from)))
                         + 1;
         END IF;

         IF p_leave_type = 'RL'
         THEN
            SELECT MAX (rlavailable)
              INTO rl_this_year_balance
              FROM ipi_leave_report_1
             WHERE empcode = p_empcode;
             
             
               SELECT MAX (rltaken)
              INTO rl_this_year_avail
              FROM ipi_leave_report_1
             WHERE empcode = p_empcode;

            /* SELECT SUM (DURATION)
              INTO cl_this_year_avail
              FROM hr_leave_child
             WHERE empcode = p_empcode
               AND leave_type = 'CL'
               AND leaveadtype = 'Leave'
               AND TO_CHAR (date_from, 'rrrr') = TO_CHAR (p_date_from, 'rrrr');
               
               */
               
               

            rl_this_year_balance := rl_this_year_balance - o_duration;

            IF    NVL (rl_this_year_balance, 0) < 0
               OR (NVL (rl_this_year_avail, 0) + NVL (o_duration, 0)) > 15
            THEN
               o_msg :=
                  'Recreation Leave cannot be taken more than the accumulated RL days';
               o_status_code := 99;
               RETURN;
            END IF;

            --rule :=  7.4.4 -- weekend prefix suffix
            --rule :=  7.4.5  ---- govt hoiday  prefix suffix

            --------------prefix
            SELECT MAX (DECODE (is_holiday, 0, tran_date)),
                   MAX (DECODE (is_default_holiday, 1, tran_date)),
                   MAX (DECODE (is_other_holiday,
                                1, DECODE (is_default_holiday, 1, tran_date)
                               )
                       )
              INTO v_tran_date_a_p_max,
                   v_tran_date_w_p_max,
                   v_tran_date_h_p_max
              FROM holiday_info
             WHERE is_holiday = 0 AND tran_date < p_date_from;

            ------------suffix
            SELECT MIN (DECODE (is_holiday, 0, tran_date)),
                   MIN (DECODE (is_default_holiday, 1, tran_date)),
                   MIN (DECODE (is_other_holiday,
                                1, DECODE (is_default_holiday, 1, tran_date)
                               )
                       )
              INTO v_tran_date_a_s_min,
                   v_tran_date_w_s_min,
                   v_tran_date_h_s_min
              FROM holiday_info
             WHERE tran_date > p_date_to;

            ---cl converted to el
            IF    (    v_tran_date_w_p_max + 1 = p_date_from
                   AND v_tran_date_h_p_max + 2 = p_date_from
                  )
               OR (    v_tran_date_w_s_min - 1 = p_date_to
                   AND v_tran_date_h_s_min - 2 = p_date_to
                  )
            THEN
               v_el := v_el + 1;
               v_cl := 0;
            END IF;

            IF    v_tran_date_h_p_max + 1 = p_date_from
               OR v_tran_date_h_s_min - 1 = p_date_to
            THEN
               v_el := v_el + 1;
               v_cl := 0;
            END IF;

            IF     (   v_tran_date_w_p_max + 1 = p_date_from
                    OR v_tran_date_w_s_min - 1 = p_date_to
                   )
               AND v_el = 0
            THEN
               v_cl := v_cl + 1;
               o_msg :=
                  'RL is taken either as pre-fixed  or post-fixed to the weekend . if RL is taken as prefixed and post-fixed to a weekend 
            then 3 days of RL will be counted';
               o_status_code := 99;
            END IF;

            

            IF v_cl > 0 AND p_leave_type = 'RL'
            THEN
               IF v_tran_date_w_p_max + 1 = p_date_from
               THEN
                  p_date_from := v_tran_date_w_p_max;
               END IF;

               IF v_tran_date_w_s_min - 1 = p_date_to
               THEN
                  p_date_to := v_tran_date_w_s_min;
               END IF;
            -- o_duration := ROUND (v_tran_date_w_s_min - v_tran_date_w_p_max);
            END IF;

            --- cl rule 7.4.3

            -- rule 7.4.3
            IF p_leave_type = 'RL' AND o_duration > 15
            THEN
               o_msg :=
                  'At a time RL cannot be taken for more than 15 consecutive days';
               o_status_code := 99;
               RETURN;
            END IF;
         ---cl   remain cl  WITH PREFIX OR SUFFIX ADDED
         END IF;
      END;
      -------=======================================
   ELSIF p_leave_type = 'CL'
   THEN
      ---casual leave
      -- rule 7.4.1
      DECLARE
         cl_this_year_balance   NUMBER;
         cl_this_year_avail     NUMBER;
      BEGIN
         IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL
         THEN
            o_duration :=
                         FLOOR ((TRUNC (p_date_to) - TRUNC (p_date_from)))
                         + 1;
         END IF;

         IF p_leave_type = 'CL'
         THEN
            SELECT MAX (clavailable)
              INTO cl_this_year_balance
              FROM ipi_leave_report_1
             WHERE empcode = p_empcode;
             
             
               SELECT MAX (cltaken)
              INTO cl_this_year_avail
              FROM ipi_leave_report_1
             WHERE empcode = p_empcode;

            /* SELECT SUM (DURATION)
              INTO cl_this_year_avail
              FROM hr_leave_child
             WHERE empcode = p_empcode
               AND leave_type = 'CL'
               AND leaveadtype = 'Leave'
               AND TO_CHAR (date_from, 'rrrr') = TO_CHAR (p_date_from, 'rrrr');
               
               */
               
               

            cl_this_year_balance := cl_this_year_balance - o_duration;

            IF    NVL (cl_this_year_balance, 0) < 0
               OR (NVL (cl_this_year_avail, 0) + NVL (o_duration, 0)) > 10
            THEN
               o_msg :=
                  'An Employee Cannot avail Casual Leave More Than  allocation  (10Days)';
               o_status_code := 99;
               RETURN;
            END IF;

            --rule :=  7.4.4 -- weekend prefix suffix
            --rule :=  7.4.5  ---- govt hoiday  prefix suffix

            --------------prefix
            SELECT MAX (DECODE (is_holiday, 0, tran_date)),
                   MAX (DECODE (is_default_holiday, 1, tran_date)),
                   MAX (DECODE (is_other_holiday,
                                1, DECODE (is_default_holiday, 1, tran_date)
                               )
                       )
              INTO v_tran_date_a_p_max,
                   v_tran_date_w_p_max,
                   v_tran_date_h_p_max
              FROM holiday_info
             WHERE is_holiday = 0 AND tran_date < p_date_from;

            ------------suffix
            SELECT MIN (DECODE (is_holiday, 0, tran_date)),
                   MIN (DECODE (is_default_holiday, 1, tran_date)),
                   MIN (DECODE (is_other_holiday,
                                1, DECODE (is_default_holiday, 1, tran_date)
                               )
                       )
              INTO v_tran_date_a_s_min,
                   v_tran_date_w_s_min,
                   v_tran_date_h_s_min
              FROM holiday_info
             WHERE tran_date > p_date_to;

            ---cl converted to el
            IF    (    v_tran_date_w_p_max + 1 = p_date_from
                   AND v_tran_date_h_p_max + 2 = p_date_from
                  )
               OR (    v_tran_date_w_s_min - 1 = p_date_to
                   AND v_tran_date_h_s_min - 2 = p_date_to
                  )
            THEN
               v_el := v_el + 1;
               v_cl := 0;
            END IF;

            IF    v_tran_date_h_p_max + 1 = p_date_from
               OR v_tran_date_h_s_min - 1 = p_date_to
            THEN
               v_el := v_el + 1;
               v_cl := 0;
            END IF;

            IF     (   v_tran_date_w_p_max + 1 = p_date_from
                    OR v_tran_date_w_s_min - 1 = p_date_to
                   )
               AND v_el = 0
            THEN
               v_cl := v_cl + 1;
               o_msg :=
                  'CL is taken either as pre-fixed  or post-fixed to the weekend . if CL is taken as prefixed and post-fixed to a weekend 
            then 3 days of CL will be counted';
               o_status_code := 99;
            END IF;

            IF v_el > 0
            THEN
               o_msg :=
                  'CL can not be taken either as prefixed and post-fixed to a  govertment declared holiday. if taken it will be treated as EL ';
               p_leave_type := 'EL';
               o_status_code := 99;
               RETURN;
            END IF;

            IF v_cl > 0 AND p_leave_type = 'CL'
            THEN
               IF v_tran_date_w_p_max + 1 = p_date_from
               THEN
                  p_date_from := v_tran_date_w_p_max;
               END IF;

               IF v_tran_date_w_s_min - 1 = p_date_to
               THEN
                  p_date_to := v_tran_date_w_s_min;
               END IF;
            -- o_duration := ROUND (v_tran_date_w_s_min - v_tran_date_w_p_max);
            END IF;

            --- cl rule 7.4.3

            -- rule 7.4.3
            IF p_leave_type = 'CL' AND o_duration > 3
            THEN
               o_msg :=
                  'At a time CL cannot be taken for more than 3 consecutive days';
               o_status_code := 99;
               RETURN;
            END IF;
         ---cl   remain cl  WITH PREFIX OR SUFFIX ADDED
         END IF;
      END;
   --- maternity leave
   ---rule 7.5.1
   ELSIF p_leave_type = 'ML'
   THEN
      SELECT COUNT (*)
        INTO total_ml
        FROM hr_leave_child
       WHERE leave_type = 'ML' AND leaveadtype = 'Leave'
             AND empcode = p_empcode;

      IF p_leave_type = 'ML' AND o_duration > (7 * 8) + (7 * 8)
      THEN
         o_msg :=
            'Maternity Leave Cannot avail more than 8 Weeks Before Delivery and 8 Weeks after Delivery  ';
         o_status_code := 99;
         RETURN;
      END IF;

      ---rule 7.5.4
    

      IF v_service_period < 6
      THEN
         o_msg :=
            'Employee Needs to complete minimum 6 months of service on the expected date of delivery ';
         o_status_code := 99;
         RETURN;
      END IF;
   ELSIF p_leave_type = 'PL'
   THEN
      --- paternity leave
      ---rule 7.8.1
      IF p_leave_type = 'PL' AND o_duration > 3
      THEN
         o_status_code := 99;
         o_msg :=
                 'Paternity Leave cannot avail more then 3 Consecutive days ';
         RETURN;
      END IF;

      ---rule 7.8.2
      SELECT COUNT (*)
        INTO total_pl
        FROM hr_leave_child
       WHERE leave_type = 'PL'
         AND leaveadtype = 'Leave'
         AND empcode = p_empcode
         AND leaveadtype = 'Leave';

      IF total_pl >= 2
      THEN
         o_status_code := 99;
         o_msg :=
            'An employee is entitled for paternity leave  for only two times duirng the total service period ';
         RETURN;
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      o_status_code := 99;
      o_msg := SQLERRM;
END;
/
