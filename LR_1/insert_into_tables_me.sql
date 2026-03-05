INSERT INTO employees 
VALUES
(106, 'Владислав', 'Сергеев', '2026-02-19');

INSERT INTO designation_employees 
VALUES
(106, 1, TRUE);


INSERT INTO skills
VALUES
(307, 106, 203, 'Продвинутый');

INSERT INTO clients
VALUES
(404, 'Контур', 'Петров', '+7 (900) 153-45-67');

INSERT INTO project
VALUES
(504, 'Веб-чат','2025-03-01','2026-02-28');

INSERT INTO contracts 
VALUES
(604, 404, 504, '2026-12-31');

INSERT INTO documents 
VALUES
(704, 504, '2025-01-01');

INSERT INTO project_participants
VALUES
(806, 106, 504, '2025-01-15', '2026-01-14');
