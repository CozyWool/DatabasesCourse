INSERT INTO designation_employees 
VALUES
(106, 3),
(106, 4),
(101, 2);

-- для каждого сотрудника определить сколько должностей он занимает, включая доп. и основные, двумя способами (с подзапросом и используя оконную функцию), 
-- вывести имя сотрудника, код сотрудника, количество должностей
--SELECT e.employees_id, e.firstname, COUNT(des.designation_id)
--FROM employees e
--JOIN designation_employees de ON e.employees_id = de.employees_id
--JOIN designation des ON de.designation_id = des.designation_id
--GROUP BY e.employees_id;

SELECT
	e.employees_id, 
	e.firstname, 
	(SELECT COUNT(*)
	FROM designation des 
	JOIN designation_employees de ON de.designation_id = des.designation_id
	JOIN employees em ON em.employees_id = de.employees_id
	WHERE e.employees_id = em.employees_id
	GROUP BY em.employees_id)
FROM employees e
ORDER BY e.employees_id;

SELECT
	e.employees_id, 
	e.firstname, 
	COUNT(*) OVER(PARTITION BY e.employees_id)
FROM employees e
JOIN designation_employees de ON e.employees_id = de.employees_id
JOIN designation des ON de.designation_id = des.designation_id
ORDER BY e.employees_id;

-- для каждой должности подсчитать сколько раз она основная и дополнительная 
-- вывести название должности, кол-во основных, кол-во дополнителных, всего  (с подзапросом и используя оконную функцию)

INSERT INTO designation 
VALUES
(6,'Программист', 100000);

SELECT
	d.designation_name,
	(SELECT COUNT(*) 
	FROM designation des
	JOIN designation_employees de ON de.designation_id = des.designation_id
	WHERE de.is_primary = TRUE AND des.designation_id = d.designation_id) AS primary_count,
	(SELECT COUNT(*) 
	FROM designation des
	JOIN designation_employees de ON de.designation_id = des.designation_id
	WHERE de.is_primary = FALSE AND des.designation_id = d.designation_id) AS secondary_count,
	(SELECT COUNT(*) 
	FROM designation des
	JOIN designation_employees de ON de.designation_id = des.designation_id
	WHERE des.designation_id = d.designation_id) AS total_count
FROM designation d
ORDER BY d.designation_id;

SELECT
	d.designation_name,
	COUNT(de.is_primary) FILTER (WHERE de.is_primary = TRUE) OVER (PARTITION BY d.designation_id) AS primary_count,
	COUNT(de.is_primary) FILTER (WHERE de.is_primary = FALSE) OVER (PARTITION BY d.designation_id) AS secondary_count,
	COUNT(de.is_primary) OVER (PARTITION BY d.designation_id) AS total_count
FROM designation d
LEFT JOIN designation_employees de ON de.designation_id = d.designation_id
ORDER BY d.designation_id;

