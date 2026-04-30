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

