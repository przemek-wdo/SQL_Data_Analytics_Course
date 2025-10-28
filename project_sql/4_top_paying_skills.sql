/*
**Answer: What are the top skills based on salary?** 

-   Look at the average salary associated with each skill for Data Analyst positions.
-   Focuses on roles with specified salaries, regardless of location.
-   Why? It reveals how different skills impact salary levels for Data Analysts 
    and helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) as avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location LIKE '%Poland%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 5
ORDER BY 
    avg_salary DESC;




/*

Code below allows counting demand and salary in one query without using query no.5, but for the purpose of practice I've decided to stay with it.


SELECT 
    skills_dim.skills,
        COUNT(skills_job_dim.job_id) as demand,
    ROUND(AVG(salary_year_avg), 0) as avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location LIKE '%Poland%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 5
ORDER BY
    COUNT(skills_job_dim.job_id) DESC
LIMIT 50;

*/