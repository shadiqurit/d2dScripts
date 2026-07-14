WITH VALID_USERS AS (
    -- Step 1: Filter active employees
    SELECT ms.USERID, ms.GROUPNM
    FROM USERSEC_MAST ms
    JOIN ipihr.emp v ON ms.EMPCODE = v.EMPCODE
    WHERE ms.USERSTATUS = 'Y' 
    and v.department_name = 'MMIC'
      AND v.emp_status = 'A'
),
DISTINCT_MENU_USERS AS (
    -- Step 2: Get unique user/menu pairs to prevent duplicates
    SELECT DISTINCT mu.MENUID, mu.USERID 
    FROM MENUUSER mu
    JOIN VALID_USERS vu ON mu.USERID = vu.USERID OR mu.USERID = vu.GROUPNM
),
ACCESSED_MENUS AS (
    -- Step 3: Use your custom WM_CONCAT
    SELECT 
        MENUID,
        WM_CONCAT(USERID) AS ACCESSED_BY_USERS
    FROM DISTINCT_MENU_USERS
    GROUP BY MENUID
)
-- Step 4: Run the hierarchical tree query
SELECT 
    CASE WHEN LEVEL = 1 THEN m.MENUNAME END AS "Level 1: Parent Menu",
    CASE WHEN LEVEL = 2 THEN m.MENUNAME END AS "Level 2: Child Menu",
    CASE WHEN LEVEL = 3 THEN m.MENUNAME END AS "Level 3: Child-Child Menu",
    CASE WHEN LEVEL = 4 THEN m.MENUNAME END AS "Level 4: Deep Child Menu",
    LEVEL AS "Menu Depth",
    m.MENUID AS "Menu ID",
    m.RUNFILE AS "Run File / Action",
    m.MENUSTATUS AS "Status",
    NVL(a.ACCESSED_BY_USERS, 'No User Access') AS "Permitted Users"
FROM 
    MENUMASTER m
LEFT JOIN 
    ACCESSED_MENUS a ON m.MENUID = a.MENUID
WHERE 
    m.MENUNAME IS NOT NULL
START WITH 
    m.MENUPARENT IS NULL OR m.MENUPARENT = 0
CONNECT BY 
    PRIOR m.MENUID = m.MENUPARENT
ORDER SIBLINGS BY 
    m.MENUSL;