/* Formatted on 5/4/2025 7:40:15 PM (QP5 v5.362) */
CREATE TABLE institutes
(
    institute_id          NUMBER PRIMARY KEY,
    institute_code        VARCHAR2 (20) UNIQUE NOT NULL,
    institute_name        VARCHAR2 (100) NOT NULL,
    bengali_name          NVARCHAR2 (200),
    institute_type        VARCHAR2 (30),
    establishment_year    NUMBER (4),
    eiin_number           VARCHAR2 (20) UNIQUE, -- Educational Institute Identification Number
    board_id              NUMBER,
    address_line1         VARCHAR2 (100) NOT NULL,
    address_line2         VARCHAR2 (100),
    city                  VARCHAR2 (50) NOT NULL,
    district              VARCHAR2 (50) NOT NULL,
    postal_code           VARCHAR2 (10),
    phone_number          VARCHAR2 (15),
    email                 VARCHAR2 (100),
    website               VARCHAR2 (100),
    principal_name        VARCHAR2 (100),
    principal_phone       VARCHAR2 (15),
    principal_email       VARCHAR2 (100),
    STATUS                CHAR (1) DEFAULT 'A' CHECK (status IN ('A', 'I')),
    logo                  BLOB,
    created_by            NUMBER,
    created_at            DATE DEFAULT SYSDATE,
    updated_by            NUMBER,
    updated_at            DATE
);


-- Classes Table

CREATE TABLE classes
(
    class_id      NUMBER PRIMARY KEY,
    class_code    VARCHAR2 (10) UNIQUE NOT NULL,
    class_name    VARCHAR2 (50) NOT NULL,
    class_type    VARCHAR2 (20),
    status        CHAR (1) DEFAULT 'A' CHECK (status IN ('A', 'I')),
    r_inst_id     NUMBER,
    created_by    NUMBER,
    created_at    DATE DEFAULT SYSDATE,
    updated_by    NUMBER,
    updated_at    DATE
);

CREATE TABLE shifts
(
    shift_id       NUMBER PRIMARY KEY,
    shift_name     VARCHAR2 (30),
    shift_code     VARCHAR2 (10) UNIQUE NOT NULL,
    start_time     DATE,
    end_time       DATE,
    description    VARCHAR2 (255),
    status         CHAR (1) DEFAULT 'A' CHECK (status IN ('A', 'I')),
    r_inst_id      NUMBER,
    created_by     NUMBER,
    created_at     DATE DEFAULT SYSDATE,
    updated_by     NUMBER,
    updated_at     DATE
);

CREATE TABLE sections
(
    section_id      NUMBER PRIMARY KEY,
    section_code    VARCHAR2 (10) UNIQUE NOT NULL,
    section_name    VARCHAR2 (10) NOT NULL,
    r_inst_id       NUMBER,
    status          CHAR (1) DEFAULT 'A' CHECK (status IN ('A', 'I')),
    created_by      NUMBER,
    created_at      DATE DEFAULT SYSDATE,
    updated_by      NUMBER,
    updated_at      DATE
);

-- Subjects Table

CREATE TABLE subjects
(
    subject_id      NUMBER PRIMARY KEY,
    subject_code    VARCHAR2 (20) UNIQUE NOT NULL,
    subject_name    VARCHAR2 (100) NOT NULL,
    subject_type    VARCHAR2 (20),
    r_inst_id       NUMBER,
    created_by      NUMBER,
    created_at      DATE DEFAULT SYSDATE,
    updated_by      NUMBER,
    updated_at      DATE
);

-- Teachers/Staff Table

CREATE TABLE teachers
(
    teacher_id               NUMBER PRIMARY KEY,
    teacher_code             VARCHAR2 (20) UNIQUE NOT NULL,
    national_id              VARCHAR2 (17) NOT NULL,
    first_name               VARCHAR2 (50) NOT NULL,
    last_name                VARCHAR2 (50),
    bengali_name             NVARCHAR2 (100),
    date_of_birth            DATE NOT NULL,
    gender                   VARCHAR2 (3) CHECK (gender IN ('M', 'F', 'O')),
    status                   CHAR (1) DEFAULT 'A' CHECK (status IN ('A', 'I')),
    address_line1            VARCHAR2 (100),
    address_line2            VARCHAR2 (100),
    city                     VARCHAR2 (50),
    district                 VARCHAR2 (50),
    postal_code              VARCHAR2 (10),
    phone_number             VARCHAR2 (15) NOT NULL,
    email                    VARCHAR2 (100),
    highest_qualification    VARCHAR2 (100),
    specialization           VARCHAR2 (100),
    typ                      CHAR (1),
    designation              VARCHAR2 (50),
    joining_date             DATE NOT NULL,
    basic_salary             NUMBER (12, 2),
    bank_account_number      VARCHAR2 (20),
    bank_name                VARCHAR2 (50),
    photo                    BLOB,
    r_institute_id           NUMBER,
    created_by               NUMBER,
    created_at               DATE DEFAULT SYSDATE,
    updated_by               NUMBER,
    updated_at               DATE,
    CONSTRAINT fk_institute_id_r01 FOREIGN KEY (r_institute_id)
        REFERENCES teachers (teacher_id)
);



