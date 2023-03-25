SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary)
FROM employee, department
WHERE Dno = Dnumber AND Dname = 'Research';