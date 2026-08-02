/*
==============================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 09_insert_fact_transactions.sql
Descrição: Geração das movimentações financeiras sintéticas
==============================================================
*/

TRUNCATE TABLE dw.fact_transactions
RESTART IDENTITY;

INSERT INTO dw.fact_transactions (

    calendar_key,
    client_key,
    product_key,
    transaction_type,
    amount,
    quantity

)

SELECT

    (
        SELECT calendar_key
        FROM dw.dim_calendar
        WHERE year BETWEEN 2020 AND 2025
        ORDER BY random()
        LIMIT 1
    ) AS calendar_key,

    c.client_key,

    FLOOR(random()*15 + 1)::INTEGER AS product_key,

    (
        ARRAY[
            'Investment',
            'Additional Investment',
            'Redemption'
        ]
    )[FLOOR(random()*3 + 1)] AS transaction_type,

    ROUND((500 + random()*99500)::numeric,2) AS amount,

    FLOOR(random()*500 + 1)::INTEGER AS quantity

FROM dw.dim_client c

CROSS JOIN generate_series(1,100);