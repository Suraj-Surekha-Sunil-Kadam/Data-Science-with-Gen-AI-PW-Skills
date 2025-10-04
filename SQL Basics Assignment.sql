use mavenmovies;




/*
Question 1. Create a table called employees with the following structure
 emp_id (integer, should not be NULL and should be a primary key)
 emp_name (text, should not be NULL)
 age (integer, should have a check constraint to ensure the age is at least 18)
 email (text, should be unique for each employee)
 salary (decimal, with a default value of 30,000).
 Write the SQL query to create the above table with all constraints.
 
 Answer:
*/
CREATE TABLE employees (
  emp_id INT NOT NULL PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  age INT CHECK (age >= 18),
  email VARCHAR(255) UNIQUE,
  salary DECIMAL(10, 2) DEFAULT 30000
);












/*
Question 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.

Answer:
Constraints are rules defined on columns or tables to restrict the type of data that can be stored. Their main purpose is to maintain data integrity—ensuring the accuracy, consistency, and reliability of data in a database.

How constraints help maintain data integrity:
- Prevent invalid, duplicate, or inconsistent data from being stored.
- Enforce business rules automatically at the database level.
- Help ensure relationships between tables are correct.

Common types of constraints:

1. NOT NULL
   Ensures that a column cannot store a NULL value.
   Example: emp_name VARCHAR(100) NOT NULL

2. UNIQUE
   Ensures that all values in a column are different.
   Example: email VARCHAR(255) UNIQUE

3. PRIMARY KEY
   Uniquely identifies each record in a table (combination of NOT NULL + UNIQUE).
   Example: emp_id INT PRIMARY KEY

4. FOREIGN KEY
   Ensures referential integrity between tables by requiring that the value in one table exists in another.
   Example: dept_id INT, FOREIGN KEY (dept_id) REFERENCES departments(dept_id)

5. CHECK
   Validates that values in a column meet a specific condition.
   Example: age INT CHECK (age >= 18)

6. DEFAULT
   Assigns a default value to a column if no value is specified.
   Example: salary DECIMAL(10,2) DEFAULT 30000

These constraints together prevent invalid data entry, enforce relationships, and help databases remain consistent and reliable.
*/











/*
Question 3.
Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.

Answer:
The NOT NULL constraint is applied to a column to ensure that this column cannot have NULL (empty) values.
It guarantees that every record must include a valid, non-missing value in that column.
Applying NOT NULL maintains data integrity and prevents incomplete data entries in critical fields.
For example, an employee’s name or ID should never be NULL since these are essential identifiers.

A primary key cannot contain NULL values.
This is because a primary key uniquely identifies each record, and NULL represents an unknown or missing value, which breaks uniqueness.
The primary key constraint implicitly includes NOT NULL to ensure every record can be uniquely identified.
*/












/*
 Question 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an 
example for both adding and removing a constraint.

Answer:

* Adding Constraints to an Existing Table
Constraints in SQL (such as PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, or NOT NULL) enforce data integrity
rules. To add a constraint to an existing table, you use the ALTER TABLE statement. This modifies the 
table structure without recreating it. 

* Steps to Add a Constraint:

-Identify the Table and Constraint Details: 
Determine the table name, the type of constraint (e.g., PRIMARY KEY), the column(s) it applies to, and 
optionally a name for the constraint (if not named, the database may auto-generate one).

-Check Existing Data: 
Ensure the existing data in the table satisfies the new constraint to avoid errors (e.g., no duplicates 
for a UNIQUE constraint).

-Execute the SQL Command: 
Run the ALTER TABLE statement with the ADD CONSTRAINT clause.

-Verify the Change: 
Query the table's metadata (e.g., using SHOW CREATE TABLE in MySQL or INFORMATION_SCHEMA views) to 
confirm the constraint was added.

Example:
Suppose we have an existing table Employees with columns emp_id (INT), emp_name (VARCHAR), age(INT) and 
salary (INT). We want to add a PRIMARY KEY constraint on EmployeeID. It can be done as below:
*/

ALTER TABLE Employees
ADD CONSTRAINT UQ_emp_name UNIQUE (emp_name);

-- This will give error since this table already have emp_id as Primary key but this is just an example
-- to understand how constraints can be added

/*

* Removing Constraints from an Existing Table
To remove a constraint, you also use the ALTER TABLE statement, but with the DROP CONSTRAINT clause. Note that some constraints (like NOT NULL) might use slightly different syntax in certain databases (e.g., ALTER COLUMN instead), but for named constraints, DROP CONSTRAINT is standard.


* Steps to Remove a Constraint:

-Identify the Constraint: 
Find the exact name of the constraint using database metadata queries (e.g., INFORMATION_SCHEMA.CONSTRAINTS
 or SHOW CREATE TABLE).
 
-Understand Dependencies: 
Check if removing the constraint affects other tables (e.g., dropping a FOREIGN KEY might break referential 
integrity).

-Execute the SQL Command: 
Run the ALTER TABLE statement with the DROP CONSTRAINT clause.

-Verify the Change: 
Query the table's metadata to confirm the constraint is gone.

Example:

Using the same Employees table from above, where we previously added PK_Employees as the PRIMARY KEY on 
emp_id. 

To remove it:
*/

ALTER TABLE employees
DROP CONSTRAINT UQ_emp_name;

show create table employees;










/*
Question 5. Explain the consequences of attempting to insert, update, or delete data in a way that 
violates constraints. Provide an example of an error message that might occur when violating a 
constraint.

Answer:
*/

/*
When an operation (INSERT, UPDATE, DELETE) violates a constraint in a MySQL database, the database 
engine rejects the operation and returns an error. This helps maintain data integrity by preventing 
invalid or inconsistent data from being stored.

Consequences:

The invalid operation fails and does not modify the table.

An error message is returned specifying the violated constraint.

Dependent operations may also fail if executed within a transaction.

Applications must handle these errors to ensure graceful failure or corrective action.
*/

