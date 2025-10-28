/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

WITH 
    demanded_skills as 
    (
        SELECT 
            skills_dim.skills,
            skills_dim.skill_id,
            COUNT(skills_job_dim.job_id) AS demand_count
        FROM job_postings_fact
            INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
            INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        WHERE
            job_title_short = 'Data Analyst' AND 
            job_location LIKE '%Poland%' AND
            salary_year_avg IS NOT NULL
        GROUP BY
            skills_dim.skills,
            skills_dim.skill_id
        ORDER BY
            demand_count DESC
    ),
    averaged_salary as
    (
        SELECT 
            skills_dim.skills,
            skills_dim.skill_id,
            ROUND(AVG(salary_year_avg), 0) as avg_salary
        FROM job_postings_fact
            INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
            INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        WHERE
            job_title_short = 'Data Analyst' AND 
            job_location LIKE '%Poland%' AND
            salary_year_avg IS NOT NULL
        GROUP BY
            skills_dim.skills,
            skills_dim.skill_id
        HAVING
            COUNT(skills_job_dim.job_id) > 5
        ORDER BY
            COUNT(skills_job_dim.job_id) DESC
    )

SELECT
    demanded_skills.skills,
    demand_count,
    averaged_salary.avg_salary
FROM
    demanded_skills
INNER JOIN averaged_salary ON demanded_skills.skill_id = averaged_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC
