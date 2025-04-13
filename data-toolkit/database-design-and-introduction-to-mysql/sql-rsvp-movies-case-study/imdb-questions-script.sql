USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables. */

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT TABLE_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb'
ORDER BY TABLE_NAME;
-- The table with the most columns is the names table.
-- The table with the fewest columns is the director_mapping table.

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 'id' AS column_name, COUNT(*) - COUNT(id) AS null_count FROM movie
UNION ALL
SELECT 'title', COUNT(*) - COUNT(title) FROM movie
UNION ALL
SELECT 'year', COUNT(*) - COUNT(year) FROM movie
UNION ALL
SELECT 'date_published', COUNT(*) - COUNT(date_published) FROM movie
UNION ALL
SELECT 'duration', COUNT(*) - COUNT(duration) FROM movie
UNION ALL
SELECT 'country', COUNT(*) - COUNT(country) FROM movie
UNION ALL
SELECT 'worlwide_gross_income', COUNT(*) - COUNT(worlwide_gross_income) FROM movie
UNION ALL
SELECT 'languages', COUNT(*) - COUNT(languages) FROM movie
UNION ALL
SELECT 'production_company', COUNT(*) - COUNT(production_company) FROM movie
-- The columns that have no null values are: id, title, year, date_published, duration.
-- The columns that have null values include: country, worlwide_gross_income, languages, production_company.
-- Among these, the column worlwide_gross_income has the most null values.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
SELECT year AS `Year`, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;
-- The highest number of movies is produced in the year 2017. */
-- The lowest number of movies is produced in the year 2019. */

SELECT MONTH(date_published) AS `month_num`, COUNT(*) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;
-- The highest number of movies is produced in the month of March. */
-- The lowest number of movies is produced in the month of December. */
/* The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year. */
  
