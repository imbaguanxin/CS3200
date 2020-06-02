use emr_sp;

-- STORED PROCEDURES



-- The canonical "Hello World" example!
DROP PROCEDURE IF EXISTS helloWorld;

DELIMITER //

CREATE PROCEDURE helloWorld()
BEGIN

 SELECT "Hello World!" as Message;
 
END //

DELIMITER ;

CALL helloWorld(); -- Call the procedure



-- A hello procedure that takes the name 
-- of a person to say hello to.




-- A Patient's Medical History
-- Use input parameter to complete a SQL query
-- The "output" is the result of the query

DROP PROCEDURE IF EXISTS medicalHistory;

DELIMITER //

CREATE PROCEDURE medicalHistory
(
  patientName VARCHAR(50)
)
BEGIN
	select 
		patient_name 'patient name', 
		pcp.doctor_name 'pcp', 
        doc.doctor_name 'diagnosing doctor', 
        disease_name 'diagnosis',
        diagnosis_date 'date'
    from patient pat
		left join diagnosis diag on (pat.patient_id = diag.patient_id) 
		left join disease dis on (diag.disease_id = dis.disease_id) 
        left join doctor doc on (diag.doctor_id = doc.doctor_id)
        join doctor pcp on (pat.pcp_id = pcp.doctor_id)
    where patient_name = patientName
    order by date;
END //   

DELIMITER ;


CALL medicalHistory('johnson');

-- More practice with joins
-- patients of Howser and whether they got their flushot


-- stats on  patients 
-- number of patients, number that got flushot, % that got flushot




-- What % of a doctor's patient's got their flu shot?

DROP PROCEDURE IF EXISTS fluShotPct;

DELIMITER //

CREATE PROCEDURE fluShotPct
(
	docName VARCHAR(50)
)
BEGIN
	DECLARE numPatients INT;
    DECLARE numPatientsHadFluShot INT;
    DECLARE pctFluShot FLOAT;
    
    SELECT COUNT(patient_id), SUM(fluShot)
    INTO numPatients, numPatientsHadFluShot
    FROM patient JOIN doctor ON (patient.pcp_id = doctor.doctor_id)
    WHERE doctor_name = docName;
    
    SET pctFluShot = numPatientsHadFluShot * 100.0 / numPatients;
    

    IF pctFluShot < 50 THEN
		SELECT CONCAT('ALERT!  Patients of Dr. ', docName,' need flu shots!, (',pctFluShot,')') as Alert;
	ELSEIF pctFluShot >= 50 THEN
		SELECT CONCAT('Flu shot targets for Dr. ', docName,' have been met (',pctFluShot,')') as Message;
	ELSE 
		SELECT CONCAT(docName,' has no primary care patients') as Warning;
    END IF;
    
END //

DELIMITER ;


CALL fluShotPct('Quinn');

CALL fluShotPct('Howser');

CALL fluShotPct('House');






-- Recommend a flu shot to any patient that hasn't had one yet.

DROP PROCEDURE IF EXISTS recommendFluShots;
DELIMITER //

CREATE PROCEDURE recommendFluShots()
BEGIN
	
    DECLARE patient_id_var INT;
    DECLARE flushot_var TINYINT;
    DECLARE row_not_found	TINYINT DEFAULT FALSE;
    DECLARE update_count	INT DEFAULT 0;
    DECLARE row_count INT DEFAULT 0;

	DECLARE patient_cursor CURSOR FOR 
		SELECT patient_id, flushot from patient;
       
    -- Uncomment for events   
	DECLARE CONTINUE HANDLER FOR 1062
	   SET update_count = update_count - 1; -- ignore update
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
	OPEN patient_cursor;
    
	FETCH patient_cursor INTO patient_id_var, flushot_var; -- read first row
    WHILE row_not_found = FALSE DO
    
        IF flushot_var = FALSE THEN
			INSERT INTO recommendation
			VALUES (patient_id_var, 'Ask patient if he/she has had a flushot');
            SET update_count = update_count + 1;
		END IF;
        
        SET row_count = row_count + 1;
        FETCH patient_cursor INTO patient_id_var, flushot_var; -- read next row
	END WHILE;
    
    CLOSE patient_cursor;
    
    select CONCAT(row_count, ' patients scanned. ', update_count,' recommendations added') as status;

END //

DELIMITER ;


-- Test your new stored procedure




-- FUNCTIONS
-- Declaring a function to compute BMI

DROP FUNCTION IF EXISTS body_mass_index;


DELIMITER //

