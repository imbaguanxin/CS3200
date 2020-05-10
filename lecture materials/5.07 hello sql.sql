use bank;
show tables;
describe loan;

select * 
from loan 
limit 10;

select job,marital,balance,age 
from loan;

-- default is aescending, 
select job,marital,balance,age
from loan
where job='entrepreneur' or job='retired' and age > 50
order by marital,balance desc;

select * from loan
where (job='entrepreneur' or job='retired') 
	and age <= 40
order by job desc;

select distinct job from loan;

select * 
from loan 
where job like '%tr%';

select * 
from loan 
where job in ('unemployed', 'services', 'management');

select * 
from loan 
where job in (select distinct job from loan where balance > 10000);

-- number of records
select count(*) from loan;

-- maximum balance
select max(balance) from loan;

select * 
from loan
where balance = max(balance);