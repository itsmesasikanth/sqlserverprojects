/*
   Author - Sasikanth D				Date: 01-06-2023
   ----- Covid 19 Data Analysis - EDA - Project -----
   I've done an analysis on CovidDeaths, CovidVaccinations and Cause Of Death Analysis
   It was a huge data in the years between 2020 - 2023 and till date.
   There are total 300k rows I am dealing with and it is the first time I am working with a bulk data.
   I am really excited to do this project and let's get started!
*/

-- call the database.
use Project
Go

-- Count the rows in CovidDeaths Table
Select COUNT (*)
from CovidDeaths
Go
-- Result: Total 313312 rows in other words 300K.

-- Count the rows in CovidVaccinations Table
Select COUNT (*)
from CovidVaccinations
Go
-- Result: Total 313312 rows in other words 300K.

-- Count the rows in CauseOfDeath Table
Select COUNT (*)
from CauseOfDeaths
Go
-- Result: Total 313312 rows in other words 300K.

---------------------------------- let's explore the CovidDeaths Table.---------------------------------------------

-- 1. Deaths percentage

	--i) Total Deaths Percentage 

Select 'All Locations' as location,
	   sum(cast(total_cases as bigint)) as Total_Cases,
	   sum(cast(total_deaths as bigint)) as Total_Deaths,
	   (cast(sum(cast(total_deaths as bigint)) as float)/cast(sum(cast(total_cases as bigint)) as float))*100 as DeathPercentage
from CovidDeaths
where location is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')

/* Findings: Total death percentage is 1.30611339875379 */

	--ii) Total New Deaths Percentage

Select 'All Locations' as location,
	   sum(new_cases) as New_Cases,
	   sum(new_deaths) as New_Deaths,
	   (cast(sum(new_deaths) as float)/cast(sum(new_cases) as float))*100 as DeathPercentage
from CovidDeaths
where location is not null and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')

/* Findings: Total new deaths percentage is 0.905285204367082 */

--------------------------------------------------------------------------------------------------------------------

-- 2. Total Deaths Percentage by Location wise.

Select location,
	   sum(cast(total_cases as bigint)) as total_cases,
	   sum(cast(total_deaths as bigint)) as total_deaths,
	   (cast(sum(cast(total_deaths as bigint)) as float)/cast(sum(cast(total_cases as bigint)) as float))*100 as DeathPercentage
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by DeathPercentage desc

/* Findings: The highest Death Percentage located at 'Yemen' with 19.113685231129%.
			 The second highest percentage located at 'Sudan' with 7.45746529314799%.
			 The third highest percentage located at'Peru' with 6.60385645052546%. */

--------------------------------------------------------------------------------------------------------------------

-- 3. Calculating the total infected people (total cases) looking at countries by population.

select location,
	   sum(population) as population,
	   sum(cast(total_cases as bigint)) as total_cases,
	   (cast(sum(cast(total_cases as bigint)) as float)/sum(population))*100 as Infected_people
from CovidDeaths
where total_cases != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by Infected_people desc

/* Findings: The highest infected people percentage recorded in 'Cook Islands' with 33.3479295140835%.
			 Followed by second highest infected people percentage recorded in 'Saint Helena' with 33.2161987882193%. 
			 The Third highest infected people percentage recorded in 'San Marino' with 30.2743160869056%. */
--------------------------------------------------------------------------------------------------------------------

-- 4. Calculating the total deaths percentage by population.

select location,
	   sum(population) as population,
	   sum(cast(total_deaths as bigint)) as total_deaths,
	   (cast(sum(cast(total_deaths as bigint)) as float)/sum(population)*100) as Deaths_Percentage
from CovidDeaths
where total_deaths != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by Deaths_Percentage desc

/* Findings: Highest Deaths by population located at 'Peru' with 0.467723356137763%.
			 Second Highest Deaths by population located at 'Bulgaria' with 0.324981918331322%.
			 Third Highest Deaths by population located at 'Bosnia and Herzegovina' with 0.308591246014151%. */

--------------------------------------------------------------------------------------------------------------------

-- 5. Calculating the deaths of infected people. 

select location, 
	   sum(cast(total_cases as bigint)) as total_cases,
	   sum(cast(total_deaths as bigint)) as total_deaths,
	   (cast(sum(cast(total_deaths as float)) as float)/cast(sum(cast(total_cases as bigint)) as float))*100 as Infected_Deaths
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL' 
group by location
order by Infected_Deaths desc

/* Findings: Highest death rate from infected people recorded in 'Yemen' with 19.113685231129%.
			 Second Highest death from infected people recorded in 'Sudan' with 7.45746529314799%.
			 Third Highest death from infected people recorded in 'Peru' with 6.60385645052546%. */

--------------------------------------------------------------------------------------------------------------------

