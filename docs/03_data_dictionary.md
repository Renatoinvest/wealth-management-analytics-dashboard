# Data Dictionary

## Document Information

| Property    | Value |
|-------------|-------|
| Document    | Data Dictionary |
| Project     | Wealth Management Analytics Dashboard |
| Company     | On Time Financial Analytics |
| Version     | 1.0.0 |
| Status      | Approved |
| Last Update | July 2026 |

---

# Overview

This document describes all entities, attributes, relationships, and business definitions used in the Wealth Management Analytics Dashboard.

The project adopts a **Dimensional Data Warehouse (Star Schema)** architecture designed for Business Intelligence, Analytics and executive reporting.

The data model is composed of:

- Dimension Tables
- Fact Tables

This approach improves query performance, simplifies analytical modeling, and aligns the project with modern Data Warehouse best practices.

---

# Data Warehouse Architecture

```
                    DIMENSIONS

dim_customer
dim_product
dim_branch
dim_region
dim_calendar
dim_channel
dim_risk_profile
dim_advisor

             ↓

             FACT TABLES

fact_transactions
fact_portfolio_positions
fact_daily_balances
fact_revenue
fact_customer_growth
```

---

# Dimension Tables

---

# dim_customer

## Description

Stores customer demographic and profile information.

### Estimated Records

50,000

### Primary Key

customer_key

| Column | Data Type | Description |
|----------|-----------|-------------|
| customer_key | SERIAL | Surrogate Key |
| customer_id | VARCHAR(20) | Business Customer ID |
| first_name | VARCHAR(50) | First Name |
| last_name | VARCHAR(50) | Last Name |
| gender | VARCHAR(20) | Gender |
| birth_date | DATE | Birth Date |
| age | INTEGER | Customer Age |
| cpf | VARCHAR(14) | Synthetic CPF |
| city | VARCHAR(80) | City |
| state | CHAR(2) | State |
| region | VARCHAR(30) | Geographic Region |
| customer_since | DATE | Relationship Start Date |
| customer_status | VARCHAR(20) | Active / Inactive |

---

# dim_product

## Description

Investment products available to customers.

### Estimated Records

120

### Primary Key

product_key

| Column | Data Type | Description |
|----------|-----------|-------------|
| product_key | SERIAL | Surrogate Key |
| product_id | VARCHAR(20) | Business Product ID |
| product_name | VARCHAR(100) | Product Name |
| category | VARCHAR(50) | Fixed Income, Equity, Fund... |
| issuer | VARCHAR(80) | Issuer |
| liquidity | VARCHAR(30) | Daily, Monthly |
| risk_level | VARCHAR(20) | Low, Medium, High |
| management_fee | NUMERIC(5,2) | Annual Fee |
| benchmark | VARCHAR(30) | CDI, IPCA, Ibovespa |

---

# dim_branch

## Description

Stores branch information.

### Estimated Records

120

### Primary Key

branch_key

| Column | Data Type | Description |
|----------|-----------|-------------|
| branch_key | SERIAL | Surrogate Key |
| branch_code | VARCHAR(10) | Branch Code |
| branch_name | VARCHAR(80) | Branch Name |
| city | VARCHAR(60) | City |
| state | CHAR(2) | State |
| region | VARCHAR(20) | Region |

---

# dim_region

## Description

Brazilian geographic regions.

### Estimated Records

5

| Column | Data Type | Description |
|----------|-----------|-------------|
| region_key | SERIAL | Surrogate Key |
| region_name | VARCHAR(30) | Region |

---

# dim_calendar

## Description

Calendar dimension.

### Estimated Records

3,650

| Column | Data Type | Description |
|----------|-----------|-------------|
| date_key | INTEGER | YYYYMMDD |
| date | DATE | Calendar Date |
| day | INTEGER | Day |
| month | INTEGER | Month |
| month_name | VARCHAR(20) | Month Name |
| quarter | INTEGER | Quarter |
| year | INTEGER | Year |
| weekday | VARCHAR(20) | Weekday |
| weekend | BOOLEAN | Weekend Flag |

---

# dim_channel

## Description

Transaction channels.

### Estimated Records

6

| Channel |
|---------|
| Mobile App |
| Internet Banking |
| Branch |
| Investment Advisor |
| ATM |
| API |

---

# dim_risk_profile

## Description

Customer investment profile.

### Estimated Records

3

| Column | Description |
|----------|-------------|
| risk_key | Surrogate Key |
| profile | Conservative |
| profile | Moderate |
| profile | Aggressive |

---

# dim_advisor

## Description

Investment Specialists.

### Estimated Records

300

| Column | Description |
|----------|-------------|
| advisor_key | Surrogate Key |
| advisor_name | Advisor Name |
| certification | CPA / CEA / CFP |
| branch_key | Branch |

