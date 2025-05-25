# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis    
**Database**: `SQL Retail Sales Analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL Retail Sales Analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL Retail Sales Analysis;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select * from retail_sales
limit 10

select * from retail_sales
where age  is null or quantiy  is null or
price_per_unit  is null or  cogs  
is null or total_sale  is null

delete from retail_sales
where age  is null or quantiy  is null or
price_per_unit  is null or  cogs  
is null or total_sale  is null

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **How many unique customers**:
```sql
select count(distinct customer_id) from retail_sales
```

2. **write a query to find the average age of customers who have purchased items from the beauty category**:
```sql
select cast(avg(age) as decimal(10,0)) as avg_age_customers from retail_sales
where category='Beauty'
```

3. **write a query to retrieve all the transactions for sales that made on 2022-11-05.**:
```sql
select * from retail_sales
where sale_date ='2022-11-05'
```

4. **write a query to find the  customers who have purchased items from the clothing categoryand quantity sold is more than 4.**:
```sql
select * from retail_sales
 where category='Clothing' and quantiy>=4 and extract(month from sale_date)='11'
```

5. **write a query to calculate total sales for each category.**:
```sql
select category,sum(total_sale) as Total_sales,count(distinct transactions_id) as total_orders
from retail_sales
group by category
order by Total_Sales desc
```

6. **write a query that retrieve all the  transactions where total sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000
```

7. **write a sql query to find total number transactions made by each gender in eachh category**:
```sql
select category,gender,
count(distinct transactions_id)as number_transactions from retail_sales
group by category,gender
order by 1
```

8. **write a query to calculate avg sale for each month, find out best selling month in each year**:
```sql
with output_as as(
select  extract(year from sale_date) as year_here,extract(month from sale_date) as month_here,
avg(total_sale) as avg_sale,
Row_number() over(partition by  extract(year from sale_date)  order by avg(total_sale)desc) as row_num
  from retail_sales
  group by 1,2
  order by 1,avg_sale desc
)
select year_here,month_here,avg_sale from output_as
where row_num<=1
```

9. **write a query to find top 5 customers based on the highest sale.**:
```sql
select * from retail_sales
select customer_id,sum(total_sale) as Total_sale 
from retail_sales
group by 1
order by 2 desc
limit 5
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
with hourly_sales as(
select 
case
when extract(hour from sale_time)<=12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select shift,count (*) as number_of_orders 
from hourly_sales
group by shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


