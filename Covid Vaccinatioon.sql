Select *
From PortfolioProject..CovidDeaths
Order by 3,4

--Select *
--From PorfolioProject..CovidVaccinations
--Order by 3,4

-----------------------------------------------------------------------------------
Select Location, date, total_cases, new_cases, total_deaths
From PortfolioProject..CovidDeaths
order by 1,2

------------------------------------------------------------------------------------
Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

------------------------------------------------------------------------------------------
Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2
-------------------------------------------------------------------------------------------

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as int))/ SUM(new_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where locaiton like '%states%'
where continent is not null
Group by date
order by 1,2

-------------------------------------------------------------------------------------------

Select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated -- as bigint
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location= vac.location
	and dea.date= vac.date
--where dea.locatiton like '%states%
where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent, location, Date, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated -- as bigint
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location= vac.location
	and dea.date= vac.date
--where dea.locatiton like '%states%
where dea.continent is not null
)
select *
From PopvsVac


-- TEMP TABLE
Create Table #PercentPopulationVaccinated
( 
continent nvarchar(255),
location nvarchar(255),
Date datetime,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated -- as bigint
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location= vac.location
	and dea.date= vac.date
--where dea.locatiton like '%states%
where dea.continent is not null
order by 2,3

select *
From #PercentPopulationVaccinated


--------Creating View to store data for later visualization--------------------------------------------------------------------------------
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated -- as bigint
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location= vac.location
	and dea.date= vac.date
where dea.continent is not null
