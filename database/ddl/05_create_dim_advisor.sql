CREATE TABLE IF NOT EXISTS dw.dim_advisor (

    advisor_key SERIAL PRIMARY KEY,

    advisor_id VARCHAR(20) UNIQUE NOT NULL,

    advisor_name VARCHAR(120) NOT NULL,

    advisor_level VARCHAR(20) NOT NULL,

    certification VARCHAR(100),

    max_clients INTEGER,

    min_assets NUMERIC,

    max_assets NUMERIC,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);