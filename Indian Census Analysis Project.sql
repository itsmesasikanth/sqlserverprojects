/*
	Author: Sasikanth .D				Date:04-July-2023
	project: Indian Census Data Analysis Project
	Discription: In this project I have took Indian Census Dataset to retrive the least and top
				 data according to the data that has given. I have used stastical formulas to 
				 retrive the two separate kind data like male and female, literate and illiterate,
				 and etc. I have covered different type fuctions like Aggregate funcitons,
				 Rank function, sub queries, and views.
*/

USE [Indian Census Database]
GO

-- Count No.of Rows in this Table.

SELECT COUNT(*) as No_Of_Rows FROM Data1

SELECT COUNT(*) AS No_Of_Rows FROM Data2

---------------------------------------------------------------------------------------

-- 1. Write a query to get the data for Bihar and Jharkhand

SELECT * 
FROM Data1
WHERE State in ('Bihar', 'Jharkhand')

---------------------------------------------------------------------------------------

-- 2. Write a query to calculate the population of India.

SELECT SUM(Population) Population
FROM Data2

---------------------------------------------------------------------------------------

-- 3. Write a query to calculate the average growth percentage of India.

SELECT AVG(Growth)*100 Avg_Growth_Percentage
FROM Data1

---------------------------------------------------------------------------------------

-- 4. Write a query to calculate the average growth percentage for each state.

SELECT State, ROUND(AVG(Growth)*100,0) Avg_Growth_Percentage
FROM Data1
WHERE Growth IS NOT NULL
GROUP BY State

---------------------------------------------------------------------------------------

-- 5. Write a query to calculate the average sex ratio for each state.

SELECT State, ROUND(AVG(Sex_Ratio ), 0) as Sex_Ratio
FROM Data1
GROUP BY State

---------------------------------------------------------------------------------------

-- 6. Write a query to calculate the average literacy ratio for each state.

SELECT State, ROUND(AVG(literacy), 0) as literacy
FROM Data1
GROUP BY State
HAVING ROUND(AVG(literacy), 0) > 90

---------------------------------------------------------------------------------------

-- 7. Write a query to show the top 3 states having Highest growth rate.

SELECT TOP 3 State, ROUND(AVG(Growth)*100, 0) as Growth_Percentage
FROM Data1
GROUP BY State
ORDER BY Growth_Percentage DESC

---------------------------------------------------------------------------------------

-- 8. Write a query to show the least 3 states having lowest sex ratio.

SELECT TOP 3 State, ROUND(AVG(Sex_Ratio), 0) as Sex_Ratio_Percentage
FROM Data1
GROUP BY State
ORDER BY Sex_Ratio_Percentage ASC

---------------------------------------------------------------------------------------

-- 9. Write a query to return the top and bottom 3 states of literacy.

DROP TABLE IF EXISTS #topstates
CREATE TABLE #topstates
(
State nvarchar(255),
Literacy float
)

INSERT INTO #topstates
	SELECT State, ROUND(AVG(Literacy), 0) as literacy_Ratio
	FROM Data1
	GROUP BY State
	ORDER BY literacy_Ratio DESC

SELECT TOP 3 * FROM #topstates ORDER BY Literacy DESC

DROP TABLE IF EXISTS #bottomstates
CREATE TABLE #bottomstates
(
State nvarchar(255),
Literacy float
)

INSERT INTO #bottomstates
	SELECT State, ROUND(AVG(Literacy), 0) as literacy_Ratio
	FROM Data1
	GROUP BY State
	ORDER BY literacy_Ratio DESC

SELECT TOP 3 * FROM #bottomstates ORDER BY Literacy ASC

