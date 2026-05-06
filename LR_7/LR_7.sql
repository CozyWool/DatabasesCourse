USE bd_sergeev_pa_07;

-- 1
CREATE VIEW Dateorders
AS
	SELECT ODATE, COUNT(*) AS OCOUNT
    FROM Orders
    GROUP BY ODATE;

-- 2
CREATE VIEW Order_info AS
SELECT
	o.ONUM AS OrderNumber,
    o.ODATE AS OrderDate,
    c.CNAME AS CustomerName,
    c.CITY AS CustomerCity,
    s.SNAME AS SalespersonName,
    s.CITY AS SalespersonCity,
    s.COMM AS SalespersonCommision
FROM Orders o
JOIN Customers c ON o.CNUM = c.CNUM
JOIN Salespeople s ON o.SNUM = s.SNUM
ORDER BY o.ODATE DESC, o.ONUM;

-- 3
SELECT * FROM Order_info
WHERE CustomerCIty = 'Москва';

-- 4
SELECT *
FROM Customers;

-- 5
UPDATE Customers
SET CITY = REPLACE(City, ' ', ' - ');

-- 6
CREATE VIEW Order_Amount AS
SELECT
	od.ONUM AS OrderNumber,
    p.PNAME AS ProductName,
    p.Price AS UnitPrice,
    od.Quantity AS Quantity,
    (p.Price * od.Quantity) AS LineTotal,
    SUM(p.Price * od.Quantity) OVER (PARTITION BY od.ONUM) AS OrderTotal
FROM Order_details od
JOIN Product p ON od.PNUM = p.PNUM
JOIN Orders o ON od.ONUM = o.ONUM
ORDER BY od.ONUM, LineTotal DESC;

-- 7
SELECT DISTINCT OrderNumber, OrderTotal
FROM Order_Amount
WHERE OrderTotal > 10000;

-- 8
CREATE VIEW Category_Sales AS
SELECT
	c.Category_Name,
    c.Description,
    COUNT(od.PNUM) AS TotalItemsSold,
    SUM(od.Quantity) AS TotalQuantity,
    SUM(p.Price * od.Quantity) AS TotalRevenue
FROM Category c
JOIN Product p ON c.Category_ID = p.Category_ID
JOIN Order_details od ON p.PNUM = od.PNUM
JOIN Orders o ON od.ONUM = o.ONUM
GROUP BY c.Category_ID, c.Category_Name, c.Description
ORDER BY TotalRevenue DESC;

-- 9
SELECT Category_Name, TotalRevenue
FROM Category_Sales
WHERE TotalQuantity > 10;

-- 10
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';

-- 11
DELIMITER //
CREATE PROCEDURE Cus_City(IN city_name VARCHAR(50))
BEGIN
	SELECT CNUM, CNAME, CITY
    FROM Customers
    WHERE CITY = city_name;
END //
DELIMITER ;

-- 12
CALL Cus_City('Москва');

-- 13
DELIMITER //
CREATE FUNCTION OrderTotal(order_num INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
	DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(p.Price * od.Quantity) INTO total
    FROM Order_details od
    JOIN Product p ON od.PNUM
    WHERE od.ONUM = order_num;
    
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- 14
SELECT OrderTotal(3002) AS TotalAmount;

-- 15
SELECT ONUM, OrderTotal(ONUM) AS TotalAmount
FROM Orders
WHERE ONUM = 3001;

-- 16
DELIMITER //
CREATE FUNCTION Count_Period(
	customer_num INT,
    start_date DATE,
    end_date DATE
)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE order_count INT DEFAULT 0;
    
    SELECT COUNT(*)
    INTO order_count
    FROM Orders
    WHERE CNUM = customer_num
	  AND ODATE BETWEEN start_date AND end_date;
      
	RETURN order_count;
END //
DELIMITER ;

-- 17
SELECT Count_Period(2005, '2024-01-01', CURDATE()) AS OrderCount;

-- 18
SHOW FUNCTION STATUS WHERE Db = 'bd_sergeev_pa_07';

-- 19
DELIMITER //
CREATE TRIGGER Check_Date
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
	IF NEW.ODATE > CURDATE() THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Дата заказа не может быть в будущем';
	END IF;
END //
DELIMITER ;

-- 20
INSERT INTO Orders(ODATE, CNUM, SNUM) VALUES ('2026-12-31', 2005, 1001);

-- 21
DELIMITER // 
CREATE TRIGGER UpdateCustomerRating
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
	UPDATE Customers
    SET RATING = RATING + 10
    WHERE CNUM = NEW.CNUM;
END //
DELIMITER ;

-- 22
CREATE TABLE customer_rating_log(
	log_id SERIAL PRIMARY KEY,
    cnum INT NOT NULL,
    old_rating INT,
    new_rating INT,
    change_date TIMESTAMP DEFAULT NOW(),
    change_by TEXT
);

-- 23
DELIMITER //
CREATE TRIGGER log_rating_changes
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
	IF OLD.RATING <> NEW.RATING THEN
		INSERT INTO customer_rating_log (cnum, old_rating, new_rating, change_by)
        VALUES (
			NEW.CNUM,
            OLD.RATING,
            NEW.RATING,
            USER()
		);
	END IF;
END //
DELIMITER ;

-- 24
INSERT INTO Orders (ONUM, ODATE, CNUM, SNUM) VALUES
(3010, '2026-05-01', 2005, 1001),
(3011, '2025-12-03', 2005, 1007);

INSERT INTO Order_details (ONUM, PNUM, QUANTITY) VALUES
(3011, 503, 10),
(3010, 502, 3);

SELECT * FROM customer_rating_log;