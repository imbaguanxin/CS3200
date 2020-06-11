-- This is MOST of the schema and data for quiz 3
-- The actual quiz will have an additional table or two and the data might change.

-- All quizzes should have themes.
-- The theme for this quiz is: "Books that will change your life."



drop database if exists library;
create database library;
use library;

-- Book genre
drop table if exists genre;
create table genre (
	genre_id int primary key,
    genre_name varchar(25)
);

insert into genre values
(1, 'non-fiction'),
(2, 'fiction'),
(3, 'philosophy'),
(4, 'science fiction'),
(5, 'science'),
(6, 'plays')
;

-- books
-- information about each book in the library's catalog
drop table if exists book;
create table book (
	book_id int primary key,
    title varchar(255) not null,
    author varchar(255),
    year int,
    pages int,
    genre_id int,
    in_circulation boolean,
    constraint foreign key (genre_id) references genre(genre_id)
    
);

insert into book values 
(1, 'The Soul of a New Machine', 'Tracy Kidder', 1981, 320, 1, true), -- Much of the engineering of computers takes place in silence, while engineers pace in hallways or sit alone and gaze at blank pages.
(2, 'Nineteen Eighty-Four', 'George Orwell', 1948, 328, 2, true), -- Freedom is the freedom to say that 2+2=4
(3, 'Fahrenheit 451', 'Ray Bradbury', 1953, 249, 2, true), -- It doesn't matter what you do...so long as you change something from the way it was before you touched it into something that's like you after you take your hands away.
(4, 'Brave New World', 'Aldous Huxley', 1932, 288, 2, true), -- If one's different, one's bound to be lonely.
(5, 'Zen and the Art of Motorcycle Maintenance', 'Robert Pirsig', 1974, 540, 3, false), -- The real cycle you're working on is a cycle called yourself.
(6, 'Dune', 'Frank Herbert', 1965, 896, 4, true), -- Once men turned their thinking over to machines in the hope that this would set them free. But that only permitted other men with machines to enslave them.
(7, 'Wonderful Life: The Burgess Shale and the Nature of History', 'Stephen J. Gould', 1990, 352, 5, true), -- Genius has as many components as the mind itself
(8, 'The Voyage of the Beagle', 'Charles Darwin', 1839, 496, 5, true), -- The wilderness has a mysterious tongue, which teaches awful doubt.
(9, 'Crime and Punishment', 'Fyodor Dostoevsky', 1866, 565, 2, true), -- The darker the night, the brighter the stars.
(10, 'Love\'s Labor\'s Lost', 'William Shakespeare', 1598, 160, 6, true) -- O, we have made a vow to study, lords, and in that vow we have forsworn our books.
;




-- Users, contact information, and where they live

drop table if exists user;
create table user (
	user_id int primary key,
    user_name varchar(25),
    email varchar(255),
    street varchar(100),
    city varchar(100),
    state char(2)
);

insert into user values
(1, 'John', 'john@gmail.com', '1 main st', 'Boston', 'ma'),
(2, 'Abby', 'abby@kids.com', '2 summer st', 'Boston', 'ma'),
(3, 'Jack', 'jack@yahoo.com', '1 main st', 'Burlington', 'ma'),
(4, 'Sonya', 'sonya@aol.com', '3 harbor rd', 'Boylston', 'ma');
 




-- Which users are borrowing which books

drop table if exists borrow;
create table borrow (
	book_id int,
    user_id int,
    borrow_dt date,
    due_dt date,
    return_dt date,
    constraint foreign key (book_id) references book(book_id),
    constraint foreign key (user_id) references user(user_id)
);