-- Student 

CREATE TABLE students
(
    student_id            NUMBER PRIMARY KEY,
    student_code          VARCHAR2 (20) UNIQUE NOT NULL,
    national_id           VARCHAR2 (17),
    academic_id           VARCHAR2 (20),
    first_name            VARCHAR2 (50) NOT NULL,
    last_name             VARCHAR2 (50),
    bengali_name          NVARCHAR2 (100),
    date_of_birth         DATE NOT NULL,
    gender                VARCHAR2 (3) CHECK (gender IN ('M', 'F', 'O')),
    status                CHAR (1) DEFAULT 'A',
    religion              VARCHAR2 (20),
    blood_group           VARCHAR2 (5),
    address_line1         VARCHAR2 (100),
    address_line2         VARCHAR2 (100),
    city                  VARCHAR2 (50),
    district              VARCHAR2 (50),
    postal_code           VARCHAR2 (10),
    phone_number          VARCHAR2 (15),
    email                 VARCHAR2 (100),
    guardian_name         VARCHAR2 (100) NOT NULL,
    guardian_relation     VARCHAR2 (20) NOT NULL,
    guardian_phone        VARCHAR2 (15) NOT NULL,
    guardian_email        VARCHAR2 (100),
    admission_date        DATE NOT NULL,
    current_class_id      NUMBER,
    current_section_id    NUMBER,
    current_shift_id      NUMBER,
    roll_number           NUMBER,
    photo                 BLOB,
    r_institute_id        NUMBER,
    created_by            NUMBER,
    created_at            DATE DEFAULT SYSDATE,
    updated_by            NUMBER,
    updated_at            DATE,
    CONSTRAINT fk_student_class FOREIGN KEY (current_class_id)
        REFERENCES classes (class_id)
);


-- Sections Table



-- Class Subject Relation Table

CREATE TABLE class_subjects
(
    class_subject_id    NUMBER PRIMARY KEY,
    class_id            NUMBER NOT NULL,
    subject_id          NUMBER NOT NULL,
    teacher_id          NUMBER,
    total_classes       NUMBER,
    weekly_classes      NUMBER,
    is_optional         NUMBER (1) DEFAULT 0,
    created_by      NUMBER,
    created_at      DATE DEFAULT SYSDATE,
    updated_by      NUMBER,
    updated_at      DATE,
    CONSTRAINT fk_cs_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id),
    CONSTRAINT fk_cs_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id),
    CONSTRAINT fk_cs_teacher FOREIGN KEY (teacher_id)
        REFERENCES teachers (teacher_id)
);

-- Student Subject Registration (for optional subjects)

CREATE TABLE student_subjects
(
    student_subject_id    NUMBER PRIMARY KEY,
    student_id            NUMBER NOT NULL,
    class_subject_id      NUMBER NOT NULL,
    academic_year         VARCHAR2 (10) NOT NULL,
    created_at            DATE DEFAULT SYSDATE,
    updated_at            DATE,
    CONSTRAINT fk_ss_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_ss_class_subject FOREIGN KEY (class_subject_id)
        REFERENCES class_subjects (class_subject_id)
);

-- Examinations Table

CREATE TABLE examinations
(
    exam_id          NUMBER PRIMARY KEY,
    exam_code        VARCHAR2 (20) UNIQUE NOT NULL,
    exam_name        VARCHAR2 (100) NOT NULL,
    exam_type        VARCHAR2 (50)
                        CHECK
                            (exam_type IN ('Class Test',
                                           'Mid-Term',
                                           'Final',
                                           'Board Exam',
                                           'Pre-Test')),
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    academic_year    VARCHAR2 (10) NOT NULL,
    description      VARCHAR2 (500),
    is_published     NUMBER (1) DEFAULT 0,
    created_at       DATE DEFAULT SYSDATE,
    updated_at       DATE
);

