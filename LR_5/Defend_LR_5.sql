-- создать отчет, выводящий имя автора, фамилия автора, кол-во книг по жанрам (чтобы было ФИО автора - кол-во дететктивов - кол-во романов - кол-во комедий и т.д)
SELECT 
 a.first_name || ' ' || a.last_name AS "Автор",
 CASE 
        WHEN g.genre_name IS NULL THEN 'Нет книг'
        ELSE g.genre_name
 END AS "Жанр",
 COUNT(b.book_id) AS "Кол-во книг в этом жанре"
FROM authors AS a
LEFT JOIN book_authors ba ON ba.author_id = a.author_id 
LEFT JOIN books AS b ON b.book_id = ba.book_id 
LEFT JOIN genres AS g ON b.genre_id = g.genre_id 
GROUP BY a.author_id, g.genre_id
ORDER BY "Автор";


-- 2 вариант
SELECT 
    a.first_name || ' ' || a.last_name AS "Автор",
    COUNT(b.book_id) FILTER (WHERE g.genre_name = 'Роман') AS "Романы",
    COUNT(b.book_id) FILTER (WHERE g.genre_name = 'Драма') AS "Драмы",
    COUNT(b.book_id) FILTER (WHERE g.genre_name = 'Фантастика') AS "Фантастика",
    COUNT(b.book_id) FILTER (WHERE g.genre_name = 'Поэзия') AS "Поэзия"
FROM authors a
LEFT JOIN book_authors ba ON a.author_id = ba.author_id
LEFT JOIN books b ON ba.book_id = b.book_id
LEFT JOIN genres g ON b.genre_id = g.genre_id
GROUP BY a.author_id;