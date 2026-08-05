/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 07_insert_dim_advisor.sql
Descrição: População da dimensão advisor
==========================================================
*/


TRUNCATE TABLE dw.dim_advisor
RESTART IDENTITY;

INSERT INTO dw.dim_advisor (

advisor_id,
advisor_name,
advisor_level,
certification,
max_clients,
min_assets,
max_assets

)

VALUES

('ADV001','Renato Martins','Level 1','C-Pro R | C-Pro I',500,450000,1500000),
('ADV002','Carlos Oliveira','Level 1','C-Pro R | C-Pro I',500,450000,1500000),
('ADV003','Marcos Souza','Level 1','C-Pro R | C-Pro I',500,450000,1500000),
('ADV004','Ricardo Lima','Level 1','C-Pro R | C-Pro I',500,450000,1500000),

('ADV005','Fernando Costa','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV006','Paulo Ribeiro','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV007','Lucas Almeida','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV008','Bruno Carvalho','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV009','Daniel Gomes','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV010','Eduardo Castro','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV011','Thiago Rocha','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV012','Felipe Dias','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV013','André Fernandes','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV014','Rodrigo Barbosa','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV015','Leonardo Mendes','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),
('ADV016','Gustavo Freitas','Level 2','C-Pro R | C-Pro I | CFP',300,2000000,5000000),

('ADV017','Marcelo Novaes','Private','C-Pro R | C-Pro I | CFP | CFA',90,5000000,20000000),
('ADV018','Roberto Monteiro','Private','C-Pro R | C-Pro I | CFP | CFA',90,5000000,20000000),
('ADV019','Henrique Vieira','Private','C-Pro R | C-Pro I | CFP | CFA',90,5000000,20000000);