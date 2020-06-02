
-- CS3200/CS5200: Indexing Demo: LAB_indexing_START.sql
-- Prof. Rachlin

-- This script demonstrates the concept of indexing

-- First we create a database with two tables, follows and follows_wi.
-- Follows_wi has an index on the follower_id (but not on the followee_id

drop database if exists index_demo;

create database index_demo;

use index_demo;

-- A user table 



-- A simple table of followers with no indexing
create table follows (
	follower_id INT,
    followee_id INT
) ;


-- Partially indexed
-- Just the follower_id is indexed so we can quickly find who a given user is following
create table follows_pi (
	follower_id INT,
    followee_id INT,
    index idx_follows_pi_follower_id (follower_id)
) ;


-- Fully indexed
-- Both the follower AND the followee is indexed
create table follows_fi (
	follower_id INT,
    followee_id INT,
    index idx_follows_fi_follower_id (follower_id),
    index idx_follows_fi_followee_id (followee_id)
) ;

show tables;




-- We need to import an appreciable amount of data to see the impact of indexing
-- Using the table import wizard is too slow for our needs
-- I pre-generated 5 million follower-followee pairs, separated by a tab:
-- The data is in a file called "follows.dat"
-- 4165    4173
-- 3515    1326
-- 4788    365
-- 4760    4079
-- 3836    6568
-- 4752    2301
-- 4472    7084
-- 5738    342


-- LOADING DATA INTO OUR DATABASE


-- STEP 1: Change global security settings to allow data to be imported from a "local" file
-- You'll need to be in a ROOT connection


show variables;

show variables like '%local%';

set global local_infile=ON;

show variables like '%priv%';





-- STEP 2: Load the data
load data local infile '/Users/rachlin/data/index_demo/follows.txt' into table follows;

select * from follows

select count(*) from follows

-- In the MySQL workbench this gives an odd error: 
-- Error Code: 3948. Loading local data is disabled; this must be enabled on both the client and server sides

-- Workaround #1. Run the command from the mysql command-line client
--     $MYSQL_HOME/bin should be in your path (or you can cd to the installation directory)
--     $ mysql -u <user> -p -D <database> --local-infile
--     $ mysql -u root -p -D index_demo --local-infile
--     mysql>

-- Workaround #2. Run the command from a different client, 
-- such as dbeaver (https://dbeaver.io/) or DataGrip (https://www.jetbrains.com/datagrip/)

-- Workaround #3. Use the mysqlimport command-line utility
-- The file has to be the same name as the table you are importing into
--      $ mysqlimport --local -u <user> -p <database> <table>
--      $ mysqlimport --local -u root -p index_demo follows.txt




-- STEP 3: Repeat the command for the follows_pi table
-- Why did it take longer to load?
load data local infile '/Users/rachlin/data/index_demo/follows.txt' into table follows_pi;


-- STEP 4: Attempting to load data into follows_fi table will take > 3 minutes
-- We can temporarily drop the indices, load the data, and then re-enable
-- This is sometimes much faster.

-- For MyISAM tables do this:
ALTER TABLE follows_fi disable keys;

-- For InnoDB tables this is supposed to work but doesn't:
SET AUTOCOMMIT = 0; 
SET FOREIGN_KEY_CHECKS = 0; 
SET UNIQUE_CHECKS = 0;

-- This definitely works: drops the indexes!
ALTER TABLE follows_fi
DROP INDEX idx_follows_fi_follower_id,
DROP INDEX idx_follows_fi_followee_id;

truncate follows_fi

load data local infile '/Users/rachlin/data/index_demo/follows.txt' into table follows_fi;

-- Now add back in the indexes on the fully populated tables
ALTER TABLE follows_fi
ADD INDEX idx_follows_fi_follower_id (follower_id),
ADD INDEX idx_follows_fi_followee_id (followee_id);



-- How does indexing affect search for a particular value?

select *
from follows 
where follower_id = 7777;

select *
from follows_pi 
where follower_id = 7777;

select *
from follows_pi 
where followee_id = 7777;


-- What if we search for multiple values using a BETWEEN clause?

select *
from follows_pi 
where follower_id between 6000 and 7000

select *
from follows_pi 
where followee_id between 5000 and 5500



-- What if we search for multiple values using an IN clause?

select *
from follows
where followee_id in (1000,2222,6666,9999,2221)


-- Aggregation query - does indexing help?
-- Count number of followees for each follower
-- Count number of followers for each followee

select follower_id, count(*)
from follows_pi 
group by follower_id

select followee_id, count(*)
from follows_pi 
group by followee_id


-- Finding users who follow each other
-- HINT: We need a self-join!


-- This query might timeout in the workbench
-- But for testing purposes, we might want to pair down our data
-- Let's create a view with only 100,000 records first
create view follows100k as
select *
from follows_pi
limit 100000


select count(*) from follows100k


select a.*
from follows100k a join follows100k b
   on (a.follower_id = b.followee_id and a.followee_id = b.follower_id)
 where a.follower_id < a.followee_id






select a.follower_id, a.followee_id, b.follower_id, b.followee_id 
from follows100k a join follows100k b 
	on (a.follower_id = b.followee_id and a.followee_id = b.follower_id and a.follower_id < b.follower_id)
order by a.follower_id;


-- full data set (follows) takes about 11 seconds - weird
select a.follower_id, a.followee_id, b.follower_id, b.followee_id 
from follows a join follows b 
	on (a.follower_id = b.followee_id and a.followee_id = b.follower_id and a.follower_id < b.follower_id)
order by a.follower_id;


-- full data set (follows_pi) takes about 35 seconds
select a.follower_id, a.followee_id, b.follower_id, b.followee_id 
from follows_pi a join follows_pi b 
	on (a.follower_id = b.followee_id and a.followee_id = b.follower_id and a.follower_id < b.follower_id)
order by a.follower_id;


