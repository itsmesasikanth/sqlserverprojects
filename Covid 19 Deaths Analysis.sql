/*
   Author - Sasikanth D				Date: 01-06-2023
   ----- Covid 19 Data Analysis - EDA - Project -----
   I've done an analysis on CovidDeaths and CovidVaccinations.
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

---------------------------------- let's explore the CovidDeaths Table.---------------------------------------------

-- 1. Deaths percentage

	--i) Total Deaths Percentage 

Select sum(cast(total_cases as bigint)) as Total_Cases, sum(cast(total_deaths as bigint)) as Total_Deaths,
sum(cast(total_deaths as bigint))/sum(cast(total_cases as bigint))*100 as DeathPercentage
from CovidDeaths
where continent is not null

/* Findings: Total death percentage is 0.12985145794473 */

	--ii) Total New Deaths Percentage

Select sum(new_cases) as New_Cases, sum(new_deaths) as New_Deaths,
sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null

/* Findings: Total new deaths percentage is 0.905234617343085 */

--------------------------------------------------------------------------------------------------------------------

-- 2. Total Deaths Percentage by Location wise.

Select location,
	   date,
	   total_cases,
	   total_deaths,
	   (cast(total_deaths as float)/cast (total_cases as float))*100 as DeathPercentage
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL'
order by DeathPercentage desc

/* Findings: The highest Death Percentage located at 'Mauritania from Africa' with 2980% in 2020.
			 In 2020 from March to May the top highest percentage is 2980% recorded in March and
			 513.793103448276% recorded in May located at 'Mauritania from Africa'.
			 This is the highest percentage located ever since 2020 to 2023. */

--------------------------------------------------------------------------------------------------------------------

-- 3. Calculating the total infected people (total cases) looking at countries by population.

select location,
	   population,
	   total_cases,
	   (total_cases/population)*100 as Infected_people
from CovidDeaths
where total_cases != 'NULL'
group by location, population, total_cases
order by Infected_people desc

/* Findings: The highest infected people percentage recorded in 'Cyprus Country in the Middle East'
			 with 73.7554505712567%.
			 Followed by second highest infected people percentage recorded in 'San Marino Country in Europe'
			 with 72.0184030869694%. */
--------------------------------------------------------------------------------------------------------------------

-- 4. Calculating the total deaths percentage by population.

select location,
	   date,
	   population,
	   total_deaths,
	   max((total_deaths/population)*100) as Deaths_Percentage
from CovidDeaths
where total_deaths != 'NULL' and location not in
('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income') -- unwanted columns
group by location, date, population,total_deaths
order by location, date

--------------------------------------------------------------------------------------------------------------------

-- 5. Calculating the deaths of infected people. 

select location,
	   date,
	   total_cases,
	   total_deaths,
	   cast(total_deaths as float)/(total_cases)*100 as Infected_Deaths
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL'
group by location, date, total_cases, total_deaths
order by Infected_Deaths desc

/* Findings: Highest deaths rate which from infected people recorded in 'Mauritania Country in Africa' with 2980%. */

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

Select sum(cast(total_cases as float)) as Total_Cases,
	   sum(cast(total_deaths as float)) as Total_Deaths,
	   (sum(cast(total_deaths as float))/sum(cast(total_cases as float)))*100 as DeathPercentage
from CovidDeaths

/* Findings: The total death percentage between year 2020 - 2023 is 1.28%. */

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
			Select distinct continent, max(cast(total_cases as bigint)) as Highest_TotalCase_Value,
			ROW_NUMBER() over (order by max(cast(total_cases as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL'
		)
select continent, Highest_TotalCase_Value
from Highest_Total_Cases
where rownumber = 6

/* Findings:  Lowest Total Cases continent is Africa = 4072533 */

-- Lowest Total Deaths

with Highest_Death_Count as
		(
			Select distinct continent, max(cast(total_deaths as bigint)) as Highest_Deaths_Value,
			ROW_NUMBER() over (order by max(cast(total_deaths as bigint)) desc) as rownumber from CovidDeaths
			where continent != 'NULL' and
			group by continent
		)
select continent, Highest_Deaths_Value
from Highest_Death_Count
where rownumber = 5

/* Findings:  Lowest Deaths continent is Africa = 102595 */

---------------------------------------------------------------------------------------------------------------------

-- 14. What is the percentage of total cases and total deaths compared to the population for each country?

Select location,
	   sum(cast(total_cases as bigint)) as total_cases, sum((total_cases/population)*100) as Total_Cases_Percentage,
	   sum(cast(total_deaths as bigint)) as total_deaths, sum((total_deaths/population)*100) as Total_Deaths_Percentage
from CovidDeaths
where total_cases != 'NULL' and total_deaths != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
					   'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
					   'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location asc

---------------------------------------------------------------------------------------------------------------------

-- 15. What is the recovery rate for each country, calculated as the percentage of total recovered cases compared to the total cases?

select location,
	   sum(cast(total_cases as float)) as total_cases,
	   sum(cast(reproduction_rate as float)) as recoverd_cases,
	   (sum(cast(reproduction_rate as float))/sum(cast(total_cases as float)))*100 as Recovery_Rate
from CovidDeaths
where reproduction_rate != 'NULL' and total_cases != 'NULL' and
location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
			     'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America',
				 'Northern Cyprus','Northern Ireland','Northern Mariana Islands','South America')
group by location
order by Recovery_Rate desc

/* Findings: Highest recovery rate occured in United States with percentage of 0.017%.
			 Second highest recovery rate occured in India with percentage of 0.16%. */

---------------------------------------------------------------------------------------------------------------------