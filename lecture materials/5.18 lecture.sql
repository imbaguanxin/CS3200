CREATE DATABASE hr;
use hr;

drop table if exists branch;
create table branch(
	branch_id int primary key auto_increment,
    city varchar(50)
);

insert into branch values
(1, 'London'),
(2, 'Aberdeen'),
(3, 'Glasgow'),
(4, 'Bristol');

create table staff(
	staff_id int primary key auto_increment,
    name varchar(50) unique,
    branch_id int not null default 1 comment 'Which branch does the staff member work at?',
    creation_date datetime default now()    
);

insert into staff (name,branch_id) values
('Marc', 1),
('Steph', 2),
('Annie', 3),
('John', 3);

insert into staff (name) values ('jim');

insert into staff values
(10, 'Peter', 9, '1966-02-01 23:22:21.1234');

insert into branch (city) values ('Boston');
insert into branch (city) values ('London');

select *
from branch;

select * from branch
where branch_id = 6;

delete from branch
where branch_id = 6;

select * from branch where city = 'London';

delete from branch where city = 'London';

use hr;
drop table if exists branch;
drop table IF EXISTS Branch;
drop table if exists staff;

CREATE TABLE Branch(
	branch_id int PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(50)
);

insert into Branch values
(1, 'London'),
(2, 'Aberdeen'),
(3, 'Glasgow'),
(4, 'Bristol');

DROP TABLE IF EXISTS Staff;

CREATE TABLE Staff(
	staff_id int primary key auto_increment,
    name VARCHAR(50),
    branch_id INT not null default 1,
    creation_date DATETIME DEFAULT now(),
    CONSTRAINT staff_fk_branch FOREIGN KEY (branch_id) references Branch (branch_id)
);

insert into Staff (name, branch_id) values ('John', 1);
insert into Staff (name, branch_id) values ('Mary', 4);

select * from Staff;

delete from Branch where branch_id = 4;