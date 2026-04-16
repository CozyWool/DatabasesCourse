-- Создать процедуру которая будет выводить информацию о проектах, о кол-ве участников в каждой
-- Название проекта передавать в параметрах.
-- искать по вхождению (через like)
CREATE OR REPLACE PROCEDURE show_project_info(
	IN p_project_name VARCHAR,
	OUT o_project_name VARCHAR,
	OUT o_start_date DATE,
	OUT o_end_date DATE,
	OUT o_participants_count INT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT p.project_name,
		   p.start_date,
		   p.end_date,
		   COUNT(pp.participants_id)
	INTO o_project_name,
	     o_start_date,
		 o_end_date,
		 o_participants_count
	FROM project p
	LEFT JOIN project_participants pp ON pp.project_id = p.project_id
    WHERE project_name LIKE '%' || p_project_name ||'%'
	GROUP BY p.project_id;
END;
$$;

CALL show_project_info('при', NULL, NULL, NULL, NULL);
CALL show_project_info('чат', NULL, NULL, NULL, NULL);
CALL show_project_info('услуг', NULL, NULL, NULL, NULL);


-- создать триггер, с параметрами и условия определиться самостоятельно
CREATE OR REPLACE FUNCTION check_skill_valid()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		FROM skills
		WHERE skills_id = NEW.skills_id
	) THEN
		RAISE EXCEPTION 'Ошибка: скилл с ID % уже существует!', NEW.skills_id;
	END IF;

	IF NEW.employees_id IS NULL OR NEW.technology_id IS NULL OR NEW.level IS NULL OR NEW.level = '' THEN
		RAISE EXCEPTION 'Ошибка: поля employees_id, technology_id и level обязательны для заполнения!';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_skills
BEFORE INSERT ON skills
FOR EACH ROW
EXECUTE FUNCTION check_skill_valid();


INSERT INTO skills (skills_id, employees_id, technology_id, level)
VALUES
(310, 102, 204, 'Продвинутый'),
(311, NULL, 204, 'Эксперт');
