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

  -- Revision:
  -- find all the orders which status is not shipped
  -- and their comments contain 'complaint', 'complain' or 'dispute'
  SELECT orderNumber, status, comments, orders.customerNumber, customers.customerName FROM orders
   JOIN customers
   ON orders.customerNumber = customers.customerNumber
   WHERE
	status != "Shipped" AND (comments LIKE "%complaint%" OR
	 comments LIKE "%complain%" OR comments LIKE "%dispute%");  

-- Find all the customers and their sales rep
-- using as an INNER JOIN
-- a row on the LHS of the join is only included in the results 
-- if it has partner in the RHS
SELECT COUNT(*) FROM customers JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber;

--  LEFT JOIN: all the rows on the LHS of the join WILL BE INCLUDED
-- in the results, even if there is nothing to join to in the RHS table
SELECT * FROM customers LEFT JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- FULL OUTER JOIN is a combination of LEFT JOIN and RIGHT JOIN
-- BUT not supported by MySQL

--- DATES
-- MySQL uses the ISO date standard: YYYY-MM-DD
-- Find all orders before 2004-01-01
SELECT * FROM orders WHERE orderDate < "2004-01-01"

-- Find all the orders in the month of June for the year 2003
SELECT * FROM orders WHERE orderDate > "2003-05-31" AND orderDate < "2003-07-01";

-- Alternatively
SELECT * FROM orders WHERE orderDate BETWEEN "2003-06-01" AND "2003-06-30";


-- use the YEAR(), MONTH() and DAY() functions to extract the respective component
-- of a date
SELECT orderNumber, YEAR(orderDate), MONTH(orderDate), DAY(orderDate) FROM orders;

-- using the YEAR and MONTH function to find all orders placed in June 2003
SELECT orderNumber, orderDate FROM orders WHERE YEAR(orderDate) = 2003 AND MONTH(orderDate) = 6;

-- for every order, calculate the penalty date which is 14 days from the order date
SELECT orderNumber, orderDate, DATE_ADD(orderDate, INTERVAL 14 DAY) FROM orders;

-- Find all late orders
select orderNumber, requiredDate, shippedDate, shippedDate - requiredDate AS "Days Late By" 
FROM  orders WHERE shippedDate > requiredDate;

-- AGGREGRATES
-- COUNT
-- SUM - just add up all the columns from the table
SELECT SUM(creditLimit) FROM customers;

-- AVG - AVerage
SELECT AVG(creditLimit) FROM customers;

-- MIN: must be greater than 0
SELECT MIN(creditLimit) FROM customers WHERE creditLimit > 0;

SELECT MAX(creditLimit) FROM customers;

-- Find how much customerNumber 112 has paid us
SELECT SUM(amount) FROM payments WHERE customerNumber = 112;

-- REQUIREMENT: How many employees are stationed at each office

-- The brute force approach
-- 1. find all the possible office codes using DISTINCT to remove duplicates
SELECT DISTINCT officeCode FROM employees;

-- 2. for each office code, manually do a WHERE officeCode = ?
-- for each office, count how many employees there are
SELECT  officeCode, count(*) FROM employees
GROUP BY officeCode;

-- for each office, count how many employees there are

-- 1st. figure out the column that we are grouping by
-- 2nd. whatever column we group by, we MUST select
-- 3rd. what are we aggregrating: COUNT, MIN, MAX, SUM, AVG
SELECT officeCode, COUNT(*)  FROM employees
GROUP BY officeCode;

-- Find out how many customers per country:
SELECT country, COUNT(*) FROM customers
GROUP BY country;

-- We want to know, for every customer, how much have they paid us
SELECT customerNumber, SUM(amount) FROM payments
GROUP BY customerNumber

-- HAVING allows us to filter our groups
-- We want to know, for every customer, how much have they paid us
SELECT customerNumber, SUM(amount) FROM payments
GROUP BY customerNumber
HAVING SUM(amount) > 50000

-- We can give alias to the SUM(amount) and then using HAVING on it
SELECT customerNumber, SUM(amount) AS `Total Paid` FROM payments
GROUP BY customerNumber
HAVING `Total Paid` > 50000

-- Only interested in those from USA and we want to sort by their contributed
-- payment in DESCending order
-- We want to know, for every customer, how much have they paid us
SELECT customerName, payments.customerNumber, SUM(amount) AS `Total Paid` FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
WHERE country="USA"
GROUP BY payments.customerNumber, customerName
HAVING `Total Paid` > 50000
ORDER BY `Total Paid` DESC
LIMIT 10; -- only the first ten results