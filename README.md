# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/mdfaizan0011/Netflix_sql_project/blob/main/netflix%20logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
## Objective
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
## Dataset
The data for this project is sourced from the Kaggle dataset:

## Dataset Link: Movies Dataset
## Schema
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
## Business Problems and Solutions
# 1. Count the Number of Movies vs TV Shows
		select 
			type_,
			count(*) as total_content
		from netflix
		Group by 1;
Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows
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
      
Objective: Identify the most frequently occurring rating for each type of content.

3. List All Movies Released in a Specific Year (e.g., 2020)
	select *
	from netflix
	where 
		Type_ = ovie
		and
		release_year = 2020;

4. Find the Top 5 Countries with the Most Content on Netflix
	select 
		unnest(string_to_array(Country,',')) as new_country,
		count(show_id) as Total_content
	from netflix
	group by 1
	order by total_content desc
	limit 5;
Objective: Identify the top 5 countries with the highest number of content items.

5. Identify the Longest Movie
	select * from netflix
	where 
		type_ = 'Movie'
		and 
		duration = (select max(duration)from netflix);

6. Find Content Added in the Last 5 Years
	select * from netflix
	where 
		to_date(date_added, 'Month DD, YYYY') >= current_date - interval '8 years';

Objective: Retrieve content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
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

Objective: List all content directed by 'Rajiv Chilaka'.

8. List All TV Shows with More Than 5 Seasons
	select *
	from netflix
	where 
	type_ = 'TV Show'
	and 
	split_part(duration,' ',1) :: numeric > 5;
	

9. Count the Number of Content Items in Each Genre
	Select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(show_id) as total_content
	from netflix
	group by 1;
Objective: Count the number of content items in each genre.

10. List All Movies that are Documentaries
	Select *,
	from netflix 
	where listed_in ilike '%Documentaries%';

11. Find All Content Without a Director
	select * 
	from netflix
	where director is null;
Objective: List content that does not have a director.

12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 15 Years
	select *
	from netflix
	where casts ilike '%Salman Khan%'
	and type_ = 'Movie'
	and release_year > extract(year from current_date) - 15;

Objective: Count the number of movies featuring 'Salman Khan' in the last 15 years.

13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
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

Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
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

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
