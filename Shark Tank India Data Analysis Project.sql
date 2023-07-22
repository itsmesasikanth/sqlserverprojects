/*
	Author: Sasikanth .D				Date:21-July-2023
	project: Shark Tank India Data Analysis Project
	Discription: Shark Tank India is a Reality show that gives opportunity to the startups to ask big
				 companies Invest in their startup. So there is dataset that shows Investrors data,
				 Equity, deals, secotrs, Team members, male and female ratio in the show. So I have
				 took some queries to analyze.
*/

USE [Shark Tank India]
Go

-- 1. Check the Data

SELECT * FROM sharktankdata

--------------------------------------------------------------------------------------------------------------
-- 2. Data Cleaning - Deleting unuseful coulmns

ALTER TABLE [DATA]
DROP COLUMN F33, F34, F35, F36, F37, F38, F39, F40, F41, F42

--------------------------------------------------------------------------------------------------------------

-- 3. Write a query to show how many episodes in shark tank india.

SELECT DISTINCT COUNT([Ep# No#]) EpisodeCount FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 4. Write a query to see how many pitches are there and which should be unique.

SELECT DISTINCT COUNT([Amount Invested lakhs]) TotalPitches FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 5. Write a query to convert only invested pitches percentage

SELECT CAST(SUM(a.FundingRaise) as float)/CAST(COUNT(*) as float)*100 as FundingPercentage FROM
(SELECT [Amount Invested lakhs], CASE WHEN [Amount Invested lakhs]>0 THEN 1 ELSE 0 END as FundingRaise
FROM sharktankdata)a

--------------------------------------------------------------------------------------------------------------

-- 6. Write a query for total male participants.

SELECT SUM(Male) MaleParticipants FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 7. Write a query for total female participants.

SELECT SUM(Female) MaleParticipants FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 8. Write a query to generate a gender ratio

SELECT SUM(Female)/SUM(Male)*100 as GenderRatio FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 9. Write a query for total invested amount

SELECT SUM([Amount Invested lakhs]) as TotalInvestedAmount FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 10. Write a query for average equity taken

SELECT AVG([Equity Taken %]) as AvgEquityTaken FROM sharktankdata WHERE [Equity Taken %]>0

--------------------------------------------------------------------------------------------------------------

-- 11. Write a query for Highest deal taken

SELECT MAX([Amount Invested lakhs]) HighestDeal FROM sharktankdata WHERE [Amount Invested lakhs]>0

--------------------------------------------------------------------------------------------------------------

-- 12. Write a query for highest equity taken

SELECT MAX([Equity Taken %]) FROM sharktankdata WHERE [Equity Taken %]>0

--------------------------------------------------------------------------------------------------------------

-- 13. Write a query for startups having atleast women

SELECT SUM(a.FemaleCount) AtleastFemaleCount FROM
(SELECT Female, CASE WHEN Female>0 THEN 1 ELSE 0 END as FemaleCount FROM sharktankdata)a

--------------------------------------------------------------------------------------------------------------

-- 14. Write a query to know the pitches converted which are having atleast women

SELECT SUM(b.FemaleCount) FemaleCount FROM
(SELECT CASE WHEN Female>0 THEN 1 ELSE 0 END as FemaleCount FROM
(SELECT *FROM sharktankdata WHERE deal != 'No Deal')a)b

--------------------------------------------------------------------------------------------------------------

-- 15. Write a query to get the average of team members.

SELECT AVG([Team members]) AvgTeamMembers FROM sharktankdata

--------------------------------------------------------------------------------------------------------------

-- 16. Write a query to get the average amount invested per deal

SELECT AVG(a.[Amount Invested lakhs]) AmountInvestedPerDeal FROM
(SELECT * FROM sharktankdata WHERE deal != 'No Deal')a

--------------------------------------------------------------------------------------------------------------

-- 17. Write a query to know the age group contestants of average highest and lowest count.

SELECT [Avg age], COUNT([Avg age]) AvgAgeGroup FROM sharktankdata WHERE [Avg age] != 'NULL' 
GROUP BY [Avg age]
ORDER BY [Avg age] DESC

--------------------------------------------------------------------------------------------------------------

-- 18. Write a query to know the location group contestants of highest and lowest count per location

SELECT [Location], SUM([Team members]) Contestants FROM sharktankdata WHERE [Location] != 'NULL'
GROUP BY [Location]
ORDER BY Contestants DESC

--------------------------------------------------------------------------------------------------------------

-- 19. Write a query to know the sector group contestants of highest and lowest count per sector

SELECT Sector, SUM([Team members]) Contestants FROM sharktankdata WHERE Sector != 'NULL'
GROUP BY Sector
ORDER BY Contestants DESC

--------------------------------------------------------------------------------------------------------------

-- 20. Write a query to know the highest count of partners

SELECT DISTINCT Partners, COUNT(Partners) HighestCount FROM sharktankdata WHERE Partners != '-'
GROUP BY Partners
ORDER BY HighestCount DESC

--------------------------------------------------------------------------------------------------------------

-- 21. Write a query for total deals present, total deals, total amount invested, avg equity taken for 
--     Ashneer.


SELECT a.Shark, b.TotalDealsPresent, a.TotalDeals, a.TotalAmountInvested, a.AvgEquityTaken 
FROM(
SELECT 'Ashneer' as Shark,
	   COUNT(Deal) TotalDeals,
	   SUM([Ashneer Amount Invested]) TotalAmountInvested,
	   AVG([Ashneer Equity Taken %]) AvgEquityTaken 
FROM sharktankdata WHERE [Ashneer Amount Invested] != 0)a

INNER JOIN

(SELECT 'Ashneer' as Shark,
	     COUNT(Deal) TotalDealsPresent
FROM sharktankdata)b on a.Shark=b.Shark

--------------------------------------------------------------------------------------------------------------

-- 22. Write a query to know in which start up the highest amount has been invested and highest sector.

SELECT DISTINCT Sector, SUM([Amount Invested lakhs]) HighestAmountInvested, COUNT([Total investors]) Investors
FROM sharktankdata
WHERE Sector IS NOT NULL and [Amount Invested lakhs] != 0
GROUP BY Sector
ORDER BY Investors DESC

--------------------------------------------------------------------------------------------------------------

-- Thank You!