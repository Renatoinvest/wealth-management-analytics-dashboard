# Application Architecture

> **Project:** Wealth Management Analytics Dashboard  
> **Organization:** On Time Analytics Services  
> **Document:** Application Architecture  
> **Version:** 1.0  
> **Status:** In Development

---

# Overview

This document describes the logical architecture of the Wealth Management Analytics Dashboard application.

The project is organized using a modular architecture, where each component has a well-defined responsibility. This approach improves maintainability, scalability and code reusability while simplifying future enhancements.

The solution follows the principle of **Separation of Concerns (SoC)**, ensuring that each module performs a single responsibility.

---

# Architecture Overview

```text
                     User
                      │
                      ▼
            Power BI Dashboard
                      │
                      ▼
              PostgreSQL Database
                      ▲
                      │
               ETL Pipeline (Python)
                      ▲
                      │
          Synthetic Data Generator
```

---

# Application Layers

The solution is divided into independent layers.

| Layer           | Responsibility                   |
| --------------- | -------------------------------- |
| Data Generation | Create synthetic datasets        |
| ETL             | Extract, transform and load data |
| Database        | Store analytical data            |
| Analytics       | SQL queries and business rules   |
| Visualization   | Executive dashboards             |
| Documentation   | Project documentation            |

---

# Project Structure

```text
wealth-management-analytics-dashboard/

architecture/
data/
database/
docs/
images/
logs/
notebooks/
powerbi/
python/
tests/
tools/
```

Each folder has a specific purpose and is maintained independently.

---

# Python Modules

The Python application is organized into specialized modules.

```text
python/

generators/
etl/
analytics/
validation/
utils/
config/
api/
```

## generators/

Responsible for generating synthetic financial datasets used throughout the project.

Examples:

- Customers
- Advisors
- Products
- Transactions
- Portfolio Positions

---

## etl/

Contains all Extract, Transform and Load processes.

Responsibilities:

- Read CSV files
- Validate data
- Apply business rules
- Load PostgreSQL

---

## analytics/

Contains reusable business calculations.

Examples:

- Assets Under Management
- Revenue
- Portfolio Return
- Customer Growth
- Advisor Ranking

---

## validation/

Responsible for validating data quality before loading.

Examples:

- Duplicate detection
- Missing values
- Invalid dates
- Invalid foreign keys

---

## utils/

Utility functions shared across the project.

Examples:

- Logging
- Date formatting
- File management
- Helper functions

---

## config/

Stores centralized configuration files.

Examples:

- Database configuration
- File paths
- Environment variables
- Global constants

---

## api/

Reserved for future REST API implementation.

Current version:

Not implemented.

---

# Database Layer

The application uses PostgreSQL as its analytical database.

The database stores:

- Dimension Tables
- Fact Tables
- SQL Views
- Business Aggregations

The schema follows dimensional modeling principles optimized for analytical workloads.

---

# Power BI Layer

Power BI connects directly to PostgreSQL.

Responsibilities include:

- Data Modeling
- KPI Calculation
- DAX Measures
- Executive Dashboards
- Interactive Reports

---

# Logging

The application stores execution logs for ETL processes.

Future versions may include:

- Error logging
- Execution metrics
- Audit logs

---

# Configuration Management

Application settings are centralized to simplify maintenance.

Typical configurations include:

- Database credentials
- File locations
- Execution parameters
- Logging configuration

---

# Development Principles

The project follows the principles below:

- Modular Design
- Single Responsibility Principle
- Reusable Components
- Clean Code
- Documentation First
- Version Control with Git
- Incremental Development

---

# Scalability

The architecture was designed to support future enhancements without major structural changes.

Planned improvements include:

- REST API
- Authentication
- Docker
- Cloud Deployment
- Machine Learning Models
- Real-time Data Pipelines

---

# Current Version Scope

Version 1.0 includes:

- Synthetic Data Generation
- ETL Pipeline
- PostgreSQL Data Warehouse
- Power BI Dashboard
- Technical Documentation

Future versions will expand the platform with advanced analytics and cloud-native components.

---

# Expected Benefits

The proposed architecture provides:

- Clear separation of responsibilities
- Simplified maintenance
- Easy extensibility
- Improved code organization
- Professional documentation
- Enterprise-ready project structure

---

# Next Document

➡ **04_api_architecture.md**

The next document describes the planned REST API architecture that will expose analytical data for future integrations.