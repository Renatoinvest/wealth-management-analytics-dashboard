/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 05_create_product_dimension.sql
Descrição: Criação da dimensão de produtos financeiros
==========================================================
*/

CREATE TABLE IF NOT EXISTS dw.dim_product (

    product_key SERIAL PRIMARY KEY,

    product_id VARCHAR(20) NOT NULL UNIQUE,

    product_name VARCHAR(100) NOT NULL,

    product_category VARCHAR(50) NOT NULL,

    asset_class VARCHAR(50) NOT NULL,

    risk_level VARCHAR(20) NOT NULL,

    liquidity VARCHAR(30) NOT NULL,

    issuer VARCHAR(100) NOT NULL,

    minimum_investment NUMERIC(15,2) NOT NULL,

    recommended_holding_period VARCHAR(30) NOT NULL,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);
