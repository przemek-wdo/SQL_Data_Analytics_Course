/*

SELECT
    COUNT(job_id) AS amount_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE
    job_location is not null
    AND
    job_title_short = 'Data Analyst'
GROUP BY location_category

ORDER BY location_category DESC


-- ============================ PROBLEM 1 ============================

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'high salary'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'standard salary'
        ELSE 'low salary'
    END AS salary_range
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC
LIMIT 100


-- ============================ PROBLEM 2 ============================

SELECT
COUNT (DISTINCT company_id) AS company_amount,
    CASE
        WHEN job_work_from_home = true THEN 'REMOTE'
        ELSE 'ONSITE'
    END AS working_from_home
FROM job_postings_fact
GROUP BY job_work_from_home

SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact;

*/


-- ============================ PROBLEM 3 ============================

SELECT
    job_id,
    job_title
    salary_year_avg,
    CASE
        WHEN job_title ilike '%senior%' THEN 'Senior'
        WHEN job_title ilike '%manager%' or job_title ilike '%lead%' THEN 'Lead/Manager'
        WHEN job_title ilike '%junior%' or job_title ilike '%entry%' THEN 'Junior/Entry'
        ELSE 'Not specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'Remote'
        ELSE 'Onsite'
    END AS remote_option
FROM job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY job_id
    /*
Write a SQL query using the job_postings_fact table that returns the following columns:
job_id
salary_year_avg
experience_level (derived using a CASE WHEN)
remote_option (derived using a CASE WHEN)
Only include rows where salary_year_avg is not null.