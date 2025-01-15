BEGIN
    DBMS_NETWORK_ACL_ADMIN.DROP_ACL(
        acl => 'resolve_acl.xml'
    );
END;
/



BEGIN
    DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
        acl         => 'resolve_acl.xml',
        description => 'ACL for hostname resolution',
        principal   => 'TMS', -- Replace with your APEX schema user
        is_grant    => TRUE,
        privilege   => 'resolve'
    );
END;
/


BEGIN
    DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
        acl   => 'resolve_acl.xml',
        host  => '*', -- Use '*' for all hosts or specify a domain like 'example.com'
        lower_port => NULL,
        upper_port => NULL
    );
END;
/
SELECT *
FROM dba_network_acls;


SELECT *
FROM dba_network_acl_privileges;


SELECT UTL_INADDR.get_host_name(SYS_CONTEXT('USERENV', 'IP_ADDRESS')) AS hostname
FROM DUAL;

select UTL_INADDR.get_host_name('203.76.114.140') as hostname from dual;


