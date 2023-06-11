SELECT iso_code, continent, location, [date], total_cases, new_cases, new_cases_smoothed, total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, total_tests, new_tests, total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters, new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_boosters_per_hundred, new_vaccinations_smoothed_per_million, new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred, stringency_index, population_density, median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index, population, excess_mortality_cumulative_absolute, excess_mortality_cumulative, excess_mortality, excess_mortality_cumulative_per_million
FROM CovidProject.dbo.owid_covid_data;

-- select data 

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject.dbo.owid_covid_data
order by 1,2

-- Looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From CovidProject.dbo.owid_covid_data
Where location like '%states%'
order by 1,2

-- Looking at total cases vs population

Select Location, date, total_cases,Population, (total_cases/population)* 100 as DeathPercentage
From CovidProject.dbo.owid_covid_data
Where location like '%states%'
order by 1,2

-- Looking at Countires with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
From CovidProject.dbo.owid_covid_data
Group by Location, Population 
order by PercentpopulationInfected desc

-- Showing countries with highest death count per population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.owid_covid_data
Where continent is not null
Group by Location
order by TotalDeathCount desc


-- Break things dwon by continent

-- Showing continents with highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.owid_covid_data
Where continent is not null
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject.dbo.owid_covid_data
--Where location like '%states%'
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select continent, location, date, population, new_vaccinations
, SUM(new_vaccinations) OVER (Partition by Location Order by location, Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject.dbo.owid_covid_data
order by 2,3


-- Temp TABLE 
DROPT Table if exists #PrecentPopulationVaccinated(
Create Table #PrecentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255)
Date datatime
Population numeric
New_vaccinations numeric
RollingPeopleVaccinated numeric
)
 
Insert into #PrecentPopulationVaccinated
Select *, (RollingPeopleVaccinated/Population) * 100
From #PrecentPopulationVaccinated

-- Creating view to store data for later visualization


