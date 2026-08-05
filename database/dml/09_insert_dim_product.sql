/*
==========================================================
Wealth Management Analytics Dashboard
On Time Analytics Services

Script: 09_insert_dim_product.sql
Descrição: População da dimensão de produtos financeiros
==========================================================
*/

INSERT INTO dw.dim_product (

    product_id,
    product_name,
    product_category,
    asset_class,
    risk_level,
    liquidity,
    issuer,
    minimum_investment,
    recommended_holding_period,
    is_active

)

VALUES

(
'PRD001',
'Tesouro Selic',
'Government Bond',
'Fixed Income',
'Low',
'Daily',
'Tesouro Nacional',
100.00,
'Short Term',
TRUE
),

(
'PRD002',
'Tesouro Prefixado',
'Government Bond',
'Fixed Income',
'Medium',
'Daily',
'Tesouro Nacional',
100.00,
'Medium Term',
TRUE
),

(
'PRD003',
'Tesouro IPCA+',
'Government Bond',
'Fixed Income',
'Medium',
'Daily',
'Tesouro Nacional',
100.00,
'Long Term',
TRUE
),

(
'PRD004',
'CDB',
'Fixed Income',
'Fixed Income',
'Low',
'Daily',
'Itaú',
1000.00,
'Medium Term',
TRUE
),

(
'PRD005',
'LCI',
'Fixed Income',
'Fixed Income',
'Low',
'At Maturity',
'Itaú',
50000.00,
'Long Term',
TRUE
),

(
'PRD006',
'LCA',
'Fixed Income',
'Fixed Income',
'Low',
'At Maturity',
'Itaú',
50000.00,
'Long Term',
TRUE
),

(
'PRD007',
'CRI',
'Structured Credit',
'Fixed Income',
'Medium',
'Low',
'Petrobrás',
100000.00,
'Long Term',
TRUE
),

(
'PRD008',
'CRA',
'Structured Credit',
'Fixed Income',
'Medium',
'Low',
'Petrobrás S.A.',
100000.00,
'Long Term',
TRUE
),

(
'PRD009',
'Debênture',
'Corporate Bonds',
'Fixed Income',
'High',
'Meddium',
'Vale S.A.',
50000.00,
'Long Term',
TRUE
),

(
'PRD010',
'Fundo Multimercado',
'Investment Fund',
'Investment Fund',
'High',
'Daily',
'XP Investimentos',
50000.00,
'Medium Term',
TRUE
),

(
'PRD011',
'ETF',
'Exchange Traded Fund',
'Variable Income',
'High',
'Daily',
'BlackRock',
500.00,
'Long Term',
TRUE
),

(
'PRD012',
'Ações',
'Equity',
'Variable Income',
'High',
'Daily',
'B3',
500.00,
'Long Term',
TRUE
),

(
'PRD013',
'BDR',
'Internacional Equity',
'Variable Income',
'High',
'Daily',
'B3',
500.00,
'Long Term',
TRUE
),

(
'PRD014',
'Fundo Imobiliário (FII)',
'Real Estate Fund',
'Variable Income',
'High',
'Daily',
'Vinci Partners',
100.00,
'Long Term',
TRUE
),

(
'PRD015',
'Previdência Privada',
'Pension',
'Pension',
'Low',
'Long Term',
'Itaú Vida e Previdência',
1000.00,
'Long Term',
TRUE
);