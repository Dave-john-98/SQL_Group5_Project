# Real Estate Analytics Database Project

## Project Overview
This project involves the design and implementation of a PostgreSQL database to support real estate analytics, enabling advanced insights into employee performance, property transactions, marketing effectiveness, and financial metrics. The project showcases expertise in ETL processes, database schema design, and the creation of complex SQL queries for business intelligence.

**Key objectives include:**
- Designing a scalable database to store and manage high-volume real estate data.
- Automating ETL pipelines to preprocess, clean, and load data into PostgreSQL from various CSV files.
- Developing complex SQL queries for actionable insights and tracking key performance metrics.

---

## Database Schema
The database schema is designed using PostgreSQL and adheres to best practices for relational database management. The **Entity-Relationship Diagram (ERD)** highlights the relationships between key entities, such as:
- **Employees**: Captures performance metrics, department affiliations, and role hierarchies.
- **Transactions**: Tracks property sales, rental details, and associated financial data.
- **Marketing Campaigns**: Logs campaign details and their impact on property sales.
- **Offices**: Stores regional office data for financial and operational reporting.

The schema enables seamless data retrieval, ensuring efficiency and accuracy in query execution.

![ERD Diagram]([link_to_ERD_if_hosted](https://github.com/Dave-john-98/SQL_Group5_Project/blob/main/ERD_FinalSchema.pdf))

---

## ETL Process
The ETL (Extract, Transform, Load) pipeline was developed using Python libraries such as `Pandas` and `SQLAlchemy` to:
1. **Extract** data from CSV files.
2. **Transform** and preprocess the data to ensure consistency.
3. **Load** data into the PostgreSQL database while maintaining relational integrity.

This automated pipeline achieves **99% data accuracy** and supports robust data analytics workflows.

---

## Complex SQL Queries
A key aspect of this project is the development of advanced SQL queries to address various analytical needs. The queries are grouped into use cases for analysts and C-level officers, showcasing the versatility of the database.

### For Analysts:
1. **Employee Performance Analysis**:
   - Identify top-performing employees using `RANK()` and aggregate functions.
   - Detect employees with low ratings over a specified timeframe.
2. **Property Sales Insights**:
   - Calculate the days properties stay on the market before being sold.
   - Automate status updates for sold properties using triggers.

### For C-Level Officers:
1. **Financial Reporting**:
   - Quarterly sales and brokerage fees reports.
   - Comprehensive financial reports detailing revenue, expenses, and net profit by office.
2. **Marketing Campaign Effectiveness**:
   - Evaluate the revenue impact of marketing campaigns using transaction data.

---

## Key Features and Outcomes
- **Tracking and Insights**: The database provides detailed insights into employee performance, transaction trends, and financial health.
- **Automation**: Automated triggers and functions improve data accuracy and reduce manual intervention.
- **Actionable Metrics**: SQL queries enable the generation of actionable metrics for both operational and strategic decision-making.

---

## How to Use
1. **Setup**:
   - Clone the repository and install the required dependencies.
   - Load the CSV files into the database using the provided ETL scripts.
   - Execute the SQL scripts to create tables, triggers, and views.
2. **Run Queries**:
   - Use the provided SQL queries to generate reports and insights.

---

## Future Improvements
- Incorporating additional datasets for deeper market analysis.
- Implementing machine learning models to enhance predictive capabilities.
- Expanding dashboard functionality to integrate real-time data visualizations.

