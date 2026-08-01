/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 06_insert_dim_client.sql
Descrição: População da dimensão clientes
==========================================================
*/

INSERT INTO dw.dim_client (

    client_id,
    full_name,
    gender,
    birth_date,
    city,
    state,
    region,
    income_range

)

SELECT

    'CLI' || LPAD(gs::TEXT,6,'0') AS client_id,

    'Cliente ' || LPAD(gs::TEXT,6,'0') AS full_name,

    CASE
        WHEN random() < 0.55 THEN 'Male'
        ELSE 'Female'
    END AS gender,

        DATE '1955-01-01'
        + FLOOR(random()*18000)::INTEGER AS birth_date,

            (
        ARRAY[
            'São Paulo',
            'Campinas',
            'Rio de Janeiro',
            'Belo Horizonte',
            'Curitiba',
            'Porto Alegre',
            'Brasília',
            'Salvador'
        ]
    )[FLOOR(random()*8+1)] AS city,

        (
        ARRAY[
            'SP',
            'SP',
            'RJ',
            'MG',
            'PR',
            'RS',
            'DF',
            'BA'
        ]
    )[FLOOR(random()*8+1)] AS state,

        (
        ARRAY[
            'Southeast',
            'South',
            'Midwest',
            'Northeast'
        ]
    )[FLOOR(random()*4+1)] AS region,

        (
        ARRAY[
            'High',
            'Very High',
            'Ultra High'
        ]
    )[FLOOR(random()*3+1)] AS income_range

    FROM generate_series(1,5870) AS gs;