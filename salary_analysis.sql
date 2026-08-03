CREATE DATABASE ds;

SELECT * FROM ds_salaries;

-- Is there any NULL data? 
SELECT * FROM ds_salaries WHERE work_year is NULL 
	OR experience_level is NULL
    OR employment_type is NULL
    OR job_title is NULL
    OR salary is NULL
    OR salary_currency is NULL
    OR salary_in_usd is NULL
    OR employee_residence is NULL
    OR remote_ratio is NULL
    OR company_location is NULL
    OR company_size is NULL;

-- What job titles are there?
SELECT 
	DISTINCT job_title 
FROM 
	ds_salaries 
ORDER BY 
	job_title;

-- 1. What job titles are related to data analyst roles?
SELECT 
	DISTINCT job_title 
FROM 
	ds_salaries 
WHERE 
	job_title 
LIKE 
	'%data analyst%' 
ORDER BY 
	job_title;

-- 2. What is the average salary for a data analyst?
SELECT
	DISTINCT job_title,
    AVG(salary_in_usd) as avg_salary_in_usd
FROM
	ds_salaries
WHERE 
	job_title LIKE '%Data Analyst%'
GROUP BY
	job_title
ORDER BY
	avg_salary_in_usd;

    
-- 3. What is the average salary for data analysis jobs based on their experience level and employment type?
SELECT 
	experience_level, 
	employment_type, 
    ROUND((AVG(salary_in_usd) *15000)/12, 2) AS avg_salary_rp_monthly 
FROM 
    ds_salaries 
WHERE 
	job_title LIKE '%Data Analyst%'
GROUP BY 
    experience_level, 
    employment_type 
ORDER BY 
    experience_level, 
    employment_type;

-- 4. Which countries offer a minimum salary of 20,000 for full-time data analysts at a mid-level or entry-level position?
SELECT 
	company_location, 
   ROUND(AVG(salary_in_usd), 2) AS avg_sal_in_usd 
FROM 
    ds_salaries 
WHERE 
	job_title LIKE '%Data Analyst%' 
	AND employment_type = 'FT' 
    AND experience_level IN ('EN', 'MI') 
GROUP BY 
    company_location 
HAVING 
    avg_sal_in_usd >= 20000;

-- 5. In which year did the salary increase from mid to senior level have the highest increase for full-time data analyst-related jobs?
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