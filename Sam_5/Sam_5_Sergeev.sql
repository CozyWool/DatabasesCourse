-- 1
SELECT 
    DAYNAME(o.ODATE) AS 'День недели',
    ROUND(SUM(od.QUANTITY * p.PRICE) / COUNT(o.ONUM), 2) AS 'Средний чек'
FROM Orders o
JOIN Order_details od ON o.ONUM = od.ONUM
JOIN Product p ON od.PNUM = p.PNUM
GROUP BY DAYNAME(o.ODATE), DAYOFWEEK(o.ODATE)
ORDER BY DAYOFWEEK(o.ODATE);

-- 2
CREATE OR REPLACE VIEW View_1_Sergeev AS
SELECT 
    SNAME AS 'Имя продавца', 
    COMM AS 'Комиссия',
    CASE 
        WHEN COMM < 0.11 THEN 'Low commission rate'
        WHEN COMM BETWEEN 0.11 AND 0.13 THEN 'Standard commission rate'
        WHEN COMM > 0.13 THEN 'High commission rate'
    END AS 'Эффективность'
FROM Salespeople;

SELECT * FROM View_1_Sergeev;

-- 3
CREATE OR REPLACE VIEW View_2_Sergeev AS
SELECT 
	CONCAT(c.CNAME, ' ', COALESCE(c.CSURNAME, '')) AS 'ФИО покупателя',
    COUNT(o.ONUM) AS 'Кол-во заказов',
    ROUND(AVG(position_count.item_count), 2) AS 'Среднее кол-во позиций',
    SUM(p.Price * od.Quantity) AS 'Общая сумма'
FROM Customers c
LEFT JOIN Orders o ON o.CNUM = c.CNUM
LEFT JOIN Order_details od ON o.ONUM = od.ONUM
LEFT JOIN Product p ON od.PNUM = p.PNUM
LEFT JOIN (
    SELECT ONUM, COUNT(PNUM) as item_count 
    FROM Order_details 
    GROUP BY ONUM
) position_count ON o.ONUM = position_count.ONUM
GROUP BY c.CNUM;

SELECT * FROM View_2_Sergeev;

-- 4
CREATE OR REPLACE VIEW View_3_Sergeev AS
SELECT 
	p.PNAME AS 'Название товара',
    DATE_FORMAT(o.ODATE,  '%Y-%m') AS 'Месяц',
    SUM(od.Quantity) AS 'Заказно в этом месяце (шт)'
FROM Product p
LEFT JOIN Order_details od ON od.PNUM = p.PNUM
LEFT JOIN Orders o ON o.ONUM = od.ONUM
GROUP BY p.PNUM, DATE_FORMAT(o.ODATE,  '%Y-%m');

SELECT * FROM View_3_Sergeev;

-- 5
CREATE OR REPLACE VIEW View_4_Sergeev AS
SELECT 
    o.ODATE AS 'Дата',
    COUNT(o.ONUM) AS 'Кол-во заказов',
    SUM(p.Price * od.Quantity) AS 'Суммарный объем продаж'
FROM Orders o
LEFT JOIN Order_details od ON o.ONUM = od.ONUM
LEFT JOIN Product p ON od.PNUM = p.PNUM
GROUP BY o.ODATE
ORDER BY o.ODATE;

SELECT * FROM View_4_Sergeev;

-- 6
CREATE OR REPLACE VIEW View_5_Sergeev AS
SELECT 
	c.Category_Name AS 'Категория',
    DATE_FORMAT(o.ODATE, '%Y-%m') AS 'Месяц',
	SUM(p.Price * od.Quantity) AS 'Общая выручка'
FROM Category c
LEFT JOIN Product p ON p.Category_ID = c.Category_ID
LEFT JOIN Order_details od ON od.PNUM = p.PNUM
LEFT JOIN Orders o ON od.ONUM = o.ONUM
GROUP BY c.Category_ID, DATE_FORMAT(o.ODATE, '%Y-%m');

SELECT * FROM View_5_Sergeev;

-- 7
DELIMITER //
CREATE PROCEDURE Proc_1_Sergeev(
    IN p_id INT, 
    IN p_name VARCHAR(50), 
    IN p_price DECIMAL(10,2), 
    IN p_cat_id INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Product WHERE PNUM = p_id) THEN
        SELECT 'Ошибка: Продукт с таким ID уже существует' AS Message;
    ELSE
        INSERT INTO Product (PNUM, PNAME, Price, Category_ID)
        VALUES (p_id, p_name, p_price, p_cat_id);
        SELECT 'Продукт успешно добавлен' AS Message;
    END IF;
END //
DELIMITER ;

CALL Proc_1_Sergeev(507, 'Клавиатура', 2500.00, 1);
SELECT * FROM Product WHERE PNUM = 507;

-- 8
DELIMITER //
CREATE PROCEDURE Proc_2_Sergeev(
    IN c_id INT, 
    IN start_date DATE, 
    IN end_date DATE
)
BEGIN
	SELECT
		o.ONUM AS 'Номер заказа',
        o.ODATE AS 'Дата',
        p.PNAME AS 'Название товара',
        od.Quantity AS 'Кол-во',
        (p.Price * od.Quantity) AS 'Общая стоимость'
	FROM Orders o
    LEFT JOIN Order_details od ON o.ONUM = od.ONUM
    LEFT JOIN Product p ON od.PNUM = p.PNUM
    WHERE o.CNUM = c_id AND o.ODATE BETWEEN start_date AND end_date;
END //
DELIMITER ;

CALL Proc_2_Sergeev(2001, '2023-01-01', '2023-12-31');

-- 9
DELIMITER //
CREATE PROCEDURE Proc_3_Sergeev(
    IN yyyy_mm VARCHAR(7)
)
BEGIN
	SELECT
		SUM(p.Price * od.Quantity) AS 'Общая стоимость'
	FROM Orders o
    LEFT JOIN Order_details od ON o.ONUM = od.ONUM
    LEFT JOIN Product p ON od.PNUM = p.PNUM
    WHERE DATE_FORMAT(o.ODATE, '%Y-%m') = yyyy_mm;
END //
DELIMITER ;

CALL Proc_3_Sergeev('2023-10');

-- 10
DELIMITER //
CREATE TRIGGER TRIG_Sergeev
BEFORE INSERT ON Order_details
FOR EACH ROW
BEGIN
	IF NEW.Quantity < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Кол-во товара не может быть отрицательным!';
	END IF;
END //
DELIMITER ;

INSERT INTO Order_details (ONUM, PNUM, QUANTITY) VALUES (3001, 502, -5);