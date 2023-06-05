/*
   Author - Sasikanth D				Date: 01-06-2023
   --Covid 19 Data Analysis - EDA - Project--
   I have covered analysis on CovidDeaths and CovidVaccinations for that I have divide into two tables to work on it.
   It was a huge data in the years between 2020 - 2023 and till date.
   There are total 300k rows I am dealing with and it is first time I am working with bulk data.
   I am really exited to do this project and let's get started.
*/

-- call the database.
use Project
Go

-- Call the tables and show the count of rows.
Select COUNT (*)
from CovidDeaths
Go
-- Result: Total 313312 rows in other words 300K.

Select COUNT (*)
from CovidVaccinations
Go
-- Result: Total 313312 rows in other words 300K.

---------------------------------- let's explore the CovidDeaths Table.--------------------------------------------- 

-- 1. Select data that we are going to be using.

Select location,
	   date,
	   population,
	   total_cases,
	   total_deaths
from CovidDeaths
order by 1,2

--------------------------------------------------------------------------------------------------------------------

-- 2. Using Total cases Vs Total Deaths Calculate the death percentage.

Select total_deaths,
	   total_cases
from CovidDeaths

Exec sp_help 'CovidDeaths'  -- Check the data types of required columns.

/* Here total_deaths and total_cases data types are in (nvarchar) so wee need to change the data type into int
to get the result */

Select location,
	   date,
	   total_cases,
	   total_deaths,
	   (cast(total_deaths as float)/cast (total_cases as float))*100 as DeathPercentage
from CovidDeaths
where total_deaths != 'NULL'
order by 1,2

/* Findings:
 The death percentage is in between 1% to 30%.
 The Highest Death percentage is recorded at YEMEN city.
 The lowest Death percentage is recorded at several cities like U.S, Spain, Singapore, Bhutan, etc. */

-------------------------------------------------------------------------------------------------------------------

-- 3. Looking at Total cases Vs Population and Calculate the percentage of got Covid based on population.

Select location,
	   date,
	   population,
	   total_cases, 
	   max((total_deaths/population)*100) as CovidPercentage
from CovidDeaths
where total_deaths != 'NULL'--and location like '%Jordan%'
Group by location, date, total_cases, population
order by 1,2

/* Findings:
  Highest got CovidPercentage is 9.74% located at Jordan.
  Most of highest cases located at Jordan with 9%, 8%, 7%, 6%, 5% and so on.
  Majorly located at Sri Lanka - 9.16%, Jordan - 9.74%, Afghanistan - 9.72% */

-------------------------------------------------------------------------------------------------------------------

-- 4. Looking at countries with highest infection rate compareed to population.

Select location,
	   population,
	   max(total_cases) as HighlyInfected,
	   max((total_cases/population))*100 as CovidPercentageInfected
from CovidDeaths
Where location like'%India%'
Group by location, population
order by CovidPercentageInfected desc

/* Findings:
  Highest Covid Infected Countries are Cyprus and San Marino with 73% and 72%.
  Second highest infected countries are Austria, Brunei, Faeroe Islands, Slovenia, Gibraltar,
  martinique, South Korea, Andorra with in between 60% - 67%.
  India got Infected 3.17% in between 2020 - 2023. */

-------------------------------------------------------------------------------------------------------------------

-- 5. Showing countries with highest death count per population

Exec sp_help 'CovidDeaths'  -- Check the data types of required columns.

Select location,
	   max(cast(total_deaths as int)) as HighlyDeathCount
from CovidDeaths
where continent != 'NULL'
Group by location
order by HighlyDeathCount desc

/* Findings:
  Highest Death count occurs at United States. */

-------------------------------------------------------------------------------------------------------------------

-- 6. Showing Continents with highest death count per population

Select continent,
	   max(cast(total_deaths as int)) as HighlyDeathCount
from CovidDeaths
where continent != 'NULL'
Group by continent
order by HighlyDeathCount desc

/* Findings:
  North America rated for Highest Death count with 1.1 Million over across all continents. */

-------------------------------------------------------------------------------------------------------------------

-- 7. Calculate the new cases and new deaths percentage.

select sum(new_cases) as TotalCases,
	   sum(cast(new_deaths as int)) as TotalDeaths,
	   sum(cast(new_deaths as int))/sum(new_cases)*100 as NewDeathPercentage
from CovidDeaths
where continent is not null
--Group by date
order by  1,2 --NewDeathPercentage desc  -- , to order by date

/* Findings:
  Highest new deaths percentage is 29.99%. */

--------------------------------- let's explore the CovidVaccinations Table.----------------------------------------

-- Looking at Total Population and Vaccinations

Select cd.continent,
	   cd.location,
	   cd.date, 
	   cd.population, 
	   cv.new_vaccinations,
	   SUM(isnull(cast(cv.new_vaccinations as bigint),0))
	   over (partition by cd.location order by cd.location, cd.date) as TotalVaccinatedPeople
from CovidDeaths cd
join CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
where cv.continent is not null
order by 2,3

--------------------------------------------------------------------------------------------------------------------

-- Using CTE

with popvsvac (continent, location, date, population, new_vaccinations,TotalVaccinatedPeople)
as
(
Select cd.continent,
	   cd.location,
	   cd.date, 
	   cd.population, 
	   cv.new_vaccinations,
	   SUM(isnull(cast(cv.new_vaccinations as bigint),0))
	   over (partition by cd.location order by cd.location, cd.date) as TotalVaccinatedPeople
from CovidDeaths cd
join CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
where cv.continent is not null
)
select *, (TotalVaccinatedPeople/population)*100
from popvsvac

--------------------------------------------------------------------------------------------------------------------

-- Create a Temp Table 

Drop table if exists #PeopleVaccinatedPercent
create table #PeopleVaccinatedPercent
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
TotalVaccinatedPeople numeric
)
Insert into #PeopleVaccinatedPercent
Select cd.continent,
	   cd.location,
	   cd.date, 
	   cd.population, 
	   cv.new_vaccinations,
	   SUM(isnull(cast(cv.new_vaccinations as bigint),0))
	   over (partition by cd.location order by cd.location, cd.date) as TotalVaccinatedPeople
from CovidDeaths cd
join CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
--where cv.continent is not null
--order by 2,3

select *, (TotalVaccinatedPeople/population)*100
from #PeopleVaccinatedPercent

--------------------------------------------------------------------------------------------------------------------

-- Create a view for the later visualizations

create view PeopleVaccinatedPercent as
Select cd.continent,
	   cd.location,
	   cd.date, 
	   cd.population, 
	   cv.new_vaccinations,
	   SUM(isnull(cast(cv.new_vaccinations as bigint),0))
	   over (partition by cd.location order by cd.location, cd.date) as TotalVaccinatedPeople
from CovidDeaths cd
join CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
where cv.continent is not null

Select *
from PeopleVaccinatedPercent