/* Example: Violation of UNIQUE constraint by inserting duplicate email */

INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (101, 'Suraj kadam', 25, 'kadamsuraj086@gmail.com', 70000);

-- Trying to insert another employee with the same email causes error

INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (102, 'Siddhesh', 23, 'kadamsuraj086@gmail.com', 90000);


/* Example Error Message:
Error Code: 1062. Duplicate entry 'kadamsuraj086@gmail.com' for key 'employees.email'
*/

/* Example: Violation of CHECK constraint (age < 18) */

INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (103, 'Teen Employee', 16, 'teen@example.com', 28000);

/* Example Error Message:
Error Code: 3819. Check constraint 'employees_chk_1' is violated.
*/

/* Example: Violation of FOREIGN KEY constraint during INSERT */

alter table city
add constraint UQ_country_id foreign key (country_id) references country (country_id);

INSERT INTO city (city_id, city, country_id, last_update)
VALUES (604, 'India', 1000, '2006-02-15 04:45:25');

SHOW VARIABLES LIKE 'foreign_key_checks';

-- It has returned ON

/* Example Error Message:
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`mavenmovies`.`city`, CONSTRAINT `UQ_country_id` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`))
*/

-- This enforcement ensures the database remains consistent and reliable by preventing invalid modifications.











/*
 Question 6. You created a products table without constraints as follows:
 CREATE TABLE products (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2));
 
 Now, you realise that
 The product_id should be a primary key
 The price should have a default value of 50.00
 
Answer:
*/

CREATE TABLE product (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2));

/* Step 1: Ensure no duplicate or NULL values exist in product_id before adding primary key */
-- Check duplicates
SELECT product_id, COUNT(*)
FROM product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check NULLs
SELECT COUNT(*) FROM product WHERE product_id IS NULL;

/* Step 2: Modify product_id column to NOT NULL */

ALTER TABLE product
MODIFY COLUMN product_id INT NOT NULL;

/* Step 3: Add PRIMARY KEY constraint on product_id */
ALTER TABLE product
ADD PRIMARY KEY (product_id);

/* Step 4: Set default value for price column */
ALTER TABLE product
MODIFY COLUMN price DECIMAL(10, 2) DEFAULT 50.00;

Insert into product (product_id, product_name) values (200, 'Shorts');

select * from product;

/* After this, new rows inserted without specifying price will automatically have price = 50.00 */









/*
Question 7.You have two tables mentioned in the question paper.
Write a query to fetch the student_name and class_name for each student using an INNER JOIN.

Answer:
*/
-- Creating the Classes table first
CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50)
);

-- Insert data into Classes
INSERT INTO Classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

-- Creating the Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT
);

-- Insert data into Students
INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

 -- Query to fetch the student_name and class_name for each student using an INNER JOIN

select student_id, student_name, class_name
from students s 
INNER JOIN classes c 
ON s.class_id = c.class_id;







/*
Question 8. Consider the following three tables:
Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are 
listed even if they are not associated with an order 
Hint: (use INNER JOIN and LEFT JOIN)

Answer
*/

-- First creating the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Insert data into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(101, 'Alice'),
(102, 'Bob');

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert data into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);

-- Creating the Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert data into Products
INSERT INTO Products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);

/* Query: List all product_id, product_name and all customer_names */

SELECT
p.product_id,
p.product_name,
c.customer_name
FROM Products p
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id

UNION

SELECT
NULL AS product_id,
NULL AS product_name,
c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Products p ON o.order_id = p.order_id
WHERE p.product_id IS NULL

ORDER BY customer_name, product_id;










/*
Question 9. Given the following tables:
Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.\

Answer:
*/

-- Create the Products table first, creating it as New_Products since Products table already exists from previous question
CREATE TABLE New_Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

-- Insert data into Products
INSERT INTO New_Products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Create the Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10,2)
);

-- Insert data into Sales
INSERT INTO Sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

-- -> 

SELECT
    np.product_id,
    np.product_name,
    SUM(s.amount) AS total_sales_amount
FROM NEW_Products np
INNER JOIN Sales s ON np.product_id = s.product_id
GROUP BY np.product_id, np.product_name;

/*
Output:

101	Laptop	1200.00
102	Phone	300.00
*/









/*
Question 10. 10. You are given three tables:
 Write a query to display the order_id, customer_name, and the quantity of products ordered by each 
customer using an INNER JOIN between all three tables.

Answer:
*/

-- Create new_Orders table as Orders table used in previous examples

CREATE TABLE new_Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT
);

-- Insert data into new_Orders
INSERT INTO new_Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Create new_Customers table as Customers table is used in previous question
CREATE TABLE new_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Insert sample data into customers
INSERT INTO new_customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Create Order_Details table
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);

-- Insert sample data into Order_Details
INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);


-- ->

SELECT
    o.order_id,
    c.customer_name,
    od.quantity
FROM new_orders o
INNER JOIN new_customers c ON o.customer_id = c.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
ORDER BY o.order_id, od.product_id;

/*
Output:

1	Alice	2
1	Alice	1
2	Bob	    3
*/
-- The below query helped me to understand the database structure more nicely
SELECT
  c.TABLE_NAME,
  c.COLUMN_NAME,
  c.COLUMN_TYPE,
  k.CONSTRAINT_NAME,
  t.CONSTRAINT_TYPE
FROM
  INFORMATION_SCHEMA.COLUMNS c
LEFT JOIN
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE k
  ON c.TABLE_SCHEMA = k.TABLE_SCHEMA
  AND c.TABLE_NAME = k.TABLE_NAME
  AND c.COLUMN_NAME = k.COLUMN_NAME
LEFT JOIN
  INFORMATION_SCHEMA.TABLE_CONSTRAINTS t
  ON k.TABLE_SCHEMA = t.TABLE_SCHEMA
  AND k.TABLE_NAME = t.TABLE_NAME
  AND k.CONSTRAINT_NAME = t.CONSTRAINT_NAME
WHERE
  c.TABLE_SCHEMA = 'mavenmovies';










-- SQL Commands



/*
Question 1. Identify the primary keys and foreign keys in maven movies db. Discuss the differences.

Answer:
*/
SELECT 
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.CONSTRAINT_NAME,
    CASE 
        WHEN kcu.CONSTRAINT_NAME = 'PRIMARY' THEN 'Primary Key'
        WHEN kcu.REFERENCED_TABLE_NAME IS NOT NULL THEN 'Foreign Key'
    END AS CONSTRAINT_TYPE,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
LEFT JOIN 
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
    ON kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME 
    AND kcu.TABLE_SCHEMA = rc.CONSTRAINT_SCHEMA
WHERE 
    kcu.TABLE_SCHEMA = 'mavenmovies'
    AND (kcu.CONSTRAINT_NAME = 'PRIMARY' OR kcu.REFERENCED_TABLE_NAME IS NOT NULL)
ORDER BY 
    kcu.TABLE_NAME, 
    kcu.COLUMN_NAME, 
    CONSTRAINT_TYPE;



-- Below is a detailed discussion of the differences between primary keys and foreign keys, according to
-- the Maven Movies database schema:

/*
* Purpose:

Primary Key: A primary key uniquely identifies each record in a table, ensuring no two rows have the same
key value. It serves as the main identifier for a table. For example, in the actor table, actor_id is the
primary key, ensuring each actor has a unique identifier (e.g., no two actors can have the same actor_id).

Foreign Key: A foreign key establishes a relationship between two tables by referencing the primary key 
(or a unique key) of another table. It ensures referential integrity, meaning the foreign key value must 
exist in the referenced table or be NULL. For example, in the customer table, address_id is a foreign key
referencing address.address_id, ensuring every customer is linked to a valid address.


* Uniqueness and Nullability:

Primary Key: Must be unique and cannot contain NULL values. This ensures every record is distinctly 
identifiable. For instance, film.film_id is a primary key and cannot be NULL or duplicated, guaranteeing 
each film has a unique ID.

Foreign Key: Does not need to be unique and can often be NULL (unless constrained otherwise). Multiple 
rows can reference the same value in the parent table. For example, multiple rows in rental can have the
same customer_id (foreign key referencing customer.customer_id), indicating multiple rentals by the 
same customer, and customer.address_id could theoretically be NULL if the relationship is optional 
(though the schema doesn’t specify this).


* Scope:

Primary Key: Applies only within its own table to enforce uniqueness. For example, payment.payment_id is 
a primary key that uniquely identifies payment records within the payment table.

Foreign Key: Spans across tables to link them. For instance, film_actor.actor_id is a foreign key 
referencing actor.actor_id, creating a relationship between the film_actor junction table and the actor
table to track which actors appear in which films.


* Quantity per Table:

Primary Key: A table typically has one primary key, which can be a single column (e.g., store.store_id) 
or composite (e.g., film_actor with actor_id and film_id). The Maven Movies schema shows composite 
primary keys in tables like film_actor and film_category.
Foreign Key: A table can have multiple foreign keys, each linking to different tables. For example, 
the customer table has two foreign keys: store_id (referencing store.store_id) and address_id 
(referencing address.address_id).


* Role in Relationships:

Primary Key: Acts as the "parent" in a relationship, providing the values that foreign keys reference. 
For example, category.category_id is the primary key that film_category.category_id (a foreign key) 
references to link films to their categories.

Foreign Key: Acts as the "child" in a relationship, enforcing that only valid primary key values from 
the parent table are used. For instance, payment.rental_id (foreign key) references rental.rental_id 
(primary key), ensuring payments are tied to existing rentals.


* Indexing:

Primary Key: Automatically creates a unique index in MySQL to enforce uniqueness and optimize lookups. 
For example, querying film.film_id benefits from the index created by its primary key constraint.

Foreign Key: MySQL automatically creates an index on foreign key columns to optimize joins and 
referential checks, but the values themselves don’t need to be unique. For example, inventory.film_id 
(foreign key to film.film_id) is indexed to speed up queries joining inventory and film.


* Data Integrity:

Primary Key: Ensures entity integrity by preventing duplicate or NULL entries in the key column(s). 
For example, rental.rental_id ensures no two rental records are identical.

Foreign Key: Ensures referential integrity by preventing invalid references. For example, you cannot 
insert a row into film_actor with an actor_id that doesn’t exist in the actor table, thanks to the 
foreign key constraint fk_film_actor_actor.


* Examples from Maven Movies Schema:

Primary Key Example: In the staff table, staff_id is the primary key, ensuring each staff member has a 
unique identifier. The query output would show staff | staff_id | PRIMARY | Primary Key | NULL | NULL.

Foreign Key Example: In the staff table, address_id is a foreign key referencing address.address_id, 
ensuring every staff member is associated with a valid address. The query output would show 
staff | address_id | fk_staff_address | Foreign Key | address | address_id.

Composite Key Example: The film_actor table has a composite primary key (actor_id, film_id) and also 
uses these columns as foreign keys (fk_film_actor_actor and fk_film_actor_film), linking to 
actor.actor_id and film.film_id, respectively.
*/










/*
Question 2. List all details of actors

Answer:
*/

SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    a.last_update,
    GROUP_CONCAT(f.title) AS films
FROM 
    mavenmovies.actor a
LEFT JOIN 
    mavenmovies.film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN 
    mavenmovies.film f ON fa.film_id = f.film_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name, a.last_update
ORDER BY 
    a.actor_id;










/*
Question 3. List all customer information from database

Answer: 
*/

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.active,
    c.create_date,
    c.last_update AS customer_last_update,
    s.store_id,
    s.manager_staff_id AS store_manager_id,
    a.address_id,
    a.address,
    a.address2,
    a.district,
    a.postal_code,
    a.phone,
    a.last_update AS address_last_update,
    ci.city,
    co.country
FROM 
    mavenmovies.customer c
