/*

Queries used for Tableau Project

*/

-- 1. Total cases, Deaths, and Death Percentage of the World

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..CoviddDeaths
--Where location like '%states%'
WHERE continent is not null 
--Group By date
ORDER BY 1,2

-- 2. Total Death Count by Continents

-- European Union is part of Europe

SELECT location, SUM(cast(new_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CoviddDeaths
--Where location like '%states%'
WHERE continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income','High income','Lower middle income','Low income')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3. Highest Infection Count and Percent of Population Infected per Country

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CoviddDeaths
--Where location like '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- 4. Highest Infection Count and Percent of Population Infected by date 


SELECT Location, Population,date, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CoviddDeaths
--Where location like '%states%'
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC










