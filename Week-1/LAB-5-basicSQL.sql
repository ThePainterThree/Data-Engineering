-- 1.CREATE the DB
CREATE DATABASE IF NOT EXISTS Lab_sql;
USE Lab_sql;

-- 2. Create the Departments table
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
	department_id INTEGER PRIMARY KEY,
	department_name VARCHAR(50) NOT NULL,
	location VARCHAR(50)
);

-- 3. Insert sample data into Departments.
INSERT INTO departments(department_id, department_name, location) VALUES
(1,'HR','London'),
(2,'Finance','Frankfurt'),
(3,'IT','Berlin'),
(4,'Sales','Paris'),
(5,'Marketing','Madrid');

-- 4. Create the Employees table.
CREATE TABLE employees (
	employee_id INTEGER PRIMARY KEY,
	firstName VARCHAR(50),
    lastName VARCHAR(50),
	gender VARCHAR(10),
    age INTEGER,
	department_id INTEGER,
    city VARCHAR(50),
	salary INTEGER, 
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 5. Insert sample employee data.
INSERT INTO employees(employee_id, firstName, lastName, gender, age, department_id, city, salary) VALUES
(101,'Emma','Wilson','Female',28,1,'London',45000),
(102,'Liam','Smith','Male',35,2,'Manchester',62000),
(103,'Sophia','Brown','Female',31,3,'Berlin',70000),
(104,'Noah','Taylor','Male',42,4,'Paris',68000),
(105,'Olivia','Martin','Female',26,5,'Madrid',48000),
(106,'Lucas','Muller','Male',38,3,'Munich',82000),
(107,'Isabella','Garcia','Female',30,2,'Barcelona',61000),
(108,'Ethan','Johnson','Male',45,1,'Dublin',75000),
(109,'Mia','Anderson','Female',27,4,'Amsterdam',52000),
(110,'James','Thomas','Male',33,3,'London',73000);

-- Practice Questions: Understanding the Data
-- 1. Display all employees.
SELECT * FROM employees;

-- 2. Display only the employee names and salaries.
SELECT firstName, lastName, salary 
FROM employees;

-- 3. Count the total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- 4. Display all unique cities.
SELECT DISTINCT city
FROM employees;

-- 5. Display all unique department IDs.
SELECT department_id 
FROM departments;

-- Filtering
-- 6. Find employees older than 30.
SELECT employee_id ,firstName, lastName, age
FROM employees
WHERE age > 30;

-- 7. Find employees earning more than 60,000.
SELECT employee_id, salary
FROM employees
WHERE salary > 60000;

-- 8. Display employees from London.
SELECT employee_id, firstName, lastName, city
FROM employees
WHERE city ="London";

-- 9. Find employees whose salary is between 50,000 and 75,000.
SELECT employee_id, salary
FROM employees
WHERE salary BETWEEN 50000 AND 75000;

-- 10. Display employees whose first name starts with L.
SELECT firstName, lastName
FROM employees
WHERE firstName LIKE "L%";

-- 11. Display employees whose age is less than 35.
SELECT employee_id ,firstName, lastName, age
FROM employees
WHERE age < 35;

-- Sorting
-- 12. Sort employees by salary (highest first).
SELECT employee_id ,firstName, lastName, salary
FROM employees
ORDER BY salary DESC;

-- 13. Sort employees by age (youngest first).
SELECT employee_id ,firstName, lastName, age
FROM employees
ORDER BY age;

-- 14. Sort employees by city and then salary.
SELECT employee_id ,firstName, lastName, city, salary
FROM employees
ORDER BY city, salary;

-- Aggregate Functions
-- 15. Find the average salary.
SELECT ROUND(AVG(salary), 2) AS average_salary
FROM employees;

-- 16. Find the highest salary.
SELECT MAX(salary) AS highest_salary
FROM employees;

-- 17. Find the minimum salary.
SELECT MIN(salary) AS lowest_salary
FROM employees;

-- 18. Find the average employee age.
SELECT AVG(age) AS avg_age
FROM employees;

-- GROUP BY
-- 19. Count employees in each department.
SELECT d.department_name,
       COUNT(e.employee_id) AS total_employees
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 20. Find the average salary in each department.
SELECT d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 21. Find the highest salary in each department.
SELECT d.department_name,
       MAX(e.salary) AS highest_salary
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 22. Show only departments having more than one employee.
SELECT d.department_name,
       COUNT(e.employee_id) AS total_employees
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1;

-- UPDATE
-- 23. Increase salaries of IT employees by 5%.
-- check the data first
SELECT e.employee_id,
       e.firstName,
       e.lastName,
       d.department_name,
       e.salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

-- update salaries
UPDATE employees e
JOIN departments d
ON e.department_id = d.department_id
SET e.salary = e.salary * 1.05
WHERE d.department_name = 'IT';

-- confirm changes
SELECT e.employee_id,
       e.firstName,
       e.lastName,
       d.department_name,
       e.salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

-- 24. Change the city of EmployeeID 109 to Brussels.

-- check data first
SELECT employee_id,
       firstName,
       lastName,
       city
FROM employees
WHERE employee_id = 109;

-- update city for id 109
UPDATE employees
SET city = 'Brussels'
WHERE employee_id = 109;

-- confirm change
SELECT employee_id, city
FROM employees;

-- DELETE
-- 25. Delete employees whose salary is below 48,000.
-- check data 
SELECT employee_id, salary
FROM employees
WHERE salary < 48000;

-- delete
DELETE FROM employees
WHERE salary < 48000;


-- JOIN Exercises
-- 26. Display each employee along with their department name.
SELECT e.firstName,e.lastName, d.department_name
FROM  employees e 
JOIN departments d
ON e.department_id = d.department_id;

-- 27. Display employee name, department name, and department location.
SELECT e.firstName, e.lastName, d.department_name, d.location
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- 28. Count the number of employees in each department using a JOIN.
SELECT d.department_name,
    COUNT(e.employee_id) AS number_of_employees
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;
    
-- 29. Display all departments, even if they have no employees.
SELECT d.department_name,
    COUNT(e.employee_id) AS number_of_employees
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 30. Find the average salary for each department using a JOIN.
SELECT d.department_name,
	ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 31. Display employees who work in departments located in Berlin.
SELECT  e.firstName, e.lastName, 
		d.department_name,d.location
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
WHERE d.location = 'Berlin';

-- 32. Display only employees working in the IT department (using a JOIN instead of filtering by ID).
SELECT  e.firstName, e.lastName, 
		d.department_name
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
WHERE d.department_id = '3';

-- Bonus Challenges
-- 33. Display the Top 3 highest-paid employees.
SELECT e.firstName, e.lastName, e.salary
FROM employees e
ORDER BY e.salary DESC
LIMIT 3;

-- to find just one employee, i could use MAX() like this: 
-- MAX() only returns one max value! 
SELECT firstName, lastName, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);

-- 34. Find employees whose salary is above the company average.
SELECT firstName, lastName, salary
FROM employees
-- sub query to find avg salary
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- 35. Find the department with the highest average salary.
SELECT d.department_name, 
	 ROUND(AVG(e.salary), 2) AS average_salary
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC
LIMIT 1

-- to do:
-- 36. Display the oldest employee in each department.

-- 37. Display employees whose last name contains the letter 'o'.

-- 38. Show the total salary paid by each department.

-- 39. Display employees earning the second-highest salary.

-- 40. Find the city with the highest number of employees.


 





