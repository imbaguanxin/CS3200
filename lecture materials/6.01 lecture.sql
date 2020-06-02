use art;

show tables;
select * from artist;
select * from painting;

describe artist;
describe painting;

create table impressionist_painting(
	artist_name varchar(50),
    painting_title varchar(100)
);

insert into impressionist_painting
select name, title
from artist join painting using (artist_id)
join genre using (genre_id)
where genre_name = 'Impressionism';

select *
from impressionist_painting;