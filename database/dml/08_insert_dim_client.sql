/*
=====================================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 08_insert_dim_client.sql

Descrição:
População da dimensão de clientes

Objetivo:
Carga completa da dimensão de clientes para ambiente
de Wealth Management utilizando dados sintéticos.

Padrão:
Enterprise SQL
PostgreSQL
Star Schema
Kimball Modeling
=====================================================================
*/

BEGIN;

----------------------------------------------------------
-- Limpeza da dimensão
----------------------------------------------------------

TRUNCATE TABLE dw.dim_client
RESTART IDENTITY CASCADE;

----------------------------------------------------------
-- Carga da dimensão
----------------------------------------------------------

WITH

----------------------------------------------------------
-- Parâmetros
----------------------------------------------------------

params AS (

    SELECT
        5870::INTEGER AS total_clients,
        2000::INTEGER AS level1_clients,
        3600::INTEGER AS level2_clients,
        270::INTEGER  AS private_clients

),

----------------------------------------------------------
-- Nomes masculinos
----------------------------------------------------------

male_names AS (

    SELECT *
    FROM (
        SELECT
            ROW_NUMBER() OVER() AS id,
            name
        FROM (
            VALUES
            ('João'),
            ('José'),
            ('Carlos'),
            ('Paulo'),
            ('Lucas'),
            ('Gabriel'),
            ('Pedro'),
            ('Rafael'),
            ('Fernando'),
            ('Leonardo'),
            ('Rodrigo'),
            ('Thiago'),
            ('Felipe'),
            ('Ricardo'),
            ('Eduardo'),
            ('André'),
            ('Gustavo'),
            ('Bruno'),
            ('Marcelo'),
            ('Daniel'),
            ('Vinicius'),
            ('Renato'),
            ('Alexandre'),
            ('Diego'),
            ('Henrique'),
            ('Roberto'),
            ('Márcio'),
            ('Cláudio'),
            ('Antônio'),
            ('Fábio')
        ) v(name)
    ) x

),

----------------------------------------------------------
-- Nomes femininos
----------------------------------------------------------

female_names AS (

    SELECT *
    FROM (
        SELECT
            ROW_NUMBER() OVER() AS id,
            name
        FROM (
            VALUES
            ('Maria'),
            ('Ana'),
            ('Juliana'),
            ('Fernanda'),
            ('Patrícia'),
            ('Camila'),
            ('Amanda'),
            ('Mariana'),
            ('Gabriela'),
            ('Larissa'),
            ('Bruna'),
            ('Carolina'),
            ('Aline'),
            ('Natália'),
            ('Bianca'),
            ('Beatriz'),
            ('Tatiane'),
            ('Renata'),
            ('Vanessa'),
            ('Alice'),
            ('Helena'),
            ('Isabela'),
            ('Paula'),
            ('Jéssica'),
            ('Cristiane'),
            ('Daniela'),
            ('Priscila'),
            ('Sofia'),
            ('Letícia'),
            ('Luciana')
        ) v(name)
    ) x

),

----------------------------------------------------------
-- Sobrenomes
----------------------------------------------------------

last_names AS (

    SELECT *
    FROM (
        SELECT
            ROW_NUMBER() OVER() AS id,
            name
        FROM (
            VALUES
            ('Silva'),
            ('Souza'),
            ('Oliveira'),
            ('Costa'),
            ('Pereira'),
            ('Rodrigues'),
            ('Almeida'),
            ('Nascimento'),
            ('Lima'),
            ('Fernandes'),
            ('Carvalho'),
            ('Araújo'),
            ('Rocha'),
            ('Barbosa'),
            ('Dias'),
            ('Teixeira'),
            ('Moreira'),
            ('Novaes'),
            ('Mendes'),
            ('Vieira'),
            ('Campos'),
            ('Monteiro'),
            ('Freitas'),
            ('Ribeiro'),
            ('Correia'),
            ('Cardoso'),
            ('Castro'),
            ('Martins'),
            ('Moura'),
            ('Gomes')
        ) v(name)
    ) x

),

