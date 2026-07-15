# Database Model

## Document Information

| Property | Value |
|----------|-------|
| Document | Database Model |
| Project | Wealth Management Analytics Dashboard |
| Company | On Time Financial Analytics |
| Repository | wealth-management-analytics-dashboard |
| Version | 1.0.0 |
| Status | Approved |
| Last Update | July 2026 |

---

# Overview

This document describes the logical, dimensional and physical database architecture adopted by the **Wealth Management Analytics Dashboard**.

The solution follows a modern **Data Warehouse (Star Schema)** architecture designed for analytical workloads, Business Intelligence, executive reporting and future Machine Learning applications.

The database has been designed to simulate the analytical environment of a medium-sized Wealth Management institution, supporting millions of financial transactions while ensuring scalability, maintainability and high query performance.

---

# Solution Architecture

The project follows an end-to-end analytics pipeline.

```text
                           Wealth Management Analytics Platform

 ┌────────────────────────────────────────────────────────────────────────────┐
 │                    Synthetic Data Generation (Python)                      │
 │                                                                            │
 │      Faker • Pandas • NumPy • Random • Business Rules                      │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
 ┌────────────────────────────────────────────────────────────────────────────┐
 │                      Landing Zone (CSV Datasets)                           │
 │                                                                            │
 │ customers.csv                                                              │
 │ products.csv                                                               │
 │ transactions.csv                                                           │
 │ portfolios.csv                                                             │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
 ┌────────────────────────────────────────────────────────────────────────────┐
 │                           ETL Pipeline (Python)                            │
 │                                                                            │
 │ Validation • Cleaning • Transformation • Data Quality                      │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
 ┌────────────────────────────────────────────────────────────────────────────┐
 │                    PostgreSQL Data Warehouse (Star Schema)                 │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
 ┌────────────────────────────────────────────────────────────────────────────┐
 │                          SQL Analytics Layer                               │
 │                                                                            │
 │ Views • KPIs • Aggregations • Business Metrics                             │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
 ┌────────────────────────────────────────────────────────────────────────────┐
 │                           Power BI Semantic Model                          │
 └────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
                         Executive Decision Support
```

---

# Data Warehouse Architecture

The Data Warehouse follows a **Star Schema** composed of **Dimension Tables** and **Fact Tables**.

## Dimension Tables

| Table | Description |
|---------|-------------|
| dim_customer | Customer master data |
| dim_product | Investment products |
| dim_branch | Branch information |
| dim_region | Geographic regions |
| dim_calendar | Calendar dimension |
| dim_channel | Transaction channels |
| dim_risk_profile | Customer investment profile |
| dim_advisor | Investment specialists |

---

## Fact Tables

| Table | Description |
|---------|-------------|
| fact_transactions | Financial transactions |
| fact_portfolio_positions | Daily portfolio positions |
| fact_daily_balances | Daily customer balances |
| fact_revenue | Revenue generated |
| fact_customer_growth | Customer evolution |

---

# Star Schema

```text

                                   dim_calendar
                                          │
                                          │
                                          ▼

          dim_customer ───────────────────────────────┐
                                                      │
          dim_product ────────────────────────────┐   │
                                                  │   │
          dim_branch ─────────────────────────┐   │   │
                                              │   │   │
          dim_region ─────────────────────┐   │   │   │
                                          │   │   │   │
          dim_channel ────────────────┐   │   │   │   │
                                      │   │   │   │   │
          dim_advisor ─────────────┐  │   │   │   │   │
                                   │  │   │   │   │   │
          dim_risk_profile ─────┐  │  │   │   │   │   │
                                ▼  ▼  ▼   ▼   ▼   ▼   ▼

                         fact_transactions
                                 │
                                 ▼
                    fact_portfolio_positions
                                 │
                                 ▼
                      fact_daily_balances
                                 │
                                 ▼
                          fact_revenue
                                 │
                                 ▼
                     fact_customer_growth

```

---

# Entity Relationships

```text

dim_customer
      │
      ├──────────────┐
      │              │
      ▼              ▼
fact_transactions   fact_portfolio_positions
      │              │
      │              ▼
      │      fact_daily_balances
      │
      ▼
fact_revenue

dim_product ─────────────────────┘

dim_calendar
      │
      ├───────────────────────────────────────────────────────────┐
      │                                                           │
      ▼                                                           ▼
fact_transactions                                     fact_portfolio_positions
      │                                                           │
      ▼                                                           ▼
fact_daily_balances                                    fact_customer_growth

```

---

# Relationship Matrix

