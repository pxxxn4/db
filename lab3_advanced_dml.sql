CREATE DATABASE advanced_lab;


\c advanced_lab;


CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    department VARCHAR(100),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);


CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100),
    budget INTEGER,
    manager_id INTEGER
);


CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

____________________________________________

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1, 'John', 'Doe', 'HR');


INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Jane', 'Smith', 'Finance', DEFAULT, CURRENT_DATE);


INSERT INTO departments (dept_name, budget, manager_id)
VALUES 
('IT', 200000, 1),
('HR', 150000, 2),
('Finance', 300000, 3);


INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Mark', 'Taylor', 'IT', 50000 * 1.1, CURRENT_DATE);


CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE department = 'IT';


____________________________________________


UPDATE employees
SET salary = salary * 1.10;


UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';


UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;


UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';


UPDATE departments d
SET budget = (
    SELECT AVG(e.salary) * 1.2
    FROM employees e
    WHERE e.department = d.dept_name
);


UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';



____________________________________________



DELETE FROM employees
WHERE status = 'Terminated';


DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;


DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT dept_id
    FROM employees e
    JOIN departments d ON e.department = d.dept_name
    WHERE e.department IS NOT NULL
);


DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;



____________________________________________




INSERT INTO employees (first_name, last_name, salary, department, hire_date)
VALUES ('Alice', 'Brown', NULL, NULL, CURRENT_DATE);


UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;


DELETE FROM employees
WHERE salary IS NULL
   OR department IS NULL;



____________________________________________



INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Emma', 'Wilson', 'IT', 60000, CURRENT_DATE)
RETURNING emp_id, first_name || ' ' || last_name AS full_name;


UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;


DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;


____________________________________________


INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'David', 'Miller', 'HR', 45000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees WHERE first_name = 'David' AND last_name = 'Miller'
);


UPDATE employees e
SET salary = salary * CASE
    WHEN (SELECT budget FROM departments d WHERE d.dept_name = e.department) > 100000 THEN 1.10
    ELSE 1.05
END;


INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
('Anna', 'Lee', 'Finance', 50000, CURRENT_DATE),
('Brian', 'Clark', 'IT', 55000, CURRENT_DATE),
('Cathy', 'Adams', 'Sales', 48000, CURRENT_DATE),
('Daniel', 'White', 'HR', 46000, CURRENT_DATE),
('Eva', 'Hall', 'IT', 53000, CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.10
WHERE first_name IN ('Anna','Brian','Cathy','Daniel','Eva');


CREATE TABLE employee_archive AS
TABLE employees WITH NO DATA;

INSERT INTO employee_archive
SELECT * FROM employees WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';


UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND (SELECT COUNT(*) FROM employees e WHERE e.department = p.dept_id::text) > 3;
