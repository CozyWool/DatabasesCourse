CREATE TABLE project (
project_id int NOT NULL,
project_name varchar (30) NOT NULL,
start_date date NOT NULL,
end_date date NOT NULL,
CONSTRAINT PK_project PRIMARY KEY (project_id)
);

CREATE TABLE designation (
designation_id int NOT NULL,
designation_name varchar (30) NOT NULL,
CONSTRAINT PK_designation PRIMARY KEY (designation_id)
);

CREATE TABLE designation_employees (
employees_id int NOT NULL,
designation_id int NOT NULL,
is_primary BOOLEAN DEFAULT FALSE,
CONSTRAINT PK_designation_employees 
	PRIMARY KEY (employees_id, designation_id)
);

CREATE TABLE technology (
technology_id int NOT NULL,
technology_name varchar (30) NOT NULL,
description text NOT NULL,
CONSTRAINT PK_technology PRIMARY KEY (technology_id)
);

CREATE TABLE project_participants (
participants_id int NOT NULL,
employees_id int NOT NULL,
project_id int NOT NULL,
start_date_pr date NOT NULL,
end_date_pr date NOT NULL,
CONSTRAINT PK_employees_project PRIMARY KEY (participants_id)
);

CREATE TABLE skills(
skills_id int NOT NULL,
employees_id int NOT NULL,
technology_id int NOT NULL,
level varchar (30) NOT NULL,
CONSTRAINT PK_skills PRIMARY KEY (skills_id)
);

CREATE TABLE clients(
client_id int NOT NULL,
company_name varchar (60) NOT NULL,
contact_person varchar (60) NOT NULL,
phone varchar (60) NOT NULL,
CONSTRAINT PK_clients PRIMARY KEY (client_id)
);


CREATE TABLE contracts(
contracts_id int NOT NULL,
client_id int NOT NULL,
project_id int NOT NULL,
contracts_date date NOT NULL,
CONSTRAINT PK_contracts PRIMARY KEY (contracts_id)
);

CREATE TABLE documents(
documents_id int NOT NULL,
project_id int NOT NULL,
documents_date date NOT NULL,
CONSTRAINT PK_documents PRIMARY KEY (documents_id)
);