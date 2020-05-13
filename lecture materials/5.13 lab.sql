use bank;

describe loan;

SELECT marital, approved, COUNT(*), COUNT(approved='yes'), COUNT(approved='no')
FROM loan
GROUP BY marital, approved;

SELECT marital, SUM(approved='yes') AS 'approved', SUM(approved='no') AS 'rejected'
FROM loan
GROUP BY marital;

SELECT marital, 
	   COUNT(*) AS num_applications, 
	   SUM(approved) AS num_approved, 
	   SUM(rejected) AS num_rejected,
       ROUND(AVG(approved) * 100, 1) AS 'pct_approved',
       ROUND(AVG(rejected) * 100, 1) AS 'pct_rejected',
       ROUND(AVG(balance), 1) AS 'avg_balance'
FROM 
(
	SELECT marital, approved='yes' AS 'approved', approved='no' AS 'rejected', balance
	FROM loan
) temp
GROUP BY marital;

-- create a view (vitural table or an intermediate result)
CREATE VIEW loan_approvals AS
SELECT marital, balance, approved='yes' AS 'approved', approved='no' AS 'rejected'
FROM loan;

SELECT *
FROM loan_approvals;


SELECT 
	job,
    round(avg(balance),1) as 'avg_balance',
	COUNT(*) AS num_applications, 
	SUM(CASE WHEN approved='yes' then 1 else 0 end) AS num_approved, 
	SUM(CASE WHEN approved='no' then 1 else 0 end) AS num_rejected,
	ROUND(SUM(CASE WHEN approved='yes' then 1 else 0 end) / COUNT(*) * 100, 1) AS 'pct_approved',
	ROUND(SUM(CASE WHEN approved='no' then 1 else 0 end) / COUNT(*) * 100, 1)  AS 'pct_rejected'
FROM loan
GROUP BY job
ORDER BY pct_approved DESC;