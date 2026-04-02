-- объединить данные о проектах и клиентах, чтобы видеть
-- какой проект выполняется для какого клиента, с указанием даты заключения контракта.
-- вывести название и код проекта, даты начала и окончания проекта, код клиента и название
-- и дату контракта

CREATE VIEW client_project_info AS
SELECT c.client_id,
	   c.company_name,
	   p.project_id,
	   p.project_name,
	   p.start_date,
	   p.end_date,
	   con.contracts_date
FROM clients c
LEFT JOIN contracts con ON c.client_id = con.client_id
LEFT JOIN project p ON con.project_id = p.project_id;

SELECT * FROM client_project_info	
ORDER BY client_id;

-- 2
CREATE VIEW employee_participating_info AS
SELECT e.employees_id,
	   e.firstname || ' ' || e.lastname AS fullname,
	   pp.participants_id,
	   pp.start_date_pr AS participtating_start_date,
	   pp.end_date_pr AS participtating_end_date,
	   p.project_id,
	   p.project_name,
	   p.start_date AS project_start_date,
	   p.end_date AS project_end_date
FROM employees e
LEFT JOIN project_participants pp ON pp.employees_id = e.employees_id
LEFT JOIN project p ON p.project_id = pp.project_id;

SELECT * FROM employee_participating_info
ORDER BY employees_id;