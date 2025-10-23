SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

    SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

    SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

-- ========== PROBLEM 8 ========== --

SELECT
    job_title,
    salary_year_avg
FROM
(
    SELECT *
    FROM january_jobs
UNION ALL
    SELECT *
    FROM february_jobs
UNION ALL
    SELECT *
    FROM march_jobs
)
WHERE salary_year_avg > 70000 AND
job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC

-- ========== PROBLEM 1 ========== --

SELECT
    job_id,
    job_title,
CASE
        WHEN salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL THEN 'With salary info'
        ELSE 'Without salary info'
        END AS salary_info
FROM
    job_postings_fact
GROUP BY job_id

-- ========== PROBLEM 2 ========== --

/*
Retrieve the job id, job title short, job location, job via, skill and skill type for each job 
posting from the first quarter (January to March). Using a subquery to combine job postings from
the first quarter (these tables were created in the Advanced Section - Practice Problem 6 Video)
Only include postings with an average yearly salary greater than $70,000.

Hint
Use UNION ALL to combine job postings from January, February, and March into a single dataset.
Apply a LEFT JOIN to include skills information, allowing for job postings without associated skills to be included.
Filter the results to only include job postings with an average yearly salary above $70,000.
*/

SELECT
    quarter_jobpostings.job_id,
    quarter_jobpostings.job_title_short,
    quarter_jobpostings.job_location,
    quarter_jobpostings.job_via,
    skills_dim.skills,
    skills_dim.type,
    salary_year_avg
FROM
(
    SELECT *
    FROM january_jobs
UNION ALL
    SELECT *
    FROM february_jobs
UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter_jobpostings
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = quarter_jobpostings.job_id
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE salary_year_avg > 70000
ORDER BY quarter_jobpostings.job_id


-- ========== PROBLEM 2 ========== --

/*
Analyze the monthly demand for skills by counting the number of job postings for each skill in the 
first quarter (January to March), utilizing data from separate tables for each month. Ensure to include
skills from all job postings across these months.

Hint
-   Use UNION ALL to combine job postings from January, February, and March into a consolidated dataset.
-   Apply the EXTRACT function to obtain the year and month from job posting dates, even though the month will be implicitly known from the source table.
-   Group the combined results by skill to summarize the total postings for each skill across the first quarter.
-   Join with the skills dimension table to match skill IDs with skill names.
*/

SELECT
    skills_dim.skills as skills_name,
    COUNT (skills_dim.skill_id) as skill_count,
    EXTRACT(MONTH FROM quarter_jobpostings.job_posted_date) AS posted_months,
    EXTRACT(YEAR FROM quarter_jobpostings.job_posted_date) AS posted_year
FROM
    (
        SELECT *
        FROM january_jobs
    UNION ALL
        SELECT *
        FROM february_jobs
    UNION ALL
        SELECT *
        FROM march_jobs
    ) AS quarter_jobpostings
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = quarter_jobpostings.job_id
    LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY skills_dim.skills, posted_months, posted_year
ORDER BY skills_dim.skills, posted_months, posted_year
