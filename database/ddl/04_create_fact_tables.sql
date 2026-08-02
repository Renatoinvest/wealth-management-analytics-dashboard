/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 04_create_fact_tables.sql
Descrição: Criação das tabelas fato do Data Warehouse
==========================================================
*/

CREATE TABLE IF NOT EXISTS dw.fact_transactions (

    transaction_key INTEGER PRIMARY KEY,

    calendar_key INTEGER NOT NULL,

    client_key INTEGER NOT NULL,

    product_key INTEGER,

    transaction_type VARCHAR(30),

    amount NUMERIC(18,2) NOT NULL,

    quantity INTEGER,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_fact_calendar
        FOREIGN KEY (calendar_key)
        REFERENCES dw.dim_calendar(calendar_key),

    CONSTRAINT fk_fact_client
        FOREIGN KEY (client_key)
        REFERENCES dw.dim_client(client_key)

        CONSTRAINT fk_fact_product
        FOREIGN KEY (product_key)
        REFERENCES dw.dim_product(product_key)

);

CREATE INDEX IF NOT EXISTS idx_fact_calendar
ON dw.fact_transactions(calendar_key);

CREATE INDEX IF NOT EXISTS idx_fact_client
ON dw.fact_transactions(client_key);