---

# Fact Tables

---

# fact_transactions

## Description

Stores every financial transaction.

### Estimated Records

2,000,000

### Grain

One transaction.

| Column | Data Type |
|----------|-----------|
| transaction_key | BIGSERIAL |
| customer_key | INTEGER |
| product_key | INTEGER |
| advisor_key | INTEGER |
| branch_key | INTEGER |
| channel_key | INTEGER |
| date_key | INTEGER |
| transaction_type | VARCHAR(30) |
| amount | NUMERIC(18,2) |
| fee | NUMERIC(18,2) |
| status | VARCHAR(20) |

---

# fact_portfolio_positions

## Description

Daily snapshot of customer portfolios.

### Estimated Records

250,000

### Grain

Customer × Product × Day

| Column | Data Type |
|----------|-----------|
| portfolio_key | BIGSERIAL |
| customer_key | INTEGER |
| product_key | INTEGER |
| advisor_key | INTEGER |
| date_key | INTEGER |
| quantity | NUMERIC(18,4) |
| average_price | NUMERIC(18,4) |
| current_price | NUMERIC(18,4) |
| invested_amount | NUMERIC(18,2) |
| current_value | NUMERIC(18,2) |
| return_percentage | NUMERIC(8,4) |

---

# fact_daily_balances

## Description

Daily customer balances.

### Estimated Records

18,000,000+

### Grain

Customer × Day

| Column | Data Type |
|----------|-----------|
| balance_key | BIGSERIAL |
| customer_key | INTEGER |
| date_key | INTEGER |
| opening_balance | NUMERIC(18,2) |
| closing_balance | NUMERIC(18,2) |

---

# fact_revenue

## Description

Daily revenue generated by investments.

### Estimated Records

500,000

### Grain

Product × Day

| Column | Data Type |
|----------|-----------|
| revenue_key | BIGSERIAL |
| product_key | INTEGER |
| advisor_key | INTEGER |
| date_key | INTEGER |
| management_fee | NUMERIC(18,2) |
| brokerage_fee | NUMERIC(18,2) |
| total_revenue | NUMERIC(18,2) |

---

# fact_customer_growth

## Description

Historical customer metrics.

### Grain

Month

| Column | Data Type |
|----------|-----------|
| growth_key | BIGSERIAL |
| date_key | INTEGER |
| new_customers | INTEGER |
| inactive_customers | INTEGER |
| active_customers | INTEGER |

---

# Relationships

| Parent | Child | Relationship |
|----------|--------|--------------|
| dim_customer | fact_transactions | 1:N |
| dim_customer | fact_portfolio_positions | 1:N |
| dim_customer | fact_daily_balances | 1:N |
| dim_product | fact_transactions | 1:N |
| dim_product | fact_portfolio_positions | 1:N |
| dim_product | fact_revenue | 1:N |
| dim_branch | fact_transactions | 1:N |
| dim_advisor | fact_transactions | 1:N |
| dim_calendar | All Fact Tables | 1:N |

---

# Estimated Data Volume

| Table | Records |
|----------|------------:|
| dim_customer | 50,000 |
| dim_product | 120 |
| dim_branch | 120 |
| dim_region | 5 |
| dim_calendar | 3,650 |
| dim_channel | 6 |
| dim_risk_profile | 3 |
| dim_advisor | 300 |
| fact_transactions | 2,000,000 |
| fact_portfolio_positions | 250,000 |
| fact_daily_balances | 18,000,000 |
| fact_revenue | 500,000 |
| fact_customer_growth | 120 |

---

# Data Quality Rules

The synthetic datasets must satisfy the following constraints:

- Customer IDs must be unique.
- Product IDs must be unique.
- Every transaction must reference valid dimension keys.
- Negative balances are not allowed.
- Transaction dates cannot be in the future.
- Portfolio values must be consistent with asset prices.
- Every customer must have exactly one investment risk profile.
- All monetary values must be stored using NUMERIC(18,2).

---

# Naming Conventions

| Prefix | Example |
|----------|----------|
| dim_ | dim_customer |
| fact_ | fact_transactions |
| *_key | customer_key |
| *_id | customer_id |
| pct_ | pct_return |
| amt_ | amt_invested |
| dt_ | dt_transaction |

---

# Future Tables

Future versions may include:

- dim_currency
- dim_economic_indicator
- dim_market_index
- fact_market_prices
- fact_fraud_detection
- fact_credit_score
- fact_customer_segmentation
- fact_product_recommendation

---

# Next Document

04_database_model.md

This document will present the complete Entity-Relationship Diagram (ERD), Star Schema model, primary keys, foreign keys, and database normalization strategy.