-- 6. Calculating the count of Highest Death countries.

select location,
	   MAX(cast(total_deaths as int)) as Highest_Death_Count
from CovidDeaths
where continent != 'NULL'
Group by location
order by Highest_Death_Count desc

/* Findings: Highest country is 'United States' lost 1127152 population.
			 Secong Highest country is 'Brazil' 702421 population. */

---------------------------------------------------------------------------------------------------------------------

-- 7. Calculating the count of Highest Death Continent.

select continent,
	   MAX(cast(total_deaths as int)) as Highest_Death_Count
from CovidDeaths
where continent != 'NULL'
Group by continent
order by Highest_Death_Count desc

/* Findings: Highest continent is 'North America' lost 1127152 population.
			 Secong Highest continent is 'South America' lost 702421 population.
			 Third Highest continent is 'Asia' lost 531843 population. */

---------------------------------------------------------------------------------------------------------------------

-- 8. Total Deathpercentage

Select 'All Countries' as location,
	   sum(cast(total_cases as bigint)) as Total_Cases,
	   sum(cast(total_deaths as bigint)) as Total_Deaths,
	   (cast(sum(cast(total_deaths as bigint)) as float)/cast(sum(cast(total_cases as bigint)) as float))*100 as DeathPercentage
from CovidDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')

/* Findings: The total death percentage is 1.30611339875379%. */

---------------------------------------------------------------------------------------------------------------------

-- 9. What is the total number of cases and deaths for each country?

select distinct location,
	   sum(cast(total_cases as float)) as Total_Cases,
	   sum(cast(total_deaths as float)) as Total_Deaths
from CovidDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location asc

/* I actually removed some unwanted column values that are in the location column and filtered out with where clause 
those are only countries. */

---------------------------------------------------------------------------------------------------------------------

-- 10. How many new cases and new deaths were reported on each date?

select date, new_cases, new_deaths
from CovidDeaths
where new_cases is not null and new_deaths is not null and
	  new_cases != 0 and new_deaths != 0 and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
order by date asc

---------------------------------------------------------------------------------------------------------------------

-- 11. Which countries have experienced the highest increase in cases and deaths over a specific time period?

select location,
	   MAX(cast(total_cases as int)) - MIN(cast(total_cases as int)) AS Case_Increase,
	   MAX(cast(total_deaths as int)) - MIN(cast(total_deaths as int)) AS Death_Increase
from CovidDeaths
where
    Date >= '2020-04-24' and Date <= '2022-10-17' and -- I took 2020 April to 2022 October randomly
	location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
					 'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
					 'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location
order by Case_Increase desc, Death_Increase desc

/* Findings: The highest increasing cases and deaths experienced in 'United States'.
			 The second highest increasing cases and deaths experienced in 'India'. */

---------------------------------------------------------------------------------------------------------------------

-- 12. What is the average number of new cases and new deaths per day across all countries?

select distinct location, date,
	   AVG(new_cases) as New_Cases,
	   AVG(new_deaths) as New_Deaths
from CovidDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
					   'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
					   'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location, date
order by location asc

---------------------------------------------------------------------------------------------------------------------

-- 13. Which continents have the highest and lowest total cases and deaths?

-- Highest Total Cases

