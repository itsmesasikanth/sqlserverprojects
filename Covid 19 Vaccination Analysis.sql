/*
   Author - Sasikanth D				Date: 01-06-2023
   ------ Covid 19 Vaccination Analysis - EDA - Project ------
   I've done an analysis on CovidDeaths and CovidVaccinations.
   It was a huge data in the years between 2020 - 2023 and till date.
   There are total 300k rows I am dealing with and it is the first time I am working with a bulk data.
   I am really excited to do this project and let's get started!
*/

-- call the database.
use Project
Go

-- Count the rows in CovidVaccinations Table
Select COUNT (*)
from CovidVaccinations
Go

-- Result: Total 313312 rows in other words 300K.

---------------------------------- let's explore the CovidVaccinations  Table.---------------------------------------------

-- 1. Total vaccinations report by location

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

-- 2. sum of total vaccinations report

select SUM(cast(total_vaccinations as bigint))  as total_vaccinations,
	   SUM(cast(people_vaccinated as bigint)) as people_vaccinated,
	   sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated,
	   sum(cast(total_boosters as bigint)) as total_boosters
 from CovidVaccinations

---------------------------------------------------------------------------------------------------------------------

-- 3. Percentage of people vaccinated

select SUM(cast(people_vaccinated as bigint)) as people_vaccinated, 
	   SUM(cast(total_vaccinations as bigint)) as total_vaccinations,
	   SUM(cast(people_vaccinated as bigint))*100/SUM(cast(total_vaccinations as bigint)) as vaccination_percentage
from CovidVaccinations

---------------------------------------------------------------------------------------------------------------------

-- 4. What is the total number of vaccinations administered in each country?

Select location, sum(cast(total_vaccinations as bigint)) as Total_Vaccinations
from CovidVaccinations
where Total_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 5. How many people have been vaccinated in each country?

select location, SUM(cast(people_vaccinated as bigint)) as people_vaccinated
from CovidVaccinations
where people_vaccinated != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 6. How many people have received both doses of the vaccine (fully vaccinated) in each country?

select location, sum(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated
from CovidVaccinations
where people_fully_vaccinated != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

--7. What is the total number of booster shots administered in each country?

select location, sum(cast(total_boosters as bigint)) as Total_Boosters
from CovidVaccinations
where Total_Boosters != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------

-- 8. How many new vaccinations were recorded on each date?

select date, new_vaccinations
from CovidVaccinations
where new_vaccinations != 'NULL' and new_vaccinations != 0
order by date asc

/* Findings : On 2020-12-14 vaccinations started increasing. */

---------------------------------------------------------------------------------------------------------------------

-- 10. Which continents have the highest and lowest vaccination rates?

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

-- 11. What is the daily average number of vaccinations administered in each country?

select location, date, AVG(cast(total_vaccinations as bigint)) as Daily_vaccinations
from CovidVaccinations
where total_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location,date
order by location

---------------------------------------------------------------------------------------------------------------------

-- 12. What is the percentage of people fully vaccinated compared to the total population in each country?

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

-- 13. where the number of people fully vaccinated is higher than the total number of vaccinations administered?

select location
from CovidVaccinations
where people_fully_vaccinated > total_vaccinations
GROUP BY location

/* Findings: There are 227 countries that are people fully vaccinated higher than total vaccinations admisitered.
			 It is in genereal immpossible or becuase of Data discrepancies, Vaccine wastage or loss,
			 Multiple counting. */

---------------------------------------------------------------------------------------------------------------------

-- 14. Can we identify any countries that have successfully achieved a high vaccination coverage based on the number of people fully vaccinated?

select top 25 location, sum(cast(people_fully_vaccinated as float)) as Highly_vaccination_coverage
from CovidVaccinations
where location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America') and people_fully_vaccinated != 'NULL'
group by location
order by Highly_vaccination_coverage desc

/* Findings: There are top 25 countries that have successfully achieved a high vaccination coverage. */

---------------------------------------------------------------------------------------------------------------------
-- 15. How many total new vaccinations administered/

select sum(cast(new_vaccinations as bigint)) as New_Vaccinations
from CovidVaccinations

/* Findings: Toatl New Vaccinations are 51930317489. */

---------------------------------------------------------------------------------------------------------------------

-- 15. How many total new vaccinations administered across the countries?

select location, sum(cast(new_vaccinations as bigint)) as New_Vaccinations
from CovidVaccinations
where new_vaccinations != 'NULL' and location not in ('world', 'High income', 'Low income', 'Lower middle income', 'Upper middle income', 'Oceania',
'Africa', 'Asia','Europe','European Union','Faeroe Islands','Falkland Islands','North America','Northern Cyprus',
'Northern Ireland','Northern Mariana Islands','South America')
group by location
order by location

---------------------------------------------------------------------------------------------------------------------