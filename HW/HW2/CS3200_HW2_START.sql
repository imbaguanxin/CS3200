-- CS3200: Database Design
-- Homework #2: Genes and Disease

-- Create a new schema called "gad"
-- Then use the data import wizard to load the data "gad.csv" into a new table, also called "gad"
-- Remember to change the inferred datatype for the chromosome field from INT to TEXT
-- You should end up with a table containing 39,910 records


-- Write a query to answer each of the following questions
-- Save your script file as cs3200_hw2_lastname.sql
-- Submit this file for your homework submission


use gad;

-- 1a. (2.5 points)
-- Write a query that verifies that you have imported 39,910 records 


-- 1b. (2.5 points)
-- Write a query that lists the different columns in your gad table
-- Include a comment explaining why it was necessary to change the chromosome to a text field.


-- 2. (5 points)
-- What are the distinct disease classes referenced in this data?
-- Output your list in alphabetical order


-- 3. (5 points)
-- List all distinct phenotypes related to the disease class "IMMUNE"
-- Output your list in alphabetical order


-- 4. (5 points)
-- List the gene symbol, gene name, and chromosome attributes related
-- to genes positively linked to asthma (association = Y).
-- Count any phenotype containing the substring "asthma"
-- List each distinct record once
-- Sort by gene symbol




-- 5. (5 points)
-- Explore the content of the various columns in your gad table. 
-- List all genes that are "G protein-coupled" receptors in alphabetical order by gene symbol
-- Output the gene symbol, gene name, and chromosome
-- (These genes are often the target for new drugs, so are of particular interest)





-- 6. (5 points)
-- For genes on chromosome 3, what is the minimum, maximum DNA location
-- Exclude cases where the dna_start value is 0


-- 7 (10 points)
-- For each gene, what is the earliest and latest reported year
-- involving a positive association
-- Ignore records where the year isn't valid. (Explore the year column to determine what constitutes a valid year.)
-- Output the gene, min-year, max-year, and number of GAD records
-- order by min-year, max-year, gene-name (3-level sorting)




-- 8. (10 points)
-- How many records are there for each gene?
-- Output the gene symbol and name and the count of the number of records
-- Order by the record count in descending order


-- 9. (10 points)
-- Modify query 8 by considering only positive associations
-- and limit output to records having at least 100 associations


-- 10. (10 points)
-- How many total GAD records are there for each population group?
-- Sort in descending order by count
-- Show only the top five records
-- Do NOT include cases where the population is blank


-- 11. (10 points)
-- In question 4, we found asthma-linked genes
-- But these genes might also be implicated in other diseases
-- Output gad records involving a positive association between ANY asthma-linked gene and ANY disease/phenotype
-- Sort your output alphabetically by phenotype
-- Output the gene, gene_name, association (should always be 'Y'), phenotype, disease_class, and population
-- Hint: Use a subselect in your WHERE class and the IN operator



-- 12. (10 points)
-- Modify your previous query.
-- Let's count how many times each of these asthma-gene-linked phenotypes occurs
-- in our output table produced by the previous query.
-- Output just the phenotype, and a count of the number of occurrences for the top 5 phenotypes
-- with the most records involving an asthma-linked gene (EXCLUDING asthma itself).



-- 13. (10 points)
-- Interpret your analysis
-- Do an internet search and answer the following questions - (You can put your answer right into this script as comments.)

-- a) Does existing biomedical research support a connection between asthma and the disease you identified above?


-- b) Why might a drug company be interested in instances of such "overlapping" phenotypes?


-- CONGRATULATIONS!!: YOU JUST DID SOME LEGIT DRUG DISCOVERY RESEARCH! :-)




