SET SERVEROUTPUT ON;

DECLARE
    v_reporting_person   VARCHAR2 (100);
    v_hod                VARCHAR2 (100);
    v_gm                 VARCHAR2 (100);
    v_md                 VARCHAR2 (100);
    v_hohr               VARCHAR2 (100);
    v_department_name    VARCHAR2 (100);
    v_name               VARCHAR2 (100 BYTE);
    v_name_rp            VARCHAR2 (100 BYTE);
    v_name_hod           VARCHAR2 (100 BYTE);
    v_name_gm            VARCHAR2 (100 BYTE);
    v_name_md            VARCHAR2 (100 BYTE);
    v_name_hohr          VARCHAR2 (100 BYTE);
    v_desig              VARCHAR2 (100 BYTE);
    v_desig_rp           VARCHAR2 (100 BYTE);
    v_desig_hod          VARCHAR2 (100 BYTE);
    v_desig_gm           VARCHAR2 (100 BYTE);
    v_desig_md           VARCHAR2 (100 BYTE);
    v_desig_hohr         VARCHAR2 (100 BYTE);
BEGIN
    DPUSER.shortleave_approval_ins ('IPI-002155',
                                    v_reporting_person,
                                    v_hod,
                                    v_gm,
                                    v_md,
                                    v_hohr,
                                    v_department_name,
                                    v_name,
                                    v_name_rp,
                                    v_name_hod,
                                    v_name_gm,
                                    v_name_md,
                                    v_name_hohr,
                                    v_desig,
                                    v_desig_rp,
                                    v_desig_hod,
                                    v_desig_gm,
                                    v_desig_md,
                                    v_desig_hohr);
    DBMS_OUTPUT.put_line (
           'Repoting Person = '
        || v_reporting_person
        || ' HOD = '
        || v_hod
        || ' GM = '
        || v_gm
        || ' MD = '
        || v_md
        || ' HR = '
        || v_hohr
        || ' Dept = '
        || v_department_name
        || ' '
        || v_name
        || ''
        || v_name_rp
        || ''
        || v_name_hod
        || ''
        || v_name_gm
        || ''
        || v_name_md
        || ''
        || v_name_hohr
        || ''
        || v_desig
        || ''
        || v_desig_rp
        || ''
        || v_desig_hod
        || ''
        || v_desig_gm
        || ''
        || v_desig_md
        || ''
        || v_desig_hohr);
END;