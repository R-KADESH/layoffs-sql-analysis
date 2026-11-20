# layoffs-sql-analysis
📉 Layoffs SQL Analysis

"Prove all things; hold fast that which is good." (1 Thessalonians 5:21) Good advice for faith, and surprisingly good advice for data cleaning.

Thousands of people lost their jobs in the global layoff wave. This project asks what the numbers say, using plain MySQL and a Power BI dashboard.

Honest disclaimer: no spreadsheet can measure the stress of a layoff, and this project doesn't try to. It simply tells the story of the numbers.

Which companies, industries and places lost the most jobs?
When did the wave hit hardest?
Did raising a lot of money protect a company? (Spoiler: some companies raised millions and still closed.)
🧰 Tools

MySQL, CTEs, Window functions, Power BI, Git

📁 What is inside
File	What it does
01_cleaning.sql	Staging table, duplicate removal, data type fixes, standardizing text
02_eda.sql	Exploratory queries: closures, rankings, yearly and monthly trends
03_eda_tables_for_powerbi.sql	Saves the results as eda_ tables ready for Power BI

Run them in this order. Yes, order matters. Like a good morning routine.

🧹 Cleaning, in short
Worked on a staging copy, so the raw data stays untouched.
Found and removed duplicates with ROW_NUMBER() OVER (PARTITION BY ...).
Converted percentage_laid_off from text to a number.
Filled missing industries from other rows of the same company.
Removed trailing dots from country names (United States. is not a different country).
🔍 Techniques shown
GROUP BY and aggregations
DENSE_RANK() for the top 5 companies per year
A rolling total per month with SUM() OVER (ORDER BY ...)
CTEs, self-joins and CREATE TABLE ... AS

💡 Key findings

(Fill in with your own numbers, for example:)

The peak layoff month was [month year], with [number] people affected.
The industry with the most layoffs was [industry].
[number] companies shut down completely, even after raising [amount] in funding.
⚠️ Limits of this data
It only includes publicly reported layoffs, mostly from the tech sector.
Several rows have missing values (I kept them as NULL instead of guessing).
Numbers are a snapshot of the dataset, not the whole job market.
📚 Source

Dataset: Layoffs 2022 on Kaggle (Add a line about any guided course or tutorial you followed.)



"And whatsoever ye do, do it heartily, as to the Lord, and not unto men." (Colossians 3:23)

Every query here was written with care, because excellence is a form of gratitude. Behind each row in this table is a real person, and I try to remember that.


Caleb TAPOPHILE, Digital Systems Engineering student, Cameroon 🇨🇲 LinkedIn · GitHub

Feedback, corrections and better queries are welcome. Iron sharpens iron, and SQL sharpens SQL.
