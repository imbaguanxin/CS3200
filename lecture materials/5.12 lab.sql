-- LAB_Loan_Applications.sql

-- In this lab, we’ll explore GROUP BY / HAVING clauses
-- and using sub-queries.

use bank;


-- Now let's answer some questions.

-- 1. How many records in the table
select count(*)
from loan;

-- 2. What are the distinct marital status codes?
select distinct marital, education
from loan;


-- 3. min, max, avg, and count of balance for single customers
select 
	education, 
	min(balance) as 'min balance',
	max(balance) as 'max balance',
    avg(balance) as 'avg balance',
    count(*) as 'total number'
from loan
where marital='single'
group by education;

-- 4. Average balance for customers who are NOT single or divorced.
-- Apply DeMorgan's Law: not (single or divorced) = not single and not divorced
select avg(balance)
from loan
where marital <> 'single' and marital != 'divorced';


-- or use NOT IN
select avg(balance)
from loan
where marital not in ('single', 'divorced');



-- 5. balance stats by marital status - replicating homework 1 part B.
-- The correct structure is:
-- SELECT <grouping columns>, <aggregation functions>
-- FROM <table(s)>
-- GROUP BY <grouping columns>
select marital, education, avg(balance) as "avg_balance"
from loan
where balance > 1200 and balance < 10000
group by marital, education
having avg_balance > 4000
order by avg(balance);

-- where apply before the aggregation, haveing apply after the aggregation.

-- show variables where variable_names like '%group%'

-- 6. Repeat the query, but include only users with 'tertiary' education.


-- 7. The original status, but this time we want to filter any rows where the final average < 1200.
-- Why can't we use a WHERE clause?


-- 8.
-- balance stats by marital status AND education for accounts with balance>1000
-- only show stats where avg>3500.
-- sort results by avg descending.
-- use a column alias for avg_balance
-- round average to two decimal places


-- 9. Can you think of a case where we could filter on a where or a having and
-- get the same result?  If so, which method is better? Does it make a difference?

select marital, education, avg(balance)
from loan
where marital = 'married'
group by marital, education;
-- having marital = 'married';


-- 10. % loans approved

select approved, count(*) as 'count'
from loan
group by approved;

select 
   (select count(*) 
    from loan 
    where approved='yes') / count(*) * 100
from loan;

select * 
from loan
where balance > (select avg(balance)
				 from loan)
order by balance;

select *
from loan
where job in (
	select distinct job
	from loan
	where balance > 30000)
order by job;

-- as long as the query have only 1 column, we can use it in where clauses

-- main clauses: SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY
-- Connectives: AND, OR, NOT
-- Lists: IN, NOT IN
-- pattern matching: LIKE vs =; like: '%s%' include s, '%s' end with s, 's%' start with s
-- DISTINCT
-- built in functions: ROUND
-- aggregation functions: COUNT(*) vs COUNT(<column>), MIN, MAX, AVG, SUM

-- 11. Create a summary table with columns:
-- marital status, approved (#), not_approved (#)



-- Now wrap these subqueries inside another query so that you can compute % approved for each status




-- But there is a simpler way






-- 12. How many loans were approved or not approved among
-- applicants with a higher-than-average account balance?
-- Hint - Use a subquery.
-- Did our loan acceptance rate go up?