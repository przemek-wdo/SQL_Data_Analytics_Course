--========================================
-- SUBQUERY PRACTICE RUN 1 
SELECT 
    company_id,
    company_dim.name AS company_names
    
FROM 
    company_dim
WHERE 
    company_id IN 
    (
        SELECT 
            company_id
        FROM 
            job_postings_fact
        WHERE 
            job_postings_fact.job_no_degree_mention = true
        ORDER BY
            company_id
    )


--========================================
-- CTE PRACTICE RUN

WITH 
    company_job_count AS (
        SELECT
            company_id,
            COUNT(*) AS jobs_amount
        FROM
            job_postings_fact
        GROUP BY
            company_id
        ORDER BY
            jobs_amount DESC
    )

    SELECT
        company_dim.name AS company_names,
        jobs_amount
    FROM company_dim
    LEFT JOIN 
        company_job_count ON company_job_count.company_id = company_dim.company_id
    ORDER BY jobs_amount DESC

    --=====================================
    --PRACTICE PROBLEM 7:
-- Find the count of the number of remote job postings per skill
--    - Display the top 5 skills in descending order by their demand in remote jobs
--    - Include skill ID, name, and count of postings requiring the skill
--    - Why? Identify the top 5 skills in demand for remote jobs

WITH remote_job_skills AS
    (
    SELECT
        skill_id,
        count (*) as skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN 
        job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE
            job_postings.job_work_from_home = TRUE
            AND
            job_postings.job_title_short = 'Data Analyst'
            
    GROUP BY
        skill_id
    )

SELECT
    skills.skill_id,
    skillS.skills as skill_name,
    skill_count
FROM
    remote_job_skills
    INNER JOIN
        skills_dim as skills
        ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 10

--=================================Problem 1=================================--
/*Subqueries
Problem Statement
Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table
and then join this result with the skills_dim table to get the skill names.

Hint
-   Focus on creating a subquery that identifies and ranks (ORDER BY in descending order) 
    the top 5 skill IDs by their frequency (COUNT) of mention in job postings.
-   Then join this subquery with the skills table (skills_dim) to match IDs to skill names.
*/
SELECT
top_skills.skill_id,
skills_dim.skills,
top_skills.jobs_amount
FROM
    skills_dim
    INNER JOIN 
        (
            SELECT
                skill_id,
                COUNT(job_id) as jobs_amount
            FROM
                skills_job_dim
            GROUP BY
                skill_id
            ORDER BY
                jobs_amount DESC
            LIMIT 5
        ) AS top_skills
        ON top_skills.skill_id = skills_dim.skill_id

--=================================Problem 2=================================--
/*
Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying
the number of job postings they have. Use a subquery to calculate the total job postings per company.
A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job 
postings is between 10 and 50, and 'Large' if it has more than 50 job postings. Implement a subquery 
to aggregate job counts per company before classifying them based on size.

Hint
Aggregate job counts per company in the subquery. This involves grouping by company and counting job postings.
Use this subquery in the FROM clause of your main query.
In the main query, categorize companies based on the aggregated job counts from the subquery with a CASE statement.
The subquery prepares data (counts jobs per company), and the outer query classifies companies based on these counts.
*/
SELECT
    name,
    jobs_amount,
    CASE
        WHEN jobs_amount < 10 THEN 'Small company'
        WHEN jobs_amount < 50 THEN 'Medium company'
        ELSE 'Large company'
        END AS Company_size
FROM
    (
        SELECT
            company_dim.name,
            company_dim.company_id,
            COUNT(job_id) as jobs_amount
        FROM
            company_dim
            INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
        GROUP BY company_dim.company_id
    )
ORDER BY jobs_amount desc


--=================================Problem 3=================================--
/*
Problem Statement
Your goal is to find the names of companies that have an average salary greater than the overall average salary across all job postings.

You'll need to use two tables: company_dim (for company names) and job_postings_fact (for salary data). The solution requires using subqueries.
*/
SELECT
    company_dim.name,
    salaries_avg.company_avg_salary
FROM
    company_dim
    INNER JOIN
        (
            SELECT
                company_id,
                AVG(salary_year_avg) as company_avg_salary
            FROM
                job_postings_fact
            GROUP BY company_id
        ) as salaries_avg 
        ON company_dim.company_id = salaries_avg.company_id
WHERE
salaries_avg.company_avg_salary >
(
    SELECT AVG(salary_year_avg)
    FROM job_postings_fact
)
ORDER BY salaries_avg.company_avg_salary DESC



