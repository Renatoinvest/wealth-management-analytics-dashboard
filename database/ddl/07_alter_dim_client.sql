/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 07_alter_dim_client.sql
Descrição: Evolução da dimensão de clientes
==========================================================
*/

ALTER TABLE dw.dim_client

ADD COLUMN marital_status VARCHAR(20),

ADD COLUMN education_level VARCHAR(50),

ADD COLUMN profession VARCHAR(80),

ADD COLUMN investor_profile VARCHAR(20),

ADD COLUMN wealth_segment VARCHAR(20),

ADD COLUMN asset_range VARCHAR(30);


ALTER TABLE dw.dim_client

ADD COLUMN advisor_key INTEGER;

ALTER TABLE dw.dim_client

ADD CONSTRAINT fk_client_advisor

FOREIGN KEY (advisor_key)

REFERENCES dw.dim_advisor(advisor_key);