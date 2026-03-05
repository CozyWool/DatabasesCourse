ALTER TABLE project_participants
ADD CONSTRAINT fk_emp FOREIGN KEY (employees_id)
REFERENCES employees (employees_id),
ADD CONSTRAINT fk_proj FOREIGN KEY (project_id)
REFERENCES project (project_id);

ALTER TABLE skills
ADD CONSTRAINT fk_empl FOREIGN KEY (employees_id)
REFERENCES employees (employees_id),
ADD CONSTRAINT fk_tech FOREIGN KEY (technology_id)
REFERENCES technology (technology_id);

ALTER TABLE contracts
ADD CONSTRAINT fk_cl FOREIGN KEY (client_id)
REFERENCES clients (client_id),
ADD CONSTRAINT fk_tech FOREIGN KEY (project_id)
REFERENCES project (project_id);


ALTER TABLE documents
ADD CONSTRAINT fk_doc FOREIGN KEY (project_id)
REFERENCES project (project_id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE designation_employees 
ADD CONSTRAINT fk_dem FOREIGN KEY (employees_id)
REFERENCES employees (employees_id),
ADD CONSTRAINT fk_des FOREIGN KEY (designation_id)
REFERENCES designation (designation_id);