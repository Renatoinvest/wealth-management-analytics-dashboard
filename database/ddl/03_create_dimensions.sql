/*
====================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script 03
Create Dimension Tables
====================================================
*/

CREATE TABLE dw.dim_calendar (

    calendar_key INTEGER PRIMARY KEY,

    full_date DATE NOT NULL,

    day SMALLINT NOT NULL,

    month SMALLINT NOT NULL,

    month_name VARCHAR(20) NOT NULL,

    quarter SMALLINT NOT NULL,

    year SMALLINT NOT NULL,

    week SMALLINT NOT NULL,

    day_of_week SMALLINT NOT NULL,

    day_name VARCHAR(20) NOT NULL,

    is_weekend BOOLEAN NOT NULL

);