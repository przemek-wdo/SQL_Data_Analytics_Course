/*
**Question: What are the top-paying data analyst jobs?**

- Identify the top 100 highest-paying Data Analyst roles that are available in Poland.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options in my country.
*/

SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Poland%' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 1000


-- ustaw filtrowanie pod polskę z wyłącznie ofertami z podanymi widełkami, nie muszą być oferty pracy zdalnej. purpose żeby zmienić trochę kursowy charakter projektu.