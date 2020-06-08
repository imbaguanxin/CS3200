-- HW5: Identifying Adverse Drug Events (ADEs) with Stored Programs
-- Prof. Rachlin
-- CS 3200 / CS5200: Databases

-- We've already setup the ade database by running ade_setup.sql
-- First, make ade the active database.  Note, this database is actually based on
-- the emr_sp schema used in the lab, but it included some extra tables.

use ade;



-- A stored procedure to process and validate prescriptions
-- Four things we need to check
-- a) Is patient a child and is medication suitable for children?
-- b) Is patient pregnant and is medication suitable for pregnant women?
-- c) Are there any adverse drug reactions


drop procedure if exists prescribe;

delimiter //
create procedure prescribe
(
	in patient_name_param varchar(255),
    in doctor_name_param varchar(255),
    in medication_name_param varchar(255),
    in ppd_param int
)
begin
	-- variable declarations
    declare patient_id_var int;
    declare age_var float;
    declare is_pregnant_var boolean;
    declare weight_var int;
    declare doctor_id_var int;
    declare medication_id_var int;
    declare take_under_12_var boolean;
    declare take_if_pregnant_var boolean;
    declare mg_per_pill_var double;
    declare max_mg_per_10kg_var double;

	declare message varchar(255); -- The error message
    declare ddi_medication varchar(255); -- The name of a medication involved in a drug-drug interaction

    -- select relevant values into variables
    
    -- patient information
	select patient_id, TIMESTAMPDIFF(YEAR, dob, CURDATE()), is_pregnant, weight
    into patient_id_var, age_var, is_pregnant_var,weight_var
    from patient
    where patient_name = patient_name_param;
    
    -- doctor information
	select doctor_id
    into doctor_id_var
    from doctor
    where doctor_name = doctor_name_param;
    
    -- medication information
	select medication_id, take_under_12, take_if_pregnant, mg_per_pill, max_mg_per_10kg
    into medication_id_var, take_under_12_var, take_if_pregnant_var, 
		 mg_per_pill_var,max_mg_per_10kg_var
    from medication
    where medication_name = medication_name_param;
    -- check age of patient
    -- I did one for you! This shows how to throw an exception and set an error message.
    if (age_var < 12 and take_under_12_var = false) then
		select concat(medication_name_param, ' cannot be prescribed to children under 12.', age_var) into message;
		signal sqlstate 'HY000' set message_text = message;
	end if;

    -- check if medication ok for pregnant women
	if (take_if_pregnant_var = false and is_pregnant_var) then
		select concat(medication_name_param, ' cannot be prescribed to pregnant women.') into message;
        signal sqlstate 'HY001' set message_text = message;
    end if;

    -- Check for reactions involving medications already prescribed to patient
	select m.medication_name
    into ddi_medication
	from prescription p join interaction i on (p.medication_id = i.medication_1 
											   and i.medication_2 = medication_id_var
                                               and patient_id = patient_id_var)
	left join medication m on (i.medication_1 = m.medication_id)
    limit 1;
	if (ddi_medication is not null) or (length(ddi_medication) > 0) then
		select concat(medication_name_param, ' interacts with ', ddi_medication, ' currently prescribed to ', patient_name_param) into message;
        signal sqlstate 'HY002' set message_text = message;
    end if;

    -- No exceptions thrown, so insert the prescription record
    insert into prescription (medication_id, patient_id, doctor_id, ppd) values
    (medication_id_var, patient_id_var, doctor_id_var, ppd_param);
	
end //
delimiter ;




-- Trigger

DROP TRIGGER IF EXISTS patient_after_update_pregnant;

DELIMITER //

CREATE TRIGGER patient_after_update_pregnant
	AFTER UPDATE ON patient
	FOR EACH ROW
BEGIN

	-- Patient became pregnant
	if new.is_pregnant = 1 and old.is_pregnant = 0 then
		-- Add pre-natal recommenation
        insert into recommendation values
        (new.patient_id, 'Take pre-natal vitamins');
        -- Delete any prescriptions that shouldn't be taken if pregnant
		delete from prescription
        where patient_id = new.patient_id
        and medication_id in (
			select medication_id
            from medication
            where take_if_pregnant = 0
        );
	end if;
    -- Patient is no longer pregnant
    if new.is_pregnant = 0 and old.is_pregnant = 1 then
    -- Remove pre-natal recommendation
		delete from recommendation
        where patient_id = new.patient_id
        and message = 'Take pre-natal vitamins';
	end if;


END //

DELIMITER ;



-- --------------------------                  TEST CASES                     -----------------------
-- -------------------------- DONT CHANGE BELOW THIS LINE! -----------------------
-- Test cases
truncate prescription;

-- These prescriptions should succeed
call prescribe('Jones', 'Dr.Marcus', 'Happyza', 2);
call prescribe('Johnson', 'Dr.Marcus', 'Forgeta', 1);
call prescribe('Williams', 'Dr.Marcus', 'Happyza', 1);
call prescribe('Phillips', 'Dr.McCoy', 'Forgeta', 1);

-- These prescriptions should fail
-- Pregnancy violation
call prescribe('Jones', 'Dr.Marcus', 'Forgeta', 2);

-- Age restriction
call prescribe('BillyTheKid', 'Dr.Marcus', 'Muscula', 1);


-- Drug interaction
call prescribe('Williams', 'Dr.Marcus', 'Sadza', 1);



-- Testing trigger
-- Phillips (patient_id=4) becomes pregnant
-- Verify that a recommendation for pre-natal vitamins is added
-- and that her prescription for
update patient
set is_pregnant = True
where patient_id = 4;

select * from recommendation;
select * from prescription;


-- Phillips (patient_id=4) is no longer pregnant
-- Verify that the prenatal vitamin recommendation is gone
-- Her old prescription does not need to be added back

update patient
set is_pregnant = False
where patient_id = 4;

select * from recommendation;

insert into prescription (medication_id, patient_id, doctor_id, ppd) values
(9, 4, 1, 1), (4, 4, 1, 1), (2, 4, 1, 1);

update patient set is_pregnant = True where patient_id = 4;