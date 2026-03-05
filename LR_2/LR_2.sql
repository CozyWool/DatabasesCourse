-- 1
SELECT * 
FROM employees e;

-- 2
SELECT *
FROM employees e
WHERE e.employees_id > 102;

-- 3
SELECT * 
FROM employees e
WHERE e.employees_id > 101 AND e.employees_id < 104;

-- 4
SELECT * 
FROM clients c
WHERE c.client_id >= 401 AND c.client_id <= 404;

-- 5
SELECT * 
FROM clients c
WHERE c.client_id NOT BETWEEN 401 AND 403;

-- 6
SELECT * 
FROM designation d 
WHERE d.designation_id IN (2,3);

-- 7
SELECT * 
FROM employees e 
WHERE e.firstname = 'Алексей';

-- 8
SELECT * 
FROM clients c
WHERE c.company_name LIKE '%Софт%';

-- 9
SELECT e.lastname, e.firstname 
FROM employees e
ORDER BY e.firstname;

SELECT e.lastname, e.firstname 
FROM employees e
ORDER BY e.firstname DESC;

-- 10
ALTER TABLE designation 
ADD COLUMN salary int NOT NULL DEFAULT 0;

UPDATE designation
SET salary = 1000
WHERE designation_id < 3;

UPDATE designation
SET salary = 2000
WHERE designation_id >= 3;

-- 11
SELECT *
FROM designation d 
ORDER BY d.designation_id 
LIMIT 2;

SELECT *
FROM designation d 
ORDER BY d.designation_id 
LIMIT 2
OFFSET 2;

-- 12
SELECT *
FROM designation d 
WHERE d.salary > 
	(SELECT AVG(d.salary) FROM designation d) 
	
-- 13
SELECT e.lastname AS фамилия, 'сотрудник' AS статус
FROM employees e 
UNION
SELECT c.contact_person, 'клиент'
FROM clients c;

-- 14
SELECT e.employees_id, e.lastname, e.firstname, s.technology_id, s.LEVEL
FROM employees e 
	INNER JOIN skills s
	ON e.employees_id = s.employees_id;

-- 15
SELECT 
	e.firstname,
	e.lastname,
	d.designation_name,
	de.is_primary
FROM employees e
JOIN designation_employees de ON e.employees_id = de.employees_id 
JOIN designation d ON de.designation_id  = d.designation_id 
ORDER BY e.employees_id, de.is_primary DESC;

-- 16
SELECT designation_name, kol
FROM
	(SELECT designation_id, COUNT(*) kol
FROM designation_employees de
GROUP BY de.designation_id) n
			JOIN designation d 
			 ON d.designation_id = n.designation_id;

-- 17
SELECT d.designation_name, d.salary,
CASE 
	WHEN d.salary > (SELECT AVG(d.salary) FROM designation d) THEN 'high'
	WHEN d.salary = (SELECT AVG(d.salary) FROM designation d) THEN 'medium'
	ELSE 'low'
END AS salary_level
FROM designation d;

-- 18
SELECT MIN(d.salary), MAX(d.salary), AVG(d.salary), SUM(d.salary)
FROM designation d;

-- 19
SELECT c.company_name, project_count
FROM
	(SELECT co.client_id, COUNT(co.project_id) AS project_count
		FROM contracts co
	GROUP BY co.client_id
	ORDER BY project_count DESC) n
JOIN clients c
ON n.client_id = c.client_id;

-- Примеры строковых функций

SELECT CONCAT(firstname, ' ', lastname) AS full_name
FROM employees;

SELECT firstname || ' ' || lastname AS full_name
FROM employees;

SELECT UPPER(firstname) AS name_upper
FROM employees;

SELECT firstname, lastname
FROM employees
WHERE LOWER(lastname) = 'иванов';

SELECT firstname, lastname
FROM employees
WHERE LENGTH(lastname) > 6;

SELECT SUBSTRING(firstname, 1, 3) AS name_short
FROM employees;

SELECT company_name,
	   REPLACE(company_name, 'Ltd', 'Limited') AS company_normalized
FROM clients;

SELECT firstname, lastname
FROM employees
WHERE POSITION('а' IN firstname) > 0;

SELECT FORMAT('Сотрудник: %s %s', lastname, LEFT(firstname, 1))
FROM employees;

SELECT LEFT(project_name, 5) AS project_short
FROM project;

SELECT MD5(firstname) AS anonymized_name
FROM employees;

-- 20
SELECT
	p.project_id,
	COUNT(d.documents_id) AS document_count
FROM project p
LEFT JOIN documents d ON p.project_id = d.project_id
GROUP BY p.project_id
ORDER BY p.project_id;

-- 21
CREATE INDEX idx_employees_department_id
ON employees (department_id);

-- 22
CREATE INDEX idx_project_participants_employees_project
ON project_participants (employees_id, project_id);

-- 23
SELECT 
	e.employees_id,
	e.firstname,
	e.lastname,
	s.level,
	RANK() OVER (ORDER BY
		CASE s.level
			WHEN 'Эксперт' THEN 3
			WHEN 'Продвинутый' THEN 2
			WHEN 'Средний' THEN 1
			ELSE 0
		END DESC
	) AS skill_rank
FROM skills s
JOIN employees e ON s.employees_id = e.employees_id
WHERE s.technology_id = 201;

-- 24
SELECT
	d.department_name,
	e.employees_id,
	e.firstname,
	e.lastname,
	ROW_NUMBER() OVER (PARTITION BY d.department_id ORDER BY e.lastname) AS department_row_num
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, department_row_num;

-- 25
SELECT
	e.employees_id,
	e.firstname,
	e.lastname,
	d.department_name,
	d.department_id,
	de.salary,
	MIN(de.salary) OVER (PARTITION BY d.department_id) AS min_salary_in_department,
	MAX(de.salary) OVER (PARTITION BY d.department_id) AS max_salary_in_department,
	AVG(de.salary) OVER (PARTITION BY d.department_id) AS avg_salary_in_department
FROM employees e
JOIN departments d ON e.department_id = d.department_id 
JOIN designation_employees dee ON dee.employees_id = e.employees_id 
JOIN designation de ON dee.designation_id = de.designation_id 
ORDER BY d.department_name; 