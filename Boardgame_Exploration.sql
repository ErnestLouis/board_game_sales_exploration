/*
Board Game Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--View imported Data from each table

SELECT * FROM board_games

SELECT * FROM themes

--Selecting Data that will be used

SELECT bgg_id, title, year_published, game_weight, avg_rating, 
	max_players, num_owned, num_want, mfg_age_rec, num_user_ratings
FROM board_games

--Number of user ratings vs number owned also include ownership_to_comment percentage

SELECT 
	bgg_id, title, num_user_ratings as "User Rating",
	num_owned, 
	ROUND(((CAST(num_user_ratings as decimal)/(CAST(num_owned as decimal))))*100,0) as owner_to_rating_percentage
	FROM 
		board_games
	WHERE num_owned <> 0

--Amount of owner_to_percentage over 50% 
SELECT 
	bgg_id, title, num_user_ratings as "User Rating",
	num_owned, 
	ROUND(((CAST(num_user_ratings as decimal)/(CAST(num_owned as decimal))))*100,0) as owner_to_rating_percentage
FROM 
		board_games
WHERE num_owned <> 0
	AND ROUND(((CAST(num_user_ratings as decimal)/(CAST(num_owned as decimal))))*100,0) > 50


--Amount of owner_to_percentage below 50%
SELECT 
	count (*) as rating_percentage, (SELECT COUNT(*) FROM board_games) as total_games
FROM 
		board_games
WHERE num_owned <> 0
	AND ROUND(((CAST(num_user_ratings as decimal)/(CAST(num_owned as decimal))))*100,0) > 50



--most popular game difficulty amonst game owners

SELECT game_weight as "Game Dificulty", COUNT(*) as preference_count
FROM board_games
WHERE game_weight IN (0,1,2,3,4,5)
GROUP BY game_weight
ORDER BY preference_count DESC




--how does GameWeight effect desirebility(game want) 

SELECT game_weight as "Game Dificulty", COUNT(*) as preference_count, sum(num_wish) as wish_listed
FROM board_games
WHERE game_weight IN (0,1,2,3,4,5)
GROUP BY game_weight
ORDER BY wish_listed DESC



--Most owned Board game

SELECT bgg_id, title, year_published, num_owned
	FROM board_games
WHERE num_owned = (
	SELECT max(num_owned)
		FROM board_games)

-- Select Max number of players per top 10 most popular games

SELECT bgg_id,title,max_players
	FROM board_games
WHERE max_players > 5
ORDER BY num_user_ratings DESC
LIMIT 10

	
--Trend of number of games published over the years (in chart)

SELECT year_published, count(year_published) as number_of_games_published
FROM board_games
WHERE year_published > 1899
GROUP BY year_published
ORDER BY year_published


--temptable of id title theme

DROP TABLE if exists title_themes
CREATE TEMP TABLE title_themes
(
	bgg_id int primary key,
	title varchar(100),
	theme varchar(50)
);

INSERT INTO title_themes
SELECT board_games.bgg_id,title,
(CASE WHEN adventure = 1 THEN 'adventure' WHEN
	fantasy = 1 THEN 'fantasy' WHEN
	fighting = 1 THEN 'fighting' WHEN
	environmental = 1 THEN 'environmental' WHEN
	medical = 1 THEN 'medical' WHEN
	economic = 1 THEN 'economic' WHEN
	industry_manufacturing = 1 THEN 'industry_manufacturing' WHEN
	transportation = 1 THEN 'transportation' WHEN
	science_fiction = 1 THEN 'science_fiction' WHEN
	space_exploration = 1 THEN 'space_exploration' WHEN
	civilization = 1 THEN 'civilization' WHEN
	civil_war = 1 THEN 'civil_war' WHEN
	movies_tv_radio = 1 THEN 'movies_tv_radio' WHEN
	novel_based = 1 THEN 'novel_based' WHEN
	age_of_reason = 1 THEN 'age_of_reason' WHEN
	mythology = 1 THEN 'mythology' WHEN
	renaissance = 1 THEN 'renaissance' WHEN
	american_west = 1 THEN 'american_west' WHEN
	animals = 1 THEN 'animals' WHEN
	modern_warfare = 1 THEN 'modern_warfare' WHEN
	medieval = 1 THEN 'medieval' WHEN
	ancient = 1 THEN 'ancient' WHEN
	nautical = 1 THEN 'nautical'WHEN
	post_napoleonic = 1 THEN 'post_napoleonic' WHEN
	horror = 1 THEN 'horror' WHEN
	farming = 1 THEN 'farming' WHEN
	religious = 1 THEN 'religious' WHEN
	travel = 1 THEN 'travel' WHEN
	murder_mystery = 1 THEN 'murder_mystery' WHEN
	pirates = 1 THEN 'pirates' WHEN
	comic_book = 1 THEN 'comic_book' WHEN
	mature_adult = 1 THEN 'mature_adult' WHEN
	video_game = 1 THEN 'video_game' WHEN
	spies_secret_agents = 1 THEN 'spies_secret_agents' WHEN
	arabian = 1 THEN 'arabian' WHEN
	prehistoric = 1 THEN 'prehistoric' WHEN
	trains = 1 THEN 'trains' WHEN
	aviation_flight = 1 THEN 'aviation_flight' WHEN
	zombies = 1 THEN 'zombies' WHEN
	world_war_II = 1 THEN 'world_war_II' WHEN
	racing = 1 THEN 'racing' WHEN
	pike_and_shot = 1 THEN 'pike_and_shot' WHEN
	world_war_I = 1 THEN 'world_war_I' WHEN
	humor = 1 THEN 'humor' WHEN
	sports = 1 THEN 'sports' WHEN
	mafia = 1 THEN 'mafia' WHEN
	american_indian_wars = 1 THEN 'american_indian_wars' WHEN
	napoleonic = 1 THEN 'napoleonic' WHEN
	american_revolutionary_war = 1 THEN 'american_revolutionary_war' WHEN
	vietnam_war = 1 THEN 'vietnam_war' WHEN
	american_civil_war = 1 THEN 'american_civil_war' WHEN
	numbers = 1 THEN 'numbers' WHEN
	trivia = 1 THEN 'trivia' WHEN
	music = 1 THEN 'music' WHEN
	korean_war = 1 THEN 'korean_war' WHEN
	city_building = 1 THEN 'city_building' WHEN
	political = 1 THEN 'political' WHEN
	math = 1 THEN 'math' WHEN
	maze = 1 THEN 'maze' WHEN
	cooking = 1 THEN 'cooking' END ) as theme
FROM board_games INNER JOIN themes
	ON board_games.bgg_id = themes.bgg_id
ORDER BY 1

SELECT * FROM title_themes

---joins
--theme of most owned game
WITH most_owned_cte
AS
(
SELECT title_themes.bgg_id, title_themes.title, num_owned,theme
	FROM title_themes INNER JOIN board_games
		ON title_themes.bgg_id = board_games.bgg_id
)
SELECT title,theme
FROM most_owned_cte 
	WHERE num_owned = (
		SELECT max(num_owned)
			FROM board_games)
			
			
--average sold per theme in past 10 years

WITH most_owned_cte
AS
(
SELECT title_themes.bgg_id, title_themes.title, num_owned,theme,year_published
	FROM title_themes INNER JOIN board_games
		ON title_themes.bgg_id = board_games.bgg_id
)
SELECT DISTINCT theme, ROUND(AVG(num_owned) OVER (PARTITION BY theme),2) AS avg_sales_per_theme
FROM most_owned_cte 
WHERE year_published BETWEEN 2010 AND 2023
ORDER BY avg_sales_per_theme DESC