LEFT JOIN 
    mavenmovies.store s ON c.store_id = s.store_id
LEFT JOIN 
    mavenmovies.address a ON c.address_id = a.address_id
LEFT JOIN 
    mavenmovies.city ci ON a.city_id = ci.city_id
LEFT JOIN 
    mavenmovies.country co ON ci.country_id = co.country_id
ORDER BY 
    c.customer_id;
  
  
  
  
  
  
  
  
    
/*
Question 4. List different countries

Answer:
*/

SELECT 
    country
FROM 
    country
ORDER BY 
    country;
    
   
   
   
   
   
   
   
   
/*
Question 5. Display all active customers

Answer:
*/

SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    address_id,
    active,
    create_date,
    last_update
FROM 
    customer
WHERE 
    active = 1
ORDER BY 
    customer_id;
   
   
   
   
   
   
   
   
   
   
/*
Question 6 -List of all rental IDs for customer with ID 1.

Answer:
*/

SELECT 
    rental_id
FROM 
    rental
WHERE 
    customer_id = 1
ORDER BY 
    rental_id;
    
   
   
   
   
   
   
   
   
   
/*
Question 7 - Display all the films whose rental duration is greater than 5.

Answer:
*/

SELECT 
    film_id,
    title,
    rental_duration
FROM 
    mavenmovies.film
WHERE 
    rental_duration > 5
ORDER BY 
    rental_duration, title;










/*
Question 8 - List the total number of films whose replacement cost is greater than $15 and less than $20

Answer:
*/

select count(film_id)
from film
where replacement_cost > 15 
    AND replacement_cost < 20;









/*
Question 9 - Display the count of unique first names of actors.

Answer:
*/

SELECT 
    COUNT(DISTINCT first_name) AS unique_first_names
FROM 
    actor;
    
-- output: 128









/*
Question 10- Display the first 10 records from the customer table.

Answer:
*/

select * 
from customer
limit 10;









/*
Question 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.

Answer:
*/

select *
from customer
where first_name like "b%"
limit 3;









/*
Question 12 -Display the names of the first 5 movies which are rated as ‘G’

Answer:
*/

select f.title 
from film f
where rating = 'G'
limit 5;










/*
Question 13-Find all customers whose first name starts with "a".

Answer:
*/

select *
from customer
where first_name like "a%"
order by first_name;











/*
Question 14- Find all customers whose first name ends with "a".

Answer:
*/

select *
from  customer
where first_name like "%a";









/*
Question 15- Display the list of first 4 cities which start and end with ‘a’ .

Answer:
*/

select city
from city
where city like "a%a"
limit 4;








/*
Question 16- Find all customers whose first name have "NI" in any position.

Answer:
*/

select customer_id, first_name, last_name 
from customer
where first_name like '%NI%';





/*
Question 17- Find all customers whose first name have "r" in the second position .

Answer:
*/
select customer_id, first_name, last_name
from customer
where first_name like "_r%";








/*
Question 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.

Answer:
*/
select customer_id, first_name, last_name
from customer
where first_name like "a%" and length(first_name) >=5;








/*
Question 19- Find all customers whose first name starts with "a" and ends with "o".

Answer:
*/

select customer_id, first_name, last_name
from customer
where first_name like "a%o";







/*
Question 20 - Get the films with pg and pg-13 rating using IN operator.

Answer:
*/

select film_id, title, rating
from film
where rating in ('pg','pg-13');









/*
Question 21 - Get the films with length between 50 to 100 using between operator.

Answer:
*/

select film_id, title, length
from film
where length between 50 and 100;








/*
Question 22 - Get the top 50 actors using limit operator.

Answer:
*/

SELECT 
    actor_id, first_name, last_name
FROM
    actor
LIMIT 50;









/*
Question 23 - Get the distinct film ids from inventory table

Answer:
*/

SELECT DISTINCT
    film_id
FROM
    inventory;











--  Functions


-- Basic Aggregate Functions:




/*
Question 1:
 Retrieve the total number of rentals made in the Sakila database.
 Hint: Use the COUNT() function

Answer:
*/

use sakila;

select count(*) as total_rentals
from rental;










/*
Question 2:
 Find the average rental duration (in days) of movies rented from the Sakila database.
 Hint: Utilize the AVG() function.
 
 Answer:
*/

select round(avg(datediff(return_date, rental_date)), 2) as average_rental_duration_days
from rental
where return_date is NOT NULL;









 -- String Functions:
 
 
 
 /*
 Question 3:
 Display the first name and last name of customers in uppercase.
 Hint: Use the UPPER () function.
 
 Answer:
*/

select upper(first_name) as first_name, upper(last_name) as last_name
from customer;












/*
Question 4:
Extract the month from the rental date and display it alongside the rental ID.
Hint: Employ the MONTH() function

Answer:
*/

select rental_id, month(rental_date) as rental_month
from rental;











 -- GROUP BY:
 
 

 /*
Question 5:
Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
Hint: Use COUNT () in conjunction with GROUP BY.
 
 Answer:
*/

select customer_id, count(*) as rental_count
from rental
group by customer_id;








/*
Question 6:
 Find the total revenue generated by each store.
 Hint: Combine SUM() and GROUP BY
 
 Answer:
*/

SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM 
    payment p
JOIN 
    staff s ON p.staff_id = s.staff_id
GROUP BY 
    s.store_id
ORDER BY 
    s.store_id;
    
    
    
    
    
    
    
    
    
    
/*
Question 7:
Determine the total number of rentals for each category of movies.
Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.

Answer:
*/

SELECT 
    c.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM 
    category c
LEFT JOIN 
    film_category fc ON c.category_id = fc.category_id
LEFT JOIN 
    film f ON fc.film_id = f.film_id
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    c.category_id, c.name
ORDER BY 
    c.name;
    
    
    
    
    
    
    
    
    
    
    
    
    
