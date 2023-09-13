--Q1: Who is the most senior employee based on job title?


select top 1 * from dbo.employee
order by levels desc


--Q2: Which countries have the most invoices?

select count(*) as c, billing_country from invoice
group by billing_country
order by c desc



--Q3: What are top 3 values of total invoices?


--ALTER TABLE invoice
--ALTER COLUMN total NUMERIC(10, 2);

SELECT TOP 3 total FROM invoice ORDER BY total DESC;

--Q4: Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name and sum of all invoice total?

SELECT top 1
    billing_city AS city_name,
    SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC

--Q5: Who is the best customer? The customer who has spent most money will be declared the best customer. Write query that returns the person who has spent most money.

SELECT top 1
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC

--Q6: Write query to return the email, first name, last name, & genre of all rock music listners. Return your list ordered alphabetically by email starting with A.

Select Distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
     select track_id from track
	 join genre on track.genre_id = genre.genre_id
	 where genre.name like 'Rock'
)

order by email;

--Q7: Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands


--ALTER TABLE artist
--ALTER COLUMN name VARCHAR(MAX);



SELECT top 10 artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC;



--Q8: Return all the track names that have a song lenght longer than the average song lenght. Return the Name and Milliseconds for each track. Order by the song lenght with the longest songs listed first.



SELECT name, milliseconds
FROM track
WHERE CAST(milliseconds AS INT) > (
     SELECT AVG(CAST(milliseconds AS INT)) as avg_track_length
     FROM track
)
ORDER BY CAST(milliseconds AS INT) DESC;