-- Exam Schedule Table

CREATE TABLE exam_schedules
(
    schedule_id    NUMBER PRIMARY KEY,
    exam_id        NUMBER NOT NULL,
    class_id       NUMBER NOT NULL,
    subject_id     NUMBER NOT NULL,
    exam_date      DATE NOT NULL,
    start_time     DATE,
    end_time       DATE,
    room_number    VARCHAR2 (10),
    max_marks      NUMBER NOT NULL,
    pass_marks     NUMBER NOT NULL,
    created_at     DATE DEFAULT SYSDATE,
    updated_at     DATE,
    CONSTRAINT fk_es_exam FOREIGN KEY (exam_id)
        REFERENCES examinations (exam_id),
    CONSTRAINT fk_es_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id),
    CONSTRAINT fk_es_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

-- Exam Results Table

CREATE TABLE exam_results
(
    result_id         NUMBER PRIMARY KEY,
    student_id        NUMBER NOT NULL,
    exam_id           NUMBER NOT NULL,
    subject_id        NUMBER NOT NULL,
    marks_obtained    NUMBER,
    grade             VARCHAR2 (5),
    grade_point       NUMBER (3, 2),
    remarks           VARCHAR2 (200),
    is_absent         NUMBER (1) DEFAULT 0,
    created_at        DATE DEFAULT SYSDATE,
    updated_at        DATE,
    CONSTRAINT fk_er_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_er_exam FOREIGN KEY (exam_id)
        REFERENCES examinations (exam_id),
    CONSTRAINT fk_er_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

-- Result Summary Table

CREATE TABLE result_summary
(
    summary_id       NUMBER PRIMARY KEY,
    student_id       NUMBER NOT NULL,
    exam_id          NUMBER NOT NULL,
    class_id         NUMBER NOT NULL,
    total_marks      NUMBER,
    average_marks    NUMBER (5, 2),
    gpa              NUMBER (3, 2),
    grade            VARCHAR2 (5),
    rank_in_class    NUMBER,
    pass_status      VARCHAR2 (10) CHECK (pass_status IN ('Pass', 'Fail')),
    remarks          VARCHAR2 (500),
    created_at       DATE DEFAULT SYSDATE,
    updated_at       DATE,
    CONSTRAINT fk_rs_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_rs_exam FOREIGN KEY (exam_id)
        REFERENCES examinations (exam_id),
    CONSTRAINT fk_rs_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id)
);

-- Attendance Table (Students)

CREATE TABLE student_attendance
(
    attendance_id      NUMBER PRIMARY KEY,
    student_id         NUMBER NOT NULL,
    class_id           NUMBER NOT NULL,
    attendance_date    DATE NOT NULL,
    status             VARCHAR2 (20)
                          CHECK
                              (status IN ('Present',
                                          'Absent',
                                          'Late',
                                          'Half Day',
                                          'Leave')),
    remarks            VARCHAR2 (200),
    recorded_by        NUMBER,
    created_at         DATE DEFAULT SYSDATE,
    updated_at         DATE,
    CONSTRAINT fk_sa_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_sa_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id),
    CONSTRAINT fk_sa_recorder FOREIGN KEY (recorded_by)
        REFERENCES teachers (teacher_id)
);

-- Attendance Table (Teachers)

CREATE TABLE teacher_attendance
(
    attendance_id      NUMBER PRIMARY KEY,
    teacher_id         NUMBER NOT NULL,
    attendance_date    DATE NOT NULL,
    status             VARCHAR2 (20)
                          CHECK
                              (status IN ('Present',
                                          'Absent',
                                          'Late',
                                          'Half Day',
                                          'Leave')),
    in_time            DATE,
    out_time           DATE,
    remarks            VARCHAR2 (200),
    recorded_by        NUMBER,
    created_at         DATE DEFAULT SYSDATE,
    updated_at         DATE,
    CONSTRAINT fk_ta_teacher FOREIGN KEY (teacher_id)
        REFERENCES teachers (teacher_id),
    CONSTRAINT fk_ta_recorder FOREIGN KEY (recorded_by)
        REFERENCES teachers (teacher_id)
);

-- Fee Structure Table