insert into borrow values
(1,1,'2019-01-02', '2019-01-16', '2019-01-21'),
(2,1,'2019-01-02', '2019-01-16', '2019-01-15'),
(4,1,'2019-01-02', '2019-01-16', '2019-01-16'),
(6,1,'2019-02-01', '2019-02-16', '2019-02-23'),
(7,1,'2019-02-22', '2019-03-08', '2019-04-22'),
(8,1,'2019-03-10', '2019-03-24', '2019-06-30'),
(9,1,'2019-03-20', '2019-04-04', '2019-04-18'),
(3,1,'2019-04-18', '2019-05-02', '2019-07-13'),
(10,1,'2019-07-13', '2019-07-31', '2019-07-30'),
(6,1, '2019-08-01', '2019-08-14', '2019-12-25'),
(1,2,'2019-01-04', '2019-01-16', '2019-01-15'),
(1,2,'2019-01-15', '2019-01-31', '2019-02-01'),
(1,4,'2019-04-22', '2019-05-08', '2021-05-06');



-- The fine for returning a book late is 10 cents per day!
-- No extensions will be granted! 
-- And we know where you live.
-- This table tracks payment of all fines
-- If you return 2 book 10 days late you are fined $2.00 
-- If you paid us a total of $1.75, then you still owe us $0.25!

drop table if exists payment;
create table payment (
	user_id int,
	paid_dt date,
    amount decimal(9,2),
    constraint foreign key (user_id) references user(user_id)
);

insert into payment values
(1, '2019-01-21', 0.50),
(1, '2019-02-25', 0.60),
(1, '2019-04-22', 4.00),
(1, '2019-07-01', 0.20),
(1, '2019-05-01', 0.10),
(2, '2019-02-01', 0.08),
(4, '2021-05-06', 0.01);



select 'Library DB created.';

-- q2

select title, author, year
from book left join genre using (genre_id)
where genre_name = 'science fiction';

-- q3
select user_name, city, state
from user left join borrow using (user_id)
group by user_name, city, state
having count(book_id) = 0;

-- q4
select count(book_id) / count(distinct user_id) as average
from user left join borrow using (user_id);

-- q5
select user_name, month(borrow_dt) as month, count(borrow_dt) as num_borrowed
from user join borrow using (user_id)
group by user_name, month(borrow_dt)
order by user_name, month;

-- q6
select title, genre_name, count(borrow_dt) as num_borrowed, in_circulation
from book left join borrow using (book_id)
left join genre using (genre_id)
group by book_id
order by num_borrowed desc;

-- q7
select genre_name, count(*) as num_checked_out
from user u join borrow b on (u.user_id = b.user_id and u.user_name = 'John')
join book using (book_id)
join genre using (genre_id)
group by genre_id
having num_checked_out >= 2
order by num_checked_out desc;


-- q8
select user_name, count(borrow_dt) as late_count
from user u left join borrow b on (u.user_id = b.user_id and b.due_dt < b.return_dt)
group by u.user_id
order by late_count desc;


-- q9
-- select 
-- 	user_name, 
-- 	sum(datediff(due_dt, return_dt) * 0.1) 
-- from user u left join borrow b on (u.user_id = b.user_id and b.due_dt < b.return_dt)
-- group by u.user_id;

-- select user_id, user_name, sum(amount) as paid_amount
-- from user left join payment using (user_id)
-- group by user_id;

select user_id, user_name, - IFNULL(fine_amount + sum(amount), 0) as dollar_owed 
from (
	select 
		u.user_id,
		user_name, 
		sum(datediff(due_dt, return_dt) * 0.1) as fine_amount
	from user u left join borrow b on (u.user_id = b.user_id and b.due_dt < b.return_dt)
	group by u.user_id
) as fine left join payment using (user_id)
group by user_id;

-- q10
-- create table crew (
-- 	crew_id INT primary key auto_increment,
--     name varchar(255) not null,
--     reports_to INT
-- );

-- insert into crew (name, reports_to) values
-- ('Kirk', null),
-- ('Spock', 1),
-- ('McCoy', 1),
-- ('Chapel', 3),
-- ('Scotty', 1),
-- ('Uhuru', 5),
-- ('Sulu', 2),
-- ('Chekov', 2);

-- select * from crew;

select c1.name, c2.name as reports_to
from crew c1 left join crew c2 on (c1.reports_to = c2.crew_id); 

-- q11
select * from book;


