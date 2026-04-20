DECLARE
    v_id   NUMBER;
BEGIN
    -- GRADE-01
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-01';

    revise_pay_scale (v_id,
                      46550,
                      4190,
                      10,
                      88450,
                      4310,
                      15,
                      153100,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-02
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-02';

    revise_pay_scale (v_id,
                      37050,
                      3330,
                      10,
                      70350,
                      3430,
                      15,
                      121800,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-03
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-03';

    revise_pay_scale (v_id,
                      30550,
                      2750,
                      10,
                      58050,
                      2830,
                      15,
                      100500,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-04
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-04';

    revise_pay_scale (v_id,
                      25050,
                      2250,
                      10,
                      47550,
                      2320,
                      15,
                      82350,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-05
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-05';

    revise_pay_scale (v_id,
                      22050,
                      1980,
                      10,
                      41850,
                      2040,
                      15,
                      72450,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-06
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-06';

    revise_pay_scale (v_id,
                      19050,
                      1710,
                      10,
                      36150,
                      1760,
                      15,
                      62550,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-07
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-07';

    revise_pay_scale (v_id,
                      17050,
                      1530,
                      10,
                      32350,
                      1580,
                      15,
                      56050,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-08
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-08';

    revise_pay_scale (v_id,
                      15250,
                      1370,
                      10,
                      28950,
                      1410,
                      15,
                      50100,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-09
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-09';

    revise_pay_scale (v_id,
                      13300,
                      1200,
                      10,
                      25300,
                      1230,
                      15,
                      43750,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-10
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-10';

    revise_pay_scale (v_id,
                      12250,
                      1100,
                      10,
                      23250,
                      1130,
                      15,
                      40200,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-11
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-11';

    revise_pay_scale (v_id,
                      11000,
                      990,
                      10,
                      20900,
                      1020,
                      15,
                      36200,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-12
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-12';

    revise_pay_scale (v_id,
                      10250,
                      920,
                      10,
                      19450,
                      950,
                      15,
                      33700,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-13
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-13';

    revise_pay_scale (v_id,
                      9700,
                      870,
                      10,
                      18400,
                      900,
                      15,
                      31900,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-14
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-14';

    revise_pay_scale (v_id,
                      9100,
                      820,
                      10,
                      17300,
                      840,
                      15,
                      29900,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-15
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-15';

    revise_pay_scale (v_id,
                      8250,
                      740,
                      10,
                      15650,
                      765,
                      15,
                      27125,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-16
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-16';

    revise_pay_scale (v_id,
                      7700,
                      695,
                      10,
                      14650,
                      710,
                      15,
                      25300,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-17
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-17';

    revise_pay_scale (v_id,
                      7150,
                      645,
                      10,
                      13600,
                      660,
                      15,
                      23500,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-18
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-18';

    revise_pay_scale (v_id,
                      6600,
                      595,
                      10,
                      12550,
                      610,
                      15,
                      21700,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-19
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-19';

    revise_pay_scale (v_id,
                      6050,
                      545,
                      10,
                      11500,
                      560,
                      15,
                      19900,
                      DATE '2025-07-01',
                      'Pay Scale 2025');

    -- GRADE-20
    SELECT id
      INTO v_id
      FROM JOB_GRADES
     WHERE grade_code = 'GRADE-20';

    revise_pay_scale (v_id,
                      5500,
                      500,
                      10,
                      10500,
                      510,
                      15,
                      18150,
                      DATE '2025-07-01',
                      'Pay Scale 2025');
END;
/