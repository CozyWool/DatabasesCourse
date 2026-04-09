-- 1
CREATE MATERIALIZED VIEW IT_department_employees_information AS
SELECT e.employees_id,
	   e.firstname || ' ' || e.lastname AS fullname,
	   e.regdatum,
	   d.department_name,
	   m.employees_id AS manager_id,
	   m.firstname || ' ' || m.lastname AS manager_fullname
FROM employees e
LEFT JOIN departments d ON d.department_id = e.department_id
LEFT JOIN employees m ON d.manager_id = m.employees_id
WHERE d.department_name = 'IT-департамент';

SELECT * FROM IT_department_employees_information;

-- 2
CREATE MATERIALIZED VIEW project_info AS
SELECT p.project_name,
	   p.end_date - p.start_date AS duration_in_days,
	   COUNT(pp.employees_id) AS employee_count,
	   COUNT(d.documents_id) AS document_count	   
FROM project p
LEFT JOIN project_participants pp ON p.project_id = pp.project_id	
LEFT JOIN documents d ON d.project_id = p.project_id  
GROUP BY p.project_id;

SELECT * FROM project_info;

-- 3
CREATE MATERIALIZED VIEW employees_primary_designation_info AS
SELECT e.employees_id,
	   e.firstname || ' ' || e.lastname AS fullname,
	   e.lastname,
	   e.regdatum,
	   d.designation_name AS primary_designation
FROM employees e
LEFT JOIN designation_employees de ON de.employees_id = e.employees_id AND de.is_primary
LEFT JOIN designation d ON d.designation_id = de.designation_id;

SELECT * FROM employees_primary_designation_info;

-- 4 
CREATE MATERIALIZED VIEW project_client_info AS
SELECT p.project_id,
	   p.project_name,
	   p.start_date,
	   p.end_date,
	   c.company_name,
	   c.contact_person
FROM project p
LEFT JOIN contracts con ON con.project_id = p.project_id 
LEFT JOIN clients c ON c.client_id = con.client_id;

SELECT * FROM project_client_info;

-- 5
CREATE OR REPLACE PROCEDURE get_project_count(
	p_client_id INT,
	OUT p_project_count INT
)
LANGUAGE plpgsql 
AS $$
BEGIN
	SELECT COUNT(project_id)
	INTO p_project_count
	FROM contracts
	WHERE client_id = p_client_id;
END;
$$

CALL get_project_count(401, NULL);


-- 6
CREATE OR REPLACE FUNCTION prevent_project_delete()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
	doc_count INT;
BEGIN
	SELECT COUNT(*)
	INTO doc_count
	FROM documents
	WHERE project_id = OLD.project_id;

	IF doc_count > 0 THEN
		RAISE EXCEPTION 'Ошибка: запрещено удалять проект, если есть связанные документы';
	END IF;

	RETURN OLD;
END;
$$;

CREATE TRIGGER trg_prevent_project_delete
BEFORE DELETE ON project
FOR EACH ROW
EXECUTE FUNCTION prevent_project_delete();

DELETE FROM project
WHERE project_id = 502;

-- 7
CREATE OR REPLACE PROCEDURE add_department_safe(
	p_department_id INT,
	p_department_name VARCHAR(60),
	p_manager_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		FROM departments
		WHERE department_id = p_department_id
	) THEN
		RAISE EXCEPTION 'Ошибка: департамент с ID % уже существует!', p_department_id;
	END IF;

	IF p_department_id IS NULL OR p_department_name IS NULL THEN
		RAISE EXCEPTION 'Ошибка: поля department_id, department_name обязательны для заполнения!';
	END IF;

	INSERT INTO departments (department_id, department_name, manager_id)
	VALUES (p_department_id, p_department_name, p_manager_id);

	RAISE NOTICE 'Успешно: департамент ID % (название: %, ID менджера: %) добавлен.',
		p_department_id, p_department_name, p_manager_id;
END;
$$;

CALL add_department_safe(1005, 'Департамент департаментов', 102);

-- 8
CREATE OR REPLACE FUNCTION is_manager(p_employees_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN (SELECT is_manager
	FROM employees
	WHERE employees_id = p_employees_id);
END;
$$;

SELECT is_manager(104), is_manager(101);

