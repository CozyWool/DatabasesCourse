-- 1
CREATE DATABASE literature_catalog_sergeev_pa07;

-- 3
CREATE TABLE authors(
	author_id SERIAL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	patronymic VARCHAR(50),
	birth_date DATE,
	nationality VARCHAR(50),
	biography TEXT,
	created_at TIMESTAMP DEFAULT NOW(),
	CONSTRAINT PK_aut PRIMARY KEY (author_id)
);

-- 4
CREATE TABLE genres(
	genre_id SERIAL,
	genre_name VARCHAR(50) NOT NULL,
	description TEXT,
	CONSTRAINT PK_genres PRIMARY KEY (genre_id)
);

CREATE TABLE books(
	book_id SERIAL,
	title VARCHAR(255) NOT NULL,
	isbn VARCHAR(20),
	publication_year INT2,
	page_count INT,
	LANGUAGE VARCHAR(20),
	genre_id INT NOT NULL,
	CONSTRAINT PK_books PRIMARY KEY (book_id),
	CONSTRAINT FK_books_genre_id FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
);


CREATE TABLE book_authors(
	id SERIAL,
	book_id INT NOT NULL,
	author_id INT NOT NULL,
	author_role VARCHAR(50),
	contribution_percent NUMERIC(5,2),
	CONSTRAINT PK_book_aut PRIMARY KEY (id),
	CONSTRAINT FK_book_aut_author_id FOREIGN KEY (author_id) REFERENCES authors (author_id),
	CONSTRAINT FK_book_aut_book_id FOREIGN KEY (book_id) REFERENCES books (book_id)
);

-- 5
INSERT INTO genres (genre_id, genre_name, description) VALUES
(1, 'Роман', 'Классическая и современная проза'),
(2, 'Драма', 'Произведения с глубоким конфликтом'),
(3, 'Фантастика', 'Научная и социальная фантастика'),
(4, 'Поэзия', 'Стихотворные произведения');

INSERT INTO authors (author_id, first_name, last_name, patronymic, birth_date, biography, created_at, nationality) VALUES
(1, 'Фёдор', 'Достоевский', 'Михайлович', '1821-11-11', 'Русский писатель, философ', NOW(), 'Россия'),
(2, 'Лев', 'Толстой', 'Николаевич', '1828-09-09', 'Русский писатель, автор эпических романов', NOW(), 'Россия'),
(3, 'Александр', 'Пушкин', 'Сергеевич', '1799-06-06', 'Русский поэт и писатель', NOW(), 'Россия'),
(4, 'Михаил', 'Булгаков', 'Афанасьевич', '1891-05-15', 'Русский писатель и драматург', NOW(), 'Россия'),
(5, 'Иван', 'Тургенев', 'Сергеевич', '1818-11-09', 'Русский писатель-реалист', NOW(), 'Россия');

INSERT INTO books (book_id, title, isbn, publication_year, page_count, language, genre_id) VALUES
(1, 'Преступление и наказание', '9785000000001', 1866, 671, 'RU', 1),
(2, 'Война и мир', '9785000000002', 1869, 1225, 'RU', 1),
(3, 'Евгений Онегин', '9785000000003', 1833, 224, 'RU', 4),
(4, 'Мастер и Маргарита', '9785000000004', 1967, 480, 'RU', 3),
(5, 'Отцы и дети', '9785000000005', 1862, 288, 'RU', 1);

INSERT INTO book_authors (id, book_id, author_id, author_role, contribution_percent) VALUES
(1, 1, 1, 'Автор', 100.00),
(2, 2, 2, 'Автор', 100.00),
(3, 3, 3, 'Автор', 100.00),
(4, 4, 4, 'Автор', 100.00),
(5, 5, 5, 'Автор', 100.00);

-- 7
SELECT a.first_name || ' ' || a.last_name AS "Автор",
	   COUNT(book_id) AS "Количество книг"
FROM authors a 
LEFT JOIN book_authors ba ON ba.author_id = a.author_id
GROUP BY a.author_id;

-- 8
WITH genre_ranks AS (
	SELECT g.genre_name,
		   RANK() OVER (ORDER BY COUNT(b.book_id) DESC) AS genre_rank 
	FROM genres g
	LEFT JOIN books b ON b.genre_id = g.genre_id
	GROUP BY g.genre_id)
SELECT 
	genre_name
FROM genre_ranks
WHERE genre_rank = 1;

-- 9
SELECT first_name, last_name, birth_date
FROM authors
WHERE birth_date = (
    SELECT MIN(birth_date)
    FROM authors
);

-- 10
SELECT title, publication_year
FROM books
WHERE publication_year = (
    SELECT MAX(publication_year)
    FROM books
);