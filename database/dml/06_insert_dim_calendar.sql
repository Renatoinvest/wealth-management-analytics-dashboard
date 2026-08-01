/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 06_insert_dim_calendar.sql
Descrição: População da dimensão calendário
==========================================================
*/

INSERT INTO dw.dim_calendar (

    calendar_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    week_of_year,
    day_of_week,
    day_name,
    is_weekend

)

SELECT

    TO_CHAR(datum,'YYYYMMDD')::INTEGER,

    datum,

    EXTRACT(DAY FROM datum),

    EXTRACT(MONTH FROM datum),

    TO_CHAR(datum,'Month'),

    EXTRACT(QUARTER FROM datum),

    EXTRACT(YEAR FROM datum),

    EXTRACT(WEEK FROM datum),

    EXTRACT(ISODOW FROM datum),

    TO_CHAR(datum,'Day'),

    CASE
        WHEN EXTRACT(ISODOW FROM datum) IN (6,7)
        THEN TRUE
        ELSE FALSE
    END

FROM generate_series(

    DATE '2020-01-01',
    DATE '2035-12-31',
    INTERVAL '1 day'

) AS datum;
