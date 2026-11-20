
-- LAYOFFS PROJECT
-- PART 1: DATA CLEANING
-- PART 2: EXPLORATORY DATA ANALYSIS

-- PART 1: DATA CLEANING

-- ROAD MAP 
-- 0. Fixed data types 
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways


-- INITIAL INSPECTION (before cleaning)

-- exploratory data analysis : a series of carefully choosen queries to ensure that you have insight about your data to know how you will do the clearning
-- General view or glance through 
SELECT * FROM layoffs_stagging1;
 

-- General view or glance through 
-- types inspection
DESCRIBE layoffs_stagging1; 
-- an anomaly detected percenpercentage_laid_off is a text rather than floats, the other columns has the right data 

-- identifing NULLS 

SELECT 
    SUM(company IS NULL OR UPPER(company) = " NULL") AS company,
    SUM(location IS NULL) AS location,
    SUM(industry IS NULL) AS industry,
    SUM(total_laid_off IS NULL) AS total_laid_off,
    SUM(percentage_laid_off IS NULL OR UPPER(percentage_laid_off) = "NULL") AS percentage_laid_off,
    SUM(date IS NULL) AS date,
    SUM(stage IS NULL OR UPPER(stage) = 'UNKNOWN') AS stage,
    SUM(country IS NULL) AS country,
    SUM(funds_raised_millions IS NULL) AS funds_raised_millions
FROM layoffs;


SELECT 
    company, 
    location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    date, 
    stage, 
    country, 
    funds_raised_millions, 
    COUNT(*) AS duplicate_count
FROM layoffs
GROUP BY 
    company, 
    location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    date, 
    stage, 
    country, 
    funds_raised_millions
HAVING COUNT(*) > 1;


-- 0. FIXED DATA TYPES

-- modifing the datatype of the percentage_laid_off

DESCRIBE layoffs_stagging1;
SELECT * FROM layoffs_stagging1;

UPDATE layoffs_stagging1
set percentage_laid_off = NULL
WHERE UPPER(percentage_laid_off) = "";

ALTER TABLE layoffs_stagging1
MODIFY COLUMN percentage_laid_off FLOAT NULL;


-- 1 remove duplicates from the data 

ALTER TABLE layoffs_stagging1 ADD row_num INT;

SELECT * FROM layoffs_stagging1; 

CREATE TABLE layoffs_stagging2 
LIKE layoffs_stagging1 ;

INSERT INTO layoffs_stagging2 (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions, row_num
) 
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions,
ROW_NUMBER() 
    OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) 
FROM layoffs_stagging1;

SELECT * FROM layoffs_stagging2 
WHERE row_num > 1; 

DELETE FROM layoffs_stagging2 
WHERE row_num > 1;


-- 2. STANDARDIZE DATA AND FIX ERRORS

-- 2 standardize the column 

SELECT DISTINCT country
FROM layoffs_stagging2 
ORDER BY country ASC;

UPDATE layoffs_stagging2 
SET country = TRIM(TRAILING "." FROM country);

DESCRIBE layoffs_stagging2;

-- 3. LOOK AT NULL VALUES AND SEE WHAT 
SELECT DISTINCT industry
FROM layoffs_stagging2;

SELECT * FROM layoffs_stagging2 
WHERE industry is NULL OR industry = "";

SELECT * FROM layoffs_stagging2 
where company like 'Airbnb%';

-- from other location we notice that airbnb is in the travel industry 

SELECT DISTINCT t1.company, t1.industry, t2.company, t2.industry FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
ON t1.company = t2.company 
WHERE t1.industry = t2.industry or t1.industry is NULL;

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry is NULL or t1.industry = '')
AND (t2.industry is NOT NULL AND t2.industry <> '');

SELECT * from layoffs_stagging2
WHERE company = 'Airbnb';

UPDATE layoffs_stagging2
SET percentage_laid_off = 0
WHERE total_laid_off = 0
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');
-- 4. REMOVE ANY COLUMNS AND ROWS THAT ARE NOT NECESSARY

ALTER TABLE layoffs_stagging2 
DROP COLUMN row_num;


