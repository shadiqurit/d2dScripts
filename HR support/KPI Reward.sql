/* Formatted on 8/24/2025 1:57:22 PM (QP5 v5.362) */
CREATE TABLE HR_EMPCHANGE_kpi2025
AS
    SELECT * FROM HR_EMPCHANGE;

CREATE TABLE HR_EMPINCR_DET_kpi2025
AS
    SELECT * FROM HR_EMPINCR_DET;

CREATE TABLE HR_EMPSALSTRUCTURE_kpi2025
AS
    SELECT * FROM HR_EMPSALSTRUCTURE;

CREATE TABLE kpi_reward2025
AS
    SELECT * FROM kpi_reward;
    
CREATE TABLE kpi_reward
(
    empcode           VARCHAR2 (30),
    e_name            VARCHAR2 (100),
    last_promotion    VARCHAR2 (30),
    grade             VARCHAR2 (30),
    no_of_incr        NUMBER,
    allowance         NUMBER,
    total             NUMBER,
    effective_date    DATE,
    refno             VARCHAR2 (30)
);

--1,5,7,10,13,15,26,31,36,37,121 (Special allowonce) from hr_salary_d