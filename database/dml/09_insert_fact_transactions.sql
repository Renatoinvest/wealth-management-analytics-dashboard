/*
===============================================================================
File        : 09_insert_fact_transactions.sql
Project     : Wealth Management Analytics Dashboard
Company     : On Time Analytics Services
Database    : PostgreSQL 16
Purpose     : Populate dw.fact_transactions
===============================================================================
*/

BEGIN;

-- ============================================================================
-- TRUNCATE FACT TABLE
-- ============================================================================

TRUNCATE TABLE dw.fact_transactions;

-- ============================================================================
-- LOAD FACT_TRANSACTIONS
-- ============================================================================

WITH client_population AS
(
    SELECT
        c.client_key,
        c.investor_profile,
        c.wealth_segment,
        CASE
            WHEN c.investor_profile = 'Conservative' THEN 80
            WHEN c.investor_profile = 'Moderate' THEN 110
            WHEN c.investor_profile = 'Aggressive' THEN 150
        END AS operations_per_client
    FROM dw.dim_client c
),
client_operations AS
(
    SELECT
        cp.client_key,
        cp.investor_profile,
        cp.wealth_segment,
        gs.operation_number
    FROM client_population cp
    CROSS JOIN LATERAL generate_series
    (
        1,
        cp.operations_per_client
    ) AS gs(operation_number)
),
calendar_distribution AS
(
    SELECT
        dc.calendar_key,
        dc.full_date,
        ROW_NUMBER() OVER
        (
            ORDER BY dc.full_date
        ) AS calendar_seq,
        COUNT(*) OVER () AS total_days
    FROM dw.dim_calendar dc
    WHERE dc.full_date BETWEEN DATE '2020-01-01' AND DATE '2025-12-31'
),
operation_seed AS
(
    SELECT
        co.client_key,
        co.investor_profile,
        co.wealth_segment,
        co.operation_number,
        ROW_NUMBER() OVER
        (
            ORDER BY
                co.client_key,
                co.operation_number
        ) AS global_operation_id
    FROM client_operations co
),
assigned_dates AS
(
    SELECT
        os.client_key,
        os.investor_profile,
        os.wealth_segment,
        os.operation_number,
        os.global_operation_id,
        cd.calendar_key
    FROM operation_seed os
    INNER JOIN calendar_distribution cd
        ON cd.calendar_seq =
        (
            (
                (
                    os.global_operation_id * 37
                )
                +
                (
                    os.client_key * 13
                )
                +
                (
                    os.operation_number * 7
                )
            ) % cd.total_days
        ) + 1
),
allowed_products AS
(
    SELECT
        p.product_key,
        'Conservative' AS investor_profile
    FROM dw.dim_product p
    WHERE LOWER(p.product_name) IN
    (
        LOWER('Tesouro Selic'),
        LOWER('Tesouro Prefixado'),
        LOWER('Tesouro IPCA+'),
        LOWER('CDB'),
        LOWER('LCI'),
        LOWER('LCA'),
        LOWER('Previdência Privada')
    )

    UNION ALL

    SELECT
        p.product_key,
        'Moderate'
    FROM dw.dim_product p
    WHERE LOWER(p.product_name) IN
    (
        LOWER('Tesouro Selic'),
        LOWER('Tesouro Prefixado'),
        LOWER('Tesouro IPCA+'),
        LOWER('CDB'),
        LOWER('LCI'),
        LOWER('LCA'),
        LOWER('Previdência Privada'),
        LOWER('CRI'),
        LOWER('CRA'),
        LOWER('Debênture'),
        LOWER('Fundo Multimercado'),
        LOWER('ETF')
    )

    UNION ALL

    SELECT
        p.product_key,
        'Aggressive'
    FROM dw.dim_product p
),
product_rank AS
(
    SELECT
        investor_profile,
        product_key,
        ROW_NUMBER() OVER
        (
            PARTITION BY investor_profile
            ORDER BY product_key
        ) AS product_seq,
        COUNT(*) OVER
        (
            PARTITION BY investor_profile
        ) AS total_products
    FROM allowed_products
),
final_dataset AS
(
    SELECT
        ad.calendar_key,
        ad.client_key,
        pr.product_key,

        CASE
            WHEN ((ad.global_operation_id * 97) % 100) < 60
                THEN 'Investment'
            WHEN ((ad.global_operation_id * 97) % 100) < 90
                THEN 'Additional Investment'
            ELSE 'Redemption'
        END AS transaction_type,

        CASE
            WHEN ad.investor_profile = 'Conservative'
                THEN ROUND
                (
                    (
                        500 +
                        (
                            (
                                ad.global_operation_id * 173
                            ) % 24501
                        )
                    )::NUMERIC,
                    2
                )

            WHEN ad.investor_profile = 'Moderate'
                THEN ROUND
                (
                    (
                        2000 +
                        (
                            (
                                ad.global_operation_id * 311
                            ) % 78001
                        )
                    )::NUMERIC,
                    2
                )

            WHEN ad.investor_profile = 'Aggressive'
                THEN ROUND
                (
                    (
                        5000 +
                        (
                            (
                                ad.global_operation_id * 547
                            ) % 245001
                        )
                    )::NUMERIC,
                    2
                )
        END AS amount,

        (
            (
                ad.global_operation_id * 59
            ) % 500
        ) + 1 AS quantity

    FROM assigned_dates ad

    INNER JOIN product_rank pr
        ON pr.investor_profile = ad.investor_profile
       AND pr.product_seq =
       (
            (
                (
                    ad.global_operation_id * 11
                )
                +
                ad.client_key
            ) % pr.total_products
       ) + 1
)

