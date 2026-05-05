-- 4
CREATE DATABASE bd_sergeev_pa_07;

-- 6
USE bd_sergeev_pa_07;

CREATE TABLE Customers
(
	CNUM INT NOT NULL,
    CNAME VARCHAR(10) NOT NULL,
    CITY VARCHAR(10) NOT NULL,
    RATING INT NOT NULL,
CONSTRAINT PK_Cust PRIMARY KEY (CNUM)
);

CREATE TABLE Salespeople
(
	SNUM INT NOT NULL,
    SNAME VARCHAR(10) NOT NULL,
    CITY VARCHAR(10) NOT NULL,
    COMM DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_Sal PRIMARY KEY (SNUM)
);

CREATE TABLE Orders
(
	ONUM INT AUTO_INCREMENT NOT NULL,
    ODATE DATE NOT NULL,
    CNUM INT NOT NULL,
    SNUM INT NOT NULL,
CONSTRAINT PK_Or PRIMARY KEY (ONUM),
CONSTRAINT FK_Orders_Customers FOREIGN KEY (CNUM)
	REFERENCES Customers (CNUM),
CONSTRAINT FK_Orders_Salespeople FOREIGN KEY (SNUM)
	REFERENCES Salespeople (SNUM)
);

-- 9
CREATE TABLE Category
(
    CATEGORY_ID INT NOT NULL,
    CATEGORY_NAME VARCHAR(50) NOT NULL,
    DESCRIPTION VARCHAR(255) NOT NULL,
CONSTRAINT PK_Category PRIMARY KEY (CATEGORY_ID)
);

CREATE TABLE Product
(
    PNUM INT NOT NULL,
    PNAME VARCHAR(50) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    CATEGORY_ID INT NOT NULL,
CONSTRAINT PK_Product PRIMARY KEY (PNUM),
CONSTRAINT FK_Product_Category FOREIGN KEY (CATEGORY_ID)
    REFERENCES Category (CATEGORY_ID)
);

CREATE TABLE Order_details
(
    ONUM INT NOT NULL,
    PNUM INT NOT NULL,
    QUANTITY INT NOT NULL,
CONSTRAINT PK_OrderDetails PRIMARY KEY (ONUM, PNUM),
CONSTRAINT FK_Details_Orders FOREIGN KEY (ONUM)
    REFERENCES Orders (ONUM),
CONSTRAINT FK_Details_Product FOREIGN KEY (PNUM)
    REFERENCES Product (PNUM)
);

-- 10
INSERT INTO Salespeople (SNUM, SNAME, CITY, COMM) VALUES
(1001, 'Иванов', 'Москва', 0.12),
(1002, 'Петров', 'Хабаровск', 0.13),
(1004, 'Сидоров', 'Казань', 0.11),
(1007, 'Кузнецов', 'Мурманск', 0.15),
(1003, 'Павлов', 'Сочи', 0.10);

INSERT INTO Customers (CNUM, CNAME, CITY, RATING) VALUES
(2001, 'ООО Вектор', 'Москва', 100),
(2002, 'ИП Петров', 'Рязань', 200),
(2003, 'Завод Луч', 'Ростов', 200),
(2004, 'М-Инвест', 'Москва', 300),
(2006, 'СпецТех', 'Казань', 100);

INSERT INTO Orders (ONUM, ODATE, CNUM, SNUM) VALUES
(3001, '2023-10-01', 2001, 1001),
(3002, '2023-10-03', 2003, 1007),
(3003, '2023-10-04', 2002, 1001),
(3004, '2023-10-05', 2006, 1004),
(3005, '2023-10-06', 2004, 1002);

INSERT INTO Category (CATEGORY_ID, CATEGORY_NAME, DESCRIPTION) VALUES
(1, 'Электроника', 'Гаджеты и бытовая техника'),
(2, 'Офисные товары', 'Мебель и канцелярия для офиса'),
(3, 'Инструменты', 'Ручной и электроинструмент'),
(4, 'Стройматериалы', 'Все для ремонта'),
(5, 'Спорттовары', 'Тренажеры и инвентарь');

