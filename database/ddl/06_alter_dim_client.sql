/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 06_alter_dim_client.sql
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