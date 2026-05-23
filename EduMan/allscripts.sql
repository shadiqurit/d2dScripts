/*  
  School Management ERP - Oracle Production Starter Schema  
  Project: School Management ERP  
  Database: Oracle  
  Scope: Multi-institution, multi-branch, auth/role/menu permission,  
         academic setup, student admission, attendance, fees/accounts,  
         exam/result, HR/staff, library, transport, inventory, audit.  

  Run order:  
  1) Create tablespace and user  
  2) Run this script  
*/  

-- Create sequences for all tables with auto-increment
BEGIN
   FOR c IN (SELECT sequence_name FROM user_sequences) LOOP
      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || c.sequence_name;
   END LOOP;
END;
/

-- Create all sequences
CREATE SEQUENCE seq_institutions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_branches START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_academic_years START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_academic_sessions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lookup_types START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lookup_values START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_app_users START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_roles START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_permissions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_menus START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_sessions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_password_reset_tokens START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_login_audit START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_education_boards START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_mediums START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_shifts START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_class_levels START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_groups START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sections START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_classrooms START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_subjects START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_class_subjects START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_academic_batches START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_students START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_admissions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_guardians START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_guardians START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_addresses START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_enrollments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_documents START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_status_history START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_promotions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_promotion_details START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_departments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_designations START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employees START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employee_addresses START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_teacher_subject_assignments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_leave_types START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employee_leave_applications START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_attendance_devices START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_attendance START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employee_attendance START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_holidays START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_class_routines START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notices START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notification_templates START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notification_logs START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_heads START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_structures START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_structure_details START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_fee_assignments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_invoices START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_invoice_lines START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_collections START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_collection_lines START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fee_waivers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fiscal_years START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_chart_of_accounts START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bank_accounts START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_journal_vouchers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_journal_lines START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_exam_types START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_exams START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_exam_subjects START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_mark_components START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_exam_subject_components START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_exam_marks START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_grading_scales START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_grading_scale_details START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_results START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_result_details START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_book_categories START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_books START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_book_copies START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_library_issues START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vehicles START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_transport_routes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_transport_stops START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_transport_assignments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vendors START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_item_categories START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_items START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_stock_locations START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_purchase_orders START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_purchase_order_lines START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_stock_transactions START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_hostels START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_hostel_rooms START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_student_hostel_assignments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_system_settings START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_file_attachments START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_logs START WITH 1 INCREMENT BY 1;

-- ============================================================  
-- 0. COMMON FUNCTIONS  
-- ============================================================  

CREATE OR REPLACE FUNCTION fn_set_updated_at  
RETURN TRIGGER  
AS  
BEGIN  
  :NEW.updated_at := sysdate;  
  RETURN :NEW;  
END;  
/

-- ============================================================  
-- 1. CORE ORGANIZATION / MULTI-BRANCH  
-- ============================================================  

CREATE TABLE institutions (  
  institution_id      NUMBER(20) PRIMARY KEY,  
  institution_code    VARCHAR2(30) UNIQUE NOT NULL,  
  institution_name    VARCHAR2(200) NOT NULL,  
  institution_type    VARCHAR2(50) NOT NULL,  
  eiin_no             VARCHAR2(50),  
  registration_no     VARCHAR2(80),  
  phone               VARCHAR2(30),  
  email               VARCHAR2(150),  
  website             VARCHAR2(150),  
  logo_url            CLOB,  
  address_line        CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT chk_institutions_status CHECK (status IN ('ACTIVE','INACTIVE'))  
);

CREATE TABLE branches (  
  branch_id           NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_code         VARCHAR2(30) NOT NULL,  
  branch_name         VARCHAR2(150) NOT NULL,  
  branch_type         VARCHAR2(50),  
  phone               VARCHAR2(30),  
  email               VARCHAR2(150),  
  address_line        CLOB,  
  is_main_branch      CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_branches_code UNIQUE (institution_id, branch_code),  
  CONSTRAINT chk_branches_status CHECK (status IN ('ACTIVE','INACTIVE')),  
  CONSTRAINT fk_branches_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE academic_years (  
  academic_year_id    NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  year_name           VARCHAR2(30) NOT NULL,  
  start_date          DATE NOT NULL,  
  end_date            DATE NOT NULL,  
  is_current          CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_academic_years UNIQUE (institution_id, year_name),  
  CONSTRAINT chk_academic_year_dates CHECK (end_date >= start_date),  
  CONSTRAINT fk_academic_years_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE academic_sessions (  
  session_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20),  
  session_name        VARCHAR2(80) NOT NULL,  
  session_type        VARCHAR2(50) DEFAULT 'ACADEMIC',  
  start_date          DATE,  
  end_date            DATE,  
  is_current          CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_academic_sessions UNIQUE (institution_id, session_name, session_type),  
  CONSTRAINT fk_academic_sessions_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_academic_sessions_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id)  
);

CREATE TABLE lookup_types (  
  lookup_type_id      NUMBER(20) PRIMARY KEY,  
  type_code           VARCHAR2(50) UNIQUE NOT NULL,  
  type_name           VARCHAR2(100) NOT NULL,  
  description         CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL  
);

CREATE TABLE lookup_values (  
  lookup_value_id     NUMBER(20) PRIMARY KEY,  
  lookup_type_id      NUMBER(20) NOT NULL,  
  value_code          VARCHAR2(50) NOT NULL,  
  value_name          VARCHAR2(150) NOT NULL,  
  sort_order          NUMBER(10) DEFAULT 0,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_lookup_values UNIQUE (lookup_type_id, value_code),  
  CONSTRAINT fk_lookup_values_type FOREIGN KEY (lookup_type_id) REFERENCES lookup_types(lookup_type_id) ON DELETE CASCADE  
);

-- ============================================================  
-- 2. AUTHENTICATION, USER, ROLE, MENU PERMISSION  
-- ============================================================  

CREATE TABLE app_users (  
  user_id             NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  branch_id           NUMBER(20),  
  username            VARCHAR2(80) UNIQUE NOT NULL,  
  email               VARCHAR2(150) UNIQUE,  
  mobile              VARCHAR2(30),  
  password_hash       VARCHAR2(4000) NOT NULL,  
  full_name           VARCHAR2(150) NOT NULL,  
  user_type           VARCHAR2(30) DEFAULT 'STAFF' NOT NULL,  
  avatar_url          CLOB,  
  is_super_admin      CHAR(1) DEFAULT '0' NOT NULL,  
  is_active           CHAR(1) DEFAULT '1' NOT NULL,  
  last_login_at       date,  
  password_changed_at date,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT chk_app_users_type CHECK (user_type IN ('SUPER_ADMIN','ADMIN','TEACHER','STAFF','STUDENT','GUARDIAN')),  
  CONSTRAINT chk_is_super_admin CHECK (is_super_admin IN ('0','1')),  
  CONSTRAINT chk_is_active CHECK (is_active IN ('0','1')),  
  CONSTRAINT fk_app_users_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_app_users_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL  
);

