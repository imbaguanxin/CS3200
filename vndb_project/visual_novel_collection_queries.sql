use vn_collection;


-- ---------------------------------------------------------------------
-- basic usages:
-- ---------------------------------------------------------------------
-- find a visual novel's releases by name

drop procedure if exists find_release_by_vn_name;

delimiter //
create procedure find_release_by_vn_name
(
	in vn_title_param varchar(500)
)
begin
    
    select * from vn_release
	where vn_id in (select vn_id from vn where en_title like concat('%', vn_title_param, '%'));
    
end //
delimiter ;
-- test case
call find_release_by_vn_name("Steins;Gate");

-- find a visual novel's releases by producer
drop procedure if exists find_vn_by_producer_name;

delimiter //
create procedure find_vn_by_producer_name
(
	in producer_name_param varchar(500)
)
begin
    
    select en_title, original_title
	from vn_producer_relation
	left join vn using (vn_id)
	where producer_id in (
		select producer_id from producer where en_name like concat("%", producer_name_param, "%")
	);
    
end //
delimiter ;
-- test case
call find_vn_by_producer_name('Yuzusoft');

-- find the characters of visual novel: white album
drop procedure if exists find_chars_by_vn_name;
delimiter //
create procedure find_chars_by_vn_name
(
	in vn_name_param varchar(500)
)
begin
    
	select distinct vn_char.*, r.role
	from (select * from vn where en_title like concat('%', vn_name_param, '%')) as v
	left join char_vn_relation r using (vn_id)
	left join vn_char using (char_id);
    
end //
delimiter ;
-- test case
call find_chars_by_vn_name('white album');
-- ---------------------------------------------------------------------
-- trait analysis
-- ---------------------------------------------------------------------

-- some one is interested in trait: blond
-- The following query find the top 5 common traits of characters who have the trait: blond hair.
-- This query first find all characters who is blond; Then find their traits other than blond; 
-- Then do a count on each trait and find the top 5.
select trait_name, char_count
from (
	select r.trait_id, count(*) as char_count from(
		select trait_id, char_id from trait_char_relation
		join trait using (trait_id)
		where trait_name = 'Blond' and trait_description like "%hair%") as c
	left join trait_char_relation r on (c.char_id = r.char_id and c.trait_id != r.trait_id)
	group by r.trait_id
	order by char_count desc) as t_c
left join trait using (trait_id)
limit 5;

-- find the total number of characters has the trait blond.
select count(distinct char_id) 
from trait_char_relation 
where trait_id = (
	select trait_id 
    from trait 
    where trait_name = 'Blond');
    
-- ---------------------------------------------------------------------------
-- most popular vn analysis
-- ---------------------------------------------------------------------------

-- the top 10 visual novels with the most number of releases.
select vn.en_title, vn.original_title, count(release_id) as release_count
from vn_release 
left join vn using (vn_id)
group by vn_id
order by release_count desc
limit 10;

-- the top 10 visual novels with the most number of languages.
select vn.en_title, vn.original_title, count(distinct language_code) as language_count
from vn 
left join vn_release using (vn_id)
left join lang_vn_release_relation using (release_id)
group by vn_id
order by language_count desc
limit 10;

-- ---------------------------------------------------------------------------
-- the most productive staff and producer analysis
-- ---------------------------------------------------------------------------

-- find top 10 productive producer company
select en_name, original_name, website, language_code, count(vn_id) as vn_count
from vn_producer_relation
join producer using (producer_id)
where type = 'co'
group by producer_id
order by vn_count desc
limit 10; 

-- find top 10 productive staff
-- Since staff may have many stage names,
-- I pick the name with the lowest stage name id.
select en_stage_name, original_stage_name, vn_count 
from (
	select staff_id, count(vn_id) as vn_count
	from vn_staff_relation
	group by staff_id
	order by vn_count desc
    limit 10) as sv
left join (
	select en_stage_name, original_stage_name, s.staff_id
	from (
		select min(staff_stage_name_id) as id, staff_id
		from staff_stage_name
		group by staff_id) as n
	left join staff_stage_name s on (n.id = s.staff_stage_name_id)
) as sn using (staff_id);

-- ---------------------------------------------------------------
-- language analysis
-- ---------------------------------------------------------------
-- Top 5 languages that appear most frequently in releases
select language_name, count(release_id) as lang_count
from lang_vn_release_relation
left join lang using (language_code)
group by language_code
order by lang_count desc
limit 5;

select count(*) from lang_vn_release_relation;


-- ---------------------------------------------------------------------------
-- most popular vn tags analysis
-- ---------------------------------------------------------------------------
-- most appeared tags on top 50 visual novels (in term of releases count)
select tag_name, count(vn_id) as vn_count, tag_description
from
	(select vn.vn_id, count(release_id) as release_count
	from vn_release 
	left join vn using (vn_id)
	group by vn_id
    order by release_count desc
	limit 50) as p
left join tag_vn_relation using (vn_id)
left join tag using (tag_id)
group by tag_id
having vn_count >= 25
order by vn_count desc;

-- most appeared tags on top 50 visual novels (in term of language count)
select tag_name, count(vn_id) as vn_count, tag_description
from( 
	select vn.vn_id, count(distinct language_code) as lang_count
	from vn 
	left join vn_release using (vn_id)
	left join lang_vn_release_relation using (release_id)
	group by vn_id
	order by lang_count desc
	limit 50) as p
left join tag_vn_relation using (vn_id)
left join tag using (tag_id)
group by tag_id
having vn_count >= 25
order by vn_count desc;