/*
==============================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 09_insert_fact_transactions.sql
Descrição: Geração das movimentações financeiras sintéticas
==============================================================
*/

------------------------------------------------------------
-- Limpa a tabela
------------------------------------------------------------

TRUNCATE TABLE dw.fact_transactions
RESTART IDENTITY;

------------------------------------------------------------
-- Produtos permitidos por perfil
------------------------------------------------------------

WITH allowed_products AS (

SELECT 'Conservative' AS investor_profile,'Tesouro Selic' AS product_name
UNION ALL SELECT 'Conservative','Tesouro Prefixado'
UNION ALL SELECT 'Conservative','Tesouro IPCA+'
UNION ALL SELECT 'Conservative','CDB'
UNION ALL SELECT 'Conservative','LCI'
UNION ALL SELECT 'Conservative','LCA'
UNION ALL SELECT 'Conservative','Previdência Privada'

UNION ALL

SELECT 'Moderate','Tesouro Selic'
UNION ALL SELECT 'Moderate','Tesouro Prefixado'
UNION ALL SELECT 'Moderate','Tesouro IPCA+'
UNION ALL SELECT 'Moderate','CDB'
UNION ALL SELECT 'Moderate','LCI'
UNION ALL SELECT 'Moderate','LCA'
UNION ALL SELECT 'Moderate','CRI'
UNION ALL SELECT 'Moderate','CRA'
UNION ALL SELECT 'Moderate','Debênture'
UNION ALL SELECT 'Moderate','Fundo Multimercado'
UNION ALL SELECT 'Moderate','ETF'
UNION ALL SELECT 'Moderate','Previdência Privada'

UNION ALL

SELECT 'Aggressive','Tesouro Selic'
UNION ALL SELECT 'Aggressive','Tesouro Prefixado'
UNION ALL SELECT 'Aggressive','Tesouro IPCA+'
UNION ALL SELECT 'Aggressive','CDB'
UNION ALL SELECT 'Aggressive','LCI'
UNION ALL SELECT 'Aggressive','LCA'
UNION ALL SELECT 'Aggressive','CRI'
UNION ALL SELECT 'Aggressive','CRA'
UNION ALL SELECT 'Aggressive','Debênture'
UNION ALL SELECT 'Aggressive','Fundo Multimercado'
UNION ALL SELECT 'Aggressive','ETF'
UNION ALL SELECT 'Aggressive','Ações'
UNION ALL SELECT 'Aggressive','BDR'
UNION ALL SELECT 'Aggressive','Fundo Imobiliário (FII)'
UNION ALL SELECT 'Aggressive','Previdência Privada'

),

------------------------------------------------------------
-- Quantidade de operações por cliente
------------------------------------------------------------

client_operations AS (

SELECT

    client_key,

    investor_profile,

    CASE

        WHEN investor_profile='Conservative'
            THEN 80

        WHEN investor_profile='Moderate'
            THEN 110

        ELSE 150

    END AS operations

FROM dw.dim_client

),

------------------------------------------------------------
-- Expande uma linha por operação
------------------------------------------------------------

operations AS (

SELECT

    c.client_key,

    c.investor_profile,

    generate_series(1,c.operations) AS operation_number

FROM client_operations c

),

------------------------------------------------------------
-- Escolha aleatória da data
------------------------------------------------------------

random_dates AS (

SELECT

    o.client_key,

    o.investor_profile,

    o.operation_number,

    (

        SELECT calendar_key

        FROM dw.dim_calendar

        WHERE year BETWEEN 2020 AND 2025

        ORDER BY random()

        LIMIT 1

    ) AS calendar_key

FROM operations o

),

------------------------------------------------------------
-- Escolha do produto conforme perfil
------------------------------------------------------------

chosen_products AS (

SELECT

    r.client_key,

    r.calendar_key,

    r.operation_number,

    r.investor_profile,

    (

        SELECT dp.product_key

        FROM allowed_products ap

        JOIN dw.dim_product dp

             ON dp.product_name = ap.product_name

        WHERE ap.investor_profile = r.investor_profile

        ORDER BY random()

        LIMIT 1

    ) AS product_key

FROM random_dates r

),

------------------------------------------------------------
-- Tipo da movimentação
------------------------------------------------------------

transaction_rules AS (

SELECT

    cp.*,

    CASE

        WHEN random() <= 0.60

            THEN 'Investment'

        WHEN random() <= 0.90

            THEN 'Additional Investment'

        ELSE

            'Redemption'

    END AS transaction_type

FROM chosen_products cp

),

------------------------------------------------------------
-- Valor financeiro
------------------------------------------------------------

transaction_values AS (

SELECT

    tr.*,

    CASE

        WHEN investor_profile='Conservative'

            THEN ROUND((500 + random()*24500)::numeric,2)

        WHEN investor_profile='Moderate'

            THEN ROUND((2000 + random()*78000)::numeric,2)

        ELSE

            ROUND((5000 + random()*245000)::numeric,2)

    END AS amount

FROM transaction_rules tr

),

------------------------------------------------------------
-- Quantidade negociada
------------------------------------------------------------

final_transactions AS (

SELECT

    tv.calendar_key,

    tv.client_key,

    tv.product_key,

    tv.transaction_type,

    tv.amount,

    FLOOR(random()*500 + 1)::INTEGER AS quantity

FROM transaction_values tv

)

------------------------------------------------------------
-- Inserção das movimentações
------------------------------------------------------------

INSERT INTO dw.fact_transactions (

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

FROM final_transactions;

------------------------------------------------------------
-- Validações
------------------------------------------------------------

------------------------------------------------------------
-- Quantidade total
------------------------------------------------------------

SELECT COUNT(*) AS total_transactions
FROM dw.fact_transactions;

------------------------------------------------------------
-- Distribuição por tipo
------------------------------------------------------------

SELECT

    transaction_type,
    COUNT(*) AS total

FROM dw.fact_transactions

GROUP BY transaction_type

ORDER BY total DESC;

------------------------------------------------------------
-- Produtos mais negociados
------------------------------------------------------------

SELECT

    p.product_name,

    COUNT(*) AS total

FROM dw.fact_transactions f

JOIN dw.dim_product p

ON p.product_key = f.product_key

GROUP BY p.product_name

ORDER BY total DESC;

------------------------------------------------------------
-- Perfil do investidor
------------------------------------------------------------

SELECT

    c.investor_profile,

    COUNT(*) AS total_operacoes,

    ROUND(SUM(f.amount),2) AS volume_financeiro

FROM dw.fact_transactions f

JOIN dw.dim_client c

ON c.client_key = f.client_key

GROUP BY c.investor_profile

ORDER BY volume_financeiro DESC;

------------------------------------------------------------
-- Volume por segmento
------------------------------------------------------------

SELECT

    c.wealth_segment,

    ROUND(SUM(f.amount),2) AS volume

FROM dw.fact_transactions f

JOIN dw.dim_client c

ON c.client_key=f.client_key

GROUP BY c.wealth_segment

ORDER BY volume DESC;

------------------------------------------------------------
-- Ticket médio
------------------------------------------------------------

SELECT

ROUND(AVG(amount),2) AS ticket_medio

FROM dw.fact_transactions;

------------------------------------------------------------
-- Maior operação
------------------------------------------------------------

SELECT

MAX(amount)

FROM dw.fact_transactions;

------------------------------------------------------------
-- Menor operação
------------------------------------------------------------

SELECT

MIN(amount)

FROM dw.fact_transactions;
