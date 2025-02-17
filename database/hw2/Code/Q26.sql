SELECT DISTINCT Dnumber, Dname
FROM department, employee
WHERE 
	Dnumber = Dno AND 
    Salary > 30000 AND 
    Dno IN (
		SELECT Dno
		FROM employee
		GROUP BY Dno
		HAVING COUNT(*) > 2
	);