-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Type your code below:
SELECT COUNT(*) AS number_of_movies
FROM movie
WHERE year = 2019 AND (country LIKE '%USA%' or country LIKE '%India%');
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset. */

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;
-- There are 13 movie genres that have been produced. */
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT g.genre, COUNT(*) AS movie_count
FROM movie m
INNER JOIN movie_genre AS mg ON mg.movieid = m.movieid
INNER JOIN genre AS g ON g.genreid = mg.genreid
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 1;
-- The genre with the highest number of movies is Drama.
-- The genre with the lowest number of movies is Others.
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre. */

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS movies_only_one_genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS t;
-- There are 4708 movies with at least two genres.
-- There are 3289 movies with only one genre.
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project. */

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre AS genre, AVG(m.duration) AS avg_duration
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
GROUP BY g.genre;
-- The genre with the highest average duration is Action.
-- The genre with the lowest average duration is Horror.
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies. */

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+ */
-- Type your code below:
SELECT genre, movie_count, genre_rank
FROM (
    SELECT g.genre, COUNT(*) AS movie_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM genre AS g
    GROUP BY g.genre
) AS ranked_genres
WHERE genre = 'thriller';
/* Thriller movies is in top 3 among all genres in terms of number of movies
In the previous segment, you analysed the movies and genres tables. 
In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table */

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+ */
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating. */

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+ */
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
SELECT title, avg_rating, movie_rank
FROM (
    SELECT 
        m.title,
        r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM ratings r
    INNER JOIN movie m ON m.id = r.movie_id
) AS ranked_movies
WHERE movie_rank <= 10
ORDER BY movie_rank;
-- Both Kirket and Love in Kilnerry are tied for the top spot
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight. */

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;
-- Movies with a median rating of 7 is highest in number
-- Movies with a median rating of 1 is lowest in number

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project. */

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+ */
-- Type your code below:
SELECT production_company, movie_count, prod_company_rank
FROM (
    SELECT m.production_company, COUNT(*) AS movie_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL
    GROUP BY m.production_company
) AS ranked_prod
WHERE prod_company_rank = 1;
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both
-- Both Dream Warrior Pictures and National Theatre Live have 3 movies and are tied for first place

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre AS genre, COUNT(*) AS movie_count
FROM movie AS m
INNER JOIN genre AS g ON g.movie_id = m.id
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE m.date_published BETWEEN '2017-03-01' AND '2017-03-31' AND m.country = 'USA' AND r.total_votes  > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;
-- Lets try to analyse with a unique problem statement.
-- Genre with the most movies released in March 2017 in the USA and having over 1,000 votes is Drama
-- Genre with the fewest movies released in March 2017 in the USA and having over 1,000 votes is Family

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+ */
-- Type your code below:
SELECT m.title, r.avg_rating, g.genre
FROM movie AS m
INNER JOIN genre AS g ON g.movie_id = m.id
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8;
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT r.median_rating, COUNT(*) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating = 8;
-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.country, SUM(r.total_votes) AS total_votes
FROM movie AS m
INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country;
-- The total number of votes for German movies exceeds that for Italian movies by 28,745.
-- Answer is Yes
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables. */

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/* Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+ */
-- Type your code below:
SELECT 
    SUM(CASE WHEN `name` IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM `names`;
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies. */

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH TopGenres AS (
    SELECT g.genre, COUNT(*) AS movie_count
    FROM genre AS g
    INNER JOIN ratings AS r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
TopDirectors AS (
    SELECT n.`name` AS director_name, COUNT(*) AS movie_count, ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_row_rank
    FROM `names` AS n
    INNER JOIN director_mapping AS dm ON n.id = dm.name_id
    INNER JOIN genre AS g ON dm.movie_id = g.movie_id 
	INNER JOIN ratings AS r ON r.movie_id = g.movie_id,
    TopGenres
    WHERE r.avg_rating > 8
    AND g.genre IN (SELECT genre FROM TopGenres)
    GROUP BY director_name
    ORDER BY movie_count DESC
    LIMIT 3
)
SELECT director_name, movie_count
FROM TopDirectors
WHERE director_row_rank <= 3
LIMIT 3;
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors. */

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT `name` AS actor_name, COUNT(r.movie_id) AS movie_count
FROM ratings AS r
INNER JOIN role_mapping AS rm ON rm.movie_id = r.movie_id
INNER JOIN `names` AS n ON rm.name_id = n.id
WHERE rm.category = 'actor' AND r.median_rating >= 8
GROUP BY `name`
ORDER BY movie_count DESC
LIMIT 2;
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world. */

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+ */
-- Type your code below:
WITH ProductionHouseVotes AS (
    SELECT production_company, SUM(total_votes) AS vote_count
    FROM movie AS m
    INNER JOIN ratings AS r ON r.movie_id = m.id
    GROUP BY production_company
),
RankedProductionHouses AS (
    SELECT production_company, vote_count,
	ROW_NUMBER() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
    FROM ProductionHouseVotes
)
SELECT production_company, vote_count, prod_comp_rank
FROM RankedProductionHouses
WHERE prod_comp_rank <= 3;
/* Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be. */

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+ */
-- Type your code below:
WITH ActorStats AS (
    SELECT n.`name` AS actor_name, COUNT(DISTINCT m.id) AS movie_count, SUM(r.total_votes) AS total_votes, SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes) AS actor_avg_rating
    FROM role_mapping AS rm
	INNER JOIN movie AS m ON m.id = rm.movie_id
	INNER JOIN ratings AS r ON r.movie_id = m.id
	INNER JOIN `names` AS n ON rm.name_id = n.id
    WHERE m.country = 'India'
    GROUP BY actor_name
    HAVING movie_count >= 5
),
RankedActors AS (
    SELECT actor_name, total_votes, movie_count, actor_avg_rating, ROW_NUMBER() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
    FROM ActorStats
)
SELECT actor_name, total_votes, movie_count, ROUND(actor_avg_rating, 2) AS actor_avg_rating, actor_rank
FROM RankedActors;
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+ */
-- Type your code below:
WITH ActressStats AS (
    SELECT n.`name` AS actress_name, COUNT(DISTINCT m.id) AS movie_count, SUM(r.total_votes) AS total_votes, SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes) AS actress_avg_rating
    FROM role_mapping AS rm
    INNER JOIN movie AS m ON rm.movie_id = m.id
	INNER JOIN ratings AS r ON m.id = r.movie_id
	INNER JOIN `names` AS n ON rm.name_id = n.id
    WHERE m.country = 'India' AND m.languages = 'Hindi'
    GROUP BY actress_name
    HAVING COUNT(DISTINCT m.id) >= 3
),
RankedActresses AS (
    SELECT actress_name, total_votes, movie_count, actress_avg_rating, ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM ActressStats
)
SELECT actress_name, total_votes, movie_count, ROUND(actress_avg_rating, 2) AS actress_avg_rating, actress_rank
FROM RankedActresses
WHERE actress_rank <= 5;
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers. */

/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
-------------------------------------------------------------------------------------------- */
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+ */

-- Type your code below:
SELECT 
    m.title AS movie_name,
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating >= 7 AND r.avg_rating <= 8 THEN 'Hit'
        WHEN r.avg_rating >= 5 AND r.avg_rating < 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
    END AS movie_category
FROM movie AS m
INNER JOIN genre AS g ON g.movie_id = m.id
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE g.genre = 'Thriller' AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment. */

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+ */
-- Type your code below:

