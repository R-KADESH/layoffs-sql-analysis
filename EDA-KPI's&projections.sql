-- PART 3: EDA RESULT TABLES FOR POWER BI

-- COMPANIES THAT COMPLETELY CLOSED DOWN
DROP TABLE IF EXISTS eda_closed_companies;

CREATE TABLE eda_closed_companies AS
SELECT company, percentage_laid_off 
FROM layoffs_stagging2
WHERE percentage_laid_off = 1 
ORDER BY company DESC;


-- Observing the funds raise in million for the company that closed down
DROP TABLE IF EXISTS eda_closed_companies_funds;

CREATE TABLE eda_closed_companies_funds AS
SELECT company, funds_raised_millions 
FROM layoffs_stagging2 
where  percentage_laid_off = 1
ORDER BY 2 desc;


-- companies with the biggest layoffs
DROP TABLE IF EXISTS eda_company_layoffs;

CREATE TABLE eda_company_layoffs AS
SELECT company, SUM(total_laid_off) AS total_laid_off, SUM(funds_raised_millions) AS funds_raised_millions
FROM layoffs_stagging2 
GROUP BY company 
ORDER BY 3 DESC;


-- biggest layoffs per regions 
DROP TABLE IF EXISTS eda_location_layoffs;

CREATE TABLE eda_location_layoffs AS
SELECT `location`, SUM(total_laid_off) AS total_laid_off, SUM(funds_raised_millions) AS funds_raised_millions
FROM layoffs_stagging2
GROUP BY `location`
ORDER BY 1 DESC;


-- percentage_laid_off performed during a year and the fund raised
DROP TABLE IF EXISTS eda_year_layoffs;

CREATE TABLE eda_year_layoffs AS
SELECT YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off, SUM(funds_raised_millions) AS funds_raised_millions
FROM layoffs_stagging2
GROUP BY YEAR(`date`);


-- top 5 companies per year
DROP TABLE IF EXISTS eda_top5_companies_per_year;

CREATE TABLE eda_top5_companies_per_year AS
WITH 
    company_Year AS(
    SELECT company,  YEAR(date) AS years, SUM(total_laid_off) AS total_laid
    FROM layoffs_stagging2
    WHERE YEAR(date) IS NOT NULL 
    AND total_laid_off IS NOT NULL 
    GROUP BY company, YEAR(date)
    ),
    company_Rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid DESC) AS ranking
    FROM company_Year 
    ) 
SELECT company, years, ranking, total_laid
FROM company_Rank
WHERE ranking <=5 
ORDER BY years ASC, total_laid DESC; 


-- SUM OF LAID OF PER MONTH  
DROP TABLE IF EXISTS eda_monthly_rolling;

CREATE TABLE eda_monthly_rolling AS
WITH date_cte as
    (
    SELECT SUBSTRING(date, 1, 7) as dates, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_stagging2
    WHERE date is not null
    GROUP BY dates
    ORDER BY dates asc
    )
SELECT dates, SUM(total_laid_off) OVER(ORDER BY dates) as rolling
FROM date_cte
ORDER BY dates asc;