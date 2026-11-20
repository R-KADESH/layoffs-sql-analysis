-
-- PART 2: EXPLORATORY DATA ANALYSIS

-- finding the total laid off in the terms if percentage_laid_off
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs_stagging1 
WHERE percentage_laid_off IS NOT NULL; 

-- COMPANIES THAT COMPLETELY CLOSED DOWN
SELECT company, percentage_laid_off 
FROM layoffs_stagging1
WHERE percentage_laid_off = 1 
ORDER BY company DESC;


-- Observing the funds raise in million for the company that closed down
SELECT company, funds_raised_millions 
FROM layoffs_stagging1 
where  percentage_laid_off = 1
ORDER BY 2 desc;

-- companies with the biggest layoffs
SELECT company, SUM(total_laid_off), SUM(funds_raised_millions)
FROM layoffs_stagging1 
GROUP BY company 
ORDER BY 3 DESC;

-- biggest layoffs per regions 

SELECT `location`, SUM(total_laid_off), SUM(funds_raised_millions)
FROM layoffs_stagging1
GROUP BY `location`
ORDER BY 1 DESC;

SELECT * from layoffs_stagging1
where `location` = "Vilnius"

-- percentage_laid_off performed during a year and the fund raised

SELECT YEAR(`date`), SUM(total_laid_off), SUM(funds_raised_millions)
FROM layoffs_stagging1
GROUP BY YEAR(`date`);


WITH 
    company_Year AS(
    SELECT company,  YEAR(date) AS years, SUM(total_laid_off) AS total_laid
    FROM layoffs_stagging1
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

--ING SUM OF LAID OF PER MONTH  

WITH date_cte as
    (
    SELECT SUBSTRING(date, 1, 7) as dates, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_stagging1
    WHERE date is not null
    GROUP BY dates
    ORDER BY dates asc
    )
SELECT dates, SUM(total_laid_off) OVER(ORDER BY dates) as rolling
FROM date_cte
ORDER BY dates asc;

-- JOB DONE !!!