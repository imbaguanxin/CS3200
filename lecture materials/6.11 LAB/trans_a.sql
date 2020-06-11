use ap;
-- Transaction A
-- Execute each statement one at a time.

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;
UPDATE invoices SET credit_total = 0 WHERE invoice_id = 6;  -- RESET

START TRANSACTION;
  
UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 6;

-- The SELECT statement in Transaction B won't show the updated data.
-- The UPDATE statement in Transaction B will wait for transaction A to finish.

SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;

COMMIT; -- sucess

-- or 

ROLLBACK; -- failure

-- The SELECT statement in Transaction B will display the updated data.
-- The UPDATE statement in Transaction B will execute immdediately.


SELECT invoice_id, credit_total FROM invoices WHERE invoice_id = 6;


-- DEADLOCKS

use ap;


show variables where variable_name like '%deadlock_detect%' or variable_name like '%innodb_lock_wait%';
set global innodb_deadlock_detect = ON;

-- Also disable connection timeout in preferences...sql editor. 


select vendor_id,  vendor_name, invoice_id, invoice_number, credit_total
from invoices join vendors using (vendor_id)
where vendor_name = 'IBM';


START TRANSACTION;

UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 19;
UPDATE invoices SET credit_total = credit_total + 100 WHERE invoice_id = 52;

COMMIT;
-- or --
ROLLBACK;


-- after transaction
select vendor_id,  vendor_name, invoice_id, invoice_number, credit_total
from invoices join vendors using (vendor_id)
where vendor_name = 'IBM';

-- Reset
update invoices set credit_total =0.0 where vendor_id = 34;


