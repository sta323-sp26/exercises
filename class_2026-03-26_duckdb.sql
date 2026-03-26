## Execise 1

### 1.The total costs in payroll for this company

SELECT sum(salary) AS total_payroll FROM employees;

### 2. The number of employees in each department who 
###    earn more than $35,000

SELECT dept, count(*) AS n FROM employees 
  WHERE salary > 35000
  GROUP BY dept;
  


## Exercise 2


### 1. What percentage of the total payroll does each 
###    department account for?

WITH total AS (
  SELECT sum(salary) AS total_sal FROM employees
)
SELECT dept, round(sum(salary) / total_sal,2) FROM employees
CROSS JOIN total
GROUP BY dept, total_sal;

### 2. How much more (or less) than their department’s 
###    average salary does each employee earn?

SELECT name, dept, round(salary-avg_salary,2) AS diff FROM employees
  NATURAL JOIN (
    SELECT dept, round(avg(salary),2) AS avg_salary 
      FROM employees 
      GROUP BY dept
  );

## Exercise 3


