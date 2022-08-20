

/*Creating portfolio project database_*/
create database portfolio_project; 
use portfolio_project;

/* creating tale for covid's vaccination data*/
create table covidvaccination(
iso_code varchar(50),
continent varchar(50),
location varchar(50),
date varchar(50),
total_tests varchar(50),
new_tests varchar(50),
total_tests_per_thousand varchar(50),
new_tests_per_thousand varchar(50),
new_tests_smoothed varchar(50),
new_tests_smoothed_per_thousand varchar(50),
positive_rate varchar(50),
tests_per_case varchar(50),
tests_units varchar(50),
total_vaccinations varchar(50),
people_vaccinated varchar(50),
people_fully_vaccinated varchar(50),
total_boosters varchar(50),
new_vaccinations varchar(50),
new_vaccinations_smoothed varchar(50),
total_vaccinations_per_hundred varchar(50),
people_vaccinated_per_hundred varchar(50),
people_fully_vaccinated_per_hundred varchar(50),
total_boosters_per_hundred varchar(50),
new_vaccinations_smoothed_per_million varchar(50),
new_people_vaccinated_smoothed varchar(50),
new_people_vaccinated_smoothed_per_hundred varchar(50),
stringency_index varchar(50),
population_density varchar(50),
median_age varchar(50),
aged_65_older varchar(50),
aged_70_older varchar(50),
gdp_per_capita varchar(50),
extreme_poverty varchar(50),
cardiovasc_death_rate varchar(50),
diabetes_prevalence varchar(50),
female_smokers varchar(50),
male_smokers varchar(50),
handwashing_facilities varchar(50),
hospital_beds_per_thousand varchar(50),
life_expectancy varchar(50),
human_development_index varchar(50),
excess_mortality_cumulative_absolute varchar(50),
excess_mortality_cumulative varchar(50),
excess_mortality varchar(50),
excess_mortality_cumulative_per_million varchar(50));

/*Loading data of covidvaccination in_ potfolio_project*/
load data infile 'D:/CovidVaccination.csv'
into table covidvaccination
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

/* To see all records*/
select * from covidvaccination;

/*creating table for covid's death related data*/
create table covid_deaths2(
iso_code varchar(50),
continent varchar(50),
location varchar(50),
date varchar(50),
total_cases varchar(50),
new_cases varchar(50),
new_cases_smoothed varchar(50),
total_deaths varchar(50),
new_deaths varchar(50),
new_deaths_smoothed varchar(50),
population varchar(50),
total_cases_per_million varchar(50),
new_cases_per_million varchar(50),
new_cases_smoothed_per_million varchar(50),
total_deaths_per_million varchar(50),
new_deaths_per_million varchar(50),
new_deaths_smoothed_per_million varchar(50),
reproduction_rate varchar(50),
icu_patients varchar(50),
icu_patients_per_million varchar(50),
hosp_patients varchar(50),
hosp_patients_per_million varchar(50),
weekly_icu_admissions varchar(50),
weekly_icu_admissions_per_million varchar(50),
weekly_hosp_admissions varchar(50),
weekly_hosp_admissions_per_million varchar(50)
);

/* Loading data in table*/
load data infile 'D:/Covid_Deaths2.csv'
into table covid_deaths2
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


/*Data that we use*/
select location,`date`, total_cases, new_cases, total_deaths, population from covid_deaths2
where continent is not null;  

/*Total Cases vs Total deaths in India*/
select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths_Percentage from covid_deaths2
where location = 'india' and continent is not null;

/*Total cases vs Population in India*/
select location,`date`, population, total_cases, (total_cases/population)*100 as Infected_Percentage from covid_deaths2
where location = 'india' and  continent is not null;

/*Looking at countries with highest infected rate*/
 select location, population, max(Total_cases) as highest_infected, (max(total_cases)/population)*100 as highest_Infected_Percentage from covid_deaths2
 where continent is not null
group by location 
order by highest_Infected_Percentage desc ;

/*Looking at countries with highest death count*/
select location, max(cast(total_deaths as unsigned))  as highest_total_deaths from covid_deaths2
group by location 
order by highest_total_deaths desc  ;

/*Looking at countries with highest death count*/
select location, max(cast(total_deaths as unsigned))  as highest_total_deaths from covid_deaths2
group by location 
order by highest_total_deaths desc 
limit 10 ;

/*Sorting by continents*/
select continent, max(cast(total_deaths as unsigned))  as highest_total_deaths from covid_deaths2
group by continent 
order by highest_total_deaths desc  ;

/*Global Numbers*/
Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases)*100 as DeathsPercentage from covid_deaths2;


/* Total Deaths per Continent*/
Select continent, SUM(cast(new_deaths as unsigned)) as TotalDeathCount
From Covid_Deaths2
Where location not in ('asia', 'europe','africa','north america','south america','ocenia')
Group by continent
order by TotalDeathCount desc;


/*Percent Population Infected per country */
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Deaths2
Group by Location
order by PercentPopulationInfected desc;



/*Vaccinations per day*/
SELECT 
    date, location, new_vaccinations
FROM
    covidvaccination;

/*Total vaccination Per Country*/
SELECT 
     location, sum(new_vaccinations) as TotalVaccinations
FROM
    covidvaccination
GROUP BY 
	location
    ;

/*Creating view to store data*/
create view GlobalCovidCases as Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases)*100 as DeathsPercentage from covid_deaths2;

/* To see the view*/
SELECT * FROM portfolio_project.globalcovidcases;

/* Create view for total deaths in each continent*/
create view PerContinentDeaths as select continent, max(cast(total_deaths as unsigned))  as highest_total_deaths from covid_deaths2
group by continent 
order by highest_total_deaths desc  ;

/* To see the view*/
SELECT * FROM portfolio_project.PerContinentDeaths;

