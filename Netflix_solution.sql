-- Netflix Project


Create table netflix
(
	show_id       VARCHAR(10),
    type_         VARCHAR(10),
    title         VARCHAR(300),
    director      VARCHAR(300),
    casts        VARCHAR(1000),
    country       VARCHAR(300),
    date_added    VARCHAR(50),
    release_year  INT,
    rating        VARCHAR(20),
    duration      VARCHAR(50),
    listed_in     VARCHAR(300),
    description   VARCHAR(1000)
);
select * from netflix;
select 
Distinct type_ 
from netflix;

-- 14 Business problems

-- 1. Count the Number of Movies vs TV Shows

select 
	type_,
	count(*) as total_content
from netflix
Group by 1;

-- 2. Find the Most Common Rating for Movies and TV Shows

select 
type_,
rating
from
(
	select 
	type_,
	rating,
	count(*),
	rank() over(partition by type_ order by count(*) desc) as ranking 
	from netflix
	group by 1,2
	order by 3 desc
) as t1
where ranking = 1;


-- 3. List All Movies Released in a Specific Year (e.g., 2020)

select *
from netflix
where 
	Type_ = ovie
	and
	release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

select 
	unnest(string_to_array(Country,',')) as new_country,
	count(show_id) as Total_content
from netflix
group by 1
order by total_content desc
limit 5;

-- 5. Identify the Longest Movie

select * from netflix
where 
	type_ = 'Movie'
	and 
	duration = (select max(duration)from netflix);

-- 6. Find Content Added in the Last 5 Years

select * from netflix
where 
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '8 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
Select * 
from ( 
	select 
	*,
		unnest(string_to_array(director,',')) as director_name 
	from netflix
	) as t
where director_name = 'Rajiv Chilaka';
 
select * from netflix
	where Director Ilike '%Rajiv Chilaka%';


-- 8. List All TV Shows with More Than 5 Seasons

select *
from netflix
where 
type_ = 'TV Show'
and 
split_part(duration,' ',1) :: numeric > 5;

-- 9. Count the Number of Content Items in Each Genre

Select 
unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1;

-- 10. List All Movies that are Documentaries

Select *,
-- unnest(String_to_array(listed_in, ',')) as listed_type
from netflix 
where listed_in ilike '%Documentaries%';

-- 11. Find All Content Without a Director

select * 
from netflix
where director is null;

-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 15 Years

select *
from netflix
where casts ilike '%Salman Khan%'
and type_ = 'Movie'
and release_year > extract(year from current_date) - 15;

-- 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select 
	unnest(string_to_array(casts,','))as Actor,
	count(*) as total_content
from netflix
where Type_ = 'Movie'
and 
	country ilike '%India%'
group by 1
order by 2 desc
limit 10;

-- 14.Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords in description field. 
	label content containing these keywords as 'Bad' and all other content as 'Good'.
	count how many items fall into each category.

with new_table
as
( select *,
  case 
	when description ilike '%kill%'
	or 
	description ilike '%Violence%' then 'Bad Content'
	else 'Good Content'
	end Category
from netflix
)
select 
	Category,
	count(*) as total_content
from new_table
group by 1









