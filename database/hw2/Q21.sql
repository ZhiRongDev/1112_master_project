SELECT Dno, COUNT(*), AVG(Salary)
FROM employee
GROUP BY Dno;