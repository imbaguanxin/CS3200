-- Do this before runing the python scritpt.
create database if not exists vndb_dev;
ALTER SCHEMA `vndb_dev`  DEFAULT CHARACTER SET utf8mb4;
use vndb_dev;

-- --------------------------------------------------------------------------------
-- release problems
-- -------------------------------------------------------------------------------
-- 1. clean platform information
drop table if exists release_with_plt;
create table release_with_plt(
	release_id int primary key,
    en_title varchar(500),
    original_title varchar(500),
    website varchar(500),
    note text,
    platform varchar(10)
);

INSERT INTO release_with_plt
select v.release_id, en_title, original_title, website, note, tmp.platform  -- count(*), count(distinct v.release_id)
from vn_release v 
left join (
	select p1.release_id, p1.platform
	from release_platform p1 
	left join release_platform p2
	on (p1.release_id = p2.release_id and p1.platform < p2.platform)
	WHERE p2.platform IS NULL
) as tmp 
on (v.release_id = tmp.release_id);

-- 2. delete releases of vn that is not in our database.

-- pair release with vn
drop table if exists release_with_plt_vn_id;
create table release_with_plt_vn_id(
	release_id int primary key,
    en_title varchar(500),
    original_title varchar(500),
    website varchar(500),
    note text,
    platform varchar(10),
    vn_id int
);

INSERT INTO release_with_plt_vn_id
select v.release_id, en_title, original_title, website, note, platform, tmp.vn_id  -- count(*), count(distinct v.release_id)
from release_with_plt v 
left join (
	select p1.release_id, p1.vn_id
	from release_vn p1 
	left join release_vn p2
	on (p1.release_id = p2.release_id and p1.vn_id != p2.vn_id)
	WHERE p2.vn_id IS NULL
) as tmp 
on (v.release_id = tmp.release_id);

-- varifiy all releases are unique
select count(*) from vn_release;
select count(*) from release_with_plt_vn_id;

-- I would like to output following data:
select r.*
from release_with_plt_vn_id r join vn v using (vn_id);

-- drop the temp data:
drop table if exists release_with_plt; 

-- ---------------------------------------------------------------
-- character : vn is a n to m relation, relation table's foreign key must fit the foreign key constraints.
-- I need: 
select char_id, vn_id, role
from vn_char_relation join vn_char using (char_id)
join vn using (vn_id);

-- -----------------------------------------------------------------
-- producer: similar to problems above
-- I need:
select producer_id, vn_id
from vn_producer_relation join vn using (vn_id)
join producer using (producer_id);

-- ------------------------------------------------------------------
-- staff:
-- 1. the metadata didn't have position as a seperate table.
-- 2. data consistency problem

-- problem1:
select distinct(position)
from vn_staff_relation;

create table if not exists staff_position(
	position_id INT primary key auto_increment,
    title VARCHAR(50) not null,
    intro text null
);

insert into staff_position (title)
select distinct(position) from vn_staff_relation;

set SQL_SAFE_UPDATES = 0;
update staff_position set intro = 'General art design.' where title = 'art';
update staff_position set intro = 'Designer or each scene and how to transform from scenes' where title = 'scenario';
update staff_position set intro = 'BGM producer, sometimes also produces openning and ending songs.' where title = 'music';
update staff_position set intro = 'The director, usually also the script writer' where title = 'director';
update staff_position set intro = 'Character Design.' where title = 'chardesign';
update staff_position set intro = 'General staff.' where title = 'staff';
update staff_position set intro = 'The openning and ending songs producer.' where title = 'songs';
set SQL_SAFE_UPDATES = 1;

-- I need:
select * from staff_position;

-- problem 2:
-- I need: keep data consistency.
select vn_id, staff_id, p.position_id, note
from vn_staff_relation r join staff_position p on (r.position = p.title)
join vn using (vn_id)
join staff using (staff_id);

-- ------------------------------------------
-- language:
-- some language, release relation is not good.
select distinct(language_code) from release_lang;


-- ============================================
-- trait
-- data consistency
-- I need:
select char_id, trait_id
from trait_char_relation join trait using (trait_id)
join vn_char using (char_id);

-- select r.char_id, r.trait_id
-- from (
-- 	select * from trait where searchable = 't'
-- ) as t join trait_char_relation r on (r.trait_id = t.trait_id)
-- join vn_char v on (v.char_id = r.char_id)
-- where searchable = 't';



-- -------------------------------
-- tags of vn
-- data consistency and vote
select count(*) from tag where searchable = 't';
select r.tag_id, r.vn_id, count(*) as vote from tag_vn_relation r join (
	select * from tag where searchable = 't'
) as t on (r.tag_id = t.tag_id)
group by tag_id, vn_id;