/*
Question 8:
Find the average rental rate of movies in each language.
Hint: JOIN film and language tables, then use AVG () and GROUP BY.

Answer:
*/

use mavenmovies;

SELECT 
    l.name AS language_name,
    COALESCE(ROUND(AVG(f.rental_rate), 2), 0.00) AS avg_rental_rate,
    COUNT(f.film_id) AS film_count,
    l.language_id
FROM 
    mavenmovies.language l
LEFT JOIN 
    film f ON l.language_id = f.original_language_id
GROUP BY 
    l.language_id, l.name
ORDER BY 
    l.name;








--  Joins

/*
Questions 9 -
 Display the title of the movie, customer s first name, and last name who rented it.
 Hint: Use JOIN between the film, inventory, rental, and customer tables.
 
 Answer:
 */

select 
	f.title, 
    c.first_name, 
    c.last_name
from 
rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
inner join customer c on r.customer_id = c.customer_id;








/*
 Question 10:
 Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
 Hint: Use JOIN between the film actor, film, and actor tables.
 
 Answer:
*/
select 
	a.first_name,
    a.last_name
from 
film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where title = "Gone with the Wind";












/*
Question 11:
 Retrieve the customer names along with the total amount they've spent on rentals.
 Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.
 
 Answer:
*/

select 
	c.first_name,
    c.last_name,
    SUM(p.amount) as total_amount
from customer c
inner join payment p on c.customer_id = p.customer_id
inner join rental r on p.rental_id = r.rental_id
group by 
	c.first_name,
    c.last_name;










/*
Question 12:
 List the titles of movies rented by each customer in a particular city (e.g., 'London').
 Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.
 
 Answer:
*/
select 
	GROUP_CONCAT(f.title) AS rented_movies,
    c.first_name,
    c.last_name,
    ci.city
from 
customer c
inner join address a on c.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where
	city = 'LONDON'
group by
	c.first_name,
    c.last_name,
    ci.city;
	
    
    
    
    
    
    
    
    
    
    
    
-- Advanced Joins and GROUP BY:
    
    
    
    
/*
 Question 13:
 Display the top 5 rented movies along with the number of times they've been rented.
 Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.
 
 Answer:
*/
select 
	f.title, 
	count(f.title) as no_times_movie_rented
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by
	f.title
limit 5;








/*
Question 14:
 Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
 Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.

Answer:
*/
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM 
    customer c
    INNER JOIN rental r ON c.customer_id = r.customer_id
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE 
    i.store_id IN (1, 2)
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
HAVING 
    COUNT(DISTINCT i.store_id) = 2;
    
    
    
    
    
    
    
    
    
    
-- Windows Function:






/*
Question 1. Rank the customers based on the total amount they've spent on rentals.

Answer:
*/
SELECT
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(payment.amount) DESC) AS cust_rank
FROM
    customer
    INNER JOIN rental ON customer.customer_id = rental.customer_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY
    customer.customer_id,
    customer.first_name,
    customer.last_name
ORDER BY
    total_spent DESC;










