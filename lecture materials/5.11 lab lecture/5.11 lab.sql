use bank;

select * from loan;

select marital, education, round(avg(balance),2) as 'avg_balance'
from loan
where balance > 0
group by marital, education
order by marital, education;

select distinct marital
from loan;