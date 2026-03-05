CREATE TABLE employees (
employees_id int NOT NULL,
firstname varchar (30) NOT NULL,
lastname varchar (30) NOT NULL,
regdatum date NULL,
CONSTRAINT PK_employees PRIMARY KEY (employees_id)
);