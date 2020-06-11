use ap;


select * from vendors;
-- Transaction B (open this transaction using a second connection )

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

START TRANSACTION;
  
SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

UPDATE invoices SET credit_total = credit_total + 200 WHERE invoice_id = 6;

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

COMMIT;

-- or

ROLLBACK;

use ap;

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;


show variables where variable_name like '%deadlock%';
show variables where variable_name like '%timeout%';
set global innodb_deadlock_detect = OFF;

-- DEADLOCKS

use ap;


show variables where variable_name like '%deadlock_detect%' or variable_name like '%innodb_lock_wait%';
set global innodb_deadlock_detect = OFF;


select vendor_id,  vendor_name, invoice_id, invoice_number, credit_total
from invoices join vendors using (vendor_id)
where vendor_name = 'IBM';


START TRANSACTION;

UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 52;
UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 19;

COMMIT;
-- or --
ROLLBACK;


-- after transaction
select vendor_id,  vendor_name, invoice_id, invoice_number, credit_total
from invoices join vendors using (vendor_id)
where vendor_name = 'IBM';

-- Reset
update invoices set credit_total =0.0 where vendor_id = 34;