----------------------------------------------------------
-- Profissões
----------------------------------------------------------

professions AS (

    SELECT *
    FROM (
        SELECT
            ROW_NUMBER() OVER() AS id,
            profession
        FROM (
            VALUES
            ('Physician'),
            ('Lawyer'),
            ('Engineer'),
            ('Executive'),
            ('Entrepreneur'),
            ('Investment Manager'),
            ('Trader'),
            ('Business Owner'),
            ('Dentist'),
            ('Architect'),
            ('Agribusiness Producer'),
            ('Data Scientist'),
            ('Software Engineer'),
            ('Commercial Director'),
            ('Economist'),
            ('Accountant'),
            ('Judge'),
            ('Public Prosecutor'),
            ('Bank Manager'),
            ('Financial Advisor'),
            ('IT Manager'),
            ('Industrial Executive'),
            ('University Professor'),
            ('Consultant'),
            ('Financial Analyst'),
            ('Marketing Director'),
            ('Sales Director'),
            ('Civil Engineer'),
            ('Auditor'),
            ('Notary')
        ) v(profession)
    ) x

),

----------------------------------------------------------
-- Cidades
----------------------------------------------------------

cities AS (

    SELECT *
    FROM (
        SELECT
            ROW_NUMBER() OVER() AS city_id,
            city,
            state,
            region
        FROM (
            VALUES
            ('São Paulo','SP','Southeast'),
            ('Campinas','SP','Southeast'),
            ('Ribeirão Preto','SP','Southeast'),
            ('São José dos Campos','SP','Southeast'),
            ('Santos','SP','Southeast'),
            ('Rio de Janeiro','RJ','Southeast'),
            ('Niterói','RJ','Southeast'),
            ('Belo Horizonte','MG','Southeast'),
            ('Uberlândia','MG','Southeast'),
            ('Curitiba','PR','South'),
            ('Londrina','PR','South'),
            ('Porto Alegre','RS','South'),
            ('Florianópolis','SC','South'),
            ('Brasília','DF','Midwest'),
            ('Goiânia','GO','Midwest'),
            ('Salvador','BA','Northeast'),
            ('Recife','PE','Northeast'),
            ('Fortaleza','CE','Northeast')
        ) v(city,state,region)
    ) x

),

----------------------------------------------------------
-- Estatísticas
----------------------------------------------------------

city_stats AS (

    SELECT COUNT(*) AS total_cities
    FROM cities

),

----------------------------------------------------------
-- Assessores
----------------------------------------------------------

advisor_pool AS (

    SELECT
        advisor_key,
        advisor_level,
        ROW_NUMBER() OVER (
            PARTITION BY advisor_level
            ORDER BY advisor_key
        ) AS advisor_order
    FROM dw.dim_advisor

),

----------------------------------------------------------
-- Geração da base
----------------------------------------------------------

client_seed AS (

    SELECT

        gs AS seq,

        CASE
            WHEN gs <= 2000 THEN 'Level 1'
            WHEN gs <= 5600 THEN 'Level 2'
            ELSE 'Private'
        END AS wealth_segment,

        random() AS rnd_asset,
        random() AS rnd_profile,
        random() AS rnd_gender,
        random() AS rnd_marital,
        random() AS rnd_education,

        FLOOR(random()*30 + 1)::INTEGER AS first_name_id,
        FLOOR(random()*30 + 1)::INTEGER AS last_name_1_id,
        FLOOR(random()*30 + 1)::INTEGER AS last_name_2_id,
        FLOOR(random()*30 + 1)::INTEGER AS profession_id,

        FLOOR(
            random() *
            (SELECT total_cities FROM city_stats)
        )::INTEGER + 1 AS city_id,

        DATE '1950-01-01'
        + FLOOR(random()*20000)::INTEGER AS birth_date

    FROM generate_series(
        1,
        (SELECT total_clients FROM params)
    ) gs

),

----------------------------------------------------------
-- Segmentação
----------------------------------------------------------