/*
 Question 2. Calculate the cumulative revenue generated by each film over time.alter
 
Answer:
*/
SELECT
    film.title,
    rental.rental_date,
    SUM(payment.amount) OVER (
        PARTITION BY film.film_id
        ORDER BY rental.rental_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM
    rental
    INNER JOIN payment ON rental.rental_id = payment.rental_id
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film ON inventory.film_id = film.film_id
ORDER BY
    film.title,
    rental.rental_date;









/*
Question 3. Determine the average rental duration for each film, considering films with similar lengths.

Answer:
*/
SELECT
    film.title,
    AVG(DATEDIFF(rental.return_date, rental.rental_date)) AS avg_rental_duration_days
FROM
    film
    INNER JOIN inventory ON film.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE
    rental.return_date IS NOT NULL  -- Only include rentals that have been returned
GROUP BY
    film.film_id,
    film.title
ORDER BY
    avg_rental_duration_days DESC;







    
/*
Question 4. Identify the top 3 films in each category based on their rental counts.

Answer:
*/
WITH RankedFilms AS (
    SELECT
        category.name AS category_name,
        film.title,
        COUNT(rental.rental_id) AS rental_count,
        ROW_NUMBER() OVER (
            PARTITION BY category.category_id
            ORDER BY COUNT(rental.rental_id) DESC
        ) AS cat_rank
    FROM
        film
        INNER JOIN film_category ON film.film_id = film_category.film_id
        INNER JOIN category ON film_category.category_id = category.category_id
        INNER JOIN inventory ON film.film_id = inventory.film_id
        INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
    GROUP BY
        category.category_id,
        category.name,
        film.film_id,
        film.title
)
SELECT
    category_name,
    title,
    rental_count
FROM
    RankedFilms
WHERE
    cat_rank <= 3
ORDER BY
    category_name,
    rental_count DESC;









/*
Question. 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
 across all customers.
 
 Answer:
*/
use mavenmovies;

WITH CustomerRentals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(r.rental_id) AS total_rentals
    FROM rental r
    INNER JOIN payment p ON r.rental_id = p.rental_id
    INNER JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
AverageRental AS (
    SELECT AVG(total_rentals) AS avg_rentals FROM CustomerRentals
)
SELECT
    cr.first_name,
    cr.last_name,
    cr.total_rentals,
    ar.avg_rentals,
    cr.total_rentals - ar.avg_rentals AS difference_from_avg
FROM CustomerRentals cr
CROSS JOIN AverageRental ar;










/*
Question  6. Find the monthly revenue trend for the entire rental store over time

Answer:
*/
SELECT
    EXTRACT(YEAR FROM r.rental_date) AS rental_year,
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    SUM(p.amount) AS total_monthly_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY rental_year, rental_month
ORDER BY rental_year, rental_month;
 









/*
Question 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.

Answer:
*/

WITH CustomerSpending AS (
    SELECT
        p.customer_id,
        SUM(p.amount) AS total_spent
    FROM payment p
    GROUP BY p.customer_id
),
RankedCustomers AS (
    SELECT
        customer_id,
        total_spent,
        ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS spent_rank,
        COUNT(*) OVER () AS total_customers
    FROM CustomerSpending
)
SELECT
    customer_id,
    total_spent
FROM RankedCustomers
WHERE spent_rank <= total_customers * 0.20
ORDER BY total_spent DESC;










/*
Question 8. Calculate the running total of rentals per category, ordered by rental count.

Answer:
*/
WITH CategoryRentalCounts AS (
    SELECT
        c.name as name,
        COUNT(r.rental_id) AS rental_count
    FROM category c 
    inner join film_category fc on c.category_id = fc.category_id
    inner join inventory i on fc.film_id = i.film_id
    inner join rental r on i.inventory_id = r.inventory_id
    GROUP BY c.name
)
SELECT
    name,
    rental_count,
    SUM(rental_count) OVER (ORDER BY rental_count) AS running_total_rentals
FROM CategoryRentalCounts
ORDER BY rental_count;

 
 
 
 
 
 
 
 
 /*
 Question 9. Find the films that have been rented less than the average rental count for their 
 respective categories.
 
 Answer:
 */
WITH FilmRentalCounts AS (
    SELECT
		fc.film_id,
        fc.category_id as category_id,
        c.name as name,
        COUNT(r.rental_id) AS rental_count
    FROM category c 
    inner join film_category fc on c.category_id = fc.category_id
    inner join inventory i on fc.film_id = i.film_id
    inner join rental r on i.inventory_id = r.inventory_id
    GROUP BY fc.film_id, fc.category_id
),
CategoryAverage AS (
    SELECT
        category_id,
        AVG(rental_count) AS avg_rental_count
    FROM FilmRentalCounts
    GROUP BY category_id
)
SELECT
    frc.film_id,
    frc.category_id,
    frc.rental_count,
    ca.avg_rental_count
FROM FilmRentalCounts frc
JOIN CategoryAverage ca ON frc.category_id = ca.category_id
WHERE frc.rental_count < ca.avg_rental_count;





 
 
/*
Question 10. Identify the top 5 months with the highest revenue and display the revenue generated in 
each month

Answer
*/ 
 SELECT
    EXTRACT(YEAR FROM r.rental_date) AS rental_year,
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    SUM(p.amount) AS total_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY rental_year, rental_month
ORDER BY total_revenue DESC
LIMIT 5;





Use sakila;

-- I used below code to fetech all columns and constrains from all tables in Sakila database 

 SELECT 
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.CONSTRAINT_NAME,
    CASE 
        WHEN kcu.CONSTRAINT_NAME = 'PRIMARY' THEN 'Primary Key'
        WHEN kcu.REFERENCED_TABLE_NAME IS NOT NULL THEN 'Foreign Key'
    END AS CONSTRAINT_TYPE,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
LEFT JOIN 
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
    ON kcu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME 
    AND kcu.TABLE_SCHEMA = rc.CONSTRAINT_SCHEMA
WHERE 
    kcu.TABLE_SCHEMA = 'sakila'
    AND (kcu.CONSTRAINT_NAME = 'PRIMARY' OR kcu.REFERENCED_TABLE_NAME IS NOT NULL)
ORDER BY 
    kcu.TABLE_NAME, 
    kcu.COLUMN_NAME, 
    CONSTRAINT_TYPE;
 
 
 
 
 
 
 
 
 
 
 
 -- Normalisation & CTE
 
 
 
 
 
 
 
 /*
  1. First Normal Form (1NF):
               a. Identify a table in the Sakila database that violates 1NF. Explain how you
               would normalize it to achieve 1NF.
 
 Answer:
 */
 
 -- a. Identify a table in the Sakila database that violates 1NF.
 
 /*
A table is in First Normal Form if:

All columns contain atomic values (indivisible).

There are no repeating groups or arrays/multivalued attributes.

Each row is uniquely identifiable (usually via a primary key). 
 
 */
 
 -- To identify a table in the Sakila database that violates the First Normal Form (1NF) using an SQL 
 -- query, we need to look for tables with columns that store multi-valued or non-atomic data.

-- This query searches for columns in all tables where values might contain commas, which are often used
-- to separate multiple values (i.e., multi-valued attributes).


SELECT 
    table_name,
    column_name,
    data_type
FROM 
    information_schema.columns
WHERE 
    table_schema = 'sakila'
    AND data_type IN ('varchar', 'text', 'longtext', 'mediumtext')
    AND column_name NOT IN ('email')  -- Optional: Exclude known safe columns
ORDER BY 
    table_name;

/*

In the Sakila database, the film table contains a column called special_features.

This column stores multiple values in a single field (e.g., "Trailers,Deleted Scenes,Behind the Scenes").

According to the First Normal Form (1NF), each field must hold atomic (indivisible) values, and there 
should be no repeating groups or arrays.

Thus, the film table violates 1NF because special_features is a multi-valued attribute.
 
*/
use sakila;
 -- SQL Implementation
 
SELECT film_id, title, special_features 
FROM film 
LIMIT 5;

-- b. How to Normalize the Table to Achieve 1NF

/*
To bring the table into 1NF, we must remove multi-valued attributes and create a separate table to store them.

Steps:
Create a new table, e.g., film_special_features.

Store one special feature per row instead of multiple features in a single column.

Maintain a foreign key relationship with the film table.

*/
 
 CREATE TABLE film_special_features (
    film_id SMALLINT UNSIGNED NOT NULL,
    feature VARCHAR(50) NOT NULL,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

INSERT INTO film_special_features (film_id, feature)
VALUES
(1, 'Trailers'),
(1, 'Deleted Scenes'),
(2, 'Trailers'),
(3, 'Trailers'),
(3, 'Behind the Scenes');

select * from film_special_features;

ALTER TABLE film DROP COLUMN special_features;

/*
Final Normalized Structure:

film table → stores film details (atomic values only).

film_special_features table → stores one feature per row with foreign key link to film.
*/








/*
Question 2. Second Normal Form (2NF):
               a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
            If it violates 2NF, explain the steps to normalize it.
            
Answer:

a. How to Determine if a Table is in 2NF?

The rules of 2NF:

The table must already be in 1NF (all attributes atomic).

Every non-key attribute must depend on the whole primary key, not just part of it (i.e., no partial dependency).

Partial dependency happens only when the primary key is composite (made of more than one column).

*/

SELECT 
    TABLE_NAME, 
    COUNT(COLUMN_NAME) AS pk_columns
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'sakila'
  AND CONSTRAINT_NAME = 'PRIMARY'
GROUP BY TABLE_NAME
HAVING COUNT(COLUMN_NAME) > 1;


-- from Sakila Database: film_category and film_actor Tables seems to have composite key:

SHOW CREATE TABLE film_category;
-- OR
DESCRIBE film_category;

-- Primary Key = (film_id, category_id) → composite key.
-- Non-key attribute = last_update


-- b. Checking for 2NF Violation

/*

last_update depends on the entire composite key (film_id + category_id) and not just one part.

So, film_category does not violate 2NF.

For every unique (film_id, category_id) pair, there is exactly one last_update value.

last_update does not depend on just film_id (because one film can belong to multiple categories).

last_update does not depend on just category_id (because one category has many films).

Instead, it depends on the relationship between that particular film and that particular category.

*/

-- Now checking if film_actor table violates 2NF

/*

actor_id → no partial dependency (it cannot determine film_id alone).

film_id → no partial dependency (it cannot determine actor_id alone).

last_update → depends on the combination (film_id, actor_id) (when a specific actor is linked to a specific film, you track when it was last updated).

No other attributes (like actor_name or film_title) are stored here, so no partial dependency exists.
*/







/*
Question 3. Third Normal Form (3NF):
               a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
               present and outline the steps to normalize the table to 3NF.
               
Answer:

A table is in 3NF if:

It is already in 2NF.

It has no transitive dependencies → i.e., non-key attributes must depend only on the key, not on another
non-key attribute.

*/
SELECT 
    a.address_id,
    a.address,
    a.district,
    a.city_id,
    c.city,
    c.country_id,
    co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
LIMIT 10;

/*
Here Each address_id determines a city_id.

That city_id determines a country_id.

Hence address_id indirectly determines country.
*/

-- Show Why This Violates 3NF

-- If we were to (wrongly) include country inside address, then country would repeat for all addresses 
-- in the same city.


-- SQL Query to check for redundancy

SELECT 
    c.city,
    co.country,
    COUNT(*) AS num_addresses
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
GROUP BY c.city, co.country
HAVING COUNT(*) > 1;

-- This will show cities like Calgary (Canada) appearing for multiple addresses — proving that storing 
-- country in address would cause duplication.

/*

Instead of redundancy, we keep the proper relations:

address (address_id, address, district, city_id, postal_code, phone, last_update)

city (city_id, city, country_id, last_update)

country (country_id, country, last_update)

Now each non-key attribute depends directly on its primary key.


Thus,

The address table has a transitive dependency:

address_id → city_id → country_id → country

It can be verified using below SQL Query:
*/

SELECT a.address_id, a.address, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;

/*
This shows that country is not directly dependent on address_id, but on city_id (a non-key attribute).

To achieve 3NF, we separate into three tables: address, city, country.

This removes redundancy (e.g., “Canada” stored once per country instead of many times per address).
*/








/*
Question 4. Normalization Process:
               a. Take a specific table in Sakila and guide through the process of normalizing it from the initial  
            unnormalized form up to at least 2NF
            
Answer:
*/

-- Lets take film table from sakila database:

select * from film;

/*

Looking at film table's rows, we notice:

Attributes like title, description, release_year, rental info, rating, etc. are stored properly.

But the issue is with multi-valued / non-atomic fields such as special_features (not shown in your rows 
but exists in the original Sakila schema). It allows multiple values like:

"Trailers,Deleted Scenes,Behind the Scenes"

This violates 1NF because values are not atomic.
*/

-- 1NF (First Normal Form)

-- Rule: Each attribute must be atomic (no multi-valued or repeating groups).

-- To fix special_features, we create a new table film_special_features:

CREATE TABLE new_film_special_features (
    film_id SMALLINT UNSIGNED NOT NULL,
    feature VARCHAR(50) NOT NULL,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

/*
Now instead of having one row with multiple features, we insert atomic rows:

film_id | feature
-----------------
1       | Trailers
1       | Deleted Scenes
1       | Behind the Scenes


Now the film table satisfies 1NF.


2NF (Second Normal Form)

Rule: A table is in 2NF if:

It is already in 1NF.

All non-key attributes are fully dependent on the whole primary key (not part of it).

In the film table, the primary key is film_id (a single column).

All other attributes (title, description, release_year, rental_duration, etc.) depend only on film_id.

Since there is no composite key, partial dependency is not possible.

Therefore, after fixing special_features, the film table is already in 2NF.


Normalization process of Sakila film table:

UNF: special_features contains multi-valued attributes (e.g., “Trailers,Deleted Scenes”).

1NF: Split special_features into a new table film_special_features(film_id, feature) so every attribute
is atomic.

2NF: The film table already satisfies 2NF because its primary key is a single column (film_id) and 
all non-key attributes depend on it.
*/








/*
Question 5. CTE Basics:
                a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
                have acted in from the actor and film_actor tables.
                
Answer:
*/

WITH ActorFilmCount AS (
    SELECT 
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT DISTINCT actor_name, film_count
FROM ActorFilmCount
ORDER BY film_count DESC, actor_name;

/*
CTE (ActorFilmCount):
Joins actor and film_actor.
Groups by actor_id so each actor is counted once.
Uses COUNT(fa.film_id) to get the number of films per actor.

Final SELECT
Pulls distinct actor names with their film counts.
Orders by number of films (descending), then by name for readability.
*/







/*
Question 6. CTE with Joins:
                a. Create a CTE that combines information from the film and language tables to display the film title, 
                 language name, and rental rate.
                 
Answer:
*/
WITH FilmLanguage AS (
    SELECT 
        f.film_id,
        f.title,
        l.name AS language_name,
        f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT title, language_name, rental_rate
FROM FilmLanguage
ORDER BY title;

/*
CTE (FilmLanguage)
Joins film with language using language_id.
Retrieves film title, language name, and rental rate.

Final SELECT
Pulls results from the CTE.
Orders by title for clarity.
*/










/*
Question 7. CTE for Aggregation:
               a. Write a query using a CTE to find the total revenue generated by each customer 
               (sum of payments) from the customer and payment tables.
                
Answer:
*/

WITH CustomerRevenue AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_revenue
FROM CustomerRevenue
ORDER BY total_revenue DESC;

/*
CTE (CustomerRevenue)
Joins customer with payment.
Aggregates payments (SUM(p.amount)) per customer.
Groups by customer’s ID and name.

Final SELECT
Retrieves aggregated results from the CTE.
Orders by revenue in descending order (top spenders first).
*/









/*
Question 8.  CTE with Window Functions:
               a. Utilize a CTE with a window function to rank films based on their rental duration from
               the film table
               
Answer:               
*/

WITH FilmRank AS (
    SELECT
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM film
)
SELECT film_id, title, rental_duration, rental_rank
FROM FilmRank
ORDER BY rental_rank;

/*
CTE (FilmRank):
Selects film_id, title, and rental_duration.
Uses RANK() OVER (ORDER BY rental_duration DESC) to rank films from longest to shortest rental duration.

Final SELECT:
Retrieves the ranked list from the CTE.
Orders by rental_rank for easy viewing.
*/










/*
Question 9.  CTE and Filtering:
               a. Create a CTE to list customers who have made more than two rentals, and then join this
               CTE with the customer table to retrieve additional customer details.

Answer:
*/

-- Step 1: CTE to identify customers with more than 2 rentals
WITH FrequentRenters AS (
    SELECT
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)

-- Step 2: Join with customer table to get details
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    fr.rental_count
FROM customer c
JOIN FrequentRenters fr
    ON c.customer_id = fr.customer_id
ORDER BY fr.rental_count DESC;

/*
Explanation:
CTE (FrequentRenters):
Aggregates rentals by customer_id
Uses HAVING COUNT(rental_id) > 2 to filter customers who rented more than twice

Join with customer:
Retrieves customer details (first_name, last_name, email)
Includes rental_count from the CTE

ORDER BY:
Lists the most active customers first
*/










/*
Question 10. CTE for Date Calculations:
 a. Write a query using a CTE to find the total number of rentals made each month, considering the 
rental_date from the rental table

Answer:
*/

-- Step 1: CTE to extract year and month, and count rentals
WITH MonthlyRentals AS (
    SELECT
        EXTRACT(YEAR FROM rental_date) AS rental_year,
        EXTRACT(MONTH FROM rental_date) AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date)
)
-- Step 2: Retrieve results
SELECT
    rental_year,
    rental_month,
    total_rentals
FROM MonthlyRentals
ORDER BY rental_year, rental_month;
/*
-- Explanation
CTE (MonthlyRentals):
Extracts year and month from rental_date
Counts rentals for each month

Final SELECT:
Returns rental_year, rental_month, and total rentals per month
Ordered chronologically
*/










/*
Question 11.  CTE and Self-Join:
 a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
together, using the film_actor table.

Answer:
*/

WITH ActorPairs AS (
    SELECT
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM film_actor fa1
    JOIN film_actor fa2
      ON fa1.film_id = fa2.film_id
     AND fa1.actor_id < fa2.actor_id
)
SELECT
    f.title AS film_title,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1_name,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name
FROM ActorPairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
JOIN film f ON ap.film_id = f.film_id
ORDER BY f.title, actor1_name, actor2_name;
/*
Explanation:
ActorPairs CTE – generates all unique actor pairs in the same film (fa1.actor_id < fa2.actor_id avoids duplicates and self-pairs).
JOIN actor a1 & JOIN actor a2 – fetches actor names for both actors in the pair.
JOIN film f – adds the film title for each actor pair.
ORDER BY – sorts the results by film title and actor names for readability.
*/










 /*
 Question 12. CTE for Recursive Search:
					a. Implement a recursive CTE to find all employees in the staff table who report to 
                    a specific manager, considering the reports_to column

Answer:
 
 -- Note: As mentioned in question about considering reports_to column, but there is no such column in
		  any table from database sakila and thus manager_staff_id from store table is used and report_to
          alias is used for it. This was confirmed with SME Abhieshk Singh.
 */
WITH RECURSIVE StaffHierarchy AS (
    -- Anchor: start with the manager
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        st.manager_staff_id AS reports_to,
        s.store_id
    FROM staff s
    JOIN store st 
        ON s.staff_id = st.manager_staff_id
    WHERE s.staff_id = 1   --  Change this to the manager you want to start with or we can use
						   --  WHERE s.staff_id in (1,2)  to get both reports_to(manager_staff_id) column values

    UNION ALL

    -- Recursive: find staff who belong to the same store and report to that manager
    SELECT 
        e.staff_id,
        e.first_name,
        e.last_name,
        sh.staff_id AS reports_to,
        e.store_id
    FROM staff e
    JOIN StaffHierarchy sh 
        ON e.store_id = sh.store_id
       AND e.staff_id <> sh.staff_id
)
SELECT * FROM StaffHierarchy;
/*
Explanation:
Anchor member → picks the starting manager (say staff_id = 1 = Mike Hillyer).
Recursive member → finds employees in the same store (same store_id) who “report to” that manager.
Recursive expansion → if those employees themselves were managers (not in Sakila, but if extended), 
it would keep going.
*/

 
 
 
 
 
 
 