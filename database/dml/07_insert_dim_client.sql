/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 07_insert_dim_client.sql
Descrição: População da dimensão de clientes
==========================================================
*/

WITH

male_names(name) AS (

VALUES
('João'),
('José'),
('Antônio'),
('Carlos'),
('Paulo'),
('Marcos'),
('Roberto'),
('Ricardo'),
('Fernando'),
('Eduardo'),
('Gustavo'),
('Lucas'),
('Rafael'),
('Felipe'),
('Bruno'),
('André'),
('Leonardo'),
('Renato'),
('Rodrigo'),
('Thiago'),
('Daniel'),
('Marcelo'),
('Alexandre'),
('Vinícius'),
('Henrique'),
('Diego'),
('Fábio'),
('Márcio'),
('Sérgio'),
('Cláudio')

),

female_names(name) AS (

VALUES
('Maria'),
('Ana'),
('Juliana'),
('Patrícia'),
('Fernanda'),
('Camila'),
('Aline'),
('Larissa'),
('Mariana'),
('Amanda'),
('Carolina'),
('Bianca'),
('Renata'),
('Beatriz'),
('Gabriela'),
('Vanessa'),
('Tatiane'),
('Priscila'),
('Natália'),
('Cristiane'),
('Isabela'),
('Daniela'),
('Letícia'),
('Jéssica'),
('Bruna'),
('Paula'),
('Luciana'),
('Helena'),
('Alice'),
('Sofia')

),

last_names(name) AS (

VALUES
('Silva'),
('Souza'),
('Oliveira'),
('Pereira'),
('Costa'),
('Rodrigues'),
('Almeida'),
('Nascimento'),
('Lima'),
('Araújo'),
('Fernandes'),
('Carvalho'),
('Gomes'),
('Martins'),
('Rocha'),
('Barbosa'),
('Dias'),
('Teixeira'),
('Moreira'),
('Correia'),
('Novaes'),
('Mendes'),
('Ribeiro'),
('Freitas'),
('Monteiro'),
('Campos'),
('Castro'),
('Cardoso'),
('Vieira'),
('Moura')

),

professions(profession) AS (

VALUES
('Physician'),
('Lawyer'),
('Engineer'),
('Business Owner'),
('Financial Advisor'),
('Executive'),
('Dentist'),
('Software Engineer'),
('Data Scientist'),
('University Professor'),
('Architect'),
('Civil Engineer'),
('Agribusiness Producer'),
('Commercial Director'),
('Accountant'),
('Investment Manager'),
('Trader'),
('Bank Manager'),
('Sales Director'),
('Consultant'),
('Marketing Director'),
('Judge'),
('Public Prosecutor'),
('Notary'),
('Entrepreneur'),
('Industrial Executive'),
('Economist'),
('Auditor'),
('IT Manager'),
('Financial Analyst')

),

cities(city,state,region) AS (

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

),

clientes AS (

SELECT

    gs AS seq,

    CASE
        WHEN gs <= 2000 THEN 'Level 1'
        WHEN gs <= 5600 THEN 'Level 2'
        ELSE 'Private'
    END AS wealth_segment,

    CASE
        WHEN gs <= 2000 THEN
            CASE
                WHEN random() < 0.50 THEN '450k - 1M'
                ELSE '1M - 1.5M'
            END

        WHEN gs <= 5600 THEN
            CASE
                WHEN random() < 0.40 THEN '1.5M - 2.5M'
                WHEN random() < 0.75 THEN '2.5M - 3.5M'
                ELSE '3.5M - 5M'
            END

        ELSE
            CASE
                WHEN random() < 0.35 THEN '5M - 8M'
                WHEN random() < 0.70 THEN '8M - 12M'
                WHEN random() < 0.90 THEN '12M - 15M'
                ELSE '15M - 20M'
            END

    END AS asset_range,

    CASE

        WHEN random() < 0.33 THEN 'Conservative'
        WHEN random() < 0.66 THEN 'Moderate'
        ELSE 'Aggressive'

    END AS investor_profile,

    CASE

        WHEN random() < 0.45 THEN 'Married'
        WHEN random() < 0.75 THEN 'Single'
        WHEN random() < 0.90 THEN 'Divorced'
        ELSE 'Widowed'

    END AS marital_status,

    CASE

        WHEN random() < 0.15 THEN 'High School'
        WHEN random() < 0.60 THEN 'Bachelor'
        WHEN random() < 0.85 THEN 'MBA'
        ELSE 'Master'

    END AS education_level,

    CASE

        WHEN random() < 0.55 THEN 'Male'
        ELSE 'Female'

    END AS gender,

    DATE '1950-01-01'
        + FLOOR(random()*20000)::INTEGER
        AS birth_date

FROM generate_series(1,5870) gs

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
    marital_status,
    education_level,
    profession,
    investor_profile,
    wealth_segment,
    asset_range

)

SELECT

    'CLI' || LPAD(seq::TEXT,6,'0') AS client_id,

    CASE

        WHEN gender = 'Male' THEN

            (
                SELECT name
                FROM male_names
                ORDER BY random()
                LIMIT 1
            )

        ELSE

            (
                SELECT name
                FROM female_names
                ORDER BY random()
                LIMIT 1
            )

    END

    ||

    ' '

    ||

    (
        SELECT name
        FROM last_names
        ORDER BY random()
        LIMIT 1
    )

    ||

    ' '

    ||

    (
        SELECT name
        FROM last_names
        ORDER BY random()
        LIMIT 1
    )

    AS full_name,

    gender,

    birth_date,

    cidade.city,

    cidade.state,

    cidade.region,

    CASE

        WHEN wealth_segment='Level 1' THEN 'High'

        WHEN wealth_segment='Level 2' THEN 'Very High'

        ELSE 'Ultra High'

    END AS income_range,

    marital_status,

    education_level,

    (

        SELECT profession

        FROM professions

        ORDER BY random()

        LIMIT 1

    ) AS profession,

    investor_profile,

    wealth_segment,

    asset_range

FROM clientes

JOIN (

    SELECT
        ROW_NUMBER() OVER () AS city_id,
        city,
        state,
        region
    FROM cities

) cidade

ON cidade.city_id =
    FLOOR(random()*8 + 1)::INTEGER

ORDER BY seq;

