/*
=========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 03_create_dimensions.sql
Descrição: Criação das tabelas dimensão do Data Warehouse
=========================================================
*/

-- =====================================================
-- DIMENSÃO: CALENDÁRIO
-- =====================================================

CREATE TABLE IF NOT EXISTS dw.dim_calendar (

    calendar_key INTEGER PRIMARY KEY,

    full_date DATE NOT NULL,

    day SMALLINT NOT NULL,

    month SMALLINT NOT NULL,

    month_name VARCHAR(20) NOT NULL,

    quarter SMALLINT NOT NULL,

    year SMALLINT NOT NULL,

    week_of_year SMALLINT,

    day_of_week SMALLINT,

    day_name VARCHAR(20),

    is_weekend BOOLEAN,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE UNIQUE INDEX IF NOT EXISTS idx_dim_calendar_date
ON dw.dim_calendar(full_date);


-- =====================================================
-- DIMENSÃO: CLIENTE
-- =====================================================

CREATE TABLE IF NOT EXISTS dw.dim_client (

    client_key SERIAL PRIMARY KEY,

    client_id VARCHAR(20) NOT NULL UNIQUE,

    full_name VARCHAR(150) NOT NULL,

    gender VARCHAR(20),

    birth_date DATE,

    city VARCHAR(100),

    state CHAR(2),

    region VARCHAR(30),

    income_range VARCHAR(30),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE INDEX IF NOT EXISTS idx_dim_client_id
ON dw.dim_client(client_id);