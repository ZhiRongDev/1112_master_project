SELECT Fname, Lname
FROM employee
WHERE NOT EXISTS (
	SELECT *
    FROM dependent
    WHERE employee.Ssn = Essn
);