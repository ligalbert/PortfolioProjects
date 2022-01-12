/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT Location, date, total_cases,new_cases, total_deaths, population FROM PortfolioProject..CoviddDeaths
ORDER BY 1,2

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
ORDER BY 1,2


--Looking at Total cases vs Total deaths
--Shows likelihood of dying if infected with COVID in your country 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPercentage FROM PortfolioProject..CoviddDeaths 
WHERE location = 'United States' AND continent is not null
ORDER BY 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT Location, date, population, total_cases, (total_cases/population)* 100 AS PercentPopulationInfected FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'Ecuador'
ORDER BY 1,2

-- Countries with Highest Infection Rate compared to Population 
SELECT Location, population, MAX(total_cases) AS HighestInfection, MAX(total_cases/population)* 100 AS PercentPopulationInfected  FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'Ecuador'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Countries with Highest Death Count per Populationn 
SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'United States'
WHERE continent is not null 
GROUP BY location, population
ORDER BY TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'Ecuador'
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount DESC



--Global Numbers per date
SELECT date, SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths as int)) AS Total_Deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'United States'
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2

-- Total COVID Cases, Deaths, and Death percentage of the world 
SELECT SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths as int)) AS Total_Deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage 
FROM PortfolioProject..CoviddDeaths 
--WHERE location = 'United States'
WHERE continent is not null 
--GROUP BY date
ORDER BY 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CoviddDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

FROM PortfolioProject..CoviddDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null 
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated/(population))*100 FROM PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
drop table if exists  #PercentPopulationVaccinated 
CREATE TABLE #PercentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100

FROM PortfolioProject..CoviddDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date
--WHERE dea.continent is not null 
--order by 2,3

SELECT *, (RollingPeopleVaccinated/(population))*100 FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CoviddDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 






