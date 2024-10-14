-- SELECT all columns FROM a table

-- Show all rows and all columns from the employees table
SELECT * FROM employees;

-- To show specific columns, we replace the *
-- with a comma delimited list of the columns
SELECT firstName, lastName, email FROM employees;

-- We can have expressions that are displayed in a new column

-- for each row in orderdetails show the orderNumber and the total amount
SELECT orderNumber, quantityOrdered * priceEach FROM orderdetails;

-- use `AS` to give a column an alias
SELECT orderNumber AS "Order Number", quantityOrdered * priceEach AS "Total" FROM orderdetails;

-- Find all the employees from office code 1
SELECT * FROM employees WHERE officeCode = 1;

-- find all the emplyoees that reports to the employee with employee number 1143
SELECT * FROM employees WHERE reportsTo=1143;

-- Find all the employees from officeCode 1 and show only their first name
-- last name and email
SELECT firstName, lastName, email FROM employees WHERE officeCode = 1;

-- find all the customers from France and display their contact's information
SELECT customerName, contactLastName, contactFirstName, phone FROM customers WHERE country = "France";

-- Find all the customers whose credit limit is more than 50,000

-- Logical operators: AND, OR
-- Find all the customers in the USA whose credit limit is more than 50000
SELECT * FROM customers WHERE country="USA" AND creditLimit > 50000;

-- Find all the customers who are from the USA or from France
SELECT * FROM customers WHERE country="USA" OR country="France";

-- find all customers from France or from where the USA  and 
-- where regradless of country,their credit limit is more than 50000
SELECT * from customers WHERE creditLimit >= 50000 AND (country="France" OR country="USA");

-- find all the employees whose job title include the word "sales"
-- use LIKE for matching string patterns but if we just provide a string
-- it's the same as using `=`
SELECT * FROM employees WHERE jobTitle LIKE "sales"

-- To find by patterns, we must use the % = a wildcard 
-- The % means ANYTHING

-- match all job titles that ends with "sales"
SELECT * FROM employees WHERE jobTitle LIKE "%sales";

-- match all jobtitles that begins with "sales"
SELECT * FROM employees WHERE jobTitle LIKE "sales%";

-- Match all job title with the word sales in it
SELECT * FROM employees WHERE jobTitle LIKE "%sales%";

-- Join two tables: employees and offices, to find out which country and state
-- they are stationed
SELECT * FROM employees JOIN offices
 ON employees.officeCode = offices.officeCode
 

 -- Joins happens first
 -- if we have a select <col1>, <col2>, that happens AFTER the join
 -- actually we are selecting from the joined table
 SELECT firstName, lastName, country, city FROM employees JOIN offices
 ON employees.officeCode = offices.officeCode
 WHERE country="USA"

 -- Order of precedence (SELECT, JOIN, WHERE)
 -- 1. JOIN
 -- 2. WHERE
 -- 3. SELECT
 
 -- For each customer, show their sales rep
 SELECT customerName, firstName, lastName, email FROM customers JOIN  employees
   ON  customers.salesRepEmployeeNumber = employees.employeeNumber;

-- Same as above, but only for customers in the USA
SELECT customerName, firstName, lastName, email, country FROM customers JOIN  employees
   ON  customers.salesRepEmployeeNumber = employees.employeeNumber
   WHERE country="USA"


-- For each employee, show their first name, last name, job title
-- and the first name, last name of their supervisor
-- we can 1: rename a table as we join them
--        2: state which table to take a column from
SELECT supervised_employees.firstName, supervised_employees.lastName, supervised_employees.jobTitle, supervisor.firstName, supervisor.lastName
  FROM employees AS supervised_employees JOIN employees AS supervisor
  ON supervised_employees.reportsTo = supervisor.employeeNumber

-- For each customer, show their sales rep and the sales rep country and city
SELECT customerName, employees.firstName, employees.lastName, offices.country, offices.city FROM customers JOIN employees
  ON customers.salesRepEmployeeNumber = employees.employeeNumber
  JOIN offices
  ON employees.officeCode = offices.officeCode;

  -- You can join by alias:
  SELECT customerName, e.firstName, e.lastName, o.country, o.city
  FROM customers AS c JOIN employees as e
  ON c.salesRepEmployeeNumber = e.employeeNumber
  JOIN offices as o
  ON e.officeCode = o.officeCode;