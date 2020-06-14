use vndb_dev;

drop table if exists release_with_plt;
create table release_with_plt(
	release_id int primary key,
    en_title varchar(500),
    original_title varchar(500),
    website varchar(500),
    notes text,
    platform varchar(10)
);

INSERT INTO release_with_plt
select v.release_id, en_title, original_title, website, notes, tmp.platform  -- count(*), count(distinct v.release_id)
from vn_release v 
left join (
	select p1.release_id, p1.platform
	from release_platform p1 
	left join release_platform p2
	on (p1.release_id = p2.release_id and p1.platform < p2.platform)
	WHERE p2.platform IS NULL
) as tmp 
on (v.release_id = tmp.release_id);

drop table if exists release_with_plt_producer;
create table release_with_plt_producer(
	release_id int primary key,
    en_title varchar(500),
    original_title varchar(500),
    website varchar(500),
    notes text,
    platform varchar(10),
    producer_id int
);


INSERT INTO release_with_plt_producer
select v.release_id, en_title, original_title, website, notes, platform, tmp.producer_id  -- count(*), count(distinct v.release_id)
from release_with_plt v 
left join (
	select p1.release_id, p1.producer_id
	from release_producer p1 
	left join release_producer p2
	on (p1.release_id = p2.release_id and p1.index != p2.index)
	WHERE p2.index IS NULL
) as tmp 
on (v.release_id = tmp.release_id);
select count(*) from vn_release;
select count(*) from release_with_plt_producer;
