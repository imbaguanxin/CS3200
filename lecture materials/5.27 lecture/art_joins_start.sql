-- QUERIES ON ART DATABASE
-- JOINS AND SUB-QUERIES

-- Load the art_joins_START.sql script in a root connection and run it
-- to create the database. This will create a small database about artists and paintings.



-- Make art the active database
use art;
-- Explore the contents of the different tables
select * from artist;
select * from genre;
select * from painting;
select * from rating;
select * from user;

describe painting;

-- A cartesian join
-- What's going on here? - count the # rows in artist, painting and this output
select *
from artist, painting
where artist.artist_id = painting.artist_id;

-- Inner join - add an appropriate constraint
-- What artists are missing?
-- What paintings are missing?
select *
from artist inner join painting on (artist.artist_id = painting.artist_id);




-- Inner join use join
-- Keyword INNER is optional - try it!
select *
from artist join painting on (artist.artist_id = painting.artist_id);
-- Select a few specific columns on the joined result - name and title



-- Let's also add the year that the painting was painted - CAREFUL!
-- What problem do you encounter if you just add "year"
select name, title, painting.year as 'year_painted'
from artist join painting on (artist.artist_id = painting.artist_id);


-- Adding aliases to the tables makes the query clearer
-- from artist a join painting p.....
select name, title, p.year as 'year_painted'
from artist a join painting p on (a.artist_id = p.artist_id);

-- Change the join to a left join
-- What happens
select name, title, p.year as 'year_painted'
from artist a left join painting p on (a.artist_id = p.artist_id);



-- Change the join to a right join
-- What happens?
select name, title, p.year as 'year_painted'
from artist a right join painting p on (a.artist_id = p.artist_id);




-- Outer join = Left + Right
-- MySQL doesn't support outer joins - use a UNION instead.
select name, title, p.year as 'year_painted'
from artist a left join painting p on (a.artist_id = p.artist_id)
union
select name, title, p.year as 'year_painted'
from artist a right join painting p on (a.artist_id = p.artist_id);




-- adding information about genre
-- 4 painters x 3 movements x 8 Paintings = 96 combinations
-- Verify this by doing a cartesian join on all three tables.
select * 
from artist, painting, genre;




-- What two constraints do we need to add?
-- Adding two constraints



-- selecting the columns we want
-- using table aliases
-- Distinguish year of birth and year painted
select *
from artist a, painting p, genre g
where a.artist_id = p.artist_id
and a.genre_id = g.genre_id;



-- Converting to JOIN syntax
select name, a.year as 'year_born', title, genre_name, p.year as 'year_painted'
from artist a inner join painting p on (a.artist_id = p.artist_id)
join genre g on (a.genre_id = g.genre_id);



 -- Using USING instead of ON
 -- When the field name is the same on both sides you can replace
 -- ON (x.field = y.field) with USING (field) - TRY IT!
 -- Otherwise, if the field names are different, then you HAVE to use ON syntax
select name, a.year as 'year_born', title, genre_name, p.year as 'year_painted'
from artist a join painting p using (artist_id)
join genre g using (genre_id);
-- need ()!!!!


 -- USING NATURAL JOIN
 -- Join on all shared columns - you don't need ON or USING!
 -- Join the artist to his or her genre and display the artist name, year of birth, and assigned genre
select *
from artist natural join genre g;



-- But be careful about using a natural join!
-- What happens if you use a nature join on artist and painting? WHY??
select *
from artist natural join painting;
-- join on artist_id and year


-- Rating Statistics  by user
-- Min, max, avg rating for each user




-- Step 1 - Joining user with ratings
select *
from user join rating using (user_id);



-- Step 2 - Add the Group by and aggregation functions
-- Order by average rating descending
select 
	user_id,
	name as 'user_name', 
    min(rating) as 'min', 
    max(rating) as 'max', 
	round(avg(rating),2) as 'avg'
from user join rating using (user_id)
group by user_id, name;

-- average rating of each painting in descending order
select title, avg(rating) as 'avg_rating'
from painting join rating using (painting_id)
group by painting_id, title
order by avg_rating desc;
-- number of ratings AND average rating by artist


-- who likes impressionist paintings the most?
select user.user_id, user.name, avg(rating) 
from rating join user using (user_id)
join painting using (painting_id)
join artist using (artist_id)
join genre using (genre_id)
where genre_name = 'Impressionism'
group by user.user_id, user.name
order by avg(rating) desc
limit 1;

-- For each artist, show name, genre, # paintings, # rating, avg rating
select artist.name, 
       genre_name as 'genre',
       count(distinct painting_id) as 'num_paintings',
       count(rating) as 'num_rating',
       ifnull(round(avg(rating), 2), 'N/A') as 'avg_rating'
from artist left join painting using (artist_id)
left join genre using (genre_id)
left join rating using (painting_id)
group by artist.artist_id, artist.name;

-- How many paintings did each artist paint in the 1870's
select *
from artist a left join painting p on 
	(a.artist_id = p.artist_id and p.year between 1870 and 1879);

select a.artist_id, count(painting_id)
from artist a left join painting p on 
	(a.artist_id = p.artist_id and p.year between 1870 and 1879)
group by a.artist_id;


-- self joins:
select *
from artist a join artist b
where a.name != b.name 
and a.year < b.year
and a.genre_id = b.genre_id;



-- what is the rating distribution?
-- how many paintings were rated 1, 2, 3, ... 10?
-- (This could be interpreted in two different ways!)




-- what is the average rating for each genre?




-- How many paintings did each artist paint in the 1870's
-- Include artists that painted no paintings during that decade
-- Rank from most paintings to least paintings




-- Self joins
-- You can join a table to itself

-- Find pairs of artists who are part of the same genre
-- Exclude (X,X) pairs
-- Always list the older painter first (exclude pairs where the first member is younger)
-- Things to note: it is necessary to add table aliases so we can distinguish which copy of artist we are referencing