SELECT * FROM (
SELECT TOP 3 * FROM #topstates ORDER BY Literacy DESC) a

UNION

SELECT * FROM (
SELECT TOP 3 * FROM #bottomstates ORDER BY Literacy ASC) b

---------------------------------------------------------------------------------------

-- 10. Write a query to return the states starting with letter 'a' or 'b' and then
--     starting with letter 'a' and ending with letter 'h'.

SELECT distinct State
FROM Data1
WHERE State like 'a%' or State like 'b%'

SELECT distinct State
FROM Data1
WHERE State like 'a%' and State like '%h'

---------------------------------------------------------------------------------------

-- 11. Write a query to derive the male and female population separetley from
--     population and sex ratio column.

SELECT d.[State ], SUM(Total_Males) as Total_Males, SUM(Total_Females) as Total_Females FROM
(SELECT c.District, c.[State ], ROUND((c.Population/(c.Sex_ratio+1)), 0) as Total_Males,
ROUND((c.Population*c.Sex_ratio/(c.Sex_ratio+1)), 0) as Total_Females, c.Population FROM
(SELECT a.District, a.[State ], a.Sex_Ratio/1000 Sex_ratio,b.Population
FROM Data1 a JOIN Data2 b on a.District = b.District) c) d
GROUP BY d.[State ]

---------------------------------------------------------------------------------------

-- 12. Write a query to derive the literate people and illiterate people from literacy.

SELECT d.[State ], SUM(Literate_People) as Literate_People, SUM(Illiterate_People) as Illiterate_People FROM
(SELECT c.District, c.[State ], ROUND((c.Literacy_Ratio*c.Population), 0) as Literate_People,
ROUND(((1-c.Literacy_Ratio)*Population), 0) as Illiterate_People FROM
(SELECT a.District, a.[State ], a.Literacy/1000 as Literacy_Ratio, b.Population
FROM Data1 a JOIN Data2 b on a.District = b.District) c) d
GROUP BY d.[State ]

---------------------------------------------------------------------------------------

-- 13. Write a query to get the previous census from population and growth.

SELECT d.[State ], SUM(d.Previous_Census_Population) as Previous_Census_Population,
SUM(d.Current_Census_Population) as Current_Census_Population FROM
(SELECT c.District, c.[State ], ROUND(c.Population/(1+c.Growth), 0) as Previous_Census_Population,
c.Population as Current_Census_Population FROM
(SELECT a.District, a.[State ], a.Growth, b.Population
FROM Data1 a JOIN Data2 b on a.District = b.District) c) d
GROUP BY d.[State ]

---------------------------------------------------------------------------------------

-- 14. Write a query to perform a calculation on area and population to know the 
--     previous population vs area and current population vs area.

SELECT (h.Total_Area/h.Previous_Census_Population) as Previous_Census_Population_vs_Area,
(h.Total_Area/h.Current_Census_Population) as Current_Census_Population_vs_Area FROM
(SELECT m.*, n.Total_Area FROM
(SELECT '1' keyy, f.* FROM
(SELECT SUM(e.Previous_Census_Population) as Previous_Census_Population,
SUM(e.Current_Census_Population) as Current_Census_Population FROM
(SELECT d.[State ], SUM(d.Previous_Census_Population) as Previous_Census_Population,
SUM(d.Current_Census_Population) as Current_Census_Population FROM
(SELECT c.District, c.[State ], ROUND(c.Population/(1+c.Growth), 0) as Previous_Census_Population,
c.Population as Current_Census_Population FROM
(SELECT a.District, a.[State ], a.Growth, b.Population
FROM Data1 a JOIN Data2 b on a.District = b.District) c) d
GROUP BY d.[State ]) e) f) m

INNER JOIN 

(SELECT '1' keyy, g.* FROM
(SELECT SUM(Area_km2) Total_Area
FROM Data2)g) n on m.keyy = n.keyy) h

---------------------------------------------------------------------------------------

-- 15. Write a query to return top 3 districts from each state with highest literacy rate.
SELECT a.* FROM
(SELECT District, [State ], Literacy,
RANK() OVER(PARTITION BY  [State ] ORDER BY Literacy DESC) as Literacy_Rank
FROM Data1) a
WHERE a.Literacy_Rank in (1, 2, 3) ORDER BY [State ]

---------------------------------------------------------------------------------------

-- Thank You!