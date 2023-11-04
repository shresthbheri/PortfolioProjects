SELECT * FROM hrdata

-- Employee Count

SELECT SUM(employee_count) FROM hrdata

SELECT SUM(employee_count) AS employee_count FROM hrdata 
--WHERE education = 'High School'
--WHERE department = 'Sales' 
--WHERE department = 'R&D' 
WHERE education_field = 'Medical'

-- Attrition Count

SELECT COUNT(attrition) FROM hrdata
--WHERE attrition = 'Yes' 
--WHERE attrition = 'Yes' AND education = 'Doctoral Degree'
--WHERE attrition = 'Yes' AND department = 'R&D' 
--WHERE attrition = 'Yes' AND department = 'R&D' AND education_field = 'Medical' 
WHERE attrition = 'Yes' AND department = 'R&D' AND education_field = 'Medical' AND education = 'High School'

-- Attrition Rate

SELECT ROUND(((SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes' AND department = 'Sales') /
SUM(employee_count))*100,2) FROM hrdata 
WHERE department = 'Sales'

-- Active Employee

SELECT SUM(employee_count) - (SELECT COUNT(attrition) FROM hrdata WHERE attrition='Yes' AND gender = 'Male')
FROM hrdata WHERE gender = 'Male'

-- Avg Age

SELECT ROUND(AVG(age),0) AS Avg_Age FROM hrdata

-- Attrition By Gender

SELECT gender, COUNT(attrition) FROM hrdata
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC

-- Department Wise Attrition

SELECT department , COUNT(attrition),
ROUND((CAST(COUNT(attrition) AS numeric)/(SELECT COUNT(attrition) FROM hrdata WHERE attrition ='Yes')) * 100,2) AS pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY COUNT(attrition) DESC

-- No of Employees by Age group

SELECT age, SUM(employee_count) FROM hrdata
WHERE department = 'R&D'
GROUP BY age
ORDER BY age

-- Education Field Wise Attrition

SELECT education_field , COUNT(attrition) FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC

-- Attrition Rate by Gender for different Age Group

SELECT age_band, gender , COUNT(attrition), 
ROUND((CAST(COUNT(attrition) AS numeric)
/(SELECT COUNT(attrition) FROM hrdata WHERE attrition='Yes')) * 100,2) AS pct
FROM hrdata
WHERE attrition='Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender

-- Job Satisfaction Rating
CREATE EXTENSION IF NOT EXISTS tablefunc
SELECT * 
FROM CROSSTAB(
	'SELECT job_role, job_satisfaction, SUM(employee_count)
	FROM hrdata
	GROUP BY job_role, job_satisfaction
	ORDER BY job_role, job_satisfaction'
) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role