INSERT INTO dw.fact_transactions
(
    calendar_key,
    client_key,
    product_key,
    transaction_type,
    amount,
    quantity
)
SELECT
    calendar_key,
    client_key,
    product_key,
    transaction_type,
    amount,
    quantity
FROM final_dataset;

COMMIT;

-- ============================================================================
-- VALIDATION 01 - TOTAL TRANSACTIONS
-- ============================================================================

SELECT
    COUNT(*) AS total_transactions
FROM dw.fact_transactions;

-- ============================================================================
-- VALIDATION 02 - DISTRIBUTION BY TRANSACTION TYPE
-- ============================================================================

SELECT
    transaction_type,
    COUNT(*) AS transactions,
    ROUND
    (
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM dw.fact_transactions
GROUP BY transaction_type
ORDER BY transactions DESC;

-- ============================================================================
-- VALIDATION 03 - MOST TRADED PRODUCTS
-- ============================================================================

SELECT
    p.product_name,
    COUNT(*) AS transactions
FROM dw.fact_transactions f
INNER JOIN dw.dim_product p
        ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY transactions DESC;

-- ============================================================================
-- VALIDATION 04 - INVESTOR PROFILE DISTRIBUTION
-- ============================================================================

SELECT
    c.investor_profile,
    COUNT(*) AS transactions
FROM dw.fact_transactions f
INNER JOIN dw.dim_client c
        ON c.client_key = f.client_key
GROUP BY c.investor_profile
ORDER BY transactions DESC;

-- ============================================================================
-- VALIDATION 05 - TOTAL FINANCIAL VOLUME
-- ============================================================================

SELECT
    ROUND(SUM(amount),2) AS total_financial_volume
FROM dw.fact_transactions;

-- ============================================================================
-- VALIDATION 06 - VOLUME BY WEALTH SEGMENT
-- ============================================================================

SELECT
    c.wealth_segment,
    ROUND(SUM(f.amount),2) AS financial_volume
FROM dw.fact_transactions f
INNER JOIN dw.dim_client c
        ON c.client_key = f.client_key
GROUP BY c.wealth_segment
ORDER BY financial_volume DESC;

-- ============================================================================
-- VALIDATION 07 - AVERAGE TICKET
-- ============================================================================

SELECT
    ROUND(AVG(amount),2) AS average_ticket
FROM dw.fact_transactions;

-- ============================================================================
-- VALIDATION 08 - LARGEST TRANSACTION
-- ============================================================================

SELECT
    MAX(amount) AS largest_transaction
FROM dw.fact_transactions;

-- ============================================================================
-- VALIDATION 09 - SMALLEST TRANSACTION
-- ============================================================================

SELECT
    MIN(amount) AS smallest_transaction
FROM dw.fact_transactions;

-- ============================================================================
-- VALIDATION 10 - FIRST AND LAST DATE
-- ============================================================================

SELECT
    MIN(c.full_date) AS first_transaction_date,
    MAX(c.full_date) AS last_transaction_date
FROM dw.fact_transactions f
INNER JOIN dw.dim_calendar c
        ON c.calendar_key = f.calendar_key;

-- ============================================================================
-- VALIDATION 11 - DISTRIBUTION BY YEAR
-- ============================================================================

SELECT
    c.year,
    COUNT(*) AS transactions
FROM dw.fact_transactions f
INNER JOIN dw.dim_calendar c
        ON c.calendar_key = f.calendar_key
GROUP BY c.year
ORDER BY c.year;

-- ============================================================================
-- VALIDATION 12 - DISTRIBUTION BY MONTH
-- ============================================================================

SELECT
    c.year,
    c.month,
    c.month_name,
    COUNT(*) AS transactions
FROM dw.fact_transactions f
INNER JOIN dw.dim_calendar c
        ON c.calendar_key = f.calendar_key
GROUP BY
    c.year,
    c.month,
    c.month_name
ORDER BY
    c.year,
    c.month;

-- ============================================================================
-- VALIDATION 13 - DISTINCT DAYS USED
-- ============================================================================

SELECT
    COUNT(DISTINCT calendar_key) AS distinct_days_used
FROM dw.fact_transactions;