client_base AS (

    SELECT

        cs.*,

        CASE

            WHEN wealth_segment='Level 1' THEN

                CASE
                    WHEN rnd_asset < 0.50 THEN '450k - 1M'
                    ELSE '1M - 1.5M'
                END

            WHEN wealth_segment='Level 2' THEN

                CASE
                    WHEN rnd_asset < 0.35 THEN '2M - 3M'
                    WHEN rnd_asset < 0.75 THEN '3M - 4M'
                    ELSE '4M - 5M'
                END

            ELSE

                CASE
                    WHEN rnd_asset < 0.30 THEN '5M - 8M'
                    WHEN rnd_asset < 0.65 THEN '8M - 12M'
                    WHEN rnd_asset < 0.90 THEN '12M - 15M'
                    ELSE '15M - 20M'
                END

        END AS asset_range,

        CASE
            WHEN rnd_profile < 0.30 THEN 'Conservative'
            WHEN rnd_profile < 0.70 THEN 'Moderate'
            ELSE 'Aggressive'
        END AS investor_profile,

        CASE
            WHEN rnd_gender < 0.50 THEN 'Male'
            ELSE 'Female'
        END AS gender

    FROM client_seed cs

),

----------------------------------------------------------
-- Numeração dentro do segmento
----------------------------------------------------------

ordered_clients AS (

    SELECT

        ROW_NUMBER() OVER (
            PARTITION BY wealth_segment
            ORDER BY seq
        ) AS rn,

        *

    FROM client_base

),

----------------------------------------------------------
-- Distribuição dos assessores
----------------------------------------------------------

distributed_clients AS (

    SELECT

        oc.*,

        CASE

            WHEN wealth_segment = 'Level 1'
            THEN (
                SELECT advisor_key
                FROM advisor_pool
                WHERE advisor_level = 'Level 1'
                  AND advisor_order =
                        FLOOR((oc.rn - 1)::NUMERIC / 500)::INTEGER + 1
            )

            WHEN wealth_segment = 'Level 2'
            THEN (
                SELECT advisor_key
                FROM advisor_pool
                WHERE advisor_level = 'Level 2'
                  AND advisor_order =
                        FLOOR((oc.rn - 1)::NUMERIC / 300)::INTEGER + 1
            )

            ELSE (
                SELECT advisor_key
                FROM advisor_pool
                WHERE advisor_level = 'Private'
                  AND advisor_order =
                        FLOOR((oc.rn - 1)::NUMERIC / 90)::INTEGER + 1
            )

        END AS advisor_key

    FROM ordered_clients oc

),

----------------------------------------------------------
-- Dataset final
----------------------------------------------------------

client_final AS (

    SELECT

        'CLI' || LPAD(dc.seq::TEXT,6,'0') AS client_id,

        CASE
            WHEN dc.gender='Male'
                THEN mn.name
            ELSE fn.name
        END
        || ' ' ||
        ln1.name
        || ' ' ||
        ln2.name AS full_name,

        dc.gender,

        dc.birth_date,

        ct.city,
        ct.state,
        ct.region,

        CASE
            WHEN dc.wealth_segment='Level 1'
                THEN 'High'
            WHEN dc.wealth_segment='Level 2'
                THEN 'Very High'
            ELSE
                'Ultra High'
        END AS income_range,

        CURRENT_TIMESTAMP AS created_at,

        CASE
            WHEN dc.rnd_marital < 0.45 THEN 'Married'
            WHEN dc.rnd_marital < 0.75 THEN 'Single'
            WHEN dc.rnd_marital < 0.90 THEN 'Divorced'
            ELSE 'Widowed'
        END AS marital_status,

        CASE
            WHEN dc.rnd_education < 0.15 THEN 'High School'
            WHEN dc.rnd_education < 0.60 THEN 'Bachelor'
            WHEN dc.rnd_education < 0.85 THEN 'MBA'
            ELSE 'Master'
        END AS education_level,

        pf.profession,

        dc.investor_profile,
        dc.wealth_segment,
        dc.asset_range,
        dc.advisor_key

    FROM distributed_clients dc

    LEFT JOIN male_names mn
        ON mn.id = dc.first_name_id

    LEFT JOIN female_names fn
        ON fn.id = dc.first_name_id

    LEFT JOIN last_names ln1
        ON ln1.id = dc.last_name_1_id

    LEFT JOIN last_names ln2
        ON ln2.id = dc.last_name_2_id

    LEFT JOIN professions pf
        ON pf.id = dc.profession_id

    LEFT JOIN cities ct
        ON ct.city_id = dc.city_id

)

