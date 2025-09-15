CREATE TABLE df_type
(
    type_id      NUMBER (15),
    type_name    VARCHAR2 (20 BYTE),
    type_desc    VARCHAR2 (150 BYTE),
    ent_by       VARCHAR2 (20 BYTE),
    ent_date     DATE,
    upd_by       VARCHAR2 (20 BYTE),
    upd_date     DATE
);

type_id  type_name
1	    General Note / Memo
2	    Office Order/ Memo
3	    Notice / Circular
4	    Departmental Memo
5	    Manpower Note
6	    Meeting Minutes
7	    Procurment Note