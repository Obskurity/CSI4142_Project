/* Part 1 */

-- Drill down and Roll up
-- Drill down: displaying all facilities for each city with the fact table
SELECT
ft.age_city_id,
ft.ethnicity_city_id,
ft.highest_population_age_ID,
ft.highest_population_ethnicity_ID,
f.*
FROM facttable ft
JOIN facilities f ON ft.City = f.City
ORDER BY f.city

-- Roll up: Instead of looking for each facility in each city, we sum the total facilities.
SELECT
ft.city,
ft.age_city_id,
ft.ethnicity_city_id,
ft.highest_population_age_id,
ft.highest_population_ethnicity_id,
COALESCE(f.total_appearances, 0) AS appearance_count
FROM facttable ft
LEFT JOIN
	(SELECT
     	City,
     	SUM(1) AS total_appearances
 	FROM
     	facilities
 	GROUP BY
     	City) f ON ft.City = f.City

-- Slice
SELECT * FROM FACILITIES
WHERE CITY = 'Ottawa'

-- Dice
SELECT *
FROM agedemographics AS a
JOIN facilities as f
ON a.city = f.city
WHERE f.city = 'Toronto'
AND f.facility_type_id = 'FT2'

SELECT *
FROM ethnicitydemographics AS e
JOIN facilities as f
ON e.city = f.city
WHERE f.city = 'Waterloo'
AND f.Street_Type = 'dr'

-- Combining OLAP operations
-- Comparing facility count with age demographics
SELECT
    a.*,
    ft.highest_population_age_id,
    ft.facility_count
FROM facttable ft
INNER JOIN agedemographics as a ON ft.Age_City_ID = a.Age_City_ID;

-- Finding relationship between race and facility type using the city markham
SELECT
	ft.City,
	ft.Highest_Population_Age_ID,
	em.Ethnicity AS highest_population_ethnicity,
	ft.Facility_Count,
	f.Facility_Type_ID,
	ftype.FType,
	eth.Chinese,
	eth.Japanese,
	eth.Korean
FROM facttable ft
JOIN ethnicitydemographics eth ON ft.City = eth.City
JOIN
	(
    	SELECT
        	City,
        	Facility_Type_ID
    	FROM
        	facilities
    	WHERE
        	City = 'Markham'
    	GROUP BY
        	City, Facility_Type_ID
    	ORDER BY
        	COUNT(*) DESC
    	LIMIT 1
	) AS most_occurring_facility ON ft.City = most_occurring_facility.City
JOIN
	facilities f ON most_occurring_facility.City = f.City AND most_occurring_facility.Facility_Type_ID = f.Facility_Type_ID
JOIN facilitytypes ftype ON most_occurring_facility.Facility_Type_ID = ftype.Facility_Type
JOIN ethnicitymapping em ON ft.Highest_Population_Ethnicity_ID = em.ethnicity_id
WHERE (eth.Chinese > 0 OR eth.Korean > 0 OR eth.Japanese > 0)
LIMIT 1;

-- Query to check sports related facilities
SELECT facilities.*, facttable.Age_City_ID, facttable.Ethnicity_City_ID, facttable.Highest_Population_Age_ID, facttable.Highest_Population_Ethnicity_ID
FROM facilities
JOIN facttable ON facilities.City = facttable.City
WHERE facilities.facility_type_id IN ('FT2', 'FT3', 'FT4', 'FT5', 'FT7', 'FT8');

-- Comparing facility count with ethnicity demographics
SELECT
e.*,
ft.highest_population_ethnicity_id,
ft.facility_count
FROM facttable ft
INNER JOIN ethnicitydemographics as e ON ft.Ethnicity_City_ID = e.Ethnicity_City_ID;

/* Part 2 */

-- Iceberg Queries
-- Finding highest population cities and their respective facility counts.
SELECT f.ethnicity_city_id,
   	f.city,
   	f.facility_count,
   	(e."Not a visible minority" + e."Visible minority, n.i.e." + e."Multiple visible minorities" + e."South Asian" + e.chinese + e.black + e.filipino + e.arab + e."Southeast Asian" + e."West Asian" + e.korean + e.japanese) AS total_sum
FROM facttable AS f
JOIN ethnicitydemographics AS e ON f.ethnicity_city_id = e.ethnicity_city_id
GROUP BY f.ethnicity_city_id, f.city, f.facility_count, e."Not a visible minority", e."Visible minority, n.i.e.", e."Multiple visible minorities", e."South Asian", e.chinese, e.black, e.filipino, e.arab, e."Southeast Asian", e."West Asian", e.korean, e.japanese
ORDER BY total_sum DESC
LIMIT 10;

-- Windowing Queries
For each facility type, we look at which cities have the most of a certain facility and look at the average number of times that facility pops up as. We rank each city based on how many times it has that specific facility_type_id.
WITH ranked_facilities AS (
 SELECT
City,
facility_type_id,
COUNT(*) AS no_of_facilities,
RANK() OVER (PARTITION BY facility_type_id ORDER BY COUNT(*) DESC) AS rank,
AVG(COUNT(*)) OVER (PARTITION BY facility_type_id) AS avg_facility_occurence
FROM facilities
GROUP BY City, facility_type_id
)
SELECT
  facility_type_id,
  City,
  no_of_facilities,
  rank,
  avg_facility_occurence
FROM ranked_facilities
ORDER BY facility_type_id;

-- Using the Window Clause
-- This query provides knowledge on how facilities are distributed to age groups under 25 for each city, to identify trends in facility distributions across various age demographics.

SELECT
a.City,
a.Age_City_ID,
a."0 to 4 years",
a."5 to 9 years",
a."10 to 14 years",
a."15 to 19 years",
a."20 to 24 years",
AVG(ft.Facility_Count) OVER age_window AS Avg_Facility_Count
FROM agedemographics a
JOIN facttable ft ON a.Age_City_ID = ft.Age_City_ID AND a.City = ft.City
WINDOW age_window AS (PARTITION BY a.City, a.Age_City_ID)




