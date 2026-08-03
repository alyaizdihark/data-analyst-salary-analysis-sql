# Data Analyst Salary Analysis

## Project Overview

The company wants to conduct a comprehensive analysis of salary patterns for Data Analyst-related roles in the industry, as well as understand how factors such as job title, experience level, employment type, and company location influence employee salaries.

---

## Dataset

-	Total Records: 606
-	Total Columns: 12 
-	Analysis Period: 2020–2022
-	Source: https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries 

---

## Questions

1.	What job titles are related to data analyst roles?
2.	What is the average salary for a data analyst?
3.	What is the average salary for data analysis jobs based on their experience level and employment type?
4.	Which countries offer a minimum salary of 20,000 for full-time data analysts at a mid-level or entry-level position?
5.	In which year did the salary increase from mid to senior level have the highest increase for full-time data analyst-related jobs?

---

## SQL Analysis

The analysis was performed using SQL to answer key business questions and generate actionable insights.

### Data Preparation

Checked the dataset for missing values to ensure data quality before performing the analysis.

```sql
SELECT *
FROM ds_salaries
WHERE work_year IS NULL
   OR experience_level IS NULL
   OR employment_type IS NULL
   OR job_title IS NULL
   OR salary IS NULL
   OR salary_currency IS NULL
   OR salary_in_usd IS NULL
   OR employee_residence IS NULL
   OR remote_ratio IS NULL
   OR company_location IS NULL
   OR company_size IS NULL;
```

---

### Exploratory Data Analysis

Explored all available job titles to identify roles related to Data Analyst positions.

```sql
SELECT DISTINCT job_title
FROM ds_salaries
ORDER BY job_title;
```

---

### Business Question 1

**What job titles are related to Data Analyst roles?**

```sql
SELECT DISTINCT job_title
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
ORDER BY job_title;
```

---

### Business Question 2

**What is the average salary for each Data Analyst-related role?**

```sql
SELECT
    DISTINCT job_title,
    AVG(salary_in_usd) AS avg_salary_in_usd
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY job_title
ORDER BY avg_salary_in_usd;
```

---

### Business Question 3

**What is the average monthly salary based on experience level and employment type?**

```sql
SELECT
    experience_level,
    employment_type,
    ROUND((AVG(salary_in_usd)*15000)/12,2) AS avg_salary_rp_monthly
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY experience_level, 
    employment_type;
```

---

## Business Question 4

### Which countries offer a minimum salary of USD 20,000 for full-time Entry-level or Mid-level Data Analysts?

```sql
SELECT
    company_location,
    ROUND(AVG(salary_in_usd),2) AS avg_salary_in_usd
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
    AND employment_type = 'FT'
    AND experience_level IN ('EN', 'MI')
GROUP BY company_location
HAVING avg_salary_in_usd >= 20000;
```

---

## Business Question 5

### In which year was the salary gap between Executive-level and Mid-level Data Analysts the highest?
```sql
WITH ds_1 AS (
	SELECT 
		work_year, 
		AVG(salary_in_usd) AS sal_in_usd_ex
    FROM 
		ds_salaries
    WHERE 
		employment_type = 'FT'
		AND experience_level = 'EX'
		AND job_title LIKE '%Data Analyst%'
    GROUP BY work_year
), 
ds_2 AS (
	SELECT 
		work_year, 
		AVG(salary_in_usd) AS sal_in_usd_mi
    FROM 
		ds_salaries
    WHERE 
		employment_type = 'FT'
        AND experience_level = 'MI'
        AND job_title LIKE '%Data Analyst%'
    GROUP BY work_year
) , 
t_year AS (
SELECT 
	DISTINCT work_year
FROM ds_salaries
)
SELECT 
    t_year.work_year,
    ds_1.sal_in_usd_ex,
    ds_2.sal_in_usd_mi,
    ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi AS differences
FROM t_year
LEFT JOIN ds_1
    ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2
    ON ds_2.work_year = t_year.work_year;
SELECT 
	t_year.work_year,
	ds_1.sal_in_usd_ex, 
	ds_2.sal_in_usd_mi, 
	ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi AS differences
FROM 
	t_year
LEFT JOIN ds_1 
	ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 
	ON ds_2.work_year = t_year.work_year;
```

---

## Key Insights

-	Data Analyst skills are needed in many different job titles, not only for the Data Analyst position.
-	Employees with more experience generally receive higher salaries.
-	Salary levels differ across company locations, showing that each location has different market conditions.
-	Salary growth from mid-level to senior-level changes over time, reflecting changes in market demand.

---

## Recommendations

-	Set salary ranges based on job title, experience level, employment type, and company location.
-	Review salary policies regularly to stay competitive with the job market.
-	Consider company location when planning salaries for new hires.
-	Monitor salary trends every year to support better hiring and employee retention decisions.

---

## Repository Contents

| File | Description |
|------|-------------|
| `README.md` | Project documentation |
| `salary_analysis.sql` | SQL queries |
| `salaries_dataset.csv` | Dataset |