CREATE TABLE fee_structure
(
    fee_structure_id    NUMBER PRIMARY KEY,
    fee_type            VARCHAR2 (50) NOT NULL,
    class_id            NUMBER NOT NULL,
    amount              NUMBER (12, 2) NOT NULL,
    frequency           VARCHAR2 (20)
                           CHECK
                               (frequency IN ('Monthly',
                                              'Quarterly',
                                              'Half-Yearly',
                                              'Yearly',
                                              'One-Time')),
    academic_year       VARCHAR2 (10) NOT NULL,
    created_at          DATE DEFAULT SYSDATE,
    updated_at          DATE,
    CONSTRAINT fk_fs_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id)
);

-- Fee Collection Table

CREATE TABLE fee_collection
(
    fee_collection_id    NUMBER PRIMARY KEY,
    student_id           NUMBER NOT NULL,
    fee_structure_id     NUMBER NOT NULL,
    amount_paid          NUMBER (12, 2) NOT NULL,
    payment_date         DATE NOT NULL,
    payment_method       VARCHAR2 (20)
                            CHECK
                                (payment_method IN ('Cash',
                                                    'Check',
                                                    'Bank Transfer',
                                                    'Mobile Banking')),
    transaction_id       VARCHAR2 (50),
    receipt_number       VARCHAR2 (20) NOT NULL,
    month                VARCHAR2 (20),
    academic_year        VARCHAR2 (10) NOT NULL,
    collected_by         NUMBER,
    remarks              VARCHAR2 (200),
    created_at           DATE DEFAULT SYSDATE,
    updated_at           DATE,
    CONSTRAINT fk_fc_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_fc_fee_structure FOREIGN KEY (fee_structure_id)
        REFERENCES fee_structure (fee_structure_id),
    CONSTRAINT fk_fc_collector FOREIGN KEY (collected_by)
        REFERENCES teachers (teacher_id)
);

-- Academic Calendar Table

CREATE TABLE academic_calendar
(
    event_id             NUMBER PRIMARY KEY,
    event_name           VARCHAR2 (100) NOT NULL,
    event_type           VARCHAR2 (50)
                            CHECK
                                (event_type IN ('Holiday',
                                                'Exam',
                                                'Meeting',
                                                'Function',
                                                'Other')),
    start_date           DATE NOT NULL,
    end_date             DATE,
    description          VARCHAR2 (500),
    academic_year        VARCHAR2 (10) NOT NULL,
    is_public_holiday    NUMBER (1) DEFAULT 0,
    created_at           DATE DEFAULT SYSDATE,
    updated_at           DATE
);

-- Time Table Table

CREATE TABLE time_table
(
    time_table_id    NUMBER PRIMARY KEY,
    class_id         NUMBER NOT NULL,
    section_id       NUMBER,
    subject_id       NUMBER NOT NULL,
    teacher_id       NUMBER NOT NULL,
    day_of_week      VARCHAR2 (10)
                        CHECK
                            (day_of_week IN ('Sunday',
                                             'Monday',
                                             'Tuesday',
                                             'Wednesday',
                                             'Thursday',
                                             'Friday',
                                             'Saturday')),
    start_time       DATE NOT NULL,
    end_time         DATE NOT NULL,
    room_number      VARCHAR2 (10),
    academic_year    VARCHAR2 (10) NOT NULL,
    created_at       DATE DEFAULT SYSDATE,
    updated_at       DATE,
    CONSTRAINT fk_tt_class FOREIGN KEY (class_id)
        REFERENCES classes (class_id),
    CONSTRAINT fk_tt_section FOREIGN KEY (section_id)
        REFERENCES sections (section_id),
    CONSTRAINT fk_tt_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id),
    CONSTRAINT fk_tt_teacher FOREIGN KEY (teacher_id)
        REFERENCES teachers (teacher_id)
);

-- Bangladesh-Specific Tables

-- Education Boards Table

CREATE TABLE education_boards
(
    board_id          NUMBER PRIMARY KEY,
    board_code        VARCHAR2 (10) UNIQUE NOT NULL,
    board_name        VARCHAR2 (100) NOT NULL,
    address           VARCHAR2 (200),
    contact_person    VARCHAR2 (100),
    phone_number      VARCHAR2 (15),
    email             VARCHAR2 (100),
    website           VARCHAR2 (100),
    created_at        DATE DEFAULT SYSDATE,
    updated_at        DATE
);

-- Board Examination Registration