-- Round is good to have and not a must have; Same thing applies to sorting
WITH GenreAvg AS (
    SELECT g.genre, ROUND(AVG(duration), 2) AS avg_duration
    FROM movie AS m
    INNER JOIN genre AS g ON g.movie_id = m.id
    GROUP BY g.genre
)
SELECT genre, avg_duration, ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total_duration, ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 1 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM GenreAvg;
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+ */
-- Type your code below:
WITH TopGenres AS (
    SELECT g.genre
    FROM movie AS m
    INNER JOIN genre AS g ON g.movie_id = m.id
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),
RankedMovies AS (
    SELECT g.genre, m.year, m.title, m.worlwide_gross_income, DENSE_RANK() OVER (PARTITION BY g.genre ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM movie AS m
    INNER JOIN genre AS g ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM TopGenres)
)
SELECT genre, year, title, worlwide_gross_income, movie_rank
FROM RankedMovies
WHERE movie_rank <= 5
ORDER BY genre, movie_rank;
-- Top 3 Genres based on most number of movies

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+ */
-- Type your code below:
WITH ProductionHits AS (
    SELECT m.production_company, COUNT(m.id) AS movie_count
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE POSITION(',' IN m.languages) > 0 AND r.median_rating >= 8 AND production_company IS NOT NULL
    GROUP BY m.production_company
),
RankedProduction AS (
    SELECT production_company, movie_count, ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM ProductionHits
)
SELECT production_company, movie_count, prod_comp_rank
FROM RankedProduction
WHERE prod_comp_rank <= 2;
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+ */

-- Type your code below:
WITH ActressSuperhits AS (
    SELECT n.`name` AS actress_name, COUNT(DISTINCT rm.movie_id) AS movie_count, SUM(r.total_votes) AS total_votes, ROUND((SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes)), 2) AS actress_avg_rating
    FROM `names` AS n
    INNER JOIN role_mapping rm ON rm.name_id = n.id
    INNER JOIN ratings r ON r.movie_id = rm.movie_id
    INNER JOIN genre g ON g.movie_id = r.movie_id
    WHERE g.genre = 'drama' AND rm.category = 'actress' AND r.avg_rating > 8
    GROUP BY n.`name`
),
RankedActresses AS (
    SELECT actress_name, total_votes, movie_count, actress_avg_rating, RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
    FROM ActressSuperhits
)
SELECT actress_name, total_votes, movie_count, ROUND(actress_avg_rating, 4) AS actress_avg_rating, actress_rank
FROM RankedActresses
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

-------------------------------------------------------------------------------------------- */
-- Type you code below:
WITH Director_Movie_Details AS (
    SELECT dm.name_id AS director_id, m.id AS movie_id, m.date_published, m.duration, r.avg_rating, r.total_votes
    FROM director_mapping AS dm
    INNER JOIN `names` AS n ON dm.name_id = n.id
    INNER JOIN movie AS m ON m.id = dm.movie_id
    INNER JOIN ratings r ON m.id = r.movie_id
),
DirectorMoviesGap AS (
    SELECT director_id, DATEDIFF(date_published, LAG(date_published) OVER (PARTITION BY director_id ORDER BY date_published)) AS gap_days
    FROM Director_Movie_Details
),
AvgGap AS (
    SELECT director_id, AVG(gap_days) AS avg_inter_movie_days
    FROM DirectorMoviesGap
    WHERE gap_days IS NOT NULL
    GROUP BY director_id
),
DirectorAggregation AS (
    SELECT dmd.director_id, COUNT(*) AS number_of_movies, SUM(dmd.duration) AS total_duration, SUM(dmd.total_votes) AS total_votes, MIN(dmd.avg_rating) AS min_rating, MAX(dmd.avg_rating) AS max_rating, SUM(dmd.total_votes * dmd.avg_rating) / SUM(dmd.total_votes) AS avg_rating
    FROM Director_Movie_Details dmd
    GROUP BY dmd.director_id
),
DirectorStats AS (
    SELECT da.director_id, da.number_of_movies, da.total_duration, da.total_votes, da.min_rating, da.max_rating, da.avg_rating, ag.avg_inter_movie_days
    FROM DirectorAggregation da
    LEFT JOIN AvgGap ag ON da.director_id = ag.director_id
),
RankedDirectors AS (
    SELECT ds.*, DENSE_RANK() OVER (ORDER BY number_of_movies DESC) AS director_rank
    FROM DirectorStats ds
)
SELECT rd.director_id, n.`name` AS director_name, rd.number_of_movies, ROUND(rd.avg_inter_movie_days, 2) AS avg_inter_movie_days, ROUND(rd.avg_rating, 2) AS avg_rating, rd.total_votes, rd.min_rating, rd.max_rating, rd.total_duration
FROM RankedDirectors rd
INNER JOIN `names` n ON rd.director_id = n.id
LIMIT 9;