CREATE TABLE roles (  
  role_id             NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  role_code           VARCHAR2(50) NOT NULL,  
  role_name           VARCHAR2(100) NOT NULL,  
  description         CLOB,  
  is_system_role      CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_roles UNIQUE (institution_id, role_code),  
  CONSTRAINT chk_is_system_role CHECK (is_system_role IN ('0','1')),  
  CONSTRAINT fk_roles_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE permissions (  
  permission_id       NUMBER(20) PRIMARY KEY,  
  permission_code     VARCHAR2(100) UNIQUE NOT NULL,  
  permission_name     VARCHAR2(150) NOT NULL,  
  module_name         VARCHAR2(80) NOT NULL,  
  description         CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL  
);

CREATE TABLE role_permissions (  
  role_id             NUMBER(20) NOT NULL,  
  permission_id       NUMBER(20) NOT NULL,  
  can_view            CHAR(1) DEFAULT '1' NOT NULL,  
  can_create          CHAR(1) DEFAULT '0' NOT NULL,  
  can_update          CHAR(1) DEFAULT '0' NOT NULL,  
  can_delete          CHAR(1) DEFAULT '0' NOT NULL,  
  can_approve         CHAR(1) DEFAULT '0' NOT NULL,  
  created_at          date,  
  PRIMARY KEY (role_id, permission_id),  
  CONSTRAINT chk_can_view CHECK (can_view IN ('0','1')),  
  CONSTRAINT chk_can_create CHECK (can_create IN ('0','1')),  
  CONSTRAINT chk_can_update CHECK (can_update IN ('0','1')),  
  CONSTRAINT chk_can_delete CHECK (can_delete IN ('0','1')),  
  CONSTRAINT chk_can_approve CHECK (can_approve IN ('0','1')),  
  CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,  
  CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(permission_id) ON DELETE CASCADE  
);

CREATE TABLE user_roles (  
  user_id             NUMBER(20) NOT NULL,  
  role_id             NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  assigned_at         date,  
  PRIMARY KEY (user_id, role_id, branch_id),  
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE CASCADE,  
  CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,  
  CONSTRAINT fk_user_roles_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

CREATE TABLE menus (  
  menu_id             NUMBER(20) PRIMARY KEY,  
  parent_menu_id      NUMBER(20),  
  menu_code           VARCHAR2(80) UNIQUE NOT NULL,  
  menu_title          VARCHAR2(120) NOT NULL,  
  route_path          VARCHAR2(200),  
  icon_name           VARCHAR2(80),  
  sort_order          NUMBER(10) NOT NULL,  
  is_visible          CHAR(1) DEFAULT '1' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT chk_is_visible CHECK (is_visible IN ('0','1')),  
  CONSTRAINT fk_menus_parent FOREIGN KEY (parent_menu_id) REFERENCES menus(menu_id) ON DELETE SET NULL  
);

CREATE TABLE role_menus (  
  role_id             NUMBER(20) NOT NULL,  
  menu_id             NUMBER(20) NOT NULL,  
  can_access          CHAR(1) DEFAULT '1' NOT NULL,  
  PRIMARY KEY (role_id, menu_id),  
  CONSTRAINT chk_can_access CHECK (can_access IN ('0','1')),  
  CONSTRAINT fk_role_menus_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,  
  CONSTRAINT fk_role_menus_menu FOREIGN KEY (menu_id) REFERENCES menus(menu_id) ON DELETE CASCADE  
);

CREATE TABLE user_sessions (  
  session_id          VARCHAR2(36) PRIMARY KEY,  
  user_id             NUMBER(20) NOT NULL,  
  refresh_token_hash  CLOB,  
  ip_address          VARCHAR2(45),  
  user_agent          CLOB,  
  expires_at          date NOT NULL,  
  revoked_at          date,  
  created_at          date,  
  CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE CASCADE  
);

CREATE TABLE password_reset_tokens (  
  token_id            NUMBER(20) PRIMARY KEY,  
  user_id             NUMBER(20) NOT NULL,  
  token_hash          CLOB NOT NULL,  
  expires_at          date NOT NULL,  
  used_at             date,  
  created_at          date,  
  CONSTRAINT fk_password_reset_tokens_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE CASCADE  
);

CREATE TABLE login_audit (  
  login_audit_id      NUMBER(20) PRIMARY KEY,  
  user_id             NUMBER(20),  
  username            VARCHAR2(100),  
  login_status        VARCHAR2(20) NOT NULL,  
  failure_reason      CLOB,  
  ip_address          VARCHAR2(45),  
  user_agent          CLOB,  
  created_at          date,  
  CONSTRAINT fk_login_audit_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE SET NULL  
);

-- ============================================================  
-- 3. ACADEMIC MASTER SETUP  
-- ============================================================  

CREATE TABLE education_boards (  
  board_id            NUMBER(20) PRIMARY KEY,  
  board_code          VARCHAR2(30) UNIQUE NOT NULL,  
  board_name          VARCHAR2(120) NOT NULL,  
  country_name        VARCHAR2(80) DEFAULT 'Bangladesh',  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL  
);

CREATE TABLE mediums (  
  medium_id           NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  medium_name         VARCHAR2(80) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_mediums UNIQUE (institution_id, medium_name),  
  CONSTRAINT fk_mediums_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE shifts (  
  shift_id            NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  shift_name          VARCHAR2(80) NOT NULL,  
  start_time          TIMESTAMP(0),  
  end_time            TIMESTAMP(0),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_shifts UNIQUE (institution_id, shift_name),  
  CONSTRAINT fk_shifts_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE class_levels (  
  class_id            NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  class_code          VARCHAR2(30) NOT NULL,  
  class_name          VARCHAR2(100) NOT NULL,  
  numeric_level       NUMBER(10),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_class_levels UNIQUE (institution_id, class_code),  
  CONSTRAINT fk_class_levels_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE groups (  
  group_id            NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  group_name          VARCHAR2(100) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_groups UNIQUE (institution_id, group_name),  
  CONSTRAINT fk_groups_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE sections (  
  section_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  section_name        VARCHAR2(50) NOT NULL,  
  capacity            NUMBER(10),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_sections UNIQUE (institution_id, section_name),  
  CONSTRAINT fk_sections_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE classrooms (  
  classroom_id        NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  room_no             VARCHAR2(50) NOT NULL,  
  building_name       VARCHAR2(100),  
  floor_no            VARCHAR2(30),  
  capacity            NUMBER(10),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_classrooms UNIQUE (branch_id, room_no),  
  CONSTRAINT fk_classrooms_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

CREATE TABLE subjects (  
  subject_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  subject_code        VARCHAR2(30) NOT NULL,  
  subject_name        VARCHAR2(150) NOT NULL,  
  subject_type        VARCHAR2(30) DEFAULT 'REGULAR',  
  full_marks          NUMBER(8,2) DEFAULT 100,  
  pass_marks          NUMBER(8,2) DEFAULT 33,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_subjects UNIQUE (institution_id, subject_code),  
  CONSTRAINT fk_subjects_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE class_subjects (  
  class_subject_id    NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  class_id            NUMBER(20) NOT NULL,  
  group_id            NUMBER(20),  
  subject_id          NUMBER(20) NOT NULL,  
  is_mandatory        CHAR(1) DEFAULT '1' NOT NULL,  
  sort_order          NUMBER(10) DEFAULT 0,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_class_subjects UNIQUE (class_id, group_id, subject_id),  
  CONSTRAINT chk_is_mandatory CHECK (is_mandatory IN ('0','1')),  
  CONSTRAINT fk_class_subjects_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_class_subjects_class FOREIGN KEY (class_id) REFERENCES class_levels(class_id) ON DELETE CASCADE,  
  CONSTRAINT fk_class_subjects_group FOREIGN KEY (group_id) REFERENCES groups(group_id) ON DELETE SET NULL,  
  CONSTRAINT fk_class_subjects_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE  
);

CREATE TABLE academic_batches (  
  batch_id            NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  class_id            NUMBER(20) NOT NULL,  
  group_id            NUMBER(20),  
  section_id          NUMBER(20),  
  medium_id           NUMBER(20),  
  shift_id            NUMBER(20),  
  classroom_id        NUMBER(20),  
  batch_name          VARCHAR2(150) NOT NULL,  
  capacity            NUMBER(10),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_academic_batches UNIQUE (branch_id, academic_year_id, class_id, group_id, section_id, medium_id, shift_id),  
  CONSTRAINT fk_academic_batches_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_academic_batches_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id) ON DELETE CASCADE,  
  CONSTRAINT fk_academic_batches_class FOREIGN KEY (class_id) REFERENCES class_levels(class_id),  
  CONSTRAINT fk_academic_batches_group FOREIGN KEY (group_id) REFERENCES groups(group_id),  
  CONSTRAINT fk_academic_batches_section FOREIGN KEY (section_id) REFERENCES sections(section_id),  
  CONSTRAINT fk_academic_batches_medium FOREIGN KEY (medium_id) REFERENCES mediums(medium_id),  
  CONSTRAINT fk_academic_batches_shift FOREIGN KEY (shift_id) REFERENCES shifts(shift_id),  
  CONSTRAINT fk_academic_batches_classroom FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id)  
);

-- ============================================================  
-- 4. STUDENT ADMISSION / PROFILE / GUARDIAN  
-- ============================================================  

CREATE TABLE students (  
  student_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  user_id             NUMBER(20) UNIQUE,  
  student_no          VARCHAR2(50) NOT NULL,  
  admission_no        VARCHAR2(50),  
  registration_no     VARCHAR2(80),  
  first_name          VARCHAR2(100) NOT NULL,  
  last_name           VARCHAR2(100),  
  full_name           VARCHAR2(180) GENERATED ALWAYS AS (TRIM(COALESCE(first_name,'') || ' ' || COALESCE(last_name,''))) VIRTUAL,  
  gender              VARCHAR2(20),  
  date_of_birth       DATE,  
  birth_certificate_no VARCHAR2(80),  
  nid_no              VARCHAR2(80),  
  blood_group         VARCHAR2(10),  
  religion            VARCHAR2(50),  
  nationality         VARCHAR2(80) DEFAULT 'Bangladeshi',  
  photo_url           CLOB,  
  mobile              VARCHAR2(30),  
  email               VARCHAR2(150),  
  status              VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_students_no UNIQUE (institution_id, student_no),  
  CONSTRAINT chk_students_gender CHECK (gender IS NULL OR gender IN ('MALE','FEMALE','OTHER')),  
  CONSTRAINT fk_students_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE SET NULL  
);

CREATE TABLE student_admissions (  
  admission_id        NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  admission_date      DATE DEFAULT SYSDATE NOT NULL,  
  admission_type      VARCHAR2(30) DEFAULT 'NEW',  
  previous_institute  VARCHAR2(200),  
  previous_class      VARCHAR2(100),  
  approved_by         NUMBER(20),  
  approval_status     VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_student_admissions_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_admissions_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_student_admissions_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_student_admissions_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id),  
  CONSTRAINT fk_student_admissions_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE guardians (  
  guardian_id         NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  user_id             NUMBER(20) UNIQUE,  
  guardian_name       VARCHAR2(150) NOT NULL,  
  relation_name       VARCHAR2(50),  
  occupation          VARCHAR2(100),  
  nid_no              VARCHAR2(80),  
  mobile              VARCHAR2(30),  
  alternate_mobile    VARCHAR2(30),  
  email               VARCHAR2(150),  
  monthly_income      NUMBER(12,2),  
  address_line        CLOB,  
  photo_url           CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_guardians_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_guardians_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE SET NULL  
);

CREATE TABLE student_guardians (  
  student_guardian_id NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  guardian_id         NUMBER(20) NOT NULL,  
  relation_type       VARCHAR2(50) NOT NULL,  
  is_primary          CHAR(1) DEFAULT '0' NOT NULL,  
  is_emergency_contact CHAR(1) DEFAULT '0' NOT NULL,  
  created_at          date,  
  CONSTRAINT uk_student_guardians UNIQUE (student_id, guardian_id, relation_type),  
  CONSTRAINT chk_is_primary CHECK (is_primary IN ('0','1')),  
  CONSTRAINT chk_is_emergency_contact CHECK (is_emergency_contact IN ('0','1')),  
  CONSTRAINT fk_student_guardians_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_guardians_guardian FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id) ON DELETE CASCADE  
);

CREATE TABLE student_addresses (  
  address_id          NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  address_type        VARCHAR2(30) NOT NULL,  
  village_road        VARCHAR2(200),  
  post_office         VARCHAR2(120),  
  thana_upazila       VARCHAR2(120),  
  district            VARCHAR2(120),  
  division            VARCHAR2(120),  
  postal_code         VARCHAR2(20),  
  country             VARCHAR2(80) DEFAULT 'Bangladesh',  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_student_addresses UNIQUE (student_id, address_type),  
  CONSTRAINT fk_student_addresses_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE  
);

CREATE TABLE student_enrollments (  
  enrollment_id       NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  batch_id            NUMBER(20) NOT NULL,  
  roll_no             VARCHAR2(30),  
  class_id            NUMBER(20) NOT NULL,  
  group_id            NUMBER(20),  
  section_id          NUMBER(20),  
  medium_id           NUMBER(20),  
  shift_id            NUMBER(20),  
  enrollment_status   VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,  
  start_date          DATE DEFAULT SYSDATE NOT NULL,  
  end_date            DATE,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_student_year UNIQUE (student_id, academic_year_id),  
  CONSTRAINT uk_batch_roll UNIQUE (batch_id, roll_no),  
  CONSTRAINT fk_student_enrollments_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_enrollments_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_student_enrollments_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_student_enrollments_batch FOREIGN KEY (batch_id) REFERENCES academic_batches(batch_id),  
  CONSTRAINT fk_student_enrollments_class FOREIGN KEY (class_id) REFERENCES class_levels(class_id),  
  CONSTRAINT fk_student_enrollments_group FOREIGN KEY (group_id) REFERENCES groups(group_id),  
  CONSTRAINT fk_student_enrollments_section FOREIGN KEY (section_id) REFERENCES sections(section_id),  
  CONSTRAINT fk_student_enrollments_medium FOREIGN KEY (medium_id) REFERENCES mediums(medium_id),  
  CONSTRAINT fk_student_enrollments_shift FOREIGN KEY (shift_id) REFERENCES shifts(shift_id)  
);

CREATE TABLE student_documents (  
  document_id         NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  document_type       VARCHAR2(80) NOT NULL,  
  document_title      VARCHAR2(150),  
  file_url            CLOB NOT NULL,  
  uploaded_by         NUMBER(20),  
  uploaded_at         date,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT fk_student_documents_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_documents_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES app_users(user_id)  
);

CREATE TABLE student_status_history (  
  status_history_id   NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  old_status          VARCHAR2(30),  
  new_status          VARCHAR2(30) NOT NULL,  
  effective_date      DATE DEFAULT SYSDATE NOT NULL,  
  reason              CLOB,  
  changed_by          NUMBER(20),  
  created_at          date,  
  CONSTRAINT fk_student_status_history_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES app_users(user_id)  
);

CREATE TABLE promotions (  
  promotion_id        NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  from_academic_year_id NUMBER(20) NOT NULL,  
  to_academic_year_id NUMBER(20) NOT NULL,  
  promotion_date      DATE DEFAULT SYSDATE NOT NULL,  
  promotion_status    VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  approved_by         NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_promotions_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_promotions_from_year FOREIGN KEY (from_academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_promotions_to_year FOREIGN KEY (to_academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_promotions_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id),  
  CONSTRAINT fk_promotions_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id)  
);

CREATE TABLE promotion_details (  
  promotion_detail_id NUMBER(20) PRIMARY KEY,  
  promotion_id        NUMBER(20) NOT NULL,  
  student_id          NUMBER(20) NOT NULL,  
  from_enrollment_id  NUMBER(20),  
  to_batch_id         NUMBER(20),  
  to_roll_no          VARCHAR2(30),  
  result_status       VARCHAR2(30),  
  remarks             CLOB,  
  CONSTRAINT uk_promotion_student UNIQUE (promotion_id, student_id),  
  CONSTRAINT fk_promotion_details_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE,  
  CONSTRAINT fk_promotion_details_student FOREIGN KEY (student_id) REFERENCES students(student_id),  
  CONSTRAINT fk_promotion_details_from_enrollment FOREIGN KEY (from_enrollment_id) REFERENCES student_enrollments(enrollment_id),  
  CONSTRAINT fk_promotion_details_to_batch FOREIGN KEY (to_batch_id) REFERENCES academic_batches(batch_id)  
);

-- ============================================================  
-- 5. HR / TEACHER / STAFF  
-- ============================================================  

CREATE TABLE departments (  
  department_id       NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  department_code     VARCHAR2(30) NOT NULL,  
  department_name     VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_departments UNIQUE (institution_id, department_code),  
  CONSTRAINT fk_departments_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE designations (  
  designation_id      NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  designation_code    VARCHAR2(30) NOT NULL,  
  designation_name    VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_designations UNIQUE (institution_id, designation_code),  
  CONSTRAINT fk_designations_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE employees (  
  employee_id         NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  user_id             NUMBER(20) UNIQUE,  
  employee_no         VARCHAR2(50) NOT NULL,  
  first_name          VARCHAR2(100) NOT NULL,  
  last_name           VARCHAR2(100),  
  full_name           VARCHAR2(180) GENERATED ALWAYS AS (TRIM(COALESCE(first_name,'') || ' ' || COALESCE(last_name,''))) VIRTUAL,  
  employee_type       VARCHAR2(30) DEFAULT 'STAFF' NOT NULL,  
  department_id       NUMBER(20),  
  designation_id      NUMBER(20),  
  joining_date        DATE,  
  date_of_birth       DATE,  
  gender              VARCHAR2(20),  
  blood_group         VARCHAR2(10),  
  religion            VARCHAR2(50),  
  nid_no              VARCHAR2(80),  
  mobile              VARCHAR2(30),  
  email               VARCHAR2(150),  
  photo_url           CLOB,  
  employment_status   VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_employees_no UNIQUE (institution_id, employee_no),  
  CONSTRAINT chk_employees_type CHECK (employee_type IN ('TEACHER','STAFF','ADMIN')),  
  CONSTRAINT fk_employees_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_employees_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_employees_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE SET NULL,  
  CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES departments(department_id),  
  CONSTRAINT fk_employees_designation FOREIGN KEY (designation_id) REFERENCES designations(designation_id)  
);

CREATE TABLE employee_addresses (  
  address_id          NUMBER(20) PRIMARY KEY,  
  employee_id         NUMBER(20) NOT NULL,  
  address_type        VARCHAR2(30) NOT NULL,  
  address_line        CLOB,  
  district            VARCHAR2(120),  
  division            VARCHAR2(120),  
  postal_code         VARCHAR2(20),  
  country             VARCHAR2(80) DEFAULT 'Bangladesh',  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_employee_addresses UNIQUE (employee_id, address_type),  
  CONSTRAINT fk_employee_addresses_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE  
);

CREATE TABLE teacher_subject_assignments (  
  assignment_id       NUMBER(20) PRIMARY KEY,  
  employee_id         NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  batch_id            NUMBER(20) NOT NULL,  
  subject_id          NUMBER(20) NOT NULL,  
  is_class_teacher    CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT uk_teacher_subject UNIQUE (employee_id, academic_year_id, batch_id, subject_id),  
  CONSTRAINT chk_is_class_teacher CHECK (is_class_teacher IN ('0','1')),  
  CONSTRAINT fk_teacher_subject_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,  
  CONSTRAINT fk_teacher_subject_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_teacher_subject_batch FOREIGN KEY (batch_id) REFERENCES academic_batches(batch_id),  
  CONSTRAINT fk_teacher_subject_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)  
);

CREATE TABLE leave_types (  
  leave_type_id       NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  leave_code          VARCHAR2(30) NOT NULL,  
  leave_name          VARCHAR2(100) NOT NULL,  
  yearly_limit_days   NUMBER(6,2),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_leave_types UNIQUE (institution_id, leave_code),  
  CONSTRAINT fk_leave_types_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE employee_leave_applications (  
  leave_application_id NUMBER(20) PRIMARY KEY,  
  employee_id         NUMBER(20) NOT NULL,  
  leave_type_id       NUMBER(20) NOT NULL,  
  from_date           DATE NOT NULL,  
  to_date             DATE NOT NULL,  
  total_days          NUMBER(6,2) NOT NULL,  
  reason              CLOB,  
  approval_status     VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  approved_by         NUMBER(20),  
  approved_at         date,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT chk_leave_dates CHECK (to_date >= from_date),  
  CONSTRAINT fk_employee_leave_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,  
  CONSTRAINT fk_employee_leave_type FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),  
  CONSTRAINT fk_employee_leave_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id)  
);

-- ============================================================  
-- 6. ATTENDANCE  
-- ============================================================  

CREATE TABLE attendance_devices (  
  device_id           NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  device_code         VARCHAR2(50) NOT NULL,  
  device_name         VARCHAR2(120) NOT NULL,  
  device_type         VARCHAR2(50),  
  ip_address          VARCHAR2(45),  
  location_name       VARCHAR2(120),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT uk_attendance_devices UNIQUE (branch_id, device_code),  
  CONSTRAINT fk_attendance_devices_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

CREATE TABLE student_attendance (  
  attendance_id       NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  enrollment_id       NUMBER(20),  
  branch_id           NUMBER(20) NOT NULL,  
  attendance_date     DATE NOT NULL,  
  in_time             TIMESTAMP(0),  
  out_time            TIMESTAMP(0),  
  attendance_status   VARCHAR2(30) DEFAULT 'PRESENT' NOT NULL,  
  device_id           NUMBER(20),  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_student_attendance UNIQUE (student_id, attendance_date),  
  CONSTRAINT fk_student_attendance_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_attendance_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_enrollments(enrollment_id) ON DELETE SET NULL,  
  CONSTRAINT fk_student_attendance_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_student_attendance_device FOREIGN KEY (device_id) REFERENCES attendance_devices(device_id),  
  CONSTRAINT fk_student_attendance_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE employee_attendance (  
  attendance_id       NUMBER(20) PRIMARY KEY,  
  employee_id         NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  attendance_date     DATE NOT NULL,  
  in_time             TIMESTAMP(0),  
  out_time            TIMESTAMP(0),  
  attendance_status   VARCHAR2(30) DEFAULT 'PRESENT' NOT NULL,  
  device_id           NUMBER(20),  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_employee_attendance UNIQUE (employee_id, attendance_date),  
  CONSTRAINT fk_employee_attendance_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,  
  CONSTRAINT fk_employee_attendance_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_employee_attendance_device FOREIGN KEY (device_id) REFERENCES attendance_devices(device_id),  
  CONSTRAINT fk_employee_attendance_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE holidays (  
  holiday_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  holiday_title       VARCHAR2(150) NOT NULL,  
  from_date           DATE NOT NULL,  
  to_date             DATE NOT NULL,  
  holiday_type        VARCHAR2(50),  
  description         CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT chk_holiday_dates CHECK (to_date >= from_date),  
  CONSTRAINT fk_holidays_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_holidays_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

-- ============================================================  
-- 7. ROUTINE / NOTICE / COMMUNICATION  
-- ============================================================  

CREATE TABLE class_routines (  
  routine_id          NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  batch_id            NUMBER(20) NOT NULL,  
  day_name            VARCHAR2(15) NOT NULL,  
  period_no           NUMBER(10) NOT NULL,  
  start_time          TIMESTAMP(0) NOT NULL,  
  end_time            TIMESTAMP(0) NOT NULL,  
  subject_id          NUMBER(20),  
  teacher_id          NUMBER(20),  
  classroom_id        NUMBER(20),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_class_routine UNIQUE (batch_id, day_name, period_no),  
  CONSTRAINT fk_class_routines_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_class_routines_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_class_routines_batch FOREIGN KEY (batch_id) REFERENCES academic_batches(batch_id),  
  CONSTRAINT fk_class_routines_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),  
  CONSTRAINT fk_class_routines_teacher FOREIGN KEY (teacher_id) REFERENCES employees(employee_id),  
  CONSTRAINT fk_class_routines_classroom FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id)  
);

CREATE TABLE notices (  
  notice_id           NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  notice_title        VARCHAR2(200) NOT NULL,  
  notice_body         CLOB NOT NULL,  
  audience_type       VARCHAR2(50) DEFAULT 'ALL' NOT NULL,  
  publish_date        DATE DEFAULT SYSDATE NOT NULL,  
  expire_date         DATE,  
  attachment_url      CLOB,  
  is_published        CHAR(1) DEFAULT '0' NOT NULL,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT chk_is_published CHECK (is_published IN ('0','1')),  
  CONSTRAINT fk_notices_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_notices_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_notices_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE notification_templates (  
  template_id         NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  template_code       VARCHAR2(80) NOT NULL,  
  template_name       VARCHAR2(150) NOT NULL,  
  channel             VARCHAR2(30) NOT NULL,  
  subject_template    VARCHAR2(250),  
  body_template       CLOB NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_notification_templates UNIQUE (institution_id, template_code, channel),  
  CONSTRAINT fk_notification_templates_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE notification_logs (  
  notification_log_id NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  template_id         NUMBER(20),  
  channel             VARCHAR2(30) NOT NULL,  
  recipient_type      VARCHAR2(30),  
  recipient_id        NUMBER(20),  
  recipient_address   VARCHAR2(200),  
  subject_text        VARCHAR2(250),  
  body_text           CLOB,  
  send_status         VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  error_message       CLOB,  
  sent_at             date,  
  created_at          date,  
  CONSTRAINT fk_notification_logs_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_notification_logs_template FOREIGN KEY (template_id) REFERENCES notification_templates(template_id)  
);

-- ============================================================  
-- 8. FEES MANAGEMENT  
-- ============================================================  

CREATE TABLE fee_heads (  
  fee_head_id         NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  fee_code            VARCHAR2(30) NOT NULL,  
  fee_name            VARCHAR2(120) NOT NULL,  
  fee_type            VARCHAR2(30) DEFAULT 'REGULAR' NOT NULL,  
  is_recurring        CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_fee_heads UNIQUE (institution_id, fee_code),  
  CONSTRAINT chk_is_recurring CHECK (is_recurring IN ('0','1')),  
  CONSTRAINT fk_fee_heads_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE fee_structures (  
  fee_structure_id    NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  class_id            NUMBER(20) NOT NULL,  
  group_id            NUMBER(20),  
  medium_id           NUMBER(20),  
  structure_name      VARCHAR2(150) NOT NULL,  
  effective_from      DATE NOT NULL,  
  effective_to        DATE,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_fee_structures UNIQUE (branch_id, academic_year_id, class_id, group_id, medium_id, structure_name),  
  CONSTRAINT fk_fee_structures_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_fee_structures_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_fee_structures_class FOREIGN KEY (class_id) REFERENCES class_levels(class_id),  
  CONSTRAINT fk_fee_structures_group FOREIGN KEY (group_id) REFERENCES groups(group_id),  
  CONSTRAINT fk_fee_structures_medium FOREIGN KEY (medium_id) REFERENCES mediums(medium_id),  
  CONSTRAINT fk_fee_structures_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE fee_structure_details (  
  fee_structure_detail_id NUMBER(20) PRIMARY KEY,  
  fee_structure_id    NUMBER(20) NOT NULL,  
  fee_head_id         NUMBER(20) NOT NULL,  
  amount              NUMBER(12,2) DEFAULT 0 NOT NULL,  
  frequency           VARCHAR2(30) DEFAULT 'ONE_TIME' NOT NULL,  
  due_day             NUMBER(10),  
  is_optional         CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_fee_structure_details UNIQUE (fee_structure_id, fee_head_id),  
  CONSTRAINT chk_fee_amount CHECK (amount >= 0),  
  CONSTRAINT chk_is_optional CHECK (is_optional IN ('0','1')),  
  CONSTRAINT fk_fee_structure_details_structure FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(fee_structure_id) ON DELETE CASCADE,  
  CONSTRAINT fk_fee_structure_details_head FOREIGN KEY (fee_head_id) REFERENCES fee_heads(fee_head_id)  
);

CREATE TABLE student_fee_assignments (  
  assignment_id       NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  enrollment_id       NUMBER(20) NOT NULL,  
  fee_structure_id    NUMBER(20) NOT NULL,  
  discount_percent    NUMBER(5,2) DEFAULT 0,  
  discount_amount     NUMBER(12,2) DEFAULT 0,  
  reason              CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  assigned_by         NUMBER(20),  
  assigned_at         date,  
  CONSTRAINT uk_student_fee_assignment UNIQUE (student_id, enrollment_id, fee_structure_id),  
  CONSTRAINT fk_student_fee_assignments_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_fee_assignments_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_enrollments(enrollment_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_fee_assignments_structure FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(fee_structure_id),  
  CONSTRAINT fk_student_fee_assignments_assigned_by FOREIGN KEY (assigned_by) REFERENCES app_users(user_id)  
);

CREATE TABLE fee_invoices (  
  invoice_id          NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  student_id          NUMBER(20) NOT NULL,  
  enrollment_id       NUMBER(20),  
  invoice_no          VARCHAR2(50) NOT NULL,  
  invoice_date        DATE DEFAULT SYSDATE NOT NULL,  
  due_date            DATE,  
  billing_month       NUMBER(10),  
  billing_year        NUMBER(10),  
  gross_amount        NUMBER(12,2) DEFAULT 0 NOT NULL,  
  discount_amount     NUMBER(12,2) DEFAULT 0 NOT NULL,  
  fine_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  net_amount          NUMBER(12,2) DEFAULT 0 NOT NULL,  
  paid_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  due_amount          NUMBER(12,2) DEFAULT 0 NOT NULL,  
  invoice_status      VARCHAR2(30) DEFAULT 'UNPAID' NOT NULL,  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_fee_invoices_no UNIQUE (branch_id, invoice_no),  
  CONSTRAINT fk_fee_invoices_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_fee_invoices_student FOREIGN KEY (student_id) REFERENCES students(student_id),  
  CONSTRAINT fk_fee_invoices_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_enrollments(enrollment_id),  
  CONSTRAINT fk_fee_invoices_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE fee_invoice_lines (  
  invoice_line_id     NUMBER(20) PRIMARY KEY,  
  invoice_id          NUMBER(20) NOT NULL,  
  fee_head_id         NUMBER(20) NOT NULL,  
  description         VARCHAR2(200),  
  amount              NUMBER(12,2) DEFAULT 0 NOT NULL,  
  discount_amount     NUMBER(12,2) DEFAULT 0 NOT NULL,  
  fine_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  net_amount          NUMBER(12,2) DEFAULT 0 NOT NULL,  
  paid_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  due_amount          NUMBER(12,2) DEFAULT 0 NOT NULL,  
  line_status         VARCHAR2(30) DEFAULT 'UNPAID' NOT NULL,  
  CONSTRAINT fk_fee_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES fee_invoices(invoice_id) ON DELETE CASCADE,  
  CONSTRAINT fk_fee_invoice_lines_head FOREIGN KEY (fee_head_id) REFERENCES fee_heads(fee_head_id)  
);

CREATE TABLE fee_collections (  
  collection_id       NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  student_id          NUMBER(20) NOT NULL,  
  receipt_no          VARCHAR2(50) NOT NULL,  
  collection_date     DATE DEFAULT SYSDATE NOT NULL,  
  payment_method      VARCHAR2(30) DEFAULT 'CASH' NOT NULL,  
  reference_no        VARCHAR2(100),  
  total_amount        NUMBER(12,2) DEFAULT 0 NOT NULL,  
  remarks             CLOB,  
  collected_by        NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_fee_receipt_no UNIQUE (branch_id, receipt_no),  
  CONSTRAINT fk_fee_collections_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_fee_collections_student FOREIGN KEY (student_id) REFERENCES students(student_id),  
  CONSTRAINT fk_fee_collections_collected_by FOREIGN KEY (collected_by) REFERENCES app_users(user_id)  
);

CREATE TABLE fee_collection_lines (  
  collection_line_id  NUMBER(20) PRIMARY KEY,  
  collection_id       NUMBER(20) NOT NULL,  
  invoice_id          NUMBER(20) NOT NULL,  
  invoice_line_id     NUMBER(20),  
  paid_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  discount_amount     NUMBER(12,2) DEFAULT 0 NOT NULL,  
  fine_amount         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  CONSTRAINT fk_fee_collection_lines_collection FOREIGN KEY (collection_id) REFERENCES fee_collections(collection_id) ON DELETE CASCADE,  
  CONSTRAINT fk_fee_collection_lines_invoice FOREIGN KEY (invoice_id) REFERENCES fee_invoices(invoice_id),  
  CONSTRAINT fk_fee_collection_lines_invoice_line FOREIGN KEY (invoice_line_id) REFERENCES fee_invoice_lines(invoice_line_id)  
);

CREATE TABLE fee_waivers (  
  waiver_id           NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  fee_head_id         NUMBER(20),  
  waiver_type         VARCHAR2(30) NOT NULL,  
  waiver_value        NUMBER(12,2) NOT NULL,  
  effective_from      DATE NOT NULL,  
  effective_to        DATE,  
  approval_status     VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  approved_by         NUMBER(20),  
  remarks             CLOB,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_fee_waivers_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_fee_waivers_head FOREIGN KEY (fee_head_id) REFERENCES fee_heads(fee_head_id),  
  CONSTRAINT fk_fee_waivers_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id)  
);

-- ============================================================  
-- 9. ACCOUNTING CORE  
-- ============================================================  

CREATE TABLE fiscal_years (  
  fiscal_year_id      NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  year_name           VARCHAR2(30) NOT NULL,  
  start_date          DATE NOT NULL,  
  end_date            DATE NOT NULL,  
  is_current          CHAR(1) DEFAULT '0' NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'OPEN' NOT NULL,  
  CONSTRAINT uk_fiscal_years UNIQUE (institution_id, year_name),  
  CONSTRAINT chk_fiscal_year_dates CHECK (end_date >= start_date),  
  CONSTRAINT chk_is_current CHECK (is_current IN ('0','1')),  
  CONSTRAINT fk_fiscal_years_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE chart_of_accounts (  
  account_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  parent_account_id   NUMBER(20),  
  account_code        VARCHAR2(50) NOT NULL,  
  account_name        VARCHAR2(150) NOT NULL,  
  account_type        VARCHAR2(30) NOT NULL,  
  is_postable         CHAR(1) DEFAULT '1' NOT NULL,  
  opening_balance     NUMBER(14,2) DEFAULT 0 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_chart_accounts UNIQUE (institution_id, account_code),  
  CONSTRAINT chk_is_postable CHECK (is_postable IN ('0','1')),  
  CONSTRAINT fk_chart_accounts_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_chart_accounts_parent FOREIGN KEY (parent_account_id) REFERENCES chart_of_accounts(account_id) ON DELETE SET NULL  
);

CREATE TABLE bank_accounts (  
  bank_account_id     NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  account_id          NUMBER(20),  
  bank_name           VARCHAR2(120) NOT NULL,  
  branch_name         VARCHAR2(120),  
  account_name        VARCHAR2(150) NOT NULL,  
  account_no          VARCHAR2(80) NOT NULL,  
  routing_no          VARCHAR2(50),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT uk_bank_accounts UNIQUE (institution_id, account_no),  
  CONSTRAINT fk_bank_accounts_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_bank_accounts_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_bank_accounts_account FOREIGN KEY (account_id) REFERENCES chart_of_accounts(account_id)  
);

CREATE TABLE journal_vouchers (  
  voucher_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  fiscal_year_id      NUMBER(20),  
  voucher_no          VARCHAR2(50) NOT NULL,  
  voucher_date        DATE DEFAULT SYSDATE NOT NULL,  
  voucher_type        VARCHAR2(30) DEFAULT 'JOURNAL' NOT NULL,  
  source_module       VARCHAR2(50),  
  source_id           NUMBER(20),  
  narration           CLOB,  
  total_debit         NUMBER(14,2) DEFAULT 0 NOT NULL,  
  total_credit        NUMBER(14,2) DEFAULT 0 NOT NULL,  
  approval_status     VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,  
  created_by          NUMBER(20),  
  approved_by         NUMBER(20),  
  approved_at         date,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_journal_vouchers UNIQUE (institution_id, voucher_no),  
  CONSTRAINT chk_journal_balance CHECK (total_debit = total_credit),  
  CONSTRAINT fk_journal_vouchers_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_journal_vouchers_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_journal_vouchers_fiscal_year FOREIGN KEY (fiscal_year_id) REFERENCES fiscal_years(fiscal_year_id),  
  CONSTRAINT fk_journal_vouchers_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id),  
  CONSTRAINT fk_journal_vouchers_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id)  
);

CREATE TABLE journal_lines (  
  journal_line_id     NUMBER(20) PRIMARY KEY,  
  voucher_id          NUMBER(20) NOT NULL,  
  account_id          NUMBER(20) NOT NULL,  
  debit_amount        NUMBER(14,2) DEFAULT 0 NOT NULL,  
  credit_amount       NUMBER(14,2) DEFAULT 0 NOT NULL,  
  line_description    CLOB,  
  cost_center         VARCHAR2(80),  
  CONSTRAINT chk_journal_line_amount CHECK (  
    (debit_amount > 0 AND credit_amount = 0) OR (credit_amount > 0 AND debit_amount = 0)  
  ),  
  CONSTRAINT fk_journal_lines_voucher FOREIGN KEY (voucher_id) REFERENCES journal_vouchers(voucher_id) ON DELETE CASCADE,  
  CONSTRAINT fk_journal_lines_account FOREIGN KEY (account_id) REFERENCES chart_of_accounts(account_id)  
);

-- ============================================================  
-- 10. EXAM / MARKS / RESULT  
-- ============================================================  

CREATE TABLE exam_types (  
  exam_type_id        NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  exam_type_code      VARCHAR2(30) NOT NULL,  
  exam_type_name      VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_exam_types UNIQUE (institution_id, exam_type_code),  
  CONSTRAINT fk_exam_types_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE exams (  
  exam_id             NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  academic_year_id    NUMBER(20) NOT NULL,  
  exam_type_id        NUMBER(20) NOT NULL,  
  exam_name           VARCHAR2(150) NOT NULL,  
  class_id            NUMBER(20),  
  start_date          DATE,  
  end_date            DATE,  
  result_publish_date DATE,  
  exam_status         VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,  
  created_by          NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_exams UNIQUE (branch_id, academic_year_id, exam_type_id, exam_name, class_id),  
  CONSTRAINT fk_exams_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exams_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id),  
  CONSTRAINT fk_exams_type FOREIGN KEY (exam_type_id) REFERENCES exam_types(exam_type_id),  
  CONSTRAINT fk_exams_class FOREIGN KEY (class_id) REFERENCES class_levels(class_id),  
  CONSTRAINT fk_exams_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

CREATE TABLE exam_subjects (  
  exam_subject_id     NUMBER(20) PRIMARY KEY,  
  exam_id             NUMBER(20) NOT NULL,  
  subject_id          NUMBER(20) NOT NULL,  
  full_marks          NUMBER(8,2) DEFAULT 100 NOT NULL,  
  pass_marks          NUMBER(8,2) DEFAULT 33 NOT NULL,  
  exam_date           DATE,  
  start_time          TIMESTAMP(0),  
  end_time            TIMESTAMP(0),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_exam_subjects UNIQUE (exam_id, subject_id),  
  CONSTRAINT fk_exam_subjects_exam FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exam_subjects_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)  
);

CREATE TABLE mark_components (  
  component_id        NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  component_code      VARCHAR2(30) NOT NULL,  
  component_name      VARCHAR2(100) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_mark_components UNIQUE (institution_id, component_code),  
  CONSTRAINT fk_mark_components_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE exam_subject_components (  
  exam_subject_component_id NUMBER(20) PRIMARY KEY,  
  exam_subject_id     NUMBER(20) NOT NULL,  
  component_id        NUMBER(20) NOT NULL,  
  full_marks          NUMBER(8,2) NOT NULL,  
  pass_marks          NUMBER(8,2) DEFAULT 0,  
  sort_order          NUMBER(10) DEFAULT 0,  
  CONSTRAINT uk_exam_subject_components UNIQUE (exam_subject_id, component_id),  
  CONSTRAINT fk_exam_subject_components_exam_subject FOREIGN KEY (exam_subject_id) REFERENCES exam_subjects(exam_subject_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exam_subject_components_component FOREIGN KEY (component_id) REFERENCES mark_components(component_id)  
);

CREATE TABLE exam_marks (  
  mark_id             NUMBER(20) PRIMARY KEY,  
  exam_id             NUMBER(20) NOT NULL,  
  exam_subject_id     NUMBER(20) NOT NULL,  
  student_id          NUMBER(20) NOT NULL,  
  component_id        NUMBER(20),  
  marks_obtained      NUMBER(8,2) DEFAULT 0 NOT NULL,  
  is_absent           CHAR(1) DEFAULT '0' NOT NULL,  
  remarks             CLOB,  
  entered_by          NUMBER(20),  
  entered_at          date,  
  updated_at          date,  
  CONSTRAINT uk_exam_marks UNIQUE (exam_subject_id, student_id, component_id),  
  CONSTRAINT chk_is_absent CHECK (is_absent IN ('0','1')),  
  CONSTRAINT fk_exam_marks_exam FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exam_marks_exam_subject FOREIGN KEY (exam_subject_id) REFERENCES exam_subjects(exam_subject_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exam_marks_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_exam_marks_component FOREIGN KEY (component_id) REFERENCES mark_components(component_id),  
  CONSTRAINT fk_exam_marks_entered_by FOREIGN KEY (entered_by) REFERENCES app_users(user_id)  
);

CREATE TABLE grading_scales (  
  grading_scale_id    NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  scale_name          VARCHAR2(100) NOT NULL,  
  max_gpa             NUMBER(4,2) DEFAULT 5 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_grading_scales UNIQUE (institution_id, scale_name),  
  CONSTRAINT fk_grading_scales_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE grading_scale_details (  
  grade_detail_id     NUMBER(20) PRIMARY KEY,  
  grading_scale_id    NUMBER(20) NOT NULL,  
  min_marks           NUMBER(8,2) NOT NULL,  
  max_marks           NUMBER(8,2) NOT NULL,  
  letter_grade        VARCHAR2(10) NOT NULL,  
  grade_point         NUMBER(4,2) NOT NULL,  
  remarks             VARCHAR2(100),  
  CONSTRAINT chk_grade_marks CHECK (max_marks >= min_marks),  
  CONSTRAINT fk_grading_scale_details_scale FOREIGN KEY (grading_scale_id) REFERENCES grading_scales(grading_scale_id) ON DELETE CASCADE  
);

CREATE TABLE student_results (  
  result_id           NUMBER(20) PRIMARY KEY,  
  exam_id             NUMBER(20) NOT NULL,  
  student_id          NUMBER(20) NOT NULL,  
  enrollment_id       NUMBER(20),  
  total_marks         NUMBER(10,2) DEFAULT 0 NOT NULL,  
  obtained_marks      NUMBER(10,2) DEFAULT 0 NOT NULL,  
  gpa                 NUMBER(4,2),  
  letter_grade        VARCHAR2(10),  
  merit_position      NUMBER(10),  
  result_status       VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  failed_subject_count NUMBER(10) DEFAULT 0 NOT NULL,  
  published_at        date,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_student_results UNIQUE (exam_id, student_id),  
  CONSTRAINT fk_student_results_exam FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_results_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_results_enrollment FOREIGN KEY (enrollment_id) REFERENCES student_enrollments(enrollment_id)  
);

CREATE TABLE student_result_details (  
  result_detail_id    NUMBER(20) PRIMARY KEY,  
  result_id           NUMBER(20) NOT NULL,  
  subject_id          NUMBER(20) NOT NULL,  
  full_marks          NUMBER(8,2) DEFAULT 100 NOT NULL,  
  pass_marks          NUMBER(8,2) DEFAULT 33 NOT NULL,  
  obtained_marks      NUMBER(8,2) DEFAULT 0 NOT NULL,  
  letter_grade        VARCHAR2(10),  
  grade_point         NUMBER(4,2),  
  subject_status      VARCHAR2(30) DEFAULT 'PENDING' NOT NULL,  
  remarks             CLOB,  
  CONSTRAINT uk_student_result_details UNIQUE (result_id, subject_id),  
  CONSTRAINT fk_student_result_details_result FOREIGN KEY (result_id) REFERENCES student_results(result_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_result_details_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)  
);

-- ============================================================  
-- 11. LIBRARY MANAGEMENT  
-- ============================================================  

CREATE TABLE book_categories (  
  book_category_id    NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  category_name       VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_book_categories UNIQUE (institution_id, category_name),  
  CONSTRAINT fk_book_categories_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE books (  
  book_id             NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  book_category_id    NUMBER(20),  
  isbn                VARCHAR2(80),  
  book_title          VARCHAR2(250) NOT NULL,  
  author_name         VARCHAR2(200),  
  publisher_name      VARCHAR2(200),  
  edition             VARCHAR2(80),  
  publish_year        NUMBER(10),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_books_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_books_category FOREIGN KEY (book_category_id) REFERENCES book_categories(book_category_id)  
);

CREATE TABLE book_copies (  
  book_copy_id        NUMBER(20) PRIMARY KEY,  
  book_id             NUMBER(20) NOT NULL,  
  branch_id           NUMBER(20),  
  accession_no        VARCHAR2(80) NOT NULL,  
  shelf_no            VARCHAR2(50),  
  purchase_date       DATE,  
  purchase_price      NUMBER(10,2),  
  copy_status         VARCHAR2(30) DEFAULT 'AVAILABLE' NOT NULL,  
  CONSTRAINT uk_book_copies UNIQUE (accession_no),  
  CONSTRAINT fk_book_copies_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,  
  CONSTRAINT fk_book_copies_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)  
);

CREATE TABLE library_issues (  
  issue_id            NUMBER(20) PRIMARY KEY,  
  book_copy_id        NUMBER(20) NOT NULL,  
  member_type         VARCHAR2(30) NOT NULL,  
  student_id          NUMBER(20),  
  employee_id         NUMBER(20),  
  issue_date          DATE DEFAULT SYSDATE NOT NULL,  
  due_date            DATE NOT NULL,  
  return_date         DATE,  
  issue_status        VARCHAR2(30) DEFAULT 'ISSUED' NOT NULL,  
  fine_amount         NUMBER(10,2) DEFAULT 0 NOT NULL,  
  issued_by           NUMBER(20),  
  returned_by         NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT fk_library_issues_copy FOREIGN KEY (book_copy_id) REFERENCES book_copies(book_copy_id),  
  CONSTRAINT fk_library_issues_student FOREIGN KEY (student_id) REFERENCES students(student_id),  
  CONSTRAINT fk_library_issues_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),  
  CONSTRAINT fk_library_issues_issued_by FOREIGN KEY (issued_by) REFERENCES app_users(user_id),  
  CONSTRAINT fk_library_issues_returned_by FOREIGN KEY (returned_by) REFERENCES app_users(user_id)  
);

-- ============================================================  
-- 12. TRANSPORT MANAGEMENT  
-- ============================================================  

CREATE TABLE vehicles (  
  vehicle_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  vehicle_no          VARCHAR2(50) NOT NULL,  
  vehicle_type        VARCHAR2(50),  
  capacity            NUMBER(10),  
  driver_name         VARCHAR2(150),  
  driver_mobile       VARCHAR2(30),  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_vehicles UNIQUE (institution_id, vehicle_no),  
  CONSTRAINT fk_vehicles_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE transport_routes (  
  route_id            NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  route_code          VARCHAR2(30) NOT NULL,  
  route_name          VARCHAR2(150) NOT NULL,  
  vehicle_id          NUMBER(20),  
  monthly_fee         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_transport_routes UNIQUE (branch_id, route_code),  
  CONSTRAINT fk_transport_routes_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_transport_routes_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)  
);

CREATE TABLE transport_stops (  
  stop_id             NUMBER(20) PRIMARY KEY,  
  route_id            NUMBER(20) NOT NULL,  
  stop_name           VARCHAR2(150) NOT NULL,  
  stop_order          NUMBER(10) DEFAULT 0,  
  pickup_time         TIMESTAMP(0),  
  drop_time           TIMESTAMP(0),  
  stop_fee            NUMBER(12,2) DEFAULT 0,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT fk_transport_stops_route FOREIGN KEY (route_id) REFERENCES transport_routes(route_id) ON DELETE CASCADE  
);

CREATE TABLE student_transport_assignments (  
  transport_assignment_id NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  route_id            NUMBER(20) NOT NULL,  
  stop_id             NUMBER(20),  
  start_date          DATE DEFAULT SYSDATE NOT NULL,  
  end_date            DATE,  
  monthly_fee         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT fk_student_transport_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_transport_route FOREIGN KEY (route_id) REFERENCES transport_routes(route_id),  
  CONSTRAINT fk_student_transport_stop FOREIGN KEY (stop_id) REFERENCES transport_stops(stop_id)  
);

-- ============================================================  
-- 13. INVENTORY / PROCUREMENT BASIC  
-- ============================================================  

CREATE TABLE vendors (  
  vendor_id           NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  vendor_code         VARCHAR2(30) NOT NULL,  
  vendor_name         VARCHAR2(150) NOT NULL,  
  contact_person      VARCHAR2(150),  
  mobile              VARCHAR2(30),  
  email               VARCHAR2(150),  
  address_line        CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_vendors UNIQUE (institution_id, vendor_code),  
  CONSTRAINT fk_vendors_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE item_categories (  
  item_category_id    NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  category_name       VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_item_categories UNIQUE (institution_id, category_name),  
  CONSTRAINT fk_item_categories_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE  
);

CREATE TABLE items (  
  item_id             NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20) NOT NULL,  
  item_category_id    NUMBER(20),  
  item_code           VARCHAR2(50) NOT NULL,  
  item_name           VARCHAR2(150) NOT NULL,  
  unit_name           VARCHAR2(30) DEFAULT 'PCS' NOT NULL,  
  reorder_level       NUMBER(12,2) DEFAULT 0,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_items UNIQUE (institution_id, item_code),  
  CONSTRAINT fk_items_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_items_category FOREIGN KEY (item_category_id) REFERENCES item_categories(item_category_id)  
);

CREATE TABLE stock_locations (  
  location_id         NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  location_code       VARCHAR2(30) NOT NULL,  
  location_name       VARCHAR2(120) NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_stock_locations UNIQUE (branch_id, location_code),  
  CONSTRAINT fk_stock_locations_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

CREATE TABLE purchase_orders (  
  po_id               NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  vendor_id           NUMBER(20),  
  po_no               VARCHAR2(50) NOT NULL,  
  po_date             DATE DEFAULT SYSDATE NOT NULL,  
  expected_date       DATE,  
  total_amount        NUMBER(14,2) DEFAULT 0 NOT NULL,  
  po_status           VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,  
  created_by          NUMBER(20),  
  approved_by         NUMBER(20),  
  created_at          date,  
  updated_at          date,  
  CONSTRAINT uk_purchase_orders UNIQUE (branch_id, po_no),  
  CONSTRAINT fk_purchase_orders_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_purchase_orders_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),  
  CONSTRAINT fk_purchase_orders_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id),  
  CONSTRAINT fk_purchase_orders_approved_by FOREIGN KEY (approved_by) REFERENCES app_users(user_id)  
);

CREATE TABLE purchase_order_lines (  
  po_line_id          NUMBER(20) PRIMARY KEY,  
  po_id               NUMBER(20) NOT NULL,  
  item_id             NUMBER(20) NOT NULL,  
  quantity            NUMBER(12,2) DEFAULT 0 NOT NULL,  
  rate                NUMBER(12,2) DEFAULT 0 NOT NULL,  
  amount              NUMBER(14,2) DEFAULT 0 NOT NULL,  
  remarks             CLOB,  
  CONSTRAINT fk_purchase_order_lines_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE CASCADE,  
  CONSTRAINT fk_purchase_order_lines_item FOREIGN KEY (item_id) REFERENCES items(item_id)  
);

CREATE TABLE stock_transactions (  
  stock_transaction_id NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  location_id         NUMBER(20),  
  item_id             NUMBER(20) NOT NULL,  
  transaction_date    DATE DEFAULT SYSDATE NOT NULL,  
  transaction_type    VARCHAR2(30) NOT NULL,  
  source_module       VARCHAR2(50),  
  source_id           NUMBER(20),  
  quantity            NUMBER(12,2) NOT NULL,  
  rate                NUMBER(12,2) DEFAULT 0,  
  amount              NUMBER(14,2) DEFAULT 0,  
  remarks             CLOB,  
  created_by          NUMBER(20),  
  created_at          date,  
  CONSTRAINT fk_stock_transactions_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),  
  CONSTRAINT fk_stock_transactions_location FOREIGN KEY (location_id) REFERENCES stock_locations(location_id),  
  CONSTRAINT fk_stock_transactions_item FOREIGN KEY (item_id) REFERENCES items(item_id),  
  CONSTRAINT fk_stock_transactions_created_by FOREIGN KEY (created_by) REFERENCES app_users(user_id)  
);

-- ============================================================  
-- 14. HOSTEL BASIC  
-- ============================================================  

CREATE TABLE hostels (  
  hostel_id           NUMBER(20) PRIMARY KEY,  
  branch_id           NUMBER(20) NOT NULL,  
  hostel_name         VARCHAR2(150) NOT NULL,  
  hostel_type         VARCHAR2(30),  
  address_line        CLOB,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_hostels UNIQUE (branch_id, hostel_name),  
  CONSTRAINT fk_hostels_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE  
);

CREATE TABLE hostel_rooms (  
  hostel_room_id      NUMBER(20) PRIMARY KEY,  
  hostel_id           NUMBER(20) NOT NULL,  
  room_no             VARCHAR2(50) NOT NULL,  
  capacity            NUMBER(10) NOT NULL,  
  monthly_fee         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT uk_hostel_rooms UNIQUE (hostel_id, room_no),  
  CONSTRAINT fk_hostel_rooms_hostel FOREIGN KEY (hostel_id) REFERENCES hostels(hostel_id) ON DELETE CASCADE  
);

CREATE TABLE student_hostel_assignments (  
  hostel_assignment_id NUMBER(20) PRIMARY KEY,  
  student_id          NUMBER(20) NOT NULL,  
  hostel_room_id      NUMBER(20) NOT NULL,  
  start_date          DATE DEFAULT SYSDATE NOT NULL,  
  end_date            DATE,  
  monthly_fee         NUMBER(12,2) DEFAULT 0 NOT NULL,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  created_at          date,  
  CONSTRAINT fk_student_hostel_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,  
  CONSTRAINT fk_student_hostel_room FOREIGN KEY (hostel_room_id) REFERENCES hostel_rooms(hostel_room_id)  
);

-- ============================================================  
-- 15. SYSTEM SETTINGS / FILES / AUDIT  
-- ============================================================  

CREATE TABLE system_settings (  
  setting_id          NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  branch_id           NUMBER(20),  
  setting_key         VARCHAR2(100) NOT NULL,  
  setting_value       CLOB,  
  setting_group       VARCHAR2(80),  
  is_encrypted        CHAR(1) DEFAULT '0' NOT NULL,  
  updated_by          NUMBER(20),  
  updated_at          date,  
  CONSTRAINT uk_system_settings UNIQUE (institution_id, branch_id, setting_key),  
  CONSTRAINT chk_is_encrypted CHECK (is_encrypted IN ('0','1')),  
  CONSTRAINT fk_system_settings_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_system_settings_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,  
  CONSTRAINT fk_system_settings_updated_by FOREIGN KEY (updated_by) REFERENCES app_users(user_id)  
);

CREATE TABLE file_attachments (  
  attachment_id       NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  module_name         VARCHAR2(80) NOT NULL,  
  record_id           NUMBER(20) NOT NULL,  
  file_name           VARCHAR2(250) NOT NULL,  
  file_url            CLOB NOT NULL,  
  file_type           VARCHAR2(80),  
  file_size_bytes     NUMBER(20),  
  uploaded_by         NUMBER(20),  
  uploaded_at         date,  
  status              VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,  
  CONSTRAINT fk_file_attachments_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_file_attachments_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES app_users(user_id)  
);

CREATE TABLE audit_logs (  
  audit_log_id        NUMBER(20) PRIMARY KEY,  
  institution_id      NUMBER(20),  
  user_id             NUMBER(20),  
  table_name          VARCHAR2(120) NOT NULL,  
  record_id           NUMBER(20),  
  action_type         VARCHAR2(30) NOT NULL,  
  old_data            CLOB,  
  new_data            CLOB,  
  ip_address          VARCHAR2(45),  
  user_agent          CLOB,  
  created_at          date,  
  CONSTRAINT fk_audit_logs_institution FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE,  
  CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES app_users(user_id) ON DELETE SET NULL  
);

-- ============================================================  
-- 16. INDEXES FOR PERFORMANCE  
-- ============================================================  

CREATE INDEX idx_branches_institution ON branches(institution_id);
CREATE INDEX idx_users_inst_branch ON app_users(institution_id, branch_id);
CREATE INDEX idx_students_inst_status ON students(institution_id, status);
CREATE INDEX idx_students_name ON students(first_name, last_name);
CREATE INDEX idx_student_enrollments_student ON student_enrollments(student_id);
CREATE INDEX idx_student_enrollments_batch ON student_enrollments(batch_id);
CREATE INDEX idx_student_attendance_date ON student_attendance(branch_id, attendance_date);
CREATE INDEX idx_employee_attendance_date ON employee_attendance(branch_id, attendance_date);
CREATE INDEX idx_fee_invoices_student ON fee_invoices(student_id, invoice_status);
CREATE INDEX idx_fee_invoices_date ON fee_invoices(branch_id, invoice_date);
CREATE INDEX idx_fee_collections_student ON fee_collections(student_id, collection_date);
CREATE INDEX idx_exam_marks_student ON exam_marks(student_id, exam_id);
CREATE INDEX idx_journal_voucher_date ON journal_vouchers(institution_id, voucher_date);
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_notification_logs_status ON notification_logs(send_status, created_at);

-- ============================================================  
-- 17. TRIGGERS FOR UPDATED_AT  
-- ============================================================  

-- Note: Oracle doesn't support dynamic trigger creation with functions
-- You need to create individual triggers for each table

-- Example trigger template (create for each table):
/*
CREATE OR REPLACE TRIGGER trg_institutions_updated
BEFORE UPDATE ON institutions
FOR EACH ROW
BEGIN
    :NEW.updated_at := sysdate;
END;
/
*/



-- ============================================================  
-- TRIGGER FOR AUTO_INCREMENT (BEFORE INSERT)  
-- ============================================================  

-- Example trigger for auto-increment (create for each table):
/*
CREATE OR REPLACE TRIGGER trg_institutions_bi
BEFORE INSERT ON institutions
FOR EACH ROW
BEGIN
    IF :NEW.institution_id IS NULL THEN
        SELECT seq_institutions.NEXTVAL INTO :NEW.institution_id FROM DUAL;
    END IF;
END;
/
*/

-- Create triggers for all tables with sequences
-- Note: For brevity, showing a few examples. Create for all tables similarly.

CREATE OR REPLACE TRIGGER trg_institutions_bi
BEFORE INSERT ON institutions
FOR EACH ROW
BEGIN
    IF :NEW.institution_id IS NULL THEN
        SELECT seq_institutions.NEXTVAL INTO :NEW.institution_id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_branches_bi
BEFORE INSERT ON branches
FOR EACH ROW
BEGIN
    IF :NEW.branch_id IS NULL THEN
        SELECT seq_branches.NEXTVAL INTO :NEW.branch_id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_academic_years_bi
BEFORE INSERT ON academic_years
FOR EACH ROW
BEGIN
    IF :NEW.academic_year_id IS NULL THEN
        SELECT seq_academic_years.NEXTVAL INTO :NEW.academic_year_id FROM DUAL;
    END IF;
END;
/
