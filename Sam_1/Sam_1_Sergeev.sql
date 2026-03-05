-- Создаём таблицу departments
CREATE TABLE departments(
	department_id int NOT NULL,
	department_name varchar NOT NULL,
	manager_id int,
	CONSTRAINT pk_departments PRIMARY KEY (department_id) -- Делаем department_id первичным ключом
);

-- Меняем таблицу employees
ALTER TABLE employees
ADD COLUMN department_id int, -- Добавляем колонку department_id
ADD COLUMN is_manager BOOLEAN DEFAULT FALSE; -- Добавляем колонку is_manager, по умолчанию False

-- Меняем таблицу departments
ALTER TABLE employees 
ADD CONSTRAINT fk_departments FOREIGN KEY (department_id) -- Делаем department_id внешним ключом, связывающий с таблицой departments 
REFERENCES departments (department_id);

INSERT INTO departments -- Заполняем таблицу departments
VALUES
(1001, 'Департамент транспорта', 101),
(1002, 'IT-департамент', 102),
(1003, 'Департамент образования', 103);

-- Заполняем поля department_id и is_manager
UPDATE employees 
SET department_id = 1002
WHERE employees_id < 102;

UPDATE employees
SET is_manager = TRUE
WHERE employees_id = 101;

UPDATE employees 
SET department_id = 1003
WHERE employees_id BETWEEN 103 AND 104;

UPDATE employees
SET is_manager = TRUE
WHERE employees_id = 103;

UPDATE employees
SET department_id = 1001
WHERE employees_id BETWEEN 105 AND 106;

UPDATE employees
SET is_manager = TRUE
WHERE employees_id = 106;
--


ALTER TABLE employees -- Меняем таблицу employees
ALTER COLUMN department_id SET NOT NULL; -- Делаем department_id обязательным для заполнения