INSERT INTO dw.dim_client (

    client_id,
    full_name,
    gender,
    birth_date,
    city,
    state,
    region,
    income_range,
    created_at,
    marital_status,
    education_level,
    profession,
    investor_profile,
    wealth_segment,
    asset_range,
    advisor_key

)

SELECT

    client_id,
    full_name,
    gender,
    birth_date,
    city,
    state,
    region,
    income_range,
    created_at,
    marital_status,
    education_level,
    profession,
    investor_profile,
    wealth_segment,
    asset_range,
    advisor_key

FROM client_final;

COMMIT;

----------------------------------------------------------
-- Validações
----------------------------------------------------------

----------------------------------------------------------
-- Total de clientes
----------------------------------------------------------

SELECT
    COUNT(*) AS total_clientes
FROM dw.dim_client;

----------------------------------------------------------
-- Clientes por segmento
----------------------------------------------------------

SELECT
    wealth_segment,
    COUNT(*) AS clientes
FROM dw.dim_client
GROUP BY wealth_segment
ORDER BY wealth_segment;

----------------------------------------------------------
-- Clientes por assessor
----------------------------------------------------------

SELECT
    a.advisor_id,
    a.advisor_name,
    a.advisor_level,
    COUNT(c.client_key) AS total_clientes
FROM dw.dim_advisor a
LEFT JOIN dw.dim_client c
    ON a.advisor_key = c.advisor_key
GROUP BY
    a.advisor_id,
    a.advisor_name,
    a.advisor_level,
    a.advisor_key
ORDER BY
    a.advisor_key;

----------------------------------------------------------
-- Clientes por cidade
----------------------------------------------------------

SELECT
    city,
    COUNT(*) AS clientes
FROM dw.dim_client
GROUP BY city
ORDER BY clientes DESC;

----------------------------------------------------------
-- Clientes por estado
----------------------------------------------------------

SELECT
    state,
    COUNT(*) AS clientes
FROM dw.dim_client
GROUP BY state
ORDER BY clientes DESC;

----------------------------------------------------------
-- Clientes por perfil
----------------------------------------------------------

SELECT
    investor_profile,
    COUNT(*) AS total
FROM dw.dim_client
GROUP BY investor_profile
ORDER BY total DESC;

----------------------------------------------------------
-- Clientes por escolaridade
----------------------------------------------------------

SELECT
    education_level,
    COUNT(*) AS total
FROM dw.dim_client
GROUP BY education_level
ORDER BY total DESC;

----------------------------------------------------------
-- Clientes por profissão
----------------------------------------------------------

SELECT
    profession,
    COUNT(*) AS total
FROM dw.dim_client
GROUP BY profession
ORDER BY total DESC;

----------------------------------------------------------
-- Clientes por patrimônio
----------------------------------------------------------

SELECT
    wealth_segment,
    asset_range,
    COUNT(*) AS total
FROM dw.dim_client
GROUP BY
    wealth_segment,
    asset_range
ORDER BY
    wealth_segment,
    asset_range;

----------------------------------------------------------
-- Clientes sem assessor
----------------------------------------------------------

SELECT *
FROM dw.dim_client
WHERE advisor_key IS NULL;

----------------------------------------------------------
-- Validação FK
----------------------------------------------------------

SELECT
    COUNT(*) AS fk_invalida
FROM dw.dim_client c
LEFT JOIN dw.dim_advisor a
    ON c.advisor_key = a.advisor_key
WHERE a.advisor_key IS NULL;