--=================================Problem 1=================================--
/*
Identify companies with the most diverse (unique) job titles. Use a CTE to count 
the number of unique job titles per company, then select companies with the highest
diversity in job titles.

Hint
Use a CTE to count the distinct number of job titles for each company.
-   After identifying the number of unique job titles per company, join this result with
    the company_dim table to get the company names.
-   Order your final results by the number of unique job titles in descending order to 
    highlight the companies with the highest diversity.
-   Limit your results to the top 10 companies. This limit helps focus on the companies with
    the most significant diversity in job roles. Think about how SQL determines which companies
    make it into the top 10 when there are ties in the number of unique job titles.
*/

WITH unique_title_counter AS
(
    SELECT
    company_id,
    COUNT  ( DISTINCT job_title) as unique_amount
    FROM
    job_postings_fact
    GROUP BY company_id
)

SELECT
    name,
    unique_amount
FROM
    company_dim
    INNER JOIN unique_title_counter ON unique_title_counter.company_id = company_dim.company_id
ORDER BY unique_amount DESC
LIMIT 10

--=================================Problem 2=================================--
/*
Problem Statement
Explore job postings by listing job id, job titles, company names, and their average salary rates,
while categorizing these salaries relative to the average in their respective countries. 
Include the month of the job posted date. Use CTEs, conditional logic, and date functions,
to compare individual salaries with national averages.

Hint
-   Define a CTE to calculate the average salary for each country. This will serve as a foundational dataset for comparison.
-   Within the main query, use a CASE WHEN statement to categorize each salary as 'Above Average'
    or 'Below Average' based on its comparison (>) to the country's average salary calculated  in the CTE.
-   To include the month of the job posting, use the EXTRACT function on the job posting date within your SELECT statement.
-   Join the job postings data (job_postings_fact) with the CTE to compare individual salaries to the average. Additionally,
    join with the company dimension (company_dim) table to get company names linked to each job posting.
*/

WITH avg_salary_country as
    (
        SELECT 
            job_country,
            AVG(salary_year_avg) as avg_for_country
        FROM job_postings_fact
        GROUP BY job_country
    )

SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name,
    job_postings_fact.job_country,
    job_postings_fact.salary_year_avg AS salary_rate,
    CASE
        WHEN salary_year_avg < avg_for_country 
        THEN 'Above Average'
        ELSE 'Below Average'
        END AS salary_comparison_per_country,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS posting_month
FROM
    job_postings_fact
    INNER JOIN 
        avg_salary_country 
        ON avg_salary_country.job_country = job_postings_fact.job_country
    INNER JOIN
        company_dim
        ON company_dim.company_id = job_postings_fact.company_id
WHERE
    salary_year_avg IS NOT NULL
ORDER BY posting_month DESC

--=================================Problem 3=================================--

/*
Problem Statement
Your goal is to calculate two metrics for each company:
1.   The number of unique skills required for their job postings.
2.   The highest average annual salary among job postings that require at least one skill.

Your final query should return the company name, the count of unique skills, and the highest salary. 
For companies with no skill-related job postings, the skill count should be 0 and the salary should be null.

Hint
    Use two Common Table Expressions (CTEs) to organize your query:
    -   #️⃣ required_skills - 1st CTE:
        *   Goal: To count the distinct skill_id for each company.
        *   Method: Use LEFT JOIN starting from company_dim. This ensures all 
            companies are included in your result, even if they have no job postings or required skills.

    -   💰 max_salary - 2nd CTE:
        *   Goal: To find the highest salary_year_avg for each company.
        *   Constraint: This calculation must only include jobs that have at least one skill associated with them.
            You can achieve this by using INNER JOINs or filtering with a WHERE clause.

    Combine the company_dim table with your two CTEs using LEFT JOINs. This will bring together the skill count for 
    all companies and the salary data for those that have skilled positions.
*/

WITH required_skills AS
    (
        SELECT
            companies.company_id,
            COUNT (DISTINCT skills_to_job.skill_id) AS unique_skill_required
        FROM
            company_dim AS companies
            LEFT JOIN job_postings_fact AS job_postings ON companies.company_id = job_postings.company_id
            LEFT JOIN skills_job_dim AS skills_to_job ON job_postings.job_id = skills_to_job.job_id
        GROUP BY companies.company_id
    ),

max_salary AS
    (
        SELECT
            MAX(job_postings.salary_year_avg) AS max_salary,
            job_postings.company_id
        FROM
            job_postings_fact AS job_postings
        WHERE 
            job_postings.job_id IN 
                (
                    SELECT job_id 
                    FROM skills_job_dim
                )
        GROUP BY job_postings.company_id
    )

SELECT
    companies.name,
    unique_skill_required,
    max_salary

FROM
    company_dim AS companies
    LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
    LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
WHERE max_salary IS NOT NULL
ORDER BY max_salary DESC