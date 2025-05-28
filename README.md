# Music Store Sales Analysis SQL Project

## Project Overview

**Project Title**: Music Store Analysis   
**Database**: `MUsic_Database`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a Music Store sales database**: Create and populate a Music Store sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `MUsic_Database`.
- **Table Creation**: Tables are created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

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

1. **who is the senior most employee based on job title**:
```sql
select * from employee
order by levels desc
limit 1
```

2. **which countries have the most invoices**:
```sql
select count(*) as invoice_count,billing_country
from invoice
group by billing_country
order by invoice_count desc;
```

3. **what are top 3 values of total invoice?**:
```sql
select total from invoice
order by total desc
limit 3;
```

4. **which city has the best customers? we would like to throw a promotional music festival in the citywe made the most money write the query that has the  highest sum of invoice totals  Return both the city name & sum of all invoice totals**:
```sql
select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc;
```

5. **who is the best customer, the person who has spent the most money we be declared as the best customer**:
```sql
select sum(i.total)as ans,i.customer_id,c.first_name,c.last_name
from invoice i
left join customer as c on  c.customer_id=i.customer_id
group by i.customer_id,c.first_name,c.last_name
order by ans desc
limit 1;
```

6. **write a query to return the email,firstname,lastname and genre of all rock music listeners written your list ordered alphabetically by email starting with A.**:
```sql
select distinct (customer.email),customer.first_name,customer.last_name,genre.name
from genre
join track on genre.genre_id=track.genre_id
join invoice_line on track.track_id=invoice_line.track_id
join invoice on invoice_line.invoice_id=invoice.invoice_id
join customer  on invoice.customer_id=customer.customer_id
where genre.name='Rock'
order by email;
```

7. **Lets invite the artist who have written the most rock music in our dataset. write a query that returns the artist name and total track count of the top 10 rock bands**:
```sql
select artist.name,count( track.track_id) as band_count
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by  artist.name
order by band_count desc
limit 10;
```

8. **Return all the track names that have the song length longer than the avg song length.return thename and milliseconds for each track order by the  song length with the longest songs listed first**:
```sql
select * from track
select * from album
select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) as avglength
                               from track)
order by milliseconds  desc;
```

9. **find how much amount spent by each customer on artists?write a query to return customer name,artist name and total spent**:
```sql
with best_selling_artist As(
select artist.artist_id,artist.name,sum(invoice_line.unit_price*invoice_line.quantity) as total_price
from invoice_line 
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by 1
order by 3 desc
limit 1
)
select customer.customer_id,customer.first_name,customer.last_name,best_selling_artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join  best_selling_artist on  best_selling_artist.artist_id=album.artist_id
group by 1,2,3,4
order by amount_spent desc
```

10. **we want to find out the most popular music genre for each country . we determine the most popular genre as
  the genre with the highest amount of purchases ,write a query that returns each country along with the 
  top genre ,for countries where the maximum number of purchases is shared return all genres**:
```sql
with output_as as(
select invoice.billing_country as country,genre.name as genre_name,
count(invoice_line.quantity) as total_purchase_number,
row_number() over(partition by invoice.billing_country order by count(invoice_line.quantity)desc) as row_num
from invoice
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by country,genre_name
order by country, total_purchase_number desc
)
select * from output_as 
where row_num<=1

```

11. **Write a query that determines the customer that has spent the most on music in each country
  write a query that return the country along with the top customer and how much they spent fot the
  countries where the top amount spent is shared,provide all customers who spent this amount**:
```sql
wwith Top_spent_customer as(
select customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total) as total_spent,
row_number()over(partition by invoice.billing_country order by sum(invoice.total) desc ) as row_num_sum
from customer
join invoice on customer.customer_id=invoice.customer_id
group  by 1,2,3
order by invoice.billing_country,total_spent desc
)
select * from  Top_spent_customer
where row_num_sum<=1

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


