-- First steps writing SQL
-- LAB_First_Steps_with_SQL_START.sql


-- This is a comment - a line preceded by two dashes
-- Always document your code with comments
-- Here are some very basic introductory queries.
-- They assume you've installed the Murach sample databases (ex, ap, om)

-- Show all the databases
show databases;
-- Make one of the databases the active database
use ex;

-- Show all the tables in the ex database
show tables;

-- Although "ap" isn't the currently active database, I can get a list of its tables like this:
show tables from ap;

-- Describe a particular table
-- This shows the attribute / column / field name, the data type, and other properties
describe customers;

-- Select all the columns from the customers table
select customer_id, customer_last_name, customer_zip
from customers;



-- Some people prefer to put keywords in uppercase but it's not required


-- The query could be all on one line but that's really unreadable and should be avoided
-- especially when the queries get bigger


-- We can select just a handful of columns




-- Maybe we only want to further restrict the report so that it only shows customers in CA
select customer_id, customer_last_name, customer_state, customer_zip
from customers
where customer_state = 'ca';



-- Modifying the query to show customers where the customer_id is less than 10
select customer_id, customer_last_name, customer_state, customer_zip
from customers
where customer_id < 10;


-- Sorting the results!
select customer_id, customer_last_name, customer_state, customer_zip
from customers
where customer_id < 10
order by customer_state;
-- Note: The clause order is important!  It's always:

-- SELECT some columns
-- FROM one or more tables
-- WHERE the records satify these constraints
-- ORDER BY one or more columns (sorting)




-- We will learn more SQL syntax in the weeks to come






