-- 1
CREATE PROCEDURE add_technology(tech_id INT, tech_name VARCHAR, tech_desc VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO technology (technology_id, technology_name, description)
	VALUES (tech_id, tech_name, tech_desc);
END;
$$;

CALL add_technology(206, 'C#', 'Язык программирования для разработки приложений под платформу .NET');

-- 2
CREATE PROCEDURE get_avg_salary(OUT avg_salary NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT AVG(salary) INTO avg_salary FROM designation;
END;
$$;

CALL get_avg_salary(NULL);

-- 3
CREATE PROCEDURE add_client_safe(
	p_client_id INT,
	p_company_name VARCHAR(60),
	p_contact_person VARCHAR(60),
	p_phone VARCHAR(60)
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		FROM clients
		WHERE client_id = p_client_id
	) THEN
		RAISE EXCEPTION 'Ошибка: клиент с ID % уже существует!', p_client_id;
	END IF;

	IF p_company_name IS NULL OR p_contact_person IS NULL OR p_phone IS NULL THEN
		RAISE EXCEPTION 'Ошибка: поля company_name, contact_person и phone обязательны для заполнения!';
	END IF;

	INSERT INTO clients (client_id, company_name, contact_person, phone)
	VALUES (p_client_id, p_company_name, p_contact_person, p_phone);

	RAISE NOTICE 'Успешно: клиент ID % (% - контакт: %, телефон: %) добавлен.',
		p_client_id, p_company_name, p_contact_person, p_phone;
END;
$$;

-- 4
CALL add_client_safe(
	405,
	'НовыйКлиент ООО',
	'Иванов',
	'+7 (900) 987-65-43'
);

CALL add_client_safe(
	401,
	'НовыйКлиент ООО',
	'Иванов',
	'+7 (900) 987-65-43'
);

-- 5
CREATE OR REPLACE FUNCTION set_default_regdatum()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.regdatum IS NULL THEN
		NEW.regdatum = CURRENT_DATE;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_regdatum
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION set_default_regdatum();

-- 6
INSERT INTO employees (employees_id, firstname, lastname, is_manager, department_id)
VALUES
(108, 'Кирилл', 'Кириллов', FALSE, 1002);

-- 7
SELECT *
FROM employees e;

-- 8
CREATE OR REPLACE FUNCTION prevent_employees_id_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	IF OLD.employees_id <> NEW.employees_id THEN
		RAISE EXCEPTION 'Ошибка: запрещено изменять employees_id (ID сотрудника)!';
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER trg_prevent_id_change
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_employees_id_change();

-- 9
UPDATE employees
SET employees_id = 999
WHERE employees_id = 101;

-- 10
SELECT
	tgname AS trigger_name,
	relname AS table_name,
	tgtype AS trigger_type,
	tgenabled AS status
FROM pg_trigger
JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid
WHERE tgname IN ('trg_set_regdatum', 'trg_prevent_id_change');