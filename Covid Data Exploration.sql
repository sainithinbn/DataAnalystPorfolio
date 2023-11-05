/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

--Exploring the CovidDeaths Table
select * from CovidDeaths
where continent is not NULL
order by 3,4;


--Data we will be using
select location, date,total_cases,new_cases, total_deaths,population 
from CovidDeaths
where continent is not NULL
order by 1,2;



--Total Deaths vs Total Cases Ratio
--Case Fatality Rate:-Shows likelihood of dying if you contract covid in a particular country
--We are checking for India

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%India%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  round((total_cases/population)*100,3) as PercentPopulationInfected
From CovidDeaths
Where location like '%india%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  round(Max((total_cases/population))*100,3) as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc



-- Countries with Highest Death Count 

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc




-- Showing continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2



--Exploring the CovidDeaths Table
select * from CovidVaccinations
where continent is not null
order by 3,4;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
-- Using CTE to perform Calculation

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as Percentage_Populated
From PopvsVac
where Location like '%India%'




--Top N Countries by death percentage where population is greater than 100M

select location, max(population) as population,sum(cast(new_deaths as int)) as Total_Deaths ,sum(cast(new_cases as int)) Total_cases , sum(cast(new_deaths as int))*100.0/sum(cast(new_cases as int)) as Death_Percentage
from CovidDeaths
where continent is not NULL and
population>100000000
group by location
order by 5 desc;


--What is the average, minimum, and maximum values of daily cases and deaths?
select location, max(new_cases) ,max(new_cases)
from CovidDeaths
where continent is not NULL
group by location
order by 1,2;

--Month-wise Progression of Cases and Deaths for each Country
select location, year(date) as 'Year', month(date) as 'Month' , sum(cast(new_cases as Int)) as Total_Cases, sum(cast(new_deaths as Int)) as Total_Deaths
from CovidDeaths
where continent is not NULL
and location like '%India%'
group by location, year(date),  month(date)
order by 1,2,3


