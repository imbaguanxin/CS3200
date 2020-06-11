use ap;

-- In class exercise
-- Write a script that creates and calls a stored procedure named fedUp. 
-- This procedure should include a set of three SQL statements coded as a transaction
-- to reflect the following changes: 
-- United Parcel Service has been purchased by Federal Express Corporaction 
-- and the new company is named FedUP. Rename one of 
-- the vendors and delete the other after updating the vendor_id column in the Invoices 
-- table.
-- If these statements execute successfully, commit the changes. Otherwise, rollback the changes.

-- Show vendors 122, 123
select * from vendors where vendor_id in (122, 123);

-- Try deleting UPS vendor. Why will this fail?
delete from vendors where vendor_id = 122;

-- Invoices for UPS and FedEx
select * from invoices where vendor_id in (122, 123);

-- How many invoices per vendor
select vendor_id, vendor_name, count(*)
from vendors join invoices using (vendor_id)
where vendor_id in (122, 123)
group by vendor_id, vendor_name;

drop procedure if exists fedUp;

DELIMITER //



CREATE PROCEDURE fedUp()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  -- write statements here!
  
update invoices
  set vendor_id = 123
  where vendor_id = 122;
  
  delete from vendors
  where vendor_id = 122;
  
  update vendors
  set vendor_name = 'FedUP'
  where vendor_id = 123;

  
  
  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;


call fedUp();


use ap;

select vendor_id, vendor_name, count(*)
from vendors join invoices using (vendor_id)
where vendor_id in (122, 123)
group by vendor_id, vendor_name
order by vendor_id;







-- In class exercise
-- Extend the procedure to merge any two named companies



DROP PROCEDURE IF EXISTS corporateMerge;

DELIMITER //

CREATE PROCEDURE corporateMerge
(
	IN targetCompany varchar(50),
    IN parentCompany varchar(50),
    IN newCompany varchar(50)
)
BEGIN
  DECLARE target_id INT;
  DECLARE parent_id INT;
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    

  
  SET target_id =  (SELECT vendor_id FROM vendors WHERE vendor_name = targetCompany);
  SET parent_id = (SELECT vendor_id FROM vendors WHERE vendor_name = parentCompany);

  START TRANSACTION;
  
  UPDATE invoices
  SET vendor_id = parent_id
  WHERE vendor_id = target_id;

  DELETE FROM vendors
  WHERE vendor_id = target_id;

  UPDATE vendors
  SET vendor_name = newCompany
  WHERE vendor_id = parent_id;

  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.', target_id, parent_id;
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.', target_id, parent_id;
  END IF;
END//

DELIMITER ;

CALL corporateMerge('United Parcel Service', 'Federal Express Corporation', 'FedUP');
CALL corporateMerge('FedUP', 'DMV Renewal', 'FedUpWithDMV');


