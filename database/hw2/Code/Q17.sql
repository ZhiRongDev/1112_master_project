SELECT Fname, Lname
FROM employee
WHERE Salary > all (
	SELECT Salary
    FROM employee
    WHERE Dno = 5
);