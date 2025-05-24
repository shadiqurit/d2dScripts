/* Formatted on 5/24/2025 3:57:57 PM (QP5 v5.362) */
CREATE OR REPLACE TYPE T_STRING_AGG AS OBJECT
(
    g_string VARCHAR2 (32767),
    STATIC FUNCTION ODCIAggregateInitialize (sctx IN OUT t_string_agg)
        RETURN NUMBER,
    MEMBER FUNCTION ODCIAggregateIterate (self    IN OUT t_string_agg,
                                          VALUE   IN     VARCHAR2)
        RETURN NUMBER,
    MEMBER FUNCTION ODCIAggregateTerminate (self          IN     t_string_agg,
                                            returnValue      OUT VARCHAR2,
                                            flags         IN     NUMBER)
        RETURN NUMBER,
    MEMBER FUNCTION ODCIAggregateMerge (self   IN OUT t_string_agg,
                                        ctx2   IN     t_string_agg)
        RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY T_STRING_AGG
IS
    STATIC FUNCTION ODCIAggregateInitialize (sctx IN OUT t_string_agg)
        RETURN NUMBER
    IS
    BEGIN
        sctx := t_string_agg (NULL);

        RETURN ODCIConst.Success;
    END;



    MEMBER FUNCTION ODCIAggregateIterate (self    IN OUT t_string_agg,
                                          VALUE   IN     VARCHAR2)
        RETURN NUMBER
    IS
    BEGIN
        SELF.g_string := self.g_string || ',' || VALUE;

        RETURN ODCIConst.Success;
    END;



    MEMBER FUNCTION ODCIAggregateTerminate (self          IN     t_string_agg,
                                            returnValue      OUT VARCHAR2,
                                            flags         IN     NUMBER)
        RETURN NUMBER
    IS
    BEGIN
        returnValue := SUBSTR (SELF.g_string, 2);

        RETURN ODCIConst.Success;
    END;



    MEMBER FUNCTION ODCIAggregateMerge (self   IN OUT t_string_agg,
                                        ctx2   IN     t_string_agg)
        RETURN NUMBER
    IS
    BEGIN
        SELF.g_string := SELF.g_string || ctx2.g_string;

        RETURN ODCIConst.Success;
    END;
END;
/

CREATE OR REPLACE FUNCTION WM_CONCAT (p_input VARCHAR2)
    RETURN VARCHAR2
    PARALLEL_ENABLE
    AGGREGATE USING t_string_agg;
/