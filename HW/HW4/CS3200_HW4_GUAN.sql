-- CS3200_HW4_EMR.sql

-- CS3200 / HOMEWORK #4 
-- Write a query against the Electronic Medical Record (EMR) database than answers each question
-- Remember to save your script as: CS3200_HW4_yourname.sql

use emr;
-- 1. List each patient and the name of their primary care doctor (PCP)
-- Output just the patient name and the doctor's name in
-- alphabetical order by patient
select patient_name, doctor_name
from patient left join doctor on (patient.pcp_id = doctor_id)
order by patient_name;



-- 2. How many doctors are there for each specialty?
-- Include specialties that have no doctor.
-- Order by most doctors to fewest
select specialty_name, count(distinct doctor_id) as 'doctor_count'
from specialty left join doctor using (specialty_id)
group by specialty_id, specialty_name
order by doctor_count desc;



-- 3. Which patients have the flu?
-- Output the patient name, their flushot status, the diagnosing doctor's name, and the date of the diagnosis
-- sort by diagnosis date
select patient_name, flushot, doctor_name, diagnosis_date
from patient left join diagnosis using (patient_id)
left join disease using (disease_id)
left join doctor using (doctor_id)
where patient_id in (
	select patient_id
	from diagnosis left join disease using (disease_id)
	where disease_name = 'Flu'
)
order by diagnosis_date;


-- 4. What is the BMI for each patient?
-- BMI = Body Mass Index
-- Look up the definition and formula on the internet. Don't forget unit conversions.
-- Note that patient table provides weight in lbs and height in inches!
-- Output patient_id, Patient name, weight (lbs), height (inches), and BMI rounded to 1 decimal place
-- Order by BMI descending
select 
	patient_id, 
	patient_name, 
    weight, 
    height, 
    round(703 * weight / height / height, 1) as "BMI"
from patient
order by BMI desc;



-- 5. Write an INSERT statement that adds to the recommendation table
-- the patient_id and the text "Recommend Diet and Exercise"
-- for any patient with a BMI greater than 25.0.
insert into recommendation
select patient_id, "Recommend Diet and Exercise"
from patient
where round(703 * weight / height / height, 1) > 25.0;




-- 6. Write a query to delete flushot recommendations for any patient that has had their flushot
delete from recommendation
where patient_id in (
	select patient_id
    from patient
    where flushot = 1
)
and message like '%flushot%';



-- 7. Write a query that outputs a patients name, sex, dob, flushot status, weight
-- and any recommendations. Include patients with no recommendations
select patient_name, sex, dob, flushot, weight, message as 'recommendation'
from patient left join recommendation using (patient_id);



-- 8. Show the medical history for patient 'Smith
-- Output the patient name, the name of their PCP, the diagnosing doctor, the diagnosis (disease) and date
-- Clearly distinguish the doctor who is the PCP and the diagnosing doctor in your column headers.
-- Order from newest to oldest diagnosis
select 
	patient_name, 
    doctor.doctor_name as 'pcp_doctor', 
    d.doctor_name as 'diagnosing_doctor', 
    diagnosis_date
from patient left join doctor on (doctor.doctor_id = patient.pcp_id)
left join diagnosis using (patient_id)
left join doctor d on (d.doctor_id = diagnosis.doctor_id)
where patient_name = 'Smith'
order by diagnosis_date desc;



-- 9. Output every doctor and their specialty
-- include doctors with no specialty
-- include specialties with no doctor
select doctor_name, specialty_name
from doctor left join specialty using (specialty_id)
union
select doctor_name, specialty_name
from doctor right join specialty using (specialty_id);




-- 10. How many times was each disease in the disease table
-- diagnosed in 2017? Include diseases that were never diagnosed.
-- Output the disease and the number of times it was diagnosed in 2017
-- Order by the number of diagnoses descending
-- HINT: This one is tricky. Check your result carefully. You should output 5 records one for each disease
-- 3 of the diseases have no diagnosis in 2017. 
-- The trick is that one of your join tables can be the result of a select!
select disease_name, count(diagnosis_date) as 'num_diagnosis'
from disease d left join diagnosis a on 
(d.disease_id = a.disease_id and year(diagnosis_date) = 2017)
group by disease_name
order by num_diagnosis desc;


-- 11. For each doctor that is the PCP of at least one patient
-- What is the min, max, and average weight of that doctor's patients?
-- Round avg_weight to one decimal place
-- Also count the number of patients that that doctor has
-- Order by the average weight descending
-- Use column aliases to output the column: doctor_name, min_weight, avg_weight, max_weight, num_patients
select 
	doctor_name, 
    min(weight) as 'min_weight',
    round(avg(weight), 1) as 'avg_weight',
    max(weight) as 'max_weight',
    count(patient_id) as 'num_patients'
from doctor d join patient p on (d.doctor_id = p.pcp_id)
group by doctor_name
order by avg_weight desc;



-- 12. Who is the youngest person diagnosed with the flu?
-- Output just the name of the patient and their date of birth
select patient_name, dob
from patient left join diagnosis using (patient_id)
left join disease using (disease_id)
where disease_name = 'Flu'
order by dob desc
limit 1;




-- 13. Show all diagnoses by doctors who are a general practitioners
-- Give patient name,  the diagnosis, the doctor's name, and the date
-- Order by the date
select patient_name, disease_name, doctor_name, diagnosis_date
from diagnosis join doctor using (doctor_id)
join patient using (patient_id)
join disease using (disease_id)
join specialty using (specialty_id)
where specialty_name = 'GENERAL PRACTITIONER';



-- 14. The hospital wants to pair up doctors so that  doctors
-- mentor other doctors. Doctors can only mentor another doctor
-- in the same specialty. And they can't mentor themselves!
-- Find all the candidate mentor-mentee pairs.
-- Output the name of the mentor, the name of the mentee, and their shared specialty
-- Order by the mentor, then the mentee last name
select d1.doctor_name as "mentor", d2.doctor_name as "mentee", specialty_name
from doctor d1 join doctor d2 on (d1.specialty_id = d2.specialty_id and d1.doctor_id != d2.doctor_id)
left join specialty on (d1.specialty_id = specialty.specialty_id)
order by mentor, mentee;



-- 15. What has the youngest patient been diagnosed with?
-- Output the disease and date of diagnosis
-- Order earliest to most recent diagnosis
select disease_name, diagnosis_date
from diagnosis left join disease using (disease_id)
where patient_id = (
	select patient_id
	from patient
	order by dob
	limit 1
)
order by diagnosis_date;

-- Remember to save your script as: CS3200_HW4_yourname.sql



