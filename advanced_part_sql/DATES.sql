/* 

-- ==========================================================
-- 1️⃣  STYCZEŃ - Oferty pracy z pierwszego miesiąca roku
-- ==========================================================
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;


-- ==========================================================
-- 2️⃣  LUTY - Oferty pracy z drugiego miesiąca roku
-- ==========================================================
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;


-- ==========================================================
-- 3️⃣  MARZEC - Oferty pracy z trzeciego miesiąca roku
-- ==========================================================
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
job_schedule_type,
AVG(salary_year_avg) as yearly_salary,
AVG(salary_hour_avg) as hourly_salary
FROM job_postings_fact
WHERE job_posted_date::date > '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type ASC 

SELECT
job_title_short AS title,
job_location AS location,
job_posted_date::DATE AS date
FROM job_postings_fact
LIMIT 10

SELECT
job_title_short AS title,
job_location AS location,
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
LIMIT 10;

SELECT
    COUNT(job_id) AS job_offers_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY 
    job_offers_count DESC
    
*/