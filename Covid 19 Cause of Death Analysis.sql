/*
   Author - Sasikanth D				Date: 01-06-2023
   ------ Covid 19 Cause Of Death Analysis - EDA - Project ------
   I've done an analysis on CovidCauseOfDeaths.
   It was a huge data in the years between 2020 - 2023 and till date.
   There are total 300k rows I am dealing with and it is the first time I am working with a bulk data.
   I am really excited to do this project and let's get started!
*/

-- call the database.
use Project
Go

-- Count the rows in CovidVaccinations Table
Select COUNT (*)
from CauseOfDeaths
Go

-- Result: Total 313312 rows in other words 300K.

---------------------------------- let's explore the CovidVaccinations  Table.---------------------------------------------

-- 1. Total no.of Age group people.

select sum(median_age) as MediumAge,
	   sum(aged_65_older) as Age65Group,
	   SUM(aged_70_older) as Age70Group
from CauseOfDeaths

---------------------------------------------------------------------------------------------------------------------

-- 2.Number of Medium Age group People in each country.

Select location, sum(median_age) as median_age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and median_age is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 3. Number of 65 Age group People in each country.

Select location, sum(aged_65_older) as Age65Group
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_65_older is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 4. Number of 70 Age group People in each country.

Select location, SUM(aged_70_older) as Age70Group
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_70_older is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 5. Percentage of Medium Age group people got COVID 19

select location, sum(median_age)*100/population as PercentageOfMediumAge
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and median_age is not null
group by location, population, median_age
order by PercentageOfMediumAge desc

---------------------------------------------------------------------------------------------------------------------

-- 6. Percentage of 65 Age group People got COVID 19

select location, sum(aged_65_older)*100/population as PercentageOf65Age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_65_older is not null
group by location, population, aged_65_older
order by PercentageOf65Age desc

---------------------------------------------------------------------------------------------------------------------

-- 7. Percentage of 70 Age group People got COVID 19

select location, sum(aged_70_older)*100/population as PercentageOf70Age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_70_older is not null
group by location, population, aged_70_older
order by PercentageOf70Age desc

---------------------------------------------------------------------------------------------------------------------

-- 8. Female and Male Smokers in each country.

select location,
	   sum(cast(female_smokers as float)) as Female_Smokers,
	   sum(cast(male_smokers as float)) as Male_Smokers
from CauseOfDeaths
where female_smokers is not null and male_smokers is not null
group by location
order by Female_Smokers desc, Male_Smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 9. What is the percentage of female smokers in each country?

Select location, 
	   sum(population) as population,
	   sum(cast(female_smokers as float)) as female_smokers,
	   (cast(female_smokers as float)*100/population) as Percentage_Female_Smoker
from CauseOfDeaths
where female_smokers is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
Group by location, population, female_smokers
order by Percentage_Female_Smoker

---------------------------------------------------------------------------------------------------------------------

-- 10. What is the percentage of female smokers in each continent?

SELECT continent, (SUM(cast(female_smokers as float)) / SUM(population)) * 100 AS percentage_Female_smokers
FROM CauseOfDeaths
where continent is not null and continent != 'Oceania'
GROUP BY continent
order by percentage_Female_smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 11. What is the percentage of male smokers in each country?

Select location, 
	   sum(population) as population,
	   sum(cast(male_smokers as float)) as Male_Smokers,
	   (cast(male_smokers as float)*100/population) as Percentage_Male_Smoker
from CauseOfDeaths
where male_smokers is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
Group by location, population, male_smokers
order by Percentage_Male_Smoker
---------------------------------------------------------------------------------------------------------------------

-- 12. What is the percentage of Male smokers in each continent?

SELECT continent, (SUM(cast(male_smokers as float)) / SUM(population)) * 100 AS percentage_Male_smokers
FROM CauseOfDeaths
where continent is not null and continent != 'Oceania'
GROUP BY continent
order by percentage_Male_smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 13. How does the prevalence of cardiovascular deaths compare to the number of COVID-19 cases or deaths in different regions?

Select location,
	   population,
	   sum(cast(total_deaths as bigint)) as total_deaths,
	   sum(cardiovasc_death_rate) as cardiovasc_death_rate
from CovidFile
where total_deaths is not null and cardiovasc_death_rate is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location, population
order by cardiovasc_death_rate desc

---------------------------------------------------------------------------------------------------------------------

-- 14. How does the prevalence of diabetes relate to the number of COVID-19 cases or deaths in different countries?

Select location,
	   population,
	   sum(cast(total_deaths as bigint)) as total_deaths,
	   sum(diabetes_prevalence) as diabetes_prevalence
from CovidFile
where total_deaths is not null and diabetes_prevalence is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location, population
order by diabetes_prevalence desc

---------------------------------------------------------------------------------------------------------------------

-- 15. How does the percentage of female smokers compare to the percentage of male smokers in each country or continent?

select continent,percentage_Male_smokers,percentage_Female_smokers
from
(
	SELECT continent,
		   (SUM(cast(male_smokers as float)) / SUM(population)) * 100 AS percentage_Male_smokers,
		   (SUM(cast(female_smokers as float)) / SUM(population)) * 100 AS percentage_Female_smokers
	FROM CauseOfDeaths
	where continent is not null and continent != 'Oceania'
	GROUP BY continent
) as Percentage_Of_Smokers
order by percentage_Male_smokers desc, percentage_Female_smokers desc

---------------------------------------------------------------------------------------------------------------------