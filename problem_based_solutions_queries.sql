SELECT * FROM hr;

-- 1. Gender breakdown of employees in the company.

SELECT gender,COUNT(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. race/ethinicity breakdown of employees in company
SELECT race,COUNT(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- 3. age distribution of employees in company
SELECT
CASE
WHEN age>=18 AND age<=24 THEN '18-24'
WHEN age>=25 AND age<=34 THEN '25-34'
WHEN age>=35 AND age<=44 THEN '35-44'
WHEN age>=45 AND age<=54 THEN '45-54'
WHEN age>=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group,
COUNT(*) AS age_count
FROM hr
WHERE age>=18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- 4. employees working at headquarters versus remote locations

SELECT location,COUNT(*) AS emp_count FROM hr
WHERE age>=18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. average length of employment for employees who have been terminated
-- SELECT emp_id,timestampdiff(YEAR,hire_date,termdate) AS years_of_employment FROM hr
-- WHERE age>=18 AND termdate!='0000-00-00'; 

SELECT ROUND(AVG(datediff(termdate,hire_date))/365,0) AS avg_length_emp FROM hr
WHERE termdate<=curdate() AND termdate!='0000-00-00' AND age>=18;

-- 6. Gender distribution across departments and job titles

SELECT department,gender,COUNT(*) AS count_emp FROM hr
WHERE termdate='0000-00-00' AND age>=18
GROUP BY department,gender
ORDER BY department;

SELECT jobtitle,gender,COUNT(*) AS count_emp FROM hr
WHERE termdate='0000-00-00' AND age>=18
GROUP BY jobtitle,gender
ORDER BY jobtitle;

-- 7. Distribution of job title across company

SELECT jobtitle,COUNT(*) AS job_count FROM hr
WHERE age>=18 AND termdate='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8. Department having highest turnover/termination rate

-- SELECT department,total_count,terminated_count,ROUND(terminated_count/total_count,2) AS termination_rate
-- FROM (
--      SELECT department,COUNT(*) AS total_count,SUM(CASE WHEN termdate!='0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
--      FROM hr
--      WHERE age>=18
--      GROUP BY department
--      ) AS subquery
-- ORDER BY termination_rate DESC;

WITH cte AS(
SELECT department, COUNT(*) AS total_count,SUM(CASE WHEN termdate!='0000-00-00' AND termdate<=CURDATE() THEN 1 ELSE 0 END) AS terminated_count
FROM hr
WHERE age>=18
GROUP BY department
)
SELECT department,total_count,terminated_count,ROUND(terminated_count/total_count,2) AS termination_rate
FROM cte
ORDER BY termination_rate DESC;

-- 9. distribution of employees across locations by state

SELECT location_state,COUNT(*) AS count_emp FROM hr
WHERE age>=18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count_emp DESC;

-- 10. change in employee count based on hiredate and termdate

SELECT YEAR(hire_date) AS year,COUNT(*) AS hires,
	   SUM(CASE WHEN termdate!='0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations,
       COUNT(*) - SUM(CASE WHEN termdate!='0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
       round((COUNT(*) - SUM(CASE WHEN termdate!='0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) /COUNT(*) * 100,2) AS net_percent_change
FROM hr
WHERE age>=18
GROUP BY YEAR(hire_date)
ORDER BY net_percent_change DESC;

-- 11. tenure distribution for each department

SELECT department,round(AVG(DATEDIFF(termdate,hire_date)/365),0) AS avg_tenure FROM hr
WHERE age>= 18 AND termdate!='0000-00-00' AND termdate<=CURDATE()
GROUP BY department
ORDER BY avg_tenure;











