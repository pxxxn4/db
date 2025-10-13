--Yessimkhan Kuanysh 24B031025
--lab5


CREATE DATABASE shop;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC(10,2) CHECK (salary > 0)
);

CREATE TABLE products_catalog (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    regular_price NUMERIC(10,2) CHECK (regular_price > 0),
    discount_price NUMERIC(10,2) CHECK (discount_price > 0) AND (discount_price < regular_price)
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    check_in_date DATE,
    check_out_date DATE CHECK (check_out_date > check_in_date),
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10)
);

INSERT INTO employees (first_name, last_name, email, age, salary)
VALUES
    ('Leeroy', 'Jenkins', 'leeroy.jenkins@mybusiness.com', 30, 250000.00),
    ('Vasya', 'Pupkin', 'vasya.pupkin@mybusiness.com', 28, 360000.00);

INSERT INTO products_catalog (product_name, regular_price, discount_price)
VALUES
    ('Spa room', 100000.00, 80000.00),
    ('Regular room', 20000.00, 15000.00);

INSERT INTO bookings (check_in_date, check_out_date, num_guests)
VALUES
    ('2025-01-01', '2025-01-05', 2),
    ('2025-01-10', '2025-01-15', 4);




INSERT INTO employees (first_name, last_name, email, age, salary)
VALUES
    ('Leeroy', 'Jenkins', 'leeroy.jenkins@mybusiness.com', 108, -100.00);

INSERT INTO products_catalog (product_name, regular_price, discount_price)
VALUES
    ('cat', -100.00, -200.00);

INSERT INTO bookings (check_in_date, check_out_date, num_guests)
VALUES
    ('2025-01-15', '2025-01-05', 20000);




CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    registration_date DATE NOT NULL
);

CREATE TABLE inventory (
    item_id SERIAL PRIMARY KEY NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



INSERT INTO customers (email, phone, registration_date) VALUES
('pupa.lupa@example.com', '123-456-7890', '2025-01-01'),
('yasha.lava@example.com', '098-765-4321', '2025-02-01');

INSERT INTO inventory (item_name, quantity, unit_price) VALUES
('excalibur', 5, 100000.00, NOW()),
('deportator 3000', 10, 20000.00, NOW());

INSERT INTO customers VALUES (2, NULL, '9876543210', '2025-01-13');
INSERT INTO inventory VALUES (102, 'Mouse', NULL, 25.50, NOW());

INSERT INTO customers VALUES (3, 'bob@example.com', NULL, '2025-01-13');



CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES users(user_id),
    course_code INTEGER REFERENCES courses(course_id),
    semester VARCHAR(10) CHECK (semester IN ('Fall', 'Spring', 'Summer'))
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username);

ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);



CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments VALUES 
(1, 'HR', 'Building A'),
(2, 'IT', 'Building B'),
(3, 'Finance', 'Building C');

INSERT INTO departments VALUES (1, 'Marketing', 'Building D');

INSERT INTO departments VALUES (NULL, 'Legal', 'Building E');



CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);


INSERT INTO student_courses VALUES (101, 501, '2025-09-01', 'A');
INSERT INTO student_courses VALUES (101, 502, '2025-09-01', 'B');
INSERT INTO student_courses VALUES (102, 501, '2025-09-01', 'A');

INSERT INTO student_courses VALUES (101, 501, '2025-09-15', 'C');


-- difference between UNIQUE and PRIMARY KEY
-- both make values unique
-- PRIMARY KEY also means the main identifier of the table
-- PRIMARY KEY cannot be NULL, UNIQUE can have NULL
-- a table can have only one PRIMARY KEY but many UNIQUE

-- when to use single or composite primary key
-- single key if one column can identify the row (like dept_id)
-- composite key if you need two or more columns together to be unique (like student_id + course_id)

-- why only one PRIMARY KEY but many UNIQUE
-- because table can have only one main identifier
-- but other columns can also be unique without being the main key


CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'Pupa', 1, '2024-06-01');
INSERT INTO employees_dept VALUES (2, 'Lupa', 2, '2024-07-15');
INSERT INTO employees_dept VALUES (3, 'Kuka', 3, '2024-08-10');

INSERT INTO employees_dept VALUES (4, 'Kitty', 10, '2024-09-01');




CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES (1, 'George Orwell', 'United Kingdom');
INSERT INTO authors VALUES (2, 'A.S. Pushkin', 'Russian Empire');
INSERT INTO authors VALUES (3, 'Ernest Hemingway', 'United States');

INSERT INTO publishers VALUES (1, 'Almaty kitap', 'Almaty');
INSERT INTO publishers VALUES (2, 'Forbes', 'London');
INSERT INTO publishers VALUES (3, 'Kniga bratan', 'Talgar');

INSERT INTO books VALUES (1, '1984', 1, 1, 1949, '9780451524935');
INSERT INTO books VALUES (2, 'Evgeny Onegin', 2, 2, 1825, '9780747532699');
INSERT INTO books VALUES (3, 'The Old Man and the Sea', 3, 3, 1952, '9780684801223');





CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);




INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Books');

INSERT INTO products_fk VALUES (101, 'Smartphone', 1);
INSERT INTO products_fk VALUES (102, 'Novel', 2);

INSERT INTO orders VALUES (1001, '2025-10-13');

INSERT INTO order_items VALUES (1, 1001, 101, 2);
INSERT INTO order_items VALUES (2, 1001, 102, 1);


DELETE FROM categories WHERE category_id = 1;
-- error: update or delete on table "categories" violates foreign key constraint on table "products_fk"
-- ON DELETE RESTRICT prevents deleting a category if related products still exist

DELETE FROM orders WHERE order_id = 1001;
-- deletes order_items with order_id 1001 due to ON DELETE CASCADE








--e-com tasks

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK (price >= 0) NOT NULL,
    stock_quantity INTEGER CHECK (stock_quantity >= 0) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    total_amount NUMERIC CHECK (total_amount >= 0) NOT NULL,
    status TEXT CHECK (status IN ('pending','processing','shipped','delivered','cancelled')) NOT NULL
);

CREATE TABLE order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INTEGER CHECK (quantity > 0) NOT NULL,
    unit_price NUMERIC CHECK (unit_price >= 0) NOT NULL
);

INSERT INTO customers VALUES
(1, 'birdperson', 'bird@sigma.com', '1111111111', '2025-01-01'),
(2, 'poopy bt', 'poo@py.com', '2222222222', '2025-01-15'),
(3, 'Rick Sanchez', 'crazy@science.net', '3333333333', '2025-02-02'),
(4, 'Mr. Goldenhold', 'goldenhold@math.org', '4444444444', '2025-03-03'),
(5, 'Dr. Wong', 'wong@wtf.us', '5555555555', '2025-04-04');

INSERT INTO products (prod_id, prod_name, price) VALUES
(1, 'Energy Drink "Gorilla"', 550),
(2, 'Instant Plov', 890),
(3, 'Smart Mug', 2300),
(4, 'Wireless Charger Pad', 4500),
(5, 'Hoodie "QR"', 9900);





-- too tired to check every submission req 

