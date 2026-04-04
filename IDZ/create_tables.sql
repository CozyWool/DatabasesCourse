DROP DATABASE IF EXISTS car_dealership WITH (FORCE);
CREATE DATABASE car_dealership;

-- Создание таблиц
CREATE TABLE brand (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(30) NOT NULL UNIQUE,
    country VARCHAR(30)
);

CREATE TABLE manufacturer (
    manufacturer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL
);

CREATE TABLE car (
    car_id INT PRIMARY KEY,
    brand_id INT NOT NULL,
    manufacturer_id INT,
    year INT NOT NULL CHECK (year > 1990),
    color VARCHAR(20) NOT NULL,
    category VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(manufacturer_id)
);

CREATE TABLE client (
    client_id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    passport VARCHAR(20) UNIQUE,
    address VARCHAR(100),
    city VARCHAR(30),
    birth_date DATE NOT NULL,
    gender VARCHAR(10),
    CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years')
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    experience INT,
    salary DECIMAL(10,2)
);

CREATE TABLE sale (
    sale_id INT PRIMARY KEY,
    car_id INT,
    client_id INT,
    employee_id INT,
    sale_date DATE NOT NULL,
    FOREIGN KEY (car_id) REFERENCES car(car_id),
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

-- Индексы
CREATE INDEX idx_car_brand ON car(brand_id);
CREATE INDEX idx_sale_date ON sale(sale_date);
CREATE INDEX idx_client ON sale(client_id);

-- Данные
INSERT INTO brand (brand_id, brand_name, country)
VALUES
(1, 'BMW', 'Германия'),
(2, 'Toyota', 'Япония'),
(3, 'Audi', 'Германия'),
(4, 'Kia', 'Южная Корея');

INSERT INTO manufacturer (manufacturer_id, name, address)
VALUES
(1, 'Завод BMW Мюнхен', 'Мюнхен, Германия'),
(2, 'Завод Toyota Айти', 'Айти, Япония'),
(3, 'Завод Audi Берлин', 'Берлин, Германия'),
(4, 'Завод Kia Сеул', 'Сеул, Южная Корея');

INSERT INTO car (car_id, brand_id, manufacturer_id, year, color, category, price)
VALUES
(1, 1, 1, 2023, 'Черный', 'Премиум', 55000),
(2, 1, 1, 2022, 'Белый', 'Бизнес', 47000),
(3, 2, 2, 2023, 'Красный', 'Эконом', 25000),
(4, 3, 3, 2021, 'Серый', 'Бизнес', 43000),
(5, 4, 4, 2022, 'Синий', 'Эконом', 22000),
(6, 1, 1, 2023, 'Синий', 'Премиум', 60000);

INSERT INTO client (client_id, full_name, passport, address, city, birth_date, gender)
VALUES
(1, 'Иванов Иван Иванович', 'AB1234567', 'ул. Ленина, д.10', 'Москва', '1995-05-12', 'Мужской'),
(2, 'Петров Петр Петрович', 'CD7654321', 'ул. Пушкина, д.5', 'Санкт-Петербург', '1980-03-22', 'Мужской'),
(3, 'Смирнова Анна Сергеевна', 'EF1112223', 'ул. Советская, д.7', 'Казань', '1997-11-08', 'Женский');

INSERT INTO employee (employee_id, full_name, experience, salary)
VALUES
(1, 'Сидоров Сергей Николаевич', 5, 1200),
(2, 'Иванова Ольга Викторовна', 8, 1500),
(3, 'Козлов Дмитрий Андреевич', 3, 1000);

INSERT INTO sale (sale_id, car_id, client_id, employee_id, sale_date)
VALUES
(1, 1, 1, 1, CURRENT_DATE - INTERVAL '3 months'),
(2, 2, 2, 2, CURRENT_DATE - INTERVAL '8 months'),
(3, 3, 3, 1, CURRENT_DATE - INTERVAL '2 years'),
(4, 6, 1, 3, CURRENT_DATE - INTERVAL '1 month'),
(5, 4, 2, 2, CURRENT_DATE - INTERVAL '6 months');

-- Запрос
SELECT 
    c.year AS "Год выпуска",
    c.color AS Цвет,
    c.category AS Категория,
    c.price AS Цена
FROM car c
JOIN brand b ON c.brand_id = b.brand_id
JOIN sale s ON c.car_id = s.car_id
WHERE b.brand_name = 'BMW'
  AND s.sale_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY c.price DESC
LIMIT 10;