CREATE TABLE board_exam_registration
(
    registration_id        NUMBER PRIMARY KEY,
    registration_code      VARCHAR2 (20) UNIQUE NOT NULL,
    student_id             NUMBER NOT NULL,
    board_id               NUMBER NOT NULL,
    exam_type              VARCHAR2 (10)
                              CHECK (exam_type IN ('JSC', 'SSC', 'HSC')),
    registration_number    VARCHAR2 (20),
    roll_number            VARCHAR2 (20),
    center_code            VARCHAR2 (20),
    academic_year          VARCHAR2 (10) NOT NULL,
    registration_date      DATE,
    is_regular             NUMBER (1) DEFAULT 1,
    status                 VARCHAR2 (20)
                              DEFAULT 'Pending'
                              CHECK
                                  (status IN ('Pending',
                                              'Submitted',
                                              'Approved',
                                              'Rejected')),
    created_at             DATE DEFAULT SYSDATE,
    updated_at             DATE,
    CONSTRAINT fk_ber_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_ber_board FOREIGN KEY (board_id)
        REFERENCES education_boards (board_id)
);

-- Board Exam Subjects Registration

CREATE TABLE board_exam_subjects
(
    id                 NUMBER PRIMARY KEY,
    registration_id    NUMBER NOT NULL,
    subject_id         NUMBER NOT NULL,
    subject_code       VARCHAR2 (20) NOT NULL,
    is_practical       NUMBER (1) DEFAULT 0,
    created_at         DATE DEFAULT SYSDATE,
    updated_at         DATE,
    CONSTRAINT fk_bes_registration FOREIGN KEY (registration_id)
        REFERENCES board_exam_registration (registration_id),
    CONSTRAINT fk_bes_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

-- Board Exam Results

CREATE TABLE board_exam_results
(
    result_id          NUMBER PRIMARY KEY,
    registration_id    NUMBER NOT NULL,
    subject_id         NUMBER NOT NULL,
    theory_marks       NUMBER,
    practical_marks    NUMBER,
    total_marks        NUMBER,
    grade              VARCHAR2 (5),
    grade_point        NUMBER (3, 2),
    created_at         DATE DEFAULT SYSDATE,
    updated_at         DATE,
    CONSTRAINT fk_board_result_reg FOREIGN KEY (registration_id)
        REFERENCES board_exam_registration (registration_id),
    CONSTRAINT fk_board_result_subject FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);

-- Board Exam Result Summary

CREATE TABLE board_result_summary
(
    summary_id                 NUMBER PRIMARY KEY,
    registration_id            NUMBER NOT NULL,
    total_marks                NUMBER,
    gpa                        NUMBER (3, 2),
    grade                      VARCHAR2 (5),
    pass_status                VARCHAR2 (10) CHECK (pass_status IN ('Pass', 'Fail')),
    merit_position             VARCHAR2 (20),
    certificate_no             VARCHAR2 (50),
    result_publication_date    DATE,
    created_at                 DATE DEFAULT SYSDATE,
    updated_at                 DATE,
    CONSTRAINT fk_board_summary_reg FOREIGN KEY (registration_id)
        REFERENCES board_exam_registration (registration_id)
);

-- Library Books Table

CREATE TABLE library_books
(
    book_id             NUMBER PRIMARY KEY,
    accession_number    VARCHAR2 (20) UNIQUE,
    title               VARCHAR2 (200) NOT NULL,
    author              VARCHAR2 (100),
    publisher           VARCHAR2 (100),
    publication_year    VARCHAR2 (4),
    isbn                VARCHAR2 (20),
    category            VARCHAR2 (50),
    subject             VARCHAR2 (50),
    price               NUMBER (10, 2),
    pages               NUMBER,
    shelf_number        VARCHAR2 (20),
    status              VARCHAR2 (20)
                           DEFAULT 'Available'
                           CHECK
                               (status IN ('Available',
                                           'Issued',
                                           'Lost',
                                           'Damaged',
                                           'Under Repair')),
    added_date          DATE DEFAULT SYSDATE,
    created_at          DATE DEFAULT SYSDATE,
    updated_at          DATE
);

-- Book Issue Table

CREATE TABLE book_issues
(
    issue_id       NUMBER PRIMARY KEY,
    book_id        NUMBER NOT NULL,
    student_id     NUMBER,
    teacher_id     NUMBER,
    issue_date     DATE NOT NULL,
    due_date       DATE NOT NULL,
    return_date    DATE,
    fine_amount    NUMBER (10, 2) DEFAULT 0,
    status         VARCHAR2 (20)
                      DEFAULT 'Issued'
                      CHECK
                          (status IN ('Issued',
                                      'Returned',
                                      'Overdue',
                                      'Lost')),
    remarks        VARCHAR2 (200),
    created_at     DATE DEFAULT SYSDATE,
    updated_at     DATE,
    CONSTRAINT fk_bi_book FOREIGN KEY (book_id)
        REFERENCES library_books (book_id),
    CONSTRAINT fk_bi_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_bi_teacher FOREIGN KEY (teacher_id)
        REFERENCES teachers (teacher_id),
    CONSTRAINT chk_borrower CHECK
        (   (student_id IS NOT NULL AND teacher_id IS NULL)
         OR (student_id IS NULL AND teacher_id IS NOT NULL))
);

-- Inventory Table

CREATE TABLE inventory_items
(
    item_id           NUMBER PRIMARY KEY,
    item_name         VARCHAR2 (100) NOT NULL,
    category          VARCHAR2 (50),
    quantity          NUMBER NOT NULL,
    unit              VARCHAR2 (20),
    purchase_date     DATE,
    purchase_price    NUMBER (12, 2),
    supplier          VARCHAR2 (100),
    location          VARCHAR2 (50),
    status            VARCHAR2 (20)
                         DEFAULT 'Active'
                         CHECK
                             (status IN ('Active',
                                         'Damaged',
                                         'Out of Stock',
                                         'Disposed')),
    created_at        DATE DEFAULT SYSDATE,
    updated_at        DATE
);

-- Expenses Table

CREATE TABLE expenses
(
    expense_id          NUMBER PRIMARY KEY,
    expense_type        VARCHAR2 (50) NOT NULL,
    amount              NUMBER (12, 2) NOT NULL,
    expense_date        DATE NOT NULL,
    payment_method      VARCHAR2 (20),
    reference_number    VARCHAR2 (50),
    description         VARCHAR2 (500),
    approved_by         NUMBER,
    created_at          DATE DEFAULT SYSDATE,
    updated_at          DATE
);

-- Users Table (for system access)

CREATE TABLE users
(
    user_id       NUMBER PRIMARY KEY,
    username      VARCHAR2 (50) UNIQUE NOT NULL,
    password      VARCHAR2 (100) NOT NULL,
    user_type     VARCHAR2 (20)
                     CHECK
                         (user_type IN ('Admin',
                                        'Teacher',
                                        'Student',
                                        'Parent',
                                        'Staff')),
    teacher_id    NUMBER,
    student_id    NUMBER,
    email         VARCHAR2 (100),
    is_active     NUMBER (1) DEFAULT 1,
    last_login    DATE,
    created_at    DATE DEFAULT SYSDATE,
    updated_at    DATE,
    CONSTRAINT fk_user_teacher FOREIGN KEY (teacher_id)
        REFERENCES teachers (teacher_id),
    CONSTRAINT fk_user_student FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT chk_user_reference CHECK
        (   (user_type = 'Teacher' AND teacher_id IS NOT NULL)
         OR (user_type = 'Student' AND student_id IS NOT NULL)
         OR (user_type IN ('Admin', 'Parent', 'Staff')))
);

-- Notifications Table

CREATE TABLE notifications
(
    notification_id      NUMBER PRIMARY KEY,
    title                VARCHAR2 (100) NOT NULL,
    MESSAGE              VARCHAR2 (1000) NOT NULL,
    notification_type    VARCHAR2 (20),
    recipient_type       VARCHAR2 (20)
                            CHECK
                                (recipient_type IN ('All',
                                                    'Teachers',
                                                    'Students',
                                                    'Parents',
                                                    'Staff',
                                                    'Specific')),
    recipient_id         NUMBER,
    is_read              NUMBER (1) DEFAULT 0,
    sent_date            DATE DEFAULT SYSDATE,
    created_by           NUMBER,
    created_at           DATE DEFAULT SYSDATE,
    updated_at           DATE
);

-- Create sequences for auto-incrementing IDs

CREATE SEQUENCE student_id_seq;

CREATE SEQUENCE teacher_id_seq;

CREATE SEQUENCE class_id_seq;

CREATE SEQUENCE section_id_seq;

CREATE SEQUENCE subject_id_seq;

CREATE SEQUENCE class_subject_id_seq;

CREATE SEQUENCE student_subject_id_seq;

CREATE SEQUENCE exam_id_seq;

CREATE SEQUENCE schedule_id_seq;

CREATE SEQUENCE result_id_seq;

CREATE SEQUENCE summary_id_seq;

CREATE SEQUENCE attendance_id_seq;

CREATE SEQUENCE fee_structure_id_seq;

CREATE SEQUENCE fee_collection_id_seq;

CREATE SEQUENCE event_id_seq;

CREATE SEQUENCE time_table_id_seq;

CREATE SEQUENCE board_id_seq;

CREATE SEQUENCE registration_id_seq;

CREATE SEQUENCE board_subject_id_seq;

CREATE SEQUENCE board_result_id_seq;

CREATE SEQUENCE board_summary_id_seq;

CREATE SEQUENCE book_id_seq;

CREATE SEQUENCE issue_id_seq;

CREATE SEQUENCE item_id_seq;

CREATE SEQUENCE expense_id_seq;

CREATE SEQUENCE user_id_seq;

CREATE SEQUENCE notification_id_seq;

-- Create triggers for ID generation and code generation

CREATE OR REPLACE TRIGGER trg_student_before_insert
    BEFORE INSERT
    ON students
    FOR EACH ROW
BEGIN
    IF :new.student_id IS NULL
    THEN
        :new.student_id := student_id_seq.NEXTVAL;
    END IF;

    IF :new.student_code IS NULL
    THEN
        :new.student_code :=
               'STD'
            || TO_CHAR (SYSDATE, 'YYYY')
            || LPAD (:new.student_id, 5, '0');
    END IF;

    :new.updated_at := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_teacher_before_insert
    BEFORE INSERT
    ON teachers
    FOR EACH ROW
BEGIN
    IF :new.teacher_id IS NULL
    THEN
        :new.teacher_id := teacher_id_seq.NEXTVAL;
    END IF;

    IF :new.teacher_code IS NULL
    THEN
        :new.teacher_code :=
               'TCH'
            || TO_CHAR (SYSDATE, 'YYYY')
            || LPAD (:new.teacher_id, 5, '0');
    END IF;

    :new.updated_at := SYSDATE;
END;
/

-- Create triggers for class ID and code generation

CREATE OR REPLACE TRIGGER trg_class_before_insert
    BEFORE INSERT
    ON classes
    FOR EACH ROW
BEGIN
    IF :new.class_id IS NULL
    THEN
        :new.class_id := class_id_seq.NEXTVAL;
    END IF;

    IF :new.class_code IS NULL
    THEN
        :new.class_code := 'CLS' || LPAD (:new.class_id, 4, '0');
    END IF;

    :new.updated_at := SYSDATE;
END;
/

-- Create triggers for updating timestamps

CREATE OR REPLACE TRIGGER trg_students_update
    BEFORE UPDATE
    ON students
    FOR EACH ROW
BEGIN
    :new.updated_at := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_teachers_update
    BEFORE UPDATE
    ON teachers
    FOR EACH ROW
BEGIN
    :new.updated_at := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_classes_update
    BEFORE UPDATE
    ON classes
    FOR EACH ROW
BEGIN
    :new.updated_at := SYSDATE;
END;
/

-- Add similar triggers for other tables...

-- Create indexes for frequently queried columns

--CREATE INDEX idx_student_class
--    ON students (current_class_id);
--
--CREATE INDEX idx_teacher_specialization
--    ON teachers (specialization);
--
--CREATE INDEX idx_exam_results_student
--    ON exam_results (student_id);
--
--CREATE INDEX idx_exam_results_exam
--    ON exam_results (exam_id);
--
--CREATE INDEX idx_attendance_date
--    ON student_attendance (attendance_date);
--
--CREATE INDEX idx_fee_collection_student
--    ON fee_collection (student_id);
--
--CREATE INDEX idx_fee_collection_date
--    ON fee_collection (payment_date);
--
--CREATE INDEX idx_board_registration_student
--    ON board_exam_registration (student_id);
--
--CREATE INDEX idx_student_code
--    ON students (student_code);
--
--CREATE INDEX idx_teacher_code
--    ON teachers (teacher_code);
--
--CREATE INDEX idx_class_code
--    ON classes (class_code);
--
--CREATE INDEX idx_subject_code
--    ON subjects (subject_code);