CREATE FUNCTION body_mass_index
(
	weight_lbs FLOAT,
    height_inches FLOAT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	DECLARE weight_kg FLOAT;
    DECLARE height_meters FLOAT;
    DECLARE bmi FLOAT;
    
    SET weight_kg = weight_lbs * 0.4536; -- weight in kilos
    SET height_meters = height_inches * 2.54 / 100.0; -- height in meters
    SET bmi = weight_kg / (height_meters * height_meters); -- bmi = weight / height^2 [kg / m^2]
	RETURN bmi;
END //

DELIMITER ;

select body_mass_index(180.0, 72.0);

-- Display patient data with bmi


select patient_name, length(patient_name), body_mass_index(weight, height) as bmi from patient; 






-- A diet and exercise rule

DROP PROCEDURE IF EXISTS recommendDietAndExercise;

DELIMITER //


-- A procedure to recommend diet and exercise
-- that uses the body_mass_index function

CREATE PROCEDURE recommendDietAndExercise()
BEGIN
	
    DECLARE patient_id_var INT;
    DECLARE weight_var FLOAT;
    DECLARE height_var FLOAT;
    DECLARE row_not_found	TINYINT DEFAULT FALSE;
    DECLARE update_count	INT DEFAULT 0;
    DECLARE row_count INT DEFAULT 0;

	DECLARE patient_cursor CURSOR FOR 
		SELECT patient_id, weight, height from patient;
        
	-- Uncomment for events           
	DECLARE CONTINUE HANDLER FOR 1062
	SET update_count = update_count - 1;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
	OPEN patient_cursor;
    
	FETCH patient_cursor INTO patient_id_var, weight_var, height_var; -- read first row
    WHILE row_not_found = FALSE DO
    
        IF body_mass_index(weight_var, height_var) >= 25.0 THEN
			INSERT INTO recommendation
			VALUES (patient_id_var, 'Encourage patient to diet and exercise');
            SET update_count = update_count + 1;
		END IF;
        
        SET row_count = row_count + 1;
        FETCH patient_cursor INTO patient_id_var, weight_var, height_var; -- read next row
	END WHILE;
    
    CLOSE patient_cursor;
    
    select CONCAT(row_count, ' patients scanned. ', update_count,' recommendations added') as status;

END //

DELIMITER ;


-- Test the procedure





-- TRIGGERS


-- Trigger to remove flu shot recommendation when the patient has received their flushot.

truncate recommendation;
delete from recommendation; -- reset our recommendations table
call recommendFluShots;        -- load some flu recommendations
select * from recommendation;

 
DROP TRIGGER IF EXISTS patient_after_update_flushot;

DELIMITER //

CREATE TRIGGER patient_after_update_flushot 
	AFTER UPDATE ON patient
	FOR EACH ROW
BEGIN
	IF NEW.flushot =1 AND OLD.flushot = 0 THEN
		DELETE FROM recommendation
        WHERE OLD.patient_id = recommendation.patient_id 
        AND recommendation.message = 'Ask patient if he/she has had a flushot';
    END IF;
END //

DELIMITER ;

select * from  recommendation order by message, patient_id; -- five flushot recommendations

update  patient set flushot = 1 where patient_id = 2; -- patient 5 got a flushot!
select * from  recommendation order by message, patient_id; -- four flushot recommendations

update patient set flushot = 0 where patient_id = 2; -- Removing the flushot doesn't add it back in!
select * from  recommendation order by message, patient_id; -- still four flushot recommendations
																								-- But we could modify our trigger to support this if we wanted


-- Doctors have a limit on how many patients they can see
-- Currently how many patients does each doctor have? (as a PCP)



-- Add a max_patients column with a default of 6 patients
ALTER TABLE doctor
ADD COLUMN max_patients INT DEFAULT 6;




-- VERIFY DOCTOR CAN ACCEPT NEW PATIENTS
-- Create a trigger that prevents overloading a doctor

DROP TRIGGER IF EXISTS verify_doctor_is_accepting;

DELIMITER //

CREATE TRIGGER verify_doctor_is_accepting
	BEFORE INSERT ON patient
    FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM patient WHERE pcp_id = NEW.pcp_id) >=
		(SELECT max_patients FROM doctor WHERE doctor_id = NEW.pcp_id) THEN
			SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'Doctor is not accepting new patients';
	END IF;
END; //


DELIMITER ;


-- Add patients for Dr. Howser
-- 1st patient is OK:


INSERT INTO PATIENT VALUES
(9, 'Williams', 'M', 0, 1, 'MA', '1918-08-30',72, 180, 3); -- WORKS! But now Howser (doc_id=3) has 6 patients - a full load


-- Second patient fails - Dr Howser is already at the limit

INSERT INTO PATIENT VALUES
(10, 'Clemens', 'M', 0, 1, 'MA', '1962-08-04', 76, 210, 3); 








-- PREGNANCY / SEX
-- Check consistency between sex and is_pregnant fields
DROP TRIGGER IF EXISTS patient_pregnancy_check;

DELIMITER //

CREATE TRIGGER patient_pregnancy_check
	BEFORE UPDATE ON patient
    FOR EACH ROW
BEGIN
	IF (NEW.is_pregnant = TRUE AND OLD.sex = 'M') THEN
			SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'Male patient cannot be pregnant!';
	END IF;
END; //

DELIMITER ;



-- Test the trigger
-- Make Lee pregnant (Male)
-- Make Johnson pregnant (Female)





-- EVENTS

show variables; 
show variables like 'event_scheduler'; 
set global event_scheduler = on; -- REQUIRES ROOT !





-- Building a background recommendation engine
-- we create an event that invokes the recommendation procedures
-- every 5 seconds:

drop event if exists recommendation_engine;

  
delimiter //

create event recommendation_engine
on schedule every 5 second
do begin
  call recommendFluShots;
  call recommendDietAndExercise;
end //

delimiter ;

-- But what problem have we introduced?
-- Repeatedly inspect the recommendations table.



-- To fix this, we'll add a uniqueness constraint on the pat_id, message combination
-- Then we'll modify our two recommendation procedures to handle subsequent errors
-- that occur when we try to insert a duplicate recommendation
-- (Uncomment the condition handler and then drop and redeclare the 2 procedures)

-- step 0. Turn off the engine


-- step 1. drop all current recommendations



-- step 2. add uniqueness constraint
ALTER TABLE emr_sp.recommendation
ADD UNIQUE INDEX (patient_id, message) ;


-- Step 3. add initial flushot recommendations
-- call it a second time to show the 1062. Duplicate entry error.


-- Step 4. Add condition handlers on two recommendation procedures (currently commented out)
-- Then drop and redeclare both procedures

-- Step 5. Turn back on the event scheduler
-- Verify that recommendations are no longer being duplicated



-- Join Patient data with recommendation table
-- include bmi as a column


-- marcus gains a little weight - wait 5 seconds and rerun query above







