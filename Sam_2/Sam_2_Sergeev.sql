-- 1
SELECT e.employees_id, t.technology_name, s."level"
FROM employees e 
JOIN skills s ON e.employees_id = s.employees_id -- Присоединяем таблицу skills
JOIN technology t ON s.technology_id = t.technology_id -- Присоединяем таблицу technology
WHERE e.employees_id = 101 -- Выбираем только employees_id = 101
ORDER BY t.technology_name; -- Сортируем по technology_name

-- 2
SELECT c.company_name, c.contact_person, c.phone 
FROM clients c;

-- 3 (с JOIN)
SELECT e.firstname, e.lastname, p.start_date, p.end_date
FROM project p
JOIN project_participants pp ON pp.project_id = p.project_id -- Присоединяем таблицу project_participants
JOIN employees e ON pp.employees_id = e.employees_id -- Присоединяем таблицу employees
WHERE p.project_name = 'Портал госуслуг'; -- Выбираем только project_name = 'Портал госуслуг'

-- 3 (подзапрос)
SELECT e.firstname, 
	   e.lastname,
	   (SELECT (SELECT p.start_date -- Подзапросом выбираем start_date
	   			FROM project p 
	   			WHERE p.project_id = pp.project_id) -- и при этом p.project_id = pp.project_id 
	   	FROM project_participants pp
	   	WHERE e.employees_id = pp.employees_id), -- с фильтрацией e.employees_id = pp.employees_id 
	   (SELECT (SELECT p.start_date -- Подзапросом выбираем end_date
	   			FROM project p 
	   			WHERE p.project_id = pp.project_id) -- и при этом p.project_id = pp.project_id 
	   	FROM project_participants pp
	   	WHERE e.employees_id = pp.employees_id) -- с фильтрацией e.employees_id = pp.employees_id 
FROM employees e
WHERE (SELECT (SELECT p.project_name -- Получаем имя проекта через подзапрос
	   			FROM project p 
	   			WHERE p.project_id = pp.project_id)
	   	FROM project_participants pp
	   	WHERE e.employees_id = pp.employees_id) = 'Портал госуслуг'; -- Выбираем только project_name = 'Портал госуслуг'


-- 4
SELECT d.department_id, d.department_name, e.firstname || ' ' || e.lastname AS manager_fullname
FROM employees e
RIGHT JOIN departments d ON d.manager_id = e.employees_id; -- Присоединяем таблицу departments правым JOIN, 
														   -- т.к у отдела может не быть руководителя

-- 5
SELECT t.technology_name 
FROM employees e
JOIN skills s ON e.employees_id = s.employees_id -- Присоединяем таблицу skills
JOIN technology t ON s.technology_id = t.technology_id -- Присоединяем таблицу technology
WHERE e.firstname || ' ' || e.lastname = 'Иван Иванов' -- Выбираем только Ивана Иванова;

-- 6
SELECT cl.client_id, cl.company_name, cl.contact_person, cl.phone, p.project_name 
FROM clients cl 
JOIN contracts con ON cl.client_id = con.client_id
JOIN project p ON con.project_id = p.project_id 
WHERE p.project_name LIKE '%Аналитика%';

-- Добавим пустой отдел
INSERT INTO departments 
VALUES
(1004, 'Департамент маркетинга');

-- 7
SELECT d.department_name, COUNT(e.employees_id)
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 8
SELECT AVG(CASE s."level"
			WHEN 'Эксперт' THEN 3 
			WHEN 'Продвинутый' THEN 2
			WHEN 'Средний' THEN 1
			ELSE 0 
		END) AS average_skill
FROM employees e
JOIN skills s ON e.employees_id = s.employees_id;

-- 9
SELECT e.firstname, e.lastname, COUNT(pp.project_id) AS project_count
FROM employees e
LEFT JOIN project_participants pp ON e.employees_id = pp.employees_id -- Присоединяем таблицу project_participants левым JOIN, т.к сотрудник может не участвовать в проектах
GROUP BY e.employees_id;


-- Добавляем работника без должности
INSERT INTO employees 
VALUES
(107, 'Семён', 'Зубов', '2026-03-19', 1003);

-- 10
SELECT e.employees_id, 
	   e.firstname || ' ' ||  e.lastname AS fullname,
	   CASE 
		   WHEN COUNT(d.salary) = 0 THEN 0 -- Если нету должностей, то выводим 0
		   ELSE SUM(d.salary)
	   END AS total_salary, -- Суммируем зарплаты со всех должностей
	   CASE 
			WHEN COUNT(pp.project_id) > 1 THEN 5000 -- Если участвовал больше чем в 1 проекте, то даем премию 5000
			ELSE 0
	   END AS prize
FROM employees e 
LEFT JOIN designation_employees de ON de.employees_id = e.employees_id -- Присоединяем таблицу designation_employees левым JOIN, т.к у сотрдуника может не быть должности
LEFT JOIN designation d ON d.designation_id = de.designation_id -- Присоединяем таблицу designation левым JOIN, т.к у сотрдуника может не быть должности
LEFT JOIN project_participants pp ON e.employees_id = pp.employees_id -- Присоединяем таблицу project_participants левым JOIN, т.к сотрудник может не участвовать в проектах
GROUP BY e.employees_id  -- Группируем по employees_id (для множества должностей)
ORDER BY e.employees_id; -- Сортируем по employees_id (для удобства)