with Highest_Total_Cases as
		(
			Select distinct continent, max(cast(total_cases as bigint)) as Highest_TotalCase_Value,
			ROW_NUMBER() over (order by max(cast(total_cases as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL'
			group by continent
		)
select continent, Highest_TotalCase_Value
from Highest_Total_Cases
where rownumber = 1

/* Findings:  Highest Total Cases continent is North America = 103436829 */

-- Highest Total Deaths

with Highest_Death_Count as
		(
			Select distinct continent, max(cast(total_deaths as bigint)) as Highest_Deaths_Value,
			ROW_NUMBER() over (order by max(cast(total_deaths as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL'
			group by continent
		)
select continent, Highest_Deaths_Value
from Highest_Death_Count
where rownumber = 1

/* Findings:  Highest Deaths continent is North America = 1127152 */

-- Lowest Total Cases

with Highest_Total_Cases as
		(
			Select distinct continent, max(cast(total_cases as bigint)) as Lowest_TotalCase_Value,
			ROW_NUMBER() over (order by max(cast(total_cases as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL'
			group by continent
		)
select continent, Lowest_TotalCase_Value
from Highest_Total_Cases
where rownumber = 6

/* Findings:  Lowest Total Cases continent is Africa = 4072533 */

-- Lowest Total Deaths

with Highest_Death_Count as
		(
			Select distinct continent, max(cast(total_deaths as bigint)) as Lowest_Deaths_Value,
			ROW_NUMBER() over (order by max(cast(total_deaths as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL' 
			group by continent
		)
select continent, Lowest_Deaths_Value
from Highest_Death_Count
where rownumber = 5

/* Findings:  Lowest Deaths continent is Africa = 102595 */

---------------------------------------------------------------------------------------------------------------------

-- 14. What is the percentage of total cases and total deaths compared to the population for each country?

Select location,
	   population,
	   sum(cast(total_cases as bigint)) as total_cases, sum((total_cases/population)*100) as Total_Cases_Percentage,
	   sum(cast(total_deaths as bigint)) as total_deaths, sum((total_deaths/population)*100) as Total_Deaths_Percentage
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
					   'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
					   'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location, population
order by location asc

---------------------------------------------------------------------------------------------------------------------

-- 15. What is the recovery rate for each country, calculated as the percentage of total recovered cases compared to the total cases?

select location,
	   sum(cast(total_cases as float)) as total_cases,
	   sum(cast(reproduction_rate as float)) as recovered_cases,
	   (sum(cast(reproduction_rate as float))/Cast(sum(cast(total_cases as bigint)) as float))*100 as Recovery_Rate
from CovidDeaths
where reproduction_rate != 'NULL' and total_cases != 'NULL' and
location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
			     'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
				 'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location
order by Recovery_Rate desc

/* Findings: Highest recovery rate occured in United States with percentage of 0.017%.
			 Second highest recovery rate occured in India with percentage of 0.16%. */


---------------------------------- let's explore the CovidVaccinations  Table.---------------------------------------------

-- 16. Total vaccinations report by location

select location,
	   sum(cast(total_vaccinations as bigint)) as total_vaccinations,
	   sum(cast(people_vaccinated as bigint)) as people_vaccinated,
	   sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated,
	   sum(cast(total_boosters as bigint)) as total_boosters
from CovidVaccinations
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 17. sum of total vaccinations report

select SUM(cast(total_vaccinations as bigint))  as total_vaccinations,
	   SUM(cast(people_vaccinated as bigint)) as people_vaccinated,
	   sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated,
	   sum(cast(total_boosters as bigint)) as total_boosters
 from CovidVaccinations

---------------------------------------------------------------------------------------------------------------------

-- 18. Percentage of people vaccinated

select SUM(cast(people_vaccinated as bigint)) as people_vaccinated, 
	   SUM(cast(total_vaccinations as bigint)) as total_vaccinations,
	   SUM(cast(people_vaccinated as bigint))*100/SUM(cast(total_vaccinations as bigint)) as vaccination_percentage
from CovidVaccinations

---------------------------------------------------------------------------------------------------------------------

-- 19. What is the total number of vaccinations administered in each country?

Select location, sum(cast(total_vaccinations as bigint)) as Total_Vaccinations
from CovidVaccinations
where Total_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 20. How many people have been vaccinated in each country?

select location, SUM(cast(people_vaccinated as bigint)) as people_vaccinated
from CovidVaccinations
where people_vaccinated != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 21. How many people have received both doses of the vaccine (fully vaccinated) in each country?

select location, sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated
from CovidVaccinations
where people_fully_vaccinated != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

--22. What is the total number of booster shots administered in each country?

select location, sum(cast(total_boosters as bigint)) as Total_Boosters
from CovidVaccinations
where Total_Boosters != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 23. How many new vaccinations were recorded on each date?

select date, new_vaccinations
from CovidVaccinations
where new_vaccinations != 'NULL' and new_vaccinations != 0
order by date asc

/* Findings : On 2020-12-14 vaccinations started increasing. */

---------------------------------------------------------------------------------------------------------------------

-- 24. Which continents have the highest and lowest vaccination rates?

-- Highest vaccination rate  

with Vaccination_rate as
		(
			select continent, sum(cast(people_vaccinated as bigint)) as People_vaccinated,
			row_number() over( order by sum(cast(people_vaccinated as bigint)) desc) as Rate
			from CovidVaccinations
			where continent != 'NULL' and continent != 'Oceania'
			group by continent
		)
select continent, people_vaccinated
from Vaccination_rate
where Rate = 1

-- Lowest vaccination rate  

with Vaccination_rate as
		(
			select continent, sum(cast(people_vaccinated as bigint)) as People_vaccinated,
			row_number() over( order by sum(cast(people_vaccinated as bigint)) desc) as Rate
			from CovidVaccinations
			where continent != 'NULL' and continent != 'Oceania'
			group by continent
		)
select continent, people_vaccinated
from Vaccination_rate
where Rate = 5

---------------------------------------------------------------------------------------------------------------------

-- 25. What is the daily average number of vaccinations administered in each country?

select location, date, AVG(cast(total_vaccinations as bigint)) as Daily_vaccinations
from CovidVaccinations
where total_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location,date
order by location

---------------------------------------------------------------------------------------------------------------------

-- 26. What is the percentage of people fully vaccinated compared to the total population in each country?

select location, sum(people) as FullyVaccinatedPercentage from 
(
select location, (cast(people_fully_vaccinated as bigint)*100/population) as people
from CovidVaccinations
where people_fully_vaccinated != 'NULL'
group by location, people_fully_vaccinated, population
) as Fully_people_vaccinated
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 27. where the number of people fully vaccinated is higher than the total number of vaccinations administered?

select location
from CovidVaccinations
where people_fully_vaccinated > total_vaccinations
GROUP BY location

/* Findings: There are 227 countries that are people fully vaccinated higher than total vaccinations admisitered.
			 It is in genereal immpossible or becuase of Data discrepancies, Vaccine wastage or loss,
			 Multiple counting. */

---------------------------------------------------------------------------------------------------------------------

-- 28. Can we identify any countries that have successfully achieved a high vaccination coverage based on the number of people fully vaccinated?

select top 25 location, sum(cast(people_fully_vaccinated as float)) as Highly_vaccination_coverage
from CovidVaccinations
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and people_fully_vaccinated != 'NULL'
group by location
order by Highly_vaccination_coverage desc

/* Findings: There are top 25 countries that have successfully achieved a high vaccination coverage. */

---------------------------------------------------------------------------------------------------------------------
-- 29. How many total new vaccinations administered/

select sum(cast(new_vaccinations as bigint)) as New_Vaccinations
from CovidVaccinations

/* Findings: Toatl New Vaccinations are 51930317489. */

---------------------------------------------------------------------------------------------------------------------

-- 30. How many total new vaccinations administered across the countries?

select location, sum(cast(new_vaccinations as bigint)) as New_Vaccinations
from CovidVaccinations
where new_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------- let's explore the Cause OF Death Analysis  Table.---------------------------------------------

-- 31. Total no.of Age group people.

select sum(median_age) as MediumAge,
	   sum(aged_65_older) as Age65Group,
	   SUM(aged_70_older) as Age70Group
from CauseOfDeaths

---------------------------------------------------------------------------------------------------------------------

-- 32.Number of Medium Age group People in each country.

Select location, sum(median_age) as median_age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and median_age is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 33. Number of 65 Age group People in each country.

Select location, sum(aged_65_older) as Age65Group
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_65_older is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 34. Number of 70 Age group People in each country.

Select location, SUM(aged_70_older) as Age70Group
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_70_older is not null
group by location 
order by location

---------------------------------------------------------------------------------------------------------------------

-- 35. Percentage of Medium Age group people got COVID 19

select location, sum(median_age)*100/population as PercentageOfMediumAge
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and median_age is not null
group by location, population, median_age
order by PercentageOfMediumAge desc

---------------------------------------------------------------------------------------------------------------------

-- 36. Percentage of 65 Age group People got COVID 19

select location, sum(aged_65_older)*100/population as PercentageOf65Age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_65_older is not null
group by location, population, aged_65_older
order by PercentageOf65Age desc

---------------------------------------------------------------------------------------------------------------------

-- 37. Percentage of 70 Age group People got COVID 19

select location, sum(aged_70_older)*100/population as PercentageOf70Age
from CauseOfDeaths
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and aged_70_older is not null
group by location, population, aged_70_older
order by PercentageOf70Age desc

---------------------------------------------------------------------------------------------------------------------

-- 38. Female and Male Smokers in each country.

select location,
	   sum(cast(female_smokers as float)) as Female_Smokers,
	   sum(cast(male_smokers as float)) as Male_Smokers
from CauseOfDeaths
where female_smokers is not null and male_smokers is not null
group by location
order by Female_Smokers desc, Male_Smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 39. What is the percentage of female smokers in each country?

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

-- 40. What is the percentage of female smokers in each continent?

SELECT continent, (SUM(cast(female_smokers as float)) / SUM(population)) * 100 AS percentage_Female_smokers
FROM CauseOfDeaths
where continent is not null and continent != 'Oceania'
GROUP BY continent
order by percentage_Female_smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 41. What is the percentage of male smokers in each country?

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

-- 42. What is the percentage of Male smokers in each continent?

SELECT continent, (SUM(cast(male_smokers as float)) / SUM(population)) * 100 AS percentage_Male_smokers
FROM CauseOfDeaths
where continent is not null and continent != 'Oceania'
GROUP BY continent
order by percentage_Male_smokers desc

---------------------------------------------------------------------------------------------------------------------

-- 43. How does the prevalence of cardiovascular deaths compare to the number of COVID-19 cases or deaths in different regions?

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

-- 44. How does the prevalence of diabetes relate to the number of COVID-19 cases or deaths in different countries?

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

-- 45. How does the percentage of female smokers compare to the percentage of male smokers in each country or continent?

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