INSERT INTO Product (PNUM, PNAME, PRICE, CATEGORY_ID) VALUES
(501, 'Ноутбук', 75000.00, 1),
(502, 'Принтер', 15000.50, 2),
(503, 'Перфоратор', 8900.00, 3),
(504, 'Монитор', 22000.00, 1),
(505, 'Кресло офисное', 12300.00, 2),
(506, 'Стол офисный', 15000.00, 2);

INSERT INTO Order_details (ONUM, PNUM, QUANTITY) VALUES
(3001, 501, 1),
(3001, 504, 2),
(3002, 503, 1),
(3003, 502, 1),
(3004, 505, 5),
(3005, 501, 1);

-- Запросы

-- 1
SELECT AVG(COMM) as 'avg_comm'
FROM Salespeople;

SELECT ROUND(AVG(COMM), 2) AS 'avg_comm'
FROM Salespeople;


SELECT FORMAT(AVG(COMM), 2) AS 'avg_comm'
FROM Salespeople;


SELECT CAST(AVG(COMM) AS DECIMAL(10, 2)) AS 'avg_comm'
FROM Salespeople;

-- 2
SELECT COUNT(ONUM) as 'count_zakaz'
FROM Orders;

-- 3
SELECT *
FROM Orders
WHERE SNUM = 
	(SELECT SNUM
		FROM Salespeople
        WHERE SNAME = 'Иванов');

-- 4
SELECT *
FROM Product
WHERE Price >
	(SELECT AVG(Price)
		FROM Product);

-- 5
SELECT SNUM, CITY, 'Продавец' AS 'Статус'
FROM Salespeople
UNION ALL
SELECT CNUM, CITY, 'Покупатель' 
FROM Customers;

-- 6
SELECT SNAME, ONUM
	FROM Salespeople INNER JOIN Orders
    ON Salespeople.SNUM = Orders.SNUM;

-- 7
SELECT PNAME, Price,
CASE
	WHEN Price > 20000 THEN 'High'
    WHEN Price >= 10000 AND Price <= 20000 THEN 'Medium'
    ELSE 'Low'
END AS 'Price_level'
FROM Product;

-- 8
SELECT ONUM, p.PNAME, Quantity, Price,
	Price * Quantity AS 'Сумма товара в заказе 3001'
FROM Order_details od JOIN Product p
	ON od.PNUM = p.PNUM
WHERE ONUM = 3001;

-- 9
SELECT SUM(Price * Quantity) AS 'Сумма всех заказов'
FROM Order_details od JOIN Product p
	ON od.PNUM = p.PNUM;
    
-- 10
INSERT INTO Category VALUES
(6, 'Еда', 'Все, что является едой'),
(7, 'Бытовая техника', 'Стиральные машины, холодильники и т.п');

-- 11
SELECT *
FROM Category;

-- 12
SELECT Category_Name, COUNT(p.Category_ID) AS 'kol_prod'
FROM Category c LEFT JOIN Product p
ON c.Category_ID = p.Category_ID
GROUP BY Category_Name;

-- 13
SELECT
	MIN(price) AS 'min_price',
	MAX(price) AS 'max_price',
	CAST(AVG(price) AS DECIMAL(10,2)) AS 'avg_price',
	SUM(price) AS 'sum_price',
	COUNT(*) AS 'count'
FROM Product;

-- 14
SELECT PNAME, Category_ID,
	MIN(price) OVER (PARTITION BY Category_ID) AS 'min_price',
	MAX(price) OVER (PARTITION BY Category_ID) AS 'max_price',
	CAST(AVG(price) OVER (PARTITION BY Category_ID) AS DECIMAL(10,2)) AS 'avg_price',
	SUM(price) OVER (PARTITION BY Category_ID) AS 'sum_price',
	COUNT(*) OVER (PARTITION BY Category_ID) AS 'count'
FROM Product;

