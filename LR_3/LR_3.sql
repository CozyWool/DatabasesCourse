-- 1
CREATE MATERIALIZED VIEW employee_details AS
SELECT
	e.lastname,
	e.firstname,
	des.designation_name,
	dep.department_name,
	e.regdatum,
	FLOOR(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.regdatum))) AS experience_years
FROM employees e
LEFT JOIN departments dep ON e.department_id = dep.department_id
JOIN designation_employees de ON e.employees_id = de.employees_id
JOIN designation des ON de.designation_id = des.designation_id;

-- 2
SELECT * FROM employee_details
WHERE experience_years > 5;

-- 3
CREATE VIEW employee_skills_summary AS
SELECT
	e.employees_id,
	e.firstname,
	e.lastname,
	t.technology_name,
	s.level,
	INITCAP(s.level) AS level_formatted,
	CONCAT(e.firstname, ' ', e.lastname) AS full_name,
	CASE
		WHEN s.LEVEL IN ('Высокий', 'Эксперт') THEN 'Ведущий'
	END AS skill_level_group
FROM employees e
JOIN skills s ON e.employees_id = s.employees_id
JOIN technology t ON s.technology_id = t.technology_id
ORDER BY e.lastname, e.firstname, t.technology_name;

-- 4
SELECT full_name, technology_name, level_formatted
FROM employee_skills_summary
WHERE skill_level_group = 'Ведущий';