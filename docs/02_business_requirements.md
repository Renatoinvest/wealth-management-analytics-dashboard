# Business Requirements

## Purpose

The purpose of this document is to define the business requirements for the Wealth Management Analytics Dashboard.

It describes the expected functionalities, business rules, stakeholders, analytical needs, and system requirements that will guide the design, development, and implementation of the project.

The document serves as the primary reference for database modeling, synthetic data generation, ETL processes, SQL analytics, and Power BI dashboard development.

---

## Stakeholders

The solution is intended to support multiple business areas.

**Stakeholder**	                          **Main Responsibilities**
Investment Specialist	              Manage customer portfolios and investment allocation
Regional Manager	                  Monitor regional performance and business targets
Executive Board	                      Track strategic KPIs and organizational performance
Business Intelligence Team	          Analyze trends and generate business insights
Financial Analysts	                  Perform operational and financial analysis

---

## Functional Requirements

The system shall provide the following capabilities.

### Customer Analytics

- Register customer information
- Store demographic information
- Track customer status
- Identify customer risk profile
- Calculate portfolio value

---

### Investment Analytics

- Store investment products
- Categorize products
- Monitor investment allocation
- Calculate product profitability
- Calculate Assets Under Management

---

### Transaction Analytics

- Register all financial transactions
- Track transaction channels
- Calculate monthly financial volume
- Calculate transaction frequency
- Monitor customer activity

---

### Portfolio Analytics

- Calculate portfolio diversification
- Measure portfolio performance
- Calculate customer profitability
- Identify concentration risk

---

### Executive Analytics

- Display business KPIs
- Monitor portfolio growth
- Monitor customer acquisition
- Monitor investment distribution
- Generate executive reports

---

### Non-Functional Requirements

**Requirement**	                **Description**
Performance	                  Dashboard should load in less than 5 seconds
Scalability	                  Database should support over 1 million transactions
Availability	              Dashboard available during business hours
Security	                  No personally identifiable information (synthetic data only)
Maintainability	              Modular Python scripts
Version Control	              Git & GitHub

---

## Business Rules

The following business rules apply.

### Customers

- Every customer must have at least one account.
- Every customer has only one risk profile.
- Customers may own multiple investment products.

---

### Accounts

- One account belongs to only one customer.
- One customer may own multiple accounts.

---

### Investments

- Every investment belongs to one product.
- Products belong to one investment category.

---

### Transactions

- Every transaction belongs to one account.
- Transactions may represent:
- Deposit
- Withdrawal
- Buy
- Sell
- Dividend
- Interest

---

### Portfolio

Portfolio Value = Sum of all active investment positions.

---

## Data Requirements

The system should generate synthetic datasets representing:

**Dataset**	              **Estimated Records**
Customers	                50,000
Accounts	                70,000
Products	                120
Portfolios	                250,000
Transactions	            2,000,000

---

## Analytical Requirements

The dashboard must answer questions such as:

### Customer Analytics

- How many active customers exist?
- What is the average portfolio value?
- Which region has the largest Assets Under Management?
- What is the customer distribution by risk profile?

### Investment Analytics

- Which investment product has the largest AUM?
- Which product generates the highest revenue?
- Which products are growing fastest?

---

### Transaction Analytics

- Monthly transaction volume
- Daily transaction volume
- Transaction distribution by channel
- Top active customers

---

### Executive Analytics

- Customer Growth
- Assets Under Management
- Estimated Revenue
- Portfolio Distribution
- Regional Performance

---

## Dashboard Requirements

The Power BI dashboard shall include:

### Executive Page

- Executive KPIs
- Monthly Growth
- AUM
- Revenue
- Customer Growth

---

### Customer Page

- Customer Segmentation
- Risk Profile
- Geographic Distribution

---

### Portfolio Size

- Investment Page
- Product Performance
- Product Allocation
- Profitability

---

### Transactions Page

- Transaction Volume
- Transaction Trends
- Transaction Channels

---

### Regional Performance

- Performance by State
- Performance by Branch
- Regional Ranking

--- 

## Future Enhancements

Future project versions may include:

- Machine Learning models
- Customer Segmentation (K-Means)
- Churn Prediction
- Product Recommendation Engine
- Portfolio Optimization
- Fraud Detection
- REST API
- Streamlit Web Application
- Docker Deployment
- Cloud Deployment (Azure/AWS)


## Document Information
**Property**                  	**Value**
Document	                  Business Requirements
Version	                      1.0
Status	                      Approved
Last Update	                  July 2026