-- 15
SELECT 
	PNAME, Price,
	IF(price > 10000, 'Дорого', 'Доступно') AS price_category
FROM Product;

-- 16
SELECT
	CNAME AS 'Имя покупателя',
    CITY AS 'Город',
    RATING AS 'Рейтинг',
    RANK() OVER(PARTITION BY CITY ORDER BY RATING DESC) AS 'Место в городе'
FROM Customers
ORDER BY CITY, 'Место в городе';

-- 17
SELECT
	ODATE AS 'Дата заказа',
    COUNT(ONUM) AS 'Кол-во заказов за день',
    SUM(COUNT(ONUM)) OVER (ORDER BY ODATE) AS 'Нарастающий итог'
FROM Orders
GROUP BY ODATE
ORDER BY ODATE;

-- 18
SELECT 
	p.PNAME AS 'Товар',
    c.Category_Name AS 'Категория',
    p.Price AS 'Цена',
    ROUND(
		p.Price * 100.0 / SUM(p.Price) OVER (PARTITION BY p.Category_ID),
        2
	) AS 'Доля в категории (%)'
FROM Product p
JOIN Category c ON p.Category_ID = c.Category_ID
ORDER BY 'Категория', 'Доля в категории (%)' DESC;

-- 19
SELECT
	DAYNAME(ODATE) AS 'День недели',
    COUNT(ONUM) AS 'Кол-во заказов'
FROM Orders
GROUP BY DAYNAME(ODATE), DAYOFWEEK(ODATE)
ORDER BY DAYOFWEEK(ODATE);

-- 20
SELECT
	YEAR(o.ODATE) AS 'Год',
    SUM(od.Quantity * p.Price) AS 'Суммарная выручка'
FROM Orders o
JOIN Order_details od ON o.ONUM = od.ONUM
JOIN Product p ON od.PNUM = p.PNUM
GROUP BY YEAR(o.ODATE)
ORDER BY 'Год';

-- 21
SELECT
	c.CNAME AS 'Покупатель',
    c.CITY AS 'Город',
    MAX(o.ODATE) AS 'Дата последнего заказа',
    DATEDIFF(CURDATE(), MAX(o.ODATE)) AS 'Дней с последнего заказа'
FROM Customers c
LEFT JOIN Orders o ON c.CNUM = o.CNUM
GROUP BY c.CNUM;

-- 22
SELECT
	c.CNAME AS 'Имя покупателя',
    LENGTH(c.CNAME) AS 'Длина имени покупателя',
    c.CITY AS 'Город покупателя',
    LENGTH(c.CITY) AS 'Длина названия города (покупатель)'
FROM Customers c;

-- 23
SELECT
	p.PNAME AS ProductName,
    p.Price AS Price,
    cat.Category_Name AS Category,
    cat.Description AS CategoryDescription
FROM Product p
JOIN Category cat ON p.Category_ID = cat.Category_ID
WHERE p.PNUM NOT IN (
	SELECT DISTINCT od.PNUM
    FROM Order_details od
    JOIN Orders o ON od.ONUM = o.ONUM
    WHERE o.ODATE BETWEEN '2024-01-01' AND CURDATE()
)
ORDER BY p.PNAME;

-- 24
WITH Mon_Sales AS (
	SELECT
	  s.CITY AS SellerCIty,
      DATE_FORMAT(o.ODATE, '%Y-%m') AS SaleMonth,
      SUM(od.Quantity * p.Price) AS MonthlyRevenue
	FROM Orders o
    JOIN Order_details od ON o.ONUM = od.ONUM
    JOIN Product p ON od.PNUM = p.PNUM
    JOIN Salespeople s ON o.SNUM = s.SNUM
    GROUP BY s.CITY, DATE_FORMAT(o.ODATE,  '%Y-%m')
)
SELECT
	SellerCity AS 'Город продовца',
    SaleMonth AS 'Месяц',
    MonthlyRevenue AS 'Выручка за месяц'
FROM Mon_Sales
ORDER BY SellerCity, SaleMonth;