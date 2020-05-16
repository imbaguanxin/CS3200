-- CS3200: Database Design
-- Homework #2: Genes and Disease

-- Create a new schema called "gad"
-- Then use the data import wizard to load the data "gad.csv" into a new table, also called "gad"
-- Remember to change the inferred datatype for the chromosome field from INT to TEXT
-- You should end up with a table containing 39,910 records

-- Write a query to answer each of the following questions
-- Save your script file as cs3200_hw2_lastname.sql
-- Submit this file for your homework submission

USE gad;


-- 1a. (2.5 points)
-- Write a query that verifies that you have imported 39,910 records 
SELECT (SELECT COUNT(*)
		FROM gad) = 39910;


-- 1b. (2.5 points)
-- Write a query that lists the different columns in your gad table
-- Include a comment explaining why it was necessary to change the chromosome to a text field.
SHOW COLUMNS FROM gad;
-- The field chromosome is the label of a gene showing where it comes from, 
-- but not a numerical property of the data entry. 
-- We don't want to compare the value but just use this label to differ from other genes.


-- 2. (5 points)
-- What are the distinct disease classes referenced in this data?
-- Output your list in alphabetical order
SELECT DISTINCT disease_class
FROM gad
ORDER BY disease_class ASC;


-- 3. (5 points)
-- List all distinct phenotypes related to the disease class "IMMUNE"
-- Output your list in alphabetical order
SELECT DISTINCT phenotype
FROM gad
WHERE disease_class = 'IMMUNE'
ORDER BY phenotype ASC;


-- 4. (5 points)
-- List the gene symbol, gene name, and chromosome attributes related
-- to genes positively linked to asthma (association = Y).
-- Count any phenotype containing the substring "asthma"
-- List each distinct record once
-- Sort by gene symbol
SELECT DISTINCT gene, gene_name, chromosome
FROM gad
WHERE association = 'Y' AND phenotype LIKE '%asthma%'
ORDER BY gene ASC;


-- 5. (5 points)
-- Explore the content of the various columns in your gad table. 
-- List all genes that are "G protein-coupled" receptors in alphabetical order by gene symbol
-- Output the gene symbol, gene name, and chromosome
-- (These genes are often the target for new drugs, so are of particular interest)
SELECT gene, gene_name, chromosome
FROM gad
WHERE gene_name LIKE '%G protein-coupled%'
ORDER BY gene;


-- 6. (5 points)
-- For genes on chromosome 3, what is the minimum, maximum DNA location
-- Exclude cases where the dna_start value is 0
SELECT MIN(dna_start) AS 'minimum DNA location',
	   MAX(dna_end) AS 'maximum DNA location'
FROM gad
WHERE dna_start <> 0;


-- 7 (10 points)
-- For each gene, what is the earliest and latest reported year
-- involving a positive association
-- Ignore records where the year isn't valid. (Explore the year column to determine what constitutes a valid year.)
-- Output the gene, min-year, max-year, and number of GAD records
-- order by min-year, max-year, gene-name (3-level sorting)
SELECT gene,
	   gene_name,
	   MIN(year) AS 'min_year',
	   MAX(year) AS 'max_year',
       COUNT(*)
FROM gad
WHERE year > 1900
GROUP BY gene, gene_name
ORDER BY min_year, max_year, gene_name;


-- 8. (10 points)
-- How many records are there for each gene?
-- Output the gene symbol and name and the count of the number of records
-- Order by the record count in descending order
SELECT gene, gene_name, COUNT(*) AS 'record_count'
FROM gad
GROUP BY gene, gene_name
ORDER BY record_count desc;


-- 9. (10 points)
-- Modify query 8 by considering only positive associations
-- and limit output to records having at least 100 associations
SELECT gene, gene_name, COUNT(*) AS 'record_count'
FROM gad
WHERE association = 'Y'
GROUP BY gene, gene_name
HAVING record_count >= 100
ORDER BY record_count DESC;



-- 10. (10 points)
-- How many total GAD records are there for each population group?
-- Sort in descending order by count
-- Show only the top five records
-- Do NOT include cases where the population is blank
SELECT population, COUNT(*) AS count
FROM gad
WHERE population <> ""
GROUP BY population
ORDER BY count DESC
LIMIT 5;


-- 11. (10 points)
-- In question 4, we found asthma-linked genes
-- But these genes might also be implicated in other diseases
-- Output gad records involving a positive association between ANY asthma-linked gene and ANY disease/phenotype
-- Sort your output alphabetically by phenotype
-- Output the gene, gene_name, association (should always be 'Y'), phenotype, disease_class, and population
-- Hint: Use a subselect in your WHERE class and the IN operator

SELECT gene, gene_name, association, phenotype, disease_class, population
FROM gad
WHERE gene IN (SELECT distinct gene
			   FROM gad
               WHERE phenotype LIKE "%asthma%")
	  AND association = 'Y'
ORDER BY phenotype ASC;


-- 12. (10 points)
-- Modify your previous query.
-- Let's count how many times each of these asthma-gene-linked phenotypes occurs
-- in our output table produced by the previous query.
-- Output just the phenotype, and a count of the number of occurrences for the top 5 phenotypes
-- with the most records involving an asthma-linked gene (EXCLUDING asthma itself).
SELECT phenotype, COUNT(*) as 'count'
FROM gad
WHERE gene IN (SELECT distinct gene
			   FROM gad
               WHERE phenotype LIKE "%asthma%")
	  AND association = 'Y'
      AND phenotype <> 'asthma'
GROUP BY phenotype
ORDER BY count DESC
Limit 5;


-- 13. (10 points)
-- Interpret your analysis
-- Do an internet search and answer the following questions - (You can put your answer right into this script as comments.)

-- a) Does existing biomedical research support a connection between asthma and the disease you identified above?
--    1. For type1 diabetes, some study suggest that "a prior diagnosis of asthma increases the risk of subsequent type 1 diabetes". 
--       However, some more recent study also suggest that type 1 diabetes diagnosis first decreases the risk of subsequent asthma.
--       source: https://www.patientcareonline.com/view/asthma-diagnosis-associated-type-1-diabetes
--    2. For lung cancer, a study published on Oncotarget suggest that "prior asthma is significantly associated with lung cancer risk".
--       This result is shown to be corrected in race groups including Caucasians and Asians. Also, both male and female patients with 
--       asthma "showed increased risk for lung cancer".
--       source: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5355290/
--    3. For rheumatoid arthritis, a literature review in Tuberculosis & Respiratory Diseases indicates a strong relation between these 
--       two diseases. source: https://www.rheumatologyadvisor.com/home/topics/rheumatoid-arthritis/rheumatoid-arthritis-and-asthma-is-there-a-link/
--    4. For hypertension, a research from the New England Journal of Medicien suggest that there is a potential mechanistic links between hypertension
--       and asthma. source: https://www.nejm.org/doi/full/10.1056/NEJMra1800345
--    5. For breast cancer, there is an artical from Cancer Cause Control showing that there is no statistically significant
--       relation between the two diseases.
--       source: https://www.ncbi.nlm.nih.gov/pubmed/23443321

-- b) Why might a drug company be interested in instances of such "overlapping" phenotypes?
--    Some exisiting drug might help treat the related diseases. Also, the underlying mechanism of the two diseases might have some relations. 
--    Thus help the development of the drug that treat the related diseases. 

-- CONGRATULATIONS!!: YOU JUST DID SOME LEGIT DRUG DISCOVERY RESEARCH! :-)