| Parent Table |      Child Table         | Cardinality |
|--------------|--------------------------|-------------|
| dim_customer | fact_transactions        | 1:N |
| dim_customer | fact_portfolio_positions | 1:N |
| dim_customer | fact_daily_balances      | 1:N |
| dim_product  | fact_transactions        | 1:N |
| dim_product  | fact_portfolio_positions | 1:N |
| dim_product  | fact_revenue             | 1:N |
| dim_branch   | fact_transactions        | 1:N |
| dim_advisor  | fact_transactions        | 1:N |
| dim_calendar | All Fact Tables          | 1:N |

---

# Data Warehouse Layers

The ETL process follows the Medallion Architecture.

```text

                 ┌──────────────────────────────┐
                 │        BRONZE LAYER          │
                 │                              │
                 │ Raw CSV Files                │
                 │ Generated by Python          │
                 └──────────────┬───────────────┘
                                │
                                ▼
                 ┌──────────────────────────────┐
                 │        SILVER LAYER          │
                 │                              │
                 │ Data Cleaning                │
                 │ Validation                   │
                 │ Standardization              │
                 │ Business Rules               │
                 └──────────────┬───────────────┘
                                │
                                ▼
                 ┌──────────────────────────────┐
                 │         GOLD LAYER           │
                 │                              │
                 │ Star Schema                  │
                 │ SQL Views                    │
                 │ KPIs                         │
                 │ Power BI                     │
                 └──────────────────────────────┘

```

---

# Primary Keys

| Table | Primary Key |
|---------|-------------|
| dim_customer | customer_key |
| dim_product | product_key |
| dim_branch | branch_key |
| dim_region | region_key |
| dim_calendar | date_key |
| dim_channel | channel_key |
| dim_risk_profile | risk_key |
| dim_advisor | advisor_key |
| fact_transactions | transaction_key |
| fact_portfolio_positions | portfolio_key |
| fact_daily_balances | balance_key |
| fact_revenue | revenue_key |
| fact_customer_growth | growth_key |

---

# Foreign Keys

| Fact Table | Foreign Key | References |
|-------------|-------------|------------|
| fact_transactions | customer_key | dim_customer |
| fact_transactions | product_key | dim_product |
| fact_transactions | advisor_key | dim_advisor |
| fact_transactions | branch_key | dim_branch |
| fact_transactions | channel_key | dim_channel |
| fact_transactions | date_key | dim_calendar |
| fact_portfolio_positions | customer_key | dim_customer |
| fact_portfolio_positions | product_key | dim_product |
| fact_portfolio_positions | advisor_key | dim_advisor |
| fact_portfolio_positions | date_key | dim_calendar |
| fact_daily_balances | customer_key | dim_customer |
| fact_daily_balances | date_key | dim_calendar |
| fact_revenue | product_key | dim_product |
| fact_revenue | advisor_key | dim_advisor |
| fact_revenue | date_key | dim_calendar |
| fact_customer_growth | date_key | dim_calendar |

---

# Estimated Database Size

| Table | Estimated Records |
|---------|-----------------:|
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

# Database Standards

## Naming Convention

| Object | Convention |
|---------|------------|
| Dimension Tables | `dim_<entity>` |
| Fact Tables | `fact_<entity>` |
| Primary Keys | `<entity>_key` |
| Business Keys | `<entity>_id` |
| Views | `vw_<entity>` |
| Stored Procedures | `sp_<entity>` |

---

# Indexing Strategy

Indexes should be created for:

- customer_key
- product_key
- advisor_key
- branch_key
- date_key

Composite indexes:

- customer_key + date_key
- product_key + date_key
- advisor_key + date_key

---

# Data Integrity Rules

- Every transaction must reference a valid customer.
- Every transaction must reference a valid investment product.
- Every advisor must belong to a single branch.
- Every customer must have one investment risk profile.
- Portfolio quantities cannot be negative.
- Revenue values cannot be negative.
- Transaction dates cannot be in the future.

---

# Scalability Considerations

The architecture was designed to support:

- 50+ million financial transactions
- Historical snapshots
- Incremental ETL
- Slowly Changing Dimensions (future)
- REST APIs
- Machine Learning pipelines
- Near real-time dashboard refresh
- Cloud migration

---

# Future Improvements

The next project versions may include:

- Snowflake Schema
- Slowly Changing Dimensions (SCD Type 2)
- Apache Airflow
- dbt
- Docker
- Kubernetes
- Azure Data Factory
- Apache Spark
- Delta Lake
- Feature Store for Machine Learning

---

# Next Document

**05_architecture.md**

This document will describe the complete technical architecture of the platform, including Python applications, ETL pipelines, PostgreSQL, Power BI, REST APIs, deployment strategy and future cloud infrastructure.
