-- CS 3200 / Rachlin
-- LAB_Simple_Queries.sql

-- Use the ap database - set as default
-- ap = accounts payable
use ap;


-- what tables does it contain?
show tables;

-- What's the invoice table about?
describe invoices;

-- display its data
select * from invoices;



-- display invoice_id, vendor_id,  invoice_number, invoice_date, and invoice_total
-- for vendor 123 only sorted by date, most recent first
select invoice_id, vendor_id,  invoice_number, invoice_date, invoice_total
from invoices
where vendor_id = 123
order by invoice_date desc;



-- aggregation functions and column aliases
-- what is the min, max, sum, average invoice_total, and number of invoices
-- for vendor 123?
select 
	sum(invoice_total) as 'invoice_total_123', 
    min(invoice_total) as 'min', 
    max(invoice_total) as 'max',
    round(avg(invoice_total),2) as 'avg',
    count(*) as 'num_invoices',
    count(payment_date) as 'paid_invoices'
from invoices
where vendor_id=123;


-- Functions
-- We can apply a wide variety of functions to column values
-- For example, let's round the average to 2 decimal places



-- Pinning result tabs in the workbench allows you to keep the results of older queries around
-- for reference

-- Creating a view
-- CREATE VIEW <view_name> AS <select query>





-- now display the contents of the view
-- it's treated like a regular table!



