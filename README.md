# data-analysis-project
End-to-end data analysis project demonstrating SQL, Python, and Power BI skills. Includes relational database queries, exploratory data analysis in Python, and an interactive BI dashboard.

## Project Structure

- **[01_Data](01_Data/)** – Main dataset (CSV) used for SQL, Python, and Power BI analysis  
- **[02_SQL](02_SQL/)** – SQL scripts:
  - **Load script:** [01_LoadSuperstoreFlat.sql](02_SQL/01_LoadSuperstoreFlat.sql) – loads the CSV data into the database
  - **Tables:** [02_Customers.sql](02_SQL/02_Customers.sql), [03_Products.sql](02_SQL/03_Products.sql), [04_Orders.sql](02_SQL/04_Orders.sql), [05_OrderDetails.sql](02_SQL/05_OrderDetails.sql)
  - **Views:** [06_Views.sql](02_SQL/06_Views.sql)
  - **Queries:** [07_Queries.sql](02_SQL/07_Queries.sql)
  - **Procedures:** [08_Procedures.sql](02_SQL/08_Procedures.sql)
- **[03_Python](03_Python/)** – Jupyter notebooks for data analysis and clustering; includes HTML reports  
- **[04_Power_BI](04_Power_BI/)** – Power BI dashboards and screenshots  
- **[05_Reports](05_Reports/)** – Final reports and conclusions  
- **README.md** – This file

## Usage

1. Load the CSV from [01_Data](01_Data/) into your SQL database.  
2. Run SQL scripts from [02_SQL](02_SQL/) to create tables, views, queries, and procedures.  
3. Open Python notebooks in [03_Python](03_Python/) for analysis and clustering. HTML files show the results.  
4. Open Power BI files in [04_Power_BI](04_Power_BI/) to view dashboards.  

## Key Insights

- Sales peak in October; lowest in April  
- APAC region leads in sales; other regions show weaker performance  
- Profit increased steadily from 2011 to 2014  
- Standard Class shipping contributes most to sales and profit  

## Recommendations

- Focus on high-performing markets and shipping classes  
- Optimize low-performing segments (e.g., Same Day shipping)  
- Target marketing based on customer segments identified via clustering  
