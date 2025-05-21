--Q1. who is the senior most employee vased on job title?
select * from employee
order by levels desc
limit 1

--Q2. which countries have the most invoices?
select count(*) as invoice_count,billing_country
from invoice
group by billing_country
order by invoice_count desc;

--Q3.what are top 3 values of total invoice?
select total from invoice
order by total desc
limit 3;

--Q4.which city has the best customers? we would like to throw a promotional music festival in the city
--we made the most money. write the query that has the  highest sum of invoice totals  
--Return both the city name & sum of all invoice totals

select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc;

--Q5.who is the best customer? the person who has spent the most money we be declared as the best customer.

select sum(i.total)as ans,i.customer_id,c.first_name,c.last_name
from invoice i
left join customer as c on  c.customer_id=i.customer_id
group by i.customer_id,c.first_name,c.last_name
order by ans desc
limit 1;

--Q6.write a query to return the email,firstname,lastname and genre of all rock music listeners 
--written your list ordered alphabetically by email starting with A.

select distinct (customer.email),customer.first_name,customer.last_name,genre.name
from genre
join track on genre.genre_id=track.genre_id
join invoice_line on track.track_id=invoice_line.track_id
join invoice on invoice_line.invoice_id=invoice.invoice_id
join customer  on invoice.customer_id=customer.customer_id
where genre.name='Rock'
order by email;

--Q7.Lets invite the artist who have written the most rock music in our dataset. write a query that
--returns the artist name and total track count of the top 10 rock bands

select artist.name,count( track.track_id) as band_count
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by  artist.name
order by band_count desc
limit 10;

--Q8.Return all the track names that have the song length longer than the avg song length.return the
--name and milliseconds for each track order by the  song length with the longest songs listed first
select * from track
select * from album
select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) as avglength
                               from track)
order by milliseconds  desc;

--Q9. find how much amount spent by each customer on artists?write a query to return customer name,
--artist name and total spent

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

--Q10.we want to find out the most popular music genre for each country . we determine the most popular genre as
--the genre with the highest amount of purchases ,write a query that returns each country along with the 
--top genre ,for countries where the maximum number of purchases is shared return all genres

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

--Q11.Write a query that determines the customer that has spent the most on music in each country
--write a query that return the country along with the top customer and how much they spent fot the
--countries where the top amount spent is shared,provide all customers who spent this amount

with Top_spent_customer as(
select customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total) as total_spent,
row_number()over(partition by invoice.billing_country order by sum(invoice.total) desc ) as row_num_sum
from customer
join invoice on customer.customer_id=invoice.customer_id
group  by 1,2,3
order by invoice.billing_country,total_spent desc
)
select * from  Top_spent_customer
where row_num_sum<=1




