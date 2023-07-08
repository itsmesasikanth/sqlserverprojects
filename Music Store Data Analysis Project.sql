/*
	Author: Sasikanth .D				Date:04-July-2023
	project: Music Store Data Analysis Project
	Discription: In this project I am going to querying some questions that will helpful to know the stats of
				 music store.
*/

use [Music Database]
Go

-- 1. Who is the senior most employee based on job title?

SELECT top 1 *
FROM employee
order by levels desc

---------------------------------------------------------------------------------------

-- 2. Which countries have the most invoices?

Select Top 5 billing_country, COUNT(total) Total_Invoices
from invoice
group by billing_country
order by Total_Invoices desc

---------------------------------------------------------------------------------------

-- 3. What are top 3 values of total invoice?

Select top 3 total, billing_country
from invoice
order by total desc

--------------------------------------------------------------------------------------

-- 4. Which city has the best customers? We could like to throw a promotional music
--    festival in the city we made the most money. write a query that returns one 
--    city that has the highest sum of invoice totals. Return both the city name &
--    & sum of all invoice totals.

select billing_city, sum(total) as Invoice_Totals
from invoice
group by billing_city
order by Invoice_Totals desc

--------------------------------------------------------------------------------------

-- 5. Who is the best customer? The customer who has spent the most money will be 
--    declared the best customer. Write a query that returns the person who has spent
--    the most money.

select Top 1 customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as Money_Spent
from customer
JOIN invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by Money_Spent desc

-------------------------------------------------------------------------------------

-- 6. Write query to return the email, first name, last name & genre of all rock 
--    music listeners. Returns your list ordered alphabetically by email starting 
--    with A.

select distinct email, first_name, last_name
from customer
JOIN invoice on customer.customer_id = invoice.customer_id
JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN (select track_id from track
				   JOIN genre on genre.genre_id = track.genre_id
				   where genre.genre_id = 1) AND email like 'a%'

-------------------------------------------------------------------------------------

-- 7. Let's invite the artists who have written the most rock music in our dataset.
--    Write a query that returns the artist name and total track count of the top
--    10 rock bands.

select Top 10 artist.artist_id, artist.name, count(artist.artist_id) as Total_Tracks 
from track
JOIN album on track.album_id = album.album_id
JOIN artist on album.album_id = artist.artist_id
JOIN genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by artist.artist_id, artist.name
order by Total_Tracks desc

-------------------------------------------------------------------------------------

-- 8. Return all the track names that have a song length longer than the average song 
--    length. Return the name and milliseconds for each track. Order by the song length
--    with the longest songs listed first.

Select name, milliseconds
from track
where milliseconds > ( 
	select AVG(milliseconds) as Avg_song_Length
	from track)
order by milliseconds desc

-------------------------------------------------------------------------------------

-- 9. Find how much amount spent by each customer on artists? Write a query to reutrn
--    customer name, artist name and total spent.

with best_selling_artist as (
		select artist.artist_id, (artist.name) as artist_name, 
		sum(invoice_line.unit_price*invoice_line.quantity) as Total_Sales
		from invoice_line
		JOIN track on track.track_id = invoice_line.track_id
		JOIN album on album.album_id = track.album_id
		JOIN artist on artist.artist_id = album.artist_id
		group by artist.artist_id, artist.name
		--order by Total_Sales desc
)
select c.first_name, c.last_name, bsa.artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as Total_Spent
from customer c
JOIN invoice on invoice.customer_id = c.customer_id
JOIN invoice_line on invoice_line.invoice_id = invoice.invoice_id
JOIN track on track.track_id = invoice_line.track_id
JOIN album on album.album_id = track.album_id
JOIN best_selling_artist bsa on bsa.artist_id = album.artist_id
group by c.first_name, c.last_name, c.last_name, bsa.artist_name
order by Total_Spent desc

-------------------------------------------------------------------------------------

-- 10. We want to find out the most popular music genre for each country.  We 
--     determine the most popular genre as the genre with the highest amount of 
--     purchase. Write a query that returns each country along with the top genre.
--     For countries where the maximum number of purchases is shared return all genres.

with popular_genre as (
		select count(invoice_line.quantity) as Purchases,
		customer.country, genre.genre_id, genre.name,
		ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) desc) as RowNo
		from invoice_line
		JOIN invoice on invoice.invoice_id = invoice_line.invoice_id
		JOIN customer on customer.customer_id = invoice.customer_id
		JOIN track on track.track_id = invoice_line.track_id
		JOIN genre on genre.genre_id = track.genre_id
		group by customer.country, genre.genre_id, genre.name
)
select * from popular_genre where RowNo <= 1

----------------------------------------------------------------------------------

-- 11. Write a query that determines the customer that has spent the most on music
--     for each country. Write a query that returns the country along with they
--     spent. For countries where the top amount spent is shared, provide all
--     customers who spent this amount.

with Customer_with_country as (
		select customer.customer_id,first_name,last_name,billing_country,SUM(total) as Total_Spent,
		ROW_NUMBER() OVER (PARTITION BY billing_country order by SUM(total) desc) as Row_No
		from invoice
		JOIN customer on customer.customer_id = invoice.customer_id
		group by customer.customer_id,first_name,last_name,billing_country
		--order by Total_Spent, Row_No
)
select * from Customer_with_country where Row_No <= 1

----------------------------------------